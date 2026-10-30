---
name: teach-me
description: Write a local HTML document that teaches the user, in depth and without metaphors, a problem, plan, investigation or design they have not fully followed, so they can decide, review or merge from it. Use when the user asks for an HTML page to understand something themselves ("ちゃんと理解したいので解説用のHTMLを作って", "学習用のドキュメントをローカルに", "詳しくない人でも分かるように", "コンテキストを追いきれていない人間が読んでも理解できるように"), or when gist-plan needs a fundamental decision explained before it goes into the Gist. Not for one mechanism shown interactively through a worked example (explain-me), a quick diagram (show-me), or a dead-simple picture (eli5).
---

# teach-me

The user wants to understand something well enough to act on it: approve a design, review a PR, answer a question, merge. They are an engineer who has not followed every turn of the context. Write one local HTML document that takes them from the background to the decision in front of them.

What they asked for, again and again, and what made them send pages back:

- "Easy" means each step is spelled out from the premises, not that things are renamed. No metaphors, analogies or coined names ("ledger", "gatekeeper", a fridge for a cache). Use the real terms an engineer knows, untranslated, and the real names in the code and the infrastructure. Explain a term the first time it appears, or in a glossary at the top, instead of replacing it.
- Too hard is the usual complaint, never too simple. Do not skip a premise because it seems obvious.
- A wrong page is worse than none: the user decides from it. A wrong "this is the dangerous direction" or an option that cannot actually be chosen sends the work the wrong way.

## 1. Gather what is true

- Read the sources before writing: the code at the commit in question, the issue and PR threads, Slack or Notion, the Gist plan, command output. What this conversation established counts, but check what the page rests on.
- For a gist-plan Gist, read `00-index.md`, the design files and `90-decisions.md`; the decisions, the progress table and the open questions (Q1, Q2, ...) become the page's spine.
- Keep apart what you confirmed, what you inferred and what you could not check. Every claim on the page will be one of the three.

## 2. Shape the page

Build it up so each chapter rests on the ones before. Drop a chapter that has nothing to say; keep the order:

1. The conclusion first, in a few lines: what is going on, and what the user has to decide.
2. Terms and premises the rest depends on.
3. How it works today, with the real path a request, a deploy or the data takes.
4. The problem, and why it is a problem: the concrete way it goes wrong, not "risk".
5. History, when it explains why things are this way: a vertical timeline with dates and links.
6. The options with pros and cons, and which one you recommend and why. Show only options that can actually be chosen.
7. Where the work stands and what comes next: stages, PRs, their state.
8. Open questions for the user, each with its ID and your recommendation.
9. What you did not confirm, and what is out of scope.

- Draw what has a shape: architecture, request paths, before and after, a timeline, an undecided point. Inline SVG or HTML and CSS, labeled with the real names. An open question can be a small diagram of its own.
- Show the real thing: code excerpts with file and line, actual values and measurements, actual resource names.
- Link everything that has an address: issues and PRs, commits and files as permalinks pinned to a full SHA, cloud console pages of the resources, the Slack message or Notion page a statement comes from (as a caption next to the statement).
- Tag inferred claims ("推測") and unchecked ones ("未確認") where they appear, not only in the last chapter.
- Write in the user's language. In Japanese, follow the japanese-tech-writing skill when it is available.

## 3. Build and hand over

- One self-contained `.html`: inline CSS, no external scripts, a web font from a CDN at most with a system fallback. A light and a dark scheme (`prefers-color-scheme`), readable at a narrow width, a table of contents for a long page. If the user names a page as the style to follow, follow its layout and tone.
- Save it in the session's scratchpad (otherwise a new `mktemp -d` directory), named after the topic. Do not put it in the repository or publish it unless asked.
- In chat, give the full absolute path, then only what the page cannot say for itself: which chapter holds the decision, what you found while writing that was not known before, what is tagged unconfirmed. Do not repeat the page in prose. You have not seen it render; ask the user to point at what is unclear or broken.

## 4. Keep it current

The user often keeps reading the page while the discussion goes on.

- On a follow-up, revise the same file rather than writing a second one, unless the user asks for a separate page.
- When a question in chat settles something the page covers, or corrects it, offer to write it back into the page.
- When a page is sent back as hard to follow, rewrite the part from its premises; do not paraphrase it with a metaphor.
