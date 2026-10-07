# Creating pull requests with gh pr

- Do not escape backticks
- Do not use bold
- Follow the PR template's format; do not add extra headers or sections

# Characters not to use in Markdown

- Bold in running text. Minimal use for headings and the like is fine, but no bold just to make something stand out
- "—" (em dash) to join clauses
- `---` dividers

# Rules for drafting implementation plans

- Before presenting a plan to the user, have it reviewed with the `codex` command, as shown below.
- Adjust the review request as needed, but always include "Don't nitpick trivial points. Only point out fatal issues.", because `codex` tends to raise points that don't matter.

```bash
# initial plan review request
# Always pass the model with -m (gpt-5.3-codex works best)
codex exec -m gpt-5.6-luna "Review this plan. Don't nitpick trivial points; only point out fatal issues: {plan_full_path} (ref: {CLAUDE.md full_path})"

# updated plan review request
# Without `resume --last`, the context of the first review is lost
codex exec resume --last -m gpt-5.6-luna "I updated the plan; review it again. Don't nitpick trivial points; only point out fatal issues: {plan_full_path} (ref: {CLAUDE.md full_path})"
```
