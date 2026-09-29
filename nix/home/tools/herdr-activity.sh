# Claude Code hook (PostToolUse, async): show what a Claude session inside
# herdr just did in its row of herdr's sidebar, and append the same line to
# a log per pane under $XDG_STATE_HOME/herdr-activity for a later history
# view.
#
# The sidebar row (home/.config/herdr/config.toml) shows three tokens:
# $activity_time, $activity_tool and $activity_label. herdr styles a token
# only by rules that match its value, and 16 rules cannot name every tool,
# so the tool name starts with an invisible character naming its kind
# (edit, shell, read, ...) and one `contains` rule per kind picks the colour.

[[ ${HERDR_ENV:-} == 1 && -n ${HERDR_PANE_ID:-} ]] || exit 0

input=$(cat)

# herdr hides the built-in branch token on worktree spaces grouped under
# their repo (herdrdev/herdr#2952), so a space renamed after its feature
# loses its branch. Report the checkout's branch as $branch instead; any tool
# call may have switched it, and reporting the same value again is harmless.
# A space not renamed (still named after its checkout dir) already shows its
# branch as its name, so it gets no $branch.
if [[ -n ${HERDR_WORKSPACE_ID:-} ]]; then
  # checkout<TAB>label, only for a linked worktree
  space=$(herdr workspace get "$HERDR_WORKSPACE_ID" 2>/dev/null | jq -r '
    .result.workspace | select(.worktree.is_linked_worktree)
    | [.worktree.checkout_path, .label] | join("\t")' 2>/dev/null) || space=""
  IFS=$'\t' read -r checkout space_label <<<"$space"
  if [[ -n $checkout ]]; then
    branch=""
    if [[ $space_label != "${checkout##*/}" ]]; then
      branch=$(git -C "$checkout" branch --show-current 2>/dev/null) || branch=""
    fi
    if [[ -n $branch ]]; then
      branch_args=(--token "branch=$branch")
    else
      branch_args=(--clear-token branch)
    fi
    herdr workspace report-metadata "$HERDR_WORKSPACE_ID" --source herdr-branch "${branch_args[@]}" >/dev/null 2>&1 || true
  fi
fi

# tool<TAB>kind<TAB>label
parsed=$(jq -r '
  def base: split("/") | last;
  def first_line: split("\n")[0];
  .tool_name as $tool
  | (.tool_input // {}) as $in
  | (if $tool == "Read" or $tool == "Edit" or $tool == "Write" then ($in.file_path // "" | base)
     elif $tool == "NotebookEdit" then ($in.notebook_path // "" | base)
     elif $tool == "Bash" or $tool == "PowerShell" or $tool == "Monitor" then ($in.command // "" | first_line)
     elif $tool == "Glob" or $tool == "Grep" then ($in.pattern // "")
     elif $tool == "WebFetch" then ($in.url // "" | sub("^https?://"; ""))
     elif $tool == "WebSearch" or $tool == "ToolSearch" then ($in.query // "")
     elif $tool == "Skill" then ($in.skill // "")
     elif $tool == "Agent" then ($in.description // "")
     elif $tool == "TaskCreate" then ($in.subject // "")
     elif $tool == "TaskUpdate" then ([$in.status, ($in.taskId // empty | "#\(.)")] | map(select(. != null)) | join(" "))
     elif $tool == "EnterWorktree" or $tool == "ExitWorktree" then ($in.name // $in.path // "")
     else "" end) as $label
  | (if ($tool | test("^(Edit|Write|NotebookEdit)$")) then "edit"
     elif ($tool | test("^(Bash|PowerShell|Monitor)$")) then "shell"
     elif ($tool | test("^(Read|Glob|Grep|LSP)$")) then "read"
     elif ($tool | test("^(Agent|SendMessage|TeamCreate|TeamDelete)$")) then "agent"
     elif ($tool | test("^(WebFetch|WebSearch)$")) then "web"
     elif ($tool | test("^(Task|Skill$)")) then "task"
     elif ($tool | startswith("mcp__")) then "mcp"
     else "other" end) as $kind
  # mcp__<server>__<tool> reads better as <server>:<tool>
  | ($tool | if startswith("mcp__") then (ltrimstr("mcp__") | sub("__"; ":")) else . end) as $name
  | [$name, $kind, ($label | gsub("\t"; " "))] | join("\t")
' <<<"$input" 2>/dev/null) || exit 0
IFS=$'\t' read -r tool kind label <<<"$parsed"
[[ -n $tool ]] || exit 0
time=$(date +%H:%M)

# Invisible kind marks, matched by the rules in config.toml
case $kind in
edit) mark=$'⁠' ;;
shell) mark=$'⁡' ;;
read) mark=$'⁢' ;;
agent) mark=$'⁣' ;;
web) mark=$'⁤' ;;
task) mark=$'​' ;;
mcp) mark=$'‌' ;;
*) mark="" ;;
esac

# The sidebar row is narrow; the log keeps the whole line
short=$label
((${#short} <= 48)) || short="${short:0:47}…"
args=(--token "activity_time=$time" --token "activity_tool=$mark$tool")
if [[ -n $short ]]; then
  args+=(--token "activity_label=$short")
else
  args+=(--clear-token activity_label)
fi
herdr pane report-metadata "$HERDR_PANE_ID" --source herdr-activity "${args[@]}" >/dev/null 2>&1 || true

log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/herdr-activity"
log="$log_dir/${HERDR_PANE_ID//[^a-zA-Z0-9_-]/_}.log"
mkdir -p "$log_dir"
printf '%s %s%s\n' "$time" "$tool" "${label:+ $label}" >>"$log"
# Keep the last 200 lines once it passes 210
if (($(wc -l <"$log") > 210)); then
  tail -n 200 "$log" >"$log.tmp" && mv "$log.tmp" "$log"
fi
