# herdr plugin event (worktree.created, worktree.opened): lay out a new git
# worktree workspace as Claude Code top left, gh-news top right and reviewr
# across the bottom, all in the worktree, and start Claude. Reopening a
# worktree Claude already worked in continues that conversation.
#
# herdr runs it with HERDR_PANE_ID set to the workspace's first pane and the
# event in HERDR_PLUGIN_EVENT_JSON.

event=${HERDR_PLUGIN_EVENT_JSON:-}
[[ -n $event && -n ${HERDR_PANE_ID:-} ]] || exit 0

# Leave a workspace that was open already, or that already has more panes
[[ $(jq -r '.data.already_open // false' <<<"$event") != true ]] || exit 0
[[ $(jq -r '.data.workspace.pane_count' <<<"$event") == 1 ]] || exit 0
dir=$(jq -r '.data.worktree.path // empty' <<<"$event")
[[ -d $dir ]] || exit 0
workspace=$(jq -r '.data.workspace.workspace_id' <<<"$event")
claude_pane=$HERDR_PANE_ID

# reviewr first, so that it spans the whole width below Claude and gh-news
herdr plugin pane open --plugin persiyanov.reviewr --entrypoint pane --placement split \
  --target-pane "$claude_pane" --direction down --cwd "$dir" --no-focus >/dev/null || true
# A plugin pane opens at half the height and has no --ratio; --amount moves
# the split's ratio, so this leaves reviewr a third
herdr pane resize --pane "$claude_pane" --direction down --amount 0.1667 >/dev/null || true
news_pane=$(herdr pane split "$claude_pane" --direction right --cwd "$dir" --no-focus |
  jq -r '.result.pane.pane_id')
herdr pane rename "$news_pane" news >/dev/null || true
# The typed command waits in the terminal until the new shell reads it
herdr pane run "$news_pane" 'gh news' >/dev/null || true

# Claude keeps a directory's conversations under projects/<path with every
# non-alphanumeric character turned into ->
transcripts=("${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/${dir//[^a-zA-Z0-9]/-}"/*.jsonl)
args=()
[[ -e ${transcripts[0]} ]] && args=(--continue)

# herdr only starts an agent at a shell prompt, and the new pane's shell may
# still be starting when the event arrives: retry while it is busy. Any other
# answer ends it; agent_not_ready means Claude runs but waits at a startup
# prompt (e.g. trusting a new folder) that is left for me to answer.
name="claude-${workspace,,}" # agent names are lowercase
for _ in {1..40}; do
  if out=$(herdr agent start "$name" --kind claude --pane "$claude_pane" \
    --timeout 60000 -- "${args[@]}" 2>&1); then
    exit 0
  fi
  case $out in
  *agent_pane_busy* | *'not an available shell'* | *'shell prompt'*) sleep 0.5 ;;
  *agent_not_ready*) exit 0 ;;
  *) break ;;
  esac
done
printf 'could not start Claude in %s: %s\n' "$claude_pane" "$out" >&2
