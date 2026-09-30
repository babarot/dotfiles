# Put marks on the sidebar rows of herdr's worktree spaces by conditions:
# each round runs every condition of my.herdrWorktreeStatus in the folder of
# each space, and a condition that exits 0 puts its mark in the token of its
# name ($<name> in home/.config/herdr/config.toml). Run by launchd from
# herdr-worktree-status.nix, with the conditions as a JSON file:
#   [{"name": "devstack", "condition": "...", "repos": ["minitube"], "mark": "●"}]
#
# A condition is shell, run with bash -c. Its cwd is the space's folder, and
# it gets WORKTREE_PATH, REPO_NAME and WORKSPACE_ID. A space without a folder
# (not a git checkout) gets no marks. A condition that runs past $TIMEOUT
# counts as false.
#
# Marks are reported with a TTL, so they go away on their own when this loop
# stops, and come back after herdr's server restarts (tokens are not
# restored). A round where herdr does not answer is skipped.

config=$1
INTERVAL=${INTERVAL:-10}
TIMEOUT=${TIMEOUT:-5}
TTL_MS=$((INTERVAL * 3 * 1000))

declare -A condition mark
while IFS= read -r name; do
  condition[$name]=$(jq -r --arg n "$name" '.[] | select(.name == $n) | .condition' "$config")
  mark[$name]=$(jq -r --arg n "$name" '.[] | select(.name == $n) | .mark' "$config")
done < <(jq -r '.[].name' "$config")

# One check: a condition in one folder, reported to every space open on it
# ($ids, comma separated; the main checkout can be open in several).
# $marked lists the ones showing the mark now, to clear only those.
check() {
  local name=$1 dir=$2 repo=$3 ids=$4 marked=$5 eligible=$6 id
  local -a to
  if [[ $eligible == 1 && -d $dir ]] &&
    (cd "$dir" && WORKTREE_PATH=$dir REPO_NAME=$repo WORKSPACE_ID=${ids%%,*} \
      timeout -k 1 "$TIMEOUT" bash -c "${condition[$name]}") >/dev/null 2>&1; then
    IFS=, read -ra to <<<"$ids"
    for id in "${to[@]}"; do
      herdr workspace report-metadata "$id" --source herdr-worktree-status \
        --token "$name=${mark[$name]}" --ttl-ms "$TTL_MS" >/dev/null 2>&1 || true
    done
  else
    IFS=, read -ra to <<<"$marked"
    for id in "${to[@]}"; do
      herdr workspace report-metadata "$id" --source herdr-worktree-status \
        --clear-token "$name" >/dev/null 2>&1 || true
    done
  fi
}

round() {
  local spaces jobs
  spaces=$(herdr workspace list 2>/dev/null) || return 0

  # One line per condition and folder:
  # name, folder, repo, space ids, ids showing the mark, whether the repo matches.
  # Fields are split by US (\x1f), not tab: read merges runs of a whitespace
  # IFS, which would drop an empty field and shift the rest
  jobs=$(jq -r --slurpfile cfg "$config" '
    [.result.workspaces[] | select(.worktree)]
    | group_by(.worktree.checkout_path)[] as $g
    | ($g[0].worktree.repo_name // "") as $repo
    | $cfg[0][] as $c
    | [ $c.name,
        $g[0].worktree.checkout_path,
        $repo,
        ($g | map(.workspace_id) | join(",")),
        ($g | map(select(.tokens[$c.name]? // empty)) | map(.workspace_id) | join(",")),
        (if ($c.repos | length) == 0 or ($c.repos | index($repo)) then "1" else "0" end)
      ] | join("\u001f")
  ' <<<"$spaces") || return 0

  # The checks run side by side; a round takes as long as the slowest
  while IFS=$'\x1f' read -r name dir repo ids marked eligible; do
    check "$name" "$dir" "$repo" "$ids" "$marked" "$eligible" &
  done <<<"$jobs"
  wait
}

while :; do
  # A failing round must not end the loop (set -e does not apply under ||)
  round || true
  sleep "$INTERVAL"
done
