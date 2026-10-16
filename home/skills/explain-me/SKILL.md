---
name: explain-me
description: Explain how a specific mechanism works as one self-contained interactive HTML file, built around a concrete worked example the reader can step through, toggle and compare. Every state shown is traced from the source and verified, never guessed. Runs only when invoked as /explain-me <topic>.
disable-model-invocation: true
---

# explain-me

Build one HTML file that explains the topic by showing it, not by describing it. The page is the explanation; text only labels it. A page that reads like a Markdown answer wrapped in `<div>`s has failed.

Topic: $ARGUMENTS

## Truth comes first

A polished page looks authoritative, so a wrong one does more harm than wrong prose: the reader trusts it and builds on it. This rule overrides everything below.

- Show only what you have confirmed from a source: the code, a spec or doc, the output of a command you ran. Do not invent a step to make the picture tidier.
- If you do not understand part of the mechanism, leave it out or ask. Saying "I can't draw X truthfully yet" is a correct outcome.
- What you could not confirm but still show carries a visible "assumption" tag on the page.
- Fewer states and controls mean fewer places to be wrong. When in doubt, show less.

## 1. Understand it

- Read the source before designing anything. The source is the authority, not the user: the user usually invoked this because they do not know it yet, so do not quiz them. Ask only when an ambiguity would make the picture false and the source cannot settle it.
- For a topic outside the current codebase, ground it in primary documentation or a spec, and say in the page which one.
- Pick one concrete worked example: the smallest input that still shows the interesting behavior (a real request, a real string, a real commit graph). Trace it through by hand, state by state, and write the states down.

## 2. Pick the interaction

Choose by what the concept is, and combine only when it helps:

- Stepper: one example through ordered states, forward and back. For protocols, algorithms, lifecycles.
- Toggle or tabs: the same state read two ways (before and after, naive and correct, current and intended).
- Side by side: two designs running the same example.
- Concrete state: draw the object itself (characters in boxes, a queue as cells, a tree as nodes) rather than a description of it.
- Diff: what changed between two states, the rest dimmed.
- Progressive reveal: overview first, detail on demand.
- Playground: the reader changes the input and watches the result. Only when the concept is a transformation worth playing with (see below).

## 3. Build it

- Bake the hand-traced states into the page as data; the script only shows them one by one. Live computation is a second program that can be wrong on inputs you never traced. If you do build a playground, run its logic first (e.g. in node) and check it reproduces the traced example.
- One `.html` file, CSS and JS inline, vanilla, no build step and no network: it opens offline. A web font from a CDN is the only allowed fetch, with a system font fallback.
- Colors carry meaning and keep it across the page (if green means accepted, it means accepted everywhere), with a small legend. Motion only to show cause (an index shifting), never for decoration.
- Support light and dark (`prefers-color-scheme`) and a narrow window.
- Write the page in the user's language. If the frontend-design skill is available, use it for type and color; otherwise keep it plain and legible.

## 4. Hand it over

- Write the file to the session's scratchpad directory when the harness gives one, otherwise to a new directory from `mktemp -d`. Name it after the topic (`git-rebase-onto.html`). Do not put it in the repository, open it, or publish it anywhere; on a revision, overwrite the same file.
- In chat, give the full absolute path, then only what the page cannot say for itself: where to click to reach the key moment ("step to 3, then flip to after: that's where the index goes stale"), and any assumption you tagged. Do not repeat the explanation in prose.
- You have not seen it render. Do not say it looks right; ask the user to open it and point at what is off.

## Before handing over

- Can you name the source of every state, label and transition? Unconfirmed ones are removed or tagged.
- Is there a real example, not boxes labeled "State A"?
- With the text hidden, does the picture still carry the idea?
- Could a state, control or effect go without losing the point? Then remove it.
- One page, one idea.
