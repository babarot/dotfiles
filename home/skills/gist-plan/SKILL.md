---
name: gist-plan
description: Keep the design doc and progress table of work that spans sessions or several PRs in a secret GitHub Gist, and drive the work from it. The design is reviewed and approved before any code, the table is updated after each step, and the Gist is closed at the end. Use when the user asks to put a plan, design doc, progress table or work note in a Gist ("Gistに計画・進行表を作って", "設計書はGistに", "作業用のMarkdownをGist (secret)に"), or hands over a Gist URL to continue from ("このGistをベースに開発していました", "このGistのとおりに実装して"). Not for Gists used to pass messages between agents on different machines, or for scripts that Nix imports from a Gist.
---

# gist-plan

The user keeps the plan of a long piece of work in a secret Gist, not in the repository. A Gist is never committed by mistake, stays readable across sessions and compaction, holds several files with history, can be edited with `gh` and git, and can be thrown away when the work is done. The Gist is the source of truth for what was decided and where the work stands; the conversation is not.

## When to suggest it

Suggest a Gist plan, without creating one, when the work will take two or more PRs, will span sessions, reworks the shape of stored data or a state machine, or moves production data or files. Create it only after the user agrees.

## 1. Create the Gist

- Confirm with the user that it will be secret. Say that a secret Gist is not private: anyone with the URL can read it. Never write credentials, tokens, IP addresses or hostnames, or identifiers that should not leak.
- Create it with `gh gist create` (secret is the default), then clone it to `~/.local/share/gist-plan/<gist-id>/` over HTTPS: `git -c credential.helper='!gh auth git-credential' clone https://gist.github.com/<gist-id>.git <dir>` (SSH can fail on the host key). Edit the clone and push; every review round then leaves a revision.
- If the plan already exists as a local file, move it: push it to the Gist, check that the Gist's content is identical, and only then delete the local file. Mocks and other files go into the same Gist.
- Write in the user's language, in plain words. Do not coin terms (metaphors used as names for parts of the design); the user would have to talk in them for the rest of the work. In Japanese, follow the japanese-tech-writing skill.

Files (a Gist has no directories, so the number prefix sets the order):

| File | Content |
|---|---|
| `00-index.md` | Why the work is done (the goal and the problems it solves); the progress table; where the work is now and what is next; open questions with IDs (Q1, Q2, ...) for the user to answer; the session rules (which reviews run when); the IDs of the sessions that worked on it, so claude-recall can find their transcripts |
| `90-decisions.md` | Decisions with their reasons, appended and never rewritten |
| `NN-<topic>.md` | The design itself. One file while it is small; split by topic (data, states, components, migration, stages) when it grows |

The progress table has one row per item or stage: what it does, its done condition, its state (open questions, designed, in progress, in review, merged), and its PR. Things deferred on purpose stay in the table or in a list below it, so the work can be picked up again from there.

## 2. Leave the Gist where the next session will look

- Save the Gist URL and the clone's path in memory.
- If the repository is private, ask whether to also put them in a short file under `.claude/rules/`, which every session reads at start, including after compaction. Never put the URL in a public repository.
- Do not link the Gist from documents that outlive it (ADRs, READMEs, code comments): the link breaks when the Gist is deleted.

## 3. Settle the design before any code

- Answer the user's questions about the plan before doing anything else. A "yes" to how the work will proceed is not permission to start implementing; if it is unclear what a yes covers, ask.
- When a decision is fundamental (how data is stored, combined or shown), explain it first in a local HTML page with diagrams, current design against the proposal. Write it into the Gist only after the user says they understand it.
- Ask the user once per Gist, with AskUserQuestion, which reviewers to use: Fable, Codex, or both. Record the answer in the session rules of `00-index.md`.
- Review loop:
  - Codex: call it as CLAUDE.md says (the model, "only fatal issues", `resume --last` from the second round). Give it the paths in the local clone, not the Gist URL; it may have no network.
  - Fable: an Agent with `model: fable`, given the same local paths.
  - Fix what they raise, push, and review again until neither finds a fatal issue. When they disagree, decide, and tell the user which side was taken and why.
- Show the user the reviewed design. Write no code outside the Gist until the user approves the design and says to start implementing.

## 4. Implement stage by stage

- Work on one stage at a time, in the order of the table.
- Before each PR, have the diff reviewed by the reviewers in the session rules: does it match the Gist's design and the stage's done condition, and is the code sound. Skipping a review is the user's decision, never the agent's.
- After a stage finishes or its PR merges, update the table (state, PR, what is next) and push before starting the next stage.
- When a review or the code changes the design, update the Gist and record the decision in `90-decisions.md`.
- After rewriting a file, check that no section was lost, the progress table in particular.

## 5. Resume from a Gist

When the user hands over a Gist URL, or memory or a rule points to one:

- Pull the clone (clone it first if it is missing) and read `00-index.md`, then the files it points to.
- For history the Gist does not hold, read the transcripts of the sessions listed in it with claude-recall.
- If the Gist and the code disagree, ask the user which one is right; do not quietly follow either.
- Add this session's ID to `00-index.md`.

## 6. Close

When every row of the table is done or deferred:

- Ask the user, with AskUserQuestion, whether to delete the Gist or keep it, and whether any decision should move into the repository (an ADR, the docs) first.
- Write those repository documents so that they stand without the Gist.
- Delete the Gist only after the user confirms. Then remove its memory entry and rule file, and the local clone.
- If it is kept, leave it closed: every row done or deferred, and the deferred list saying where to start again.
