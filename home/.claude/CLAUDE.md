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

# Consult

- When the user asks you to consult or brainstorm with another agent, by name or by tier, pick the agent by the same tiers as Review and run it the same way (read-only, resume by session ID), but with a different request:
  - Leave out the fatal-only sentence.
  - Pass the question and your current thinking, and ask for counterarguments and alternatives.
- A request to discuss that names no other agent is a request to talk it through with you; do not call another agent.
- Do not paste the reply as is. Give the user its main points and what you think of each.

# Messages to other Claude sessions

- If SendMessage fails, tell the user right away, before moving on to other work.
