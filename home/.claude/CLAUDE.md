# Environment

- Both Macs are managed by Nix (nix-darwin and home-manager) from babarot/dotfiles, cloned at `~/src/github.com/babarot/dotfiles`.
- Never install a tool into the system or the user environment by hand: no `brew install`, `curl ... | sh`, `npm install -g`, `pipx install`, `cargo install`, `go install` or `mise use -g`. It would exist on one Mac only, and nothing would remove it.
  - To run a tool you do not have, borrow it for the moment: `nix run nixpkgs#<pkg> -- <args>` or `nix shell nixpkgs#<pkg> -c <command>`.
  - To keep a tool, add it in dotfiles; ask the user first when you are working in another repository.
  - A project's own dependencies (`npm install`, `uv sync` and the like inside the repository) are not covered by this rule.

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
  - Tier 2: the default. Codex CLI on GPT-6.1 Sol, medium effort, read-only:

    ```bash
    codex exec -m gpt-6.1-sol -c model_reasoning_effort=medium -s read-only "Review this plan. Don't nitpick trivial points; only point out fatal issues: {full_path}"

    # re-review: the header of the first run prints "session id: ...";
    # resume takes no -s, so the sandbox is set with -c
    codex exec resume {session_id} -m gpt-6.1-sol -c model_reasoning_effort=medium -c sandbox_mode=read-only "I updated it; review it again. Don't nitpick trivial points; only point out fatal issues: {full_path}"
    ```

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

# Repositories

- In a public repository, write in English everything that goes into it or onto GitHub: code, comments, docs, commit messages, issues and PRs. In a private repository, follow its conventions instead.
- The settings of babarot's GitHub repositories (branch protection, labels, collaborators and the like) are managed as code with gh-infra in babarot/github-config. Change them there, never directly with `gh api` or `gh repo edit`; a direct change drifts from the code and is undone on the next apply.

# Documentation vs. code

- When a repository's instruction files or docs (CLAUDE.md, AGENTS.md and the like) and its existing code disagree, follow the conventions in the existing code, unless the documentation explicitly marks the rule as a migration target or a new standard.
- In your final reply, list every inconsistency you found between the documentation and the code.

# Messages to other Claude sessions

- If SendMessage fails, tell the user right away, before moving on to other work.
