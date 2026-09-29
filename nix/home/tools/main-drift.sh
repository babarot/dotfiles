# Claude Code hook: tell a session that the default branch (origin/main)
# moved under its branch, but only when the new commits touch files the
# branch changed, or would conflict. Claude reads the facts and decides by
# itself whether to rebase; nothing here decides for it.
#
# Several sessions each work in their own git worktree of one repo and keep
# opening PRs. A session has no way to see that another one merged, so it
# keeps working on an old base until the user says "pull main".
#
#   main-drift prompt   (UserPromptSubmit) no network: worktrees share refs,
#                       so any sibling's fetch is already visible here. Adds
#                       the facts to the prompt as context.
#   main-drift pretool  (PreToolUse, Bash) only before `git push` and
#                       `gh pr create`: fetches first, and refuses the
#                       command once with the facts as the reason.
#
# The same origin/main is reported only once per worktree (kept in the
# worktree's own git dir), so a retried push goes through.

mode=${1:-}
input=$(cat)

cwd=$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null) || exit 0
[[ -n $cwd ]] && cd "$cwd" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

case $mode in
prompt) ;;
pretool)
  cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null) || exit 0
  push='(^|[^[:alnum:]_-])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$)'
  pr='(^|[^[:alnum:]_-])gh[[:space:]]+pr[[:space:]]+create([[:space:]]|$)'
  [[ $cmd =~ $push || $cmd =~ $pr ]] || exit 0
  ;;
*) exit 0 ;;
esac

# The default branch as the remote names it; origin/HEAD is missing in
# clones made before it existed, so fall back to origin/main
main=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null) || main=origin/main
git rev-parse -q --verify "$main^{commit}" >/dev/null || exit 0

branch=$(git branch --show-current)
[[ -n $branch && $branch != "${main#origin/}" ]] || exit 0
for p in rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD; do
  if [[ -e $(git rev-parse --git-path "$p") ]]; then exit 0; fi
done

if [[ $mode == pretool ]]; then
  GIT_TERMINAL_PROMPT=0 timeout 8 git fetch -q origin "${main#origin/}" >/dev/null 2>&1 || true
fi

now=$(git rev-parse "$main")
state=$(git rev-parse --git-path main-drift)
[[ $(cat "$state" 2>/dev/null) != "$now" ]] || exit 0

base=$(git merge-base HEAD "$main") || exit 0
[[ $base != "$now" ]] || exit 0

# Files this branch changed (committed, staged, unstaged, untracked) and
# files the default branch changed, both since they parted
mine=$({
  git diff --no-renames --name-only "$base"
  git ls-files --others --exclude-standard
} | sort -u)
theirs=$(git diff --no-renames --name-only "$base" "$main" | sort -u)
overlap=()
if [[ -n $mine && -n $theirs ]]; then
  mapfile -t overlap < <(comm -12 <(printf '%s\n' "$mine") <(printf '%s\n' "$theirs"))
fi

# merge-tree exits 1 on conflicts; anything else is not our business
conflict=
if [[ $mode == pretool ]]; then
  rc=0
  git merge-tree --write-tree HEAD "$main" >/dev/null 2>&1 || rc=$?
  if ((rc == 1)); then conflict=1; fi
fi

((${#overlap[@]} > 0)) || [[ -n $conflict ]] || exit 0

if ((${#overlap[@]} > 0)); then
  commits=$(git log -n 10 --format='  %h %s' "$base..$main" -- "${overlap[@]}")
  files=$(printf '  %s\n' "${overlap[@]:0:10}")
else
  commits=$(git log -n 10 --format='  %h %s' "$base..$main")
  files="  (none directly; see the conflict below)"
fi

msg="$main has moved since this branch ($branch) left it, and the new commits touch files this branch changed.
New commits on $main:
$commits
Files changed on both sides:
$files"
if [[ -n $conflict ]]; then
  msg+="
Rebasing onto $main will conflict."
fi
msg+="
To take them in: git rebase --autostash $main (then push with --force-with-lease if the branch is already pushed).
Read these commits and decide whether the work on this branch needs them."

printf '%s\n' "$now" >"$state"

if [[ $mode == prompt ]]; then
  jq -n --arg m "$msg" \
    '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $m}}'
else
  jq -n --arg m "$msg
If they are not needed, run the same command again; it will not be stopped twice." \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $m}}'
fi
