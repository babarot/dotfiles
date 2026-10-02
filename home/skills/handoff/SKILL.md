---
name: handoff
description: Write a copy-pasteable prompt that hands this session over to another agent, with a summary and this session's ID so the next agent can read the full transcript when it needs detail.
disable-model-invocation: true
---

# handoff

The user wants another agent (a new Claude Code or Codex session, maybe on another machine) to continue the work of this session. Write the prompt they will paste into it. Output it in the chat; do not write a file.

## 1. Find this session's ID and transcript

- Claude Code: the ID is in `$CLAUDE_CODE_SESSION_ID` (this session: `${CLAUDE_SESSION_ID}`). The transcript is `~/.claude/projects/<cwd with every non-alphanumeric character replaced by ->/<id>.jsonl`; confirm the path with `ls`.
- Codex: use `$CODEX_THREAD_ID` if it is set. Otherwise take the newest `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl` whose first line (`session_meta`) has this session's `cwd`; the ID is its `payload.id`.

If neither works, say so in the prompt instead of guessing an ID.

## 2. Write the prompt

A summary, not a transcript: enough for the next agent to start working, with the session ID as the way to dig deeper. Write it in the language the user has been using, addressed to the next agent. Include:

- Goal: what the user wants in the end, and why if it matters.
- Working directory, repository and branch (and worktree, if any).
- Done so far: what changed and where (files, commits, PRs), and what was verified.
- Decisions: what the user chose or ruled out, with the reason, so the next agent does not reopen them.
- Next: the remaining steps, in order, starting with the very next one.
- Open questions and pitfalls: unresolved points, dead ends already tried, anything the user must do by hand (e.g. commands that need sudo).
- Source: the session ID, the agent it ran in, and the transcript path. Tell the next agent it may look up details there only when the summary is not enough: with the agent-recall MCP (`recall_search`, `recall_export`) if it has it, or by reading the transcript file directly.

Leave out secrets and tokens even if they appeared in the session.

## 3. Output

Put the whole prompt in one fenced code block (use four backticks if it contains a code block) so it can be copied as is.

Also copy the same prompt to the clipboard with `pbcopy`, through a quoted heredoc so nothing in it is expanded:

```bash
pbcopy <<'HANDOFF'
<the prompt>
HANDOFF
```

Before the code block, add one line saying whether it is on the clipboard (if `pbcopy` failed, e.g. in a sandbox, say so). Nothing else is needed.
