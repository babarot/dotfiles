# Sources

What each source contributes to the skill, and where they disagree. Numbers are heuristics unless marked otherwise.

## First-party docs

- Claude Code, How Claude remembers your project: https://code.claude.com/docs/en/memory
  Loading order, `@` imports (no context saving, four hops), `.claude/rules/` and `paths:`, AGENTS.md read only without a CLAUDE.md, HTML comments stripped, "target under 200 lines per CLAUDE.md file", contradictions resolved arbitrarily, add a line when a mistake repeats.
- Claude Code, Best practices: https://code.claude.com/docs/en/best-practices
  Keep it short; only what Claude cannot work out from the code; do not describe architecture and layout; no IMPORTANT or ALL CAPS (current models over-apply them); rules without exceptions go in hooks, deny rules or managed settings; procedures go in skills.
- Anthropic, Using CLAUDE.md files: https://claude.com/resources/articles/using-claude-md-files
  Start simple and expand on real friction; `/init` as a starting point to review, not a finished file; keep secrets out.
- OpenAI Codex, AGENTS.md: https://developers.openai.com/codex/guides/agents-md
  Discovery and override order, one file per directory, `project_doc_max_bytes` 32 KiB.
- agents.md: https://agents.md
  The open convention: plain Markdown, no required fields, nearest file wins, chat prompts override everything.

## Research

- Gloaguen et al., Evaluating AGENTS.md (2026): https://arxiv.org/abs/2602.11988
  Context files mostly do not improve success and raise cost by over 20%; overviews do not help; minimal, non-standard requirements are what helps.
- Jaroslawicz et al., How Many Instructions Can LLMs Follow at Once? (2025): https://arxiv.org/abs/2507.11538
  Adherence falls as instruction count rises, with a bias toward earlier instructions. A synthetic task, so its transfer to instruction files is an inference.

## Practitioners

- HumanLayer, Writing a good CLAUDE.md: https://www.humanlayer.dev/blog/writing-a-good-claude-md
  Less is more; progressive disclosure through topic docs; prefer pointers to copies; never send an LLM to do a linter's job; do not auto-generate. Gives "< 300 lines" as consensus and a root file under 60 lines.
- AI Hero, A Complete Guide To AGENTS.md: https://www.aihero.dev/a-complete-guide-to-agents-md
  Files grow into a ball of mud by feedback loop; stale paths poison context; minimal root (one-line description, package manager, non-standard commands); a refactoring procedure (find contradictions, extract essentials, group the rest, delete the vague).
- crystl, CLAUDE.md Best Practices: https://crystl.dev/guides/claude-md-best-practices/
  Guidance, not enforcement; make every rule checkable; give the reason with the rule; standing facts in CLAUDE.md, file rules in `.claude/rules/`, procedures in skills. Ends with a pitch for its own product.
- GitHub, How to write a great agents.md (2,500 repositories): https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/
  Commands first, with flags; a real snippet beats paragraphs of description; boundaries as always / ask first / never.

## Disagreements and how the skill resolves them

- Directory maps and overviews: Anthropic's 2025 article and GitHub include them; the Claude Code best-practices doc, crystl and the study say they waste context. The skill drops them, keeping only pointers that say when to read something.
- `/init`: Anthropic offers it as a starting point; HumanLayer and AI Hero say never. The skill allows its output only as raw material for sorting.
- Size: 200 lines (Claude Code docs), 300 (HumanLayer's consensus), 32 KiB (Codex's hard cap). None comes from a study of instruction files. The skill uses 200 as a ceiling and aims well below.
