# Language

- Talk with the user in Japanese. Code identifiers and technical terms stay as they are.

# Writing

- In chat replies, commit messages, code comments and docs, do not use:
  - Bold in running text. Minimal use for headings and the like is fine, but no bold just to make something stand out
  - "—" (em dash) to join clauses
  - `---` dividers

# Repositories

- In a public repository, write in English everything that goes into it or onto GitHub: code, comments, docs, commit messages, issues and PRs. In a private repository, follow its conventions instead.
- The settings of babarot's GitHub repositories (branch protection, labels, collaborators and the like) are managed as code with gh-infra in babarot/github-config. Change them there, never directly with `gh api` or `gh repo edit`; a direct change drifts from the code and is undone on the next apply.

# Documentation vs. code

- When a repository's instruction files or docs (CLAUDE.md, AGENTS.md and the like) and its existing code disagree, follow the conventions in the existing code, unless the documentation explicitly marks the rule as a migration target or a new standard.
- In your final reply, list every inconsistency you found between the documentation and the code.
