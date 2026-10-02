---
name: blog-seed
description: Turn what this session built or learned into a base text for a blog post the user may write later, saved as a local HTML file with this session's ID so the transcript can be read again with claude-recall. Use when the user says they might blog about it someday and asks to write it up ("いずれブログにしたい", "ブログのベースを書いておいて"). Not for drafting the post itself, which is the blog-writing skill.
---

# blog-seed

The user may write a blog post about this session's work someday and wants a base to write from: the argument, the material and the pointers, not a finished post. Write it as a local HTML file, open it, and report where it is. Do not publish it anywhere.

## 1. Find this session's ID

- Claude Code: `$CLAUDE_CODE_SESSION_ID` (this session: `${CLAUDE_SESSION_ID}`).
- Codex: `$CODEX_THREAD_ID` if it is set. Otherwise take the newest `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl` whose first line (`session_meta`) has this session's `cwd`; the ID is its `payload.id`.

If the claude-recall MCP is available, confirm the ID with `recall_search` on a phrase from this session; it lists the session by its ID prefix. If no ID can be found, say so in the file instead of guessing one.

## 2. Write the base text

Write in the language the user has been using, in a loose, note-like style. It is a reference to write from, so it need not be polished or complete.

- Near the top: the session ID (full and the prefix claude-recall shows), the date, the repository or directory, and how to read it again: `recall_search` finds it, `recall_export` with the ID returns the whole conversation.
- Lead with what the post would argue, the one thing a reader should take away, before the details.
- Then the material: the problem, what was done and how it works, with short code or command excerpts taken from what was actually built, and what was good and what to watch out for.
- Describe the approach as it stands now. Do not narrate "first we did X, then switched to Y" unless the user asks; an earlier approach worth mentioning goes at the end as an alternative, with when it fits better.
- Mark notes to self apart from the prose, in a muted style: title ideas, screenshots to take, points still to decide.
- Keep it fit for a public blog: no secrets or tokens, and nothing from work (company, internal repositories, hosts, people, PR or issue numbers) even if they came up in the session.

## 3. Save and open

- Save it as `~/Documents/blog-seeds/<short-topic-slug>.html`. If a base text for the same topic is already there, update it instead of writing a second one.
- One self-contained file: inline CSS, no external scripts, readable at phone width, with a light and a dark color scheme (`prefers-color-scheme`).
- Open it with `open <path>`.

Report the path and a short outline of what the file covers, including the session ID it points to.
