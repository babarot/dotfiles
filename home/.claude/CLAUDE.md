# Writing

- Write issues, PRs, Slack messages, blog posts and other text that has a writing skill with that skill. Only when you cannot tell which skill fits, ask with AskUserQuestion.
- Where no writing skill applies (chat replies, commit messages, code comments, docs), do not use:
  - Bold in running text. Minimal use for headings and the like is fine, but no bold just to make something stand out
  - "—" (em dash) to join clauses
  - `---` dividers

# Review

- After drafting a plan or finishing an implementation, have an agent other than this session review it when you judge that a review would make the result more certain, or when the user asks for one. It is not required every time.
- Pick the reviewer by tier:
  - Tier 1: Fable, through the Agent tool with `model: "fable"`. Only when the work is complex: the design branches widely, a mistake is hard to undo, or the change spans several modules. If Fable is out of credits, tell the user and fall back to tier 2.
  - Tier 2: the default. The CLI and model are set per Mac in `~/.claude/rules/`.
  - Tier 3: a subagent on the same model as this session. Only when tier 2 fails or the check is tiny; it shares this session's blind spots.
- Always include "Don't nitpick trivial points. Only point out fatal issues." in the request, and pass the full paths of the plan or changed files.
- Run the reviewer read-only. It reviews; it does not edit.
- To re-review, resume the first review by its session ID, never the most recent session: other sessions on this Mac may have run a review since.
- Judge each finding yourself. Tell the user which ones you did not adopt and why.

# Messages to other Claude sessions

- If SendMessage fails, tell the user right away, before moving on to other work.
