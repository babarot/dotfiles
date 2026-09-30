# Put a mark on the sidebar row of each herdr space whose folder has a
# devstack running: a compose project started from <folder>/$COMPOSE_NAME
# (minitube's dev:up). Run by launchd from herdr-devstack.nix.
#
# Every round lists the compose projects and herdr's spaces and reports the
# mark again with a TTL, so a mark goes away on its own when this loop stops,
# and comes back after herdr's server restarts (tokens are not restored).
# A round where docker or herdr does not answer (OrbStack or herdr not
# running) is skipped.

COMPOSE_NAME=${COMPOSE_NAME:-compose.devstack.yaml}
MARK=${MARK:-●}
INTERVAL=${INTERVAL:-10}
TTL_MS=$((INTERVAL * 3 * 1000))

round() {
  local projects spaces running
  projects=$(docker compose ls --format json 2>/dev/null) || return 0
  spaces=$(herdr workspace list 2>/dev/null) || return 0

  # The folders of running devstacks, one per line. ConfigFiles lists the
  # compose files of a project, comma separated
  running=$(jq -r --arg f "/$COMPOSE_NAME" '
    .[] | select(.Status | test("running"))
    | .ConfigFiles | split(",")[] | select(endswith($f)) | rtrimstr($f)
  ' <<<"$projects") || return 0

  # id<TAB>checkout path<TAB>current mark, for spaces backed by a checkout
  jq -r '
    .result.workspaces[] | select(.worktree)
    | [.workspace_id, .worktree.checkout_path, (.tokens.devstack // "")] | @tsv
  ' <<<"$spaces" | while IFS=$'\t' read -r id dir mark; do
    if grep -qxF -- "$dir" <<<"$running"; then
      herdr workspace report-metadata "$id" --source herdr-devstack \
        --token "devstack=$MARK" --ttl-ms "$TTL_MS" >/dev/null 2>&1 || true
    elif [[ -n $mark ]]; then
      # Stopped: clear it now rather than waiting for the TTL
      herdr workspace report-metadata "$id" --source herdr-devstack \
        --clear-token devstack >/dev/null 2>&1 || true
    fi
  done
}

while :; do
  # A failing round must not end the loop (set -e does not apply under ||)
  round || true
  sleep "$INTERVAL"
done
