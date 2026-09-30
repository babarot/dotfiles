# herdr plugin event (pane.agent_status_changed): dim the tool name that
# herdr-activity.sh reported once the agent in that pane goes idle, and give
# it back its colour when the agent leaves idle (working, blocked, done).
#
# A sidebar rule sees only its own token's value, not the pane's state, so
# idle is written into the value: an invisible mark in front of the kind
# mark, matched by the first rule of $activity_tool in config.toml.
#
# HERDR_PANE_ID is the focused pane here, not the one that changed, so the
# pane comes from the event.

event=${HERDR_PLUGIN_EVENT_JSON:-}
[[ -n $event ]] || exit 0
IFS=$'\t' read -r pane status < <(jq -r '.data | [.pane_id // "", .agent_status // ""] | @tsv' <<<"$event")
[[ -n $pane && -n $status ]] || exit 0

# Only panes herdr-activity.sh has reported to
tool=$(herdr pane get "$pane" 2>/dev/null | jq -r '.result.pane.tokens.activity_tool // empty') || exit 0
[[ -n $tool ]] || exit 0

idle_mark=$'﻿' # U+FEFF
bare=${tool#"$idle_mark"}
if [[ $status == idle ]]; then
  want=$idle_mark$bare
else
  want=$bare
fi
[[ $want != "$tool" ]] || exit 0
herdr pane report-metadata "$pane" --source herdr-activity --token "activity_tool=$want" >/dev/null 2>&1 || true
