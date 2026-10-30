---
name: anything-else
description: Check, before the user closes a session, what is left of it: things still running or half done, follow-ups, and above all what Claude proposed or asked earlier that never got an answer and is now buried in the chat, read from the whole transcript including what compaction dropped. Use when the user asks whether anything is left or whether the session can be closed ("このセッションでやることはもう無い？", "他にやることある？", "閉じても問題ない？", "やり残しない？").
---

# anything-else

The user is about to close this session and wants to know what would be lost. What gets lost is rarely the main task: it is the side remark Claude made two hours ago ("必要なら issue にします", "README に一言足しておきますか") that the user never answered, a claim Claude later found wrong but never said so, or a worktree left behind. Find those, check the state they depend on, and report in a shape the user can answer in one go.

## 1. Read the whole conversation, not your context

Your context may have been compacted, and a summary keeps the main line but drops side remarks, which are exactly what this skill is for. Read the transcript file instead.

- Claude Code: the ID is `$CLAUDE_CODE_SESSION_ID` (this session: `${CLAUDE_SESSION_ID}`). The transcript is `~/.claude/projects/<cwd with every non-alphanumeric character replaced by ->/<id>.jsonl`; find it with `ls ~/.claude/projects/*/<id>.jsonl`. It keeps every message from before a compaction too.
- Codex: `$CODEX_THREAD_ID`, or the newest `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl` whose `session_meta` has this session's `cwd`. Read its user and assistant messages the same way.

Extract the conversation into the scratchpad, without tool calls and their output, but with the answers to AskUserQuestion:

```bash
jq -r 'select((.type=="user" or .type=="assistant") and (.isSidechain|not) and (.isMeta|not))
  | (if (.message.content|type)=="string" then .message.content
     else [.message.content[]? | if .type=="text" then .text
       elif .type=="tool_result" and ((.content|type)=="string") and (.content|contains("questions have been answered")) then .content
       else empty end] | join("\n") end) as $t
  | select($t != "" and ($t|startswith("<")|not))
  | "[\(.timestamp[0:16]) \(.type)] \($t)"' <transcript> > <scratchpad>/conversation.txt
```

Read all of it, in parts if it is long. Do not hand this to a subagent: deciding what is still open needs the judgment and the context of this session. claude-recall (`recall_export`) holds the same messages for past sessions, but it may not have indexed the current one yet; the file is always current.

## 2. Collect the candidates

Go through the conversation from the start and list every item of these kinds, with its timestamp and a short quote:

- Buried proposals: Claude offered to do something ("〜しますか", "必要なら〜します", "〜しておきましょうか") and the user did not answer, or answered about something else in the same message. These come first; they are what the user asked this skill for.
- Unanswered questions: Claude asked, the user moved on.
- Deferred work: "後で", "別の issue で", "スコープ外", "今回はやらない", a follow-up the user said they would do themselves ("自分でアナウンスする"), anything parked in a plan's open questions.
- Retractions: something Claude said, later found wrong. Check that the correction reached the user in plain words; a belief the user still holds from the wrong version is a leftover.
- Unconfirmed claims the work rests on: "未確認", "確かめていない", "plan は回していない", "推測".
- Discoveries outside the task: a bug, a stale comment, a mismatch between docs and code noticed on the way.

Then drop what the conversation itself settled: the user said no, it was done later, or it was overtaken by a later decision. When unsure whether it was settled, keep it and say why it might be.

## 3. Check the state

Look, do not assume. Check only what this session touched:

- Repositories and worktrees this session created or worked in: uncommitted changes, commits not pushed or not landed, branches whose PR is merged and can go, worktrees to remove. Leave other sessions' worktrees alone and say you did.
- PRs and issues it opened or commented on: state, CI, review requests, whether a linked issue should be updated or closed.
- Things it started: background shells, dev servers, emulators, browser previews, `Monitor` or cron jobs, scheduled wakeups.
- Things it put in place for the work: a Gist plan and its progress table, scratchpad files the user may want to keep, temporary tool installs (mise versions, `nix shell` is fine), memory entries that are now stale.
- Things the repository's own instructions say to do at the end (a doc to update, the docs and code inconsistencies to list).

Run read-only checks freely. Do not fix anything in this step.

## 4. Report

Write in the user's language. Number every item across sections so the user can answer with numbers. Lead with the verdict in one line: whether the session can be closed now, or what would be lost if it were.

1. 今やったほうがいい: items to do in this session, each with what you would do, your recommendation, and a rough size. Buried proposals go here or under 後回し, never silently dropped.
2. 後回しでいい: items that can wait, each with where it is recorded (an issue, the Gist, memory). An item recorded nowhere is lost when the session closes; say so and offer to record it.
3. 埋もれていた話: retractions and unconfirmed claims the user should know about, even if nothing needs doing.
4. 問題なし: what you checked and found clean, briefly, so the user knows it was looked at.

Each item says where it came from ("10/28 15:40 に提案", "README の件"), so the user can tell what it refers to without scrolling back.

Then ask with AskUserQuestion (multiSelect) which items to do now, recommended ones first; if there are more than four, ask about the ones you recommend and leave the rest to a reply by number. Do what is chosen. A choice to do something counts as the user's approval for that action only.

## 5. Close out

After the chosen items are done, say in one line that nothing is left, or list what still is. When the user decides to leave an item unrecorded, accept it and do not raise it again in this session.
