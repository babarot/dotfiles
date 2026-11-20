---
name: design-doc
description: Write a design doc for other people to review from the design in a gist-plan Gist, in Notion. The doc carries the gist of the design and is thick only on its core; the Gist keeps the details, and reviewers' questions are answered from it. The outline is shown to the user before anything is written, figures go in as Mermaid or as PNG screenshots of local HTML, and the doc never links to or mentions the Gist. Use when the user asks to turn a gist-plan Gist into a design doc ("Gist を元に design doc を書いて", "Notion に設計書を起こして", "要旨で design doc にして"), or to bring an existing one up to date with the Gist. Not for the Gist itself (gist-plan), or for a page that teaches the user (teach-me).
---

# design-doc

The user keeps the design of a long piece of work in a gist-plan Gist. When it is ready for others, they want a design doc for reviewers: people who did not follow the work, reading it to approve the direction. The Gist stays the source of truth; the doc is a digest of it.

What the user asked for each time:

- The gist of the design, not a copy. Write the core parts (how it decides, how it stays safe, what it changes for others) in full, and the rest briefly. When a reviewer asks for more, the user answers from the Gist; the doc does not need to hold every detail.
- Readers are engineers. Spell things out in real terms; no metaphors.
- It is shown to people, so it states the design as it is now. How the design got there (open questions and their answers, earlier versions, the decision log) stays in the Gist.

## Never link to the Gist

The doc must not lead anyone to the Gist, with no exception, even when the user asks for details to be moved out of the doc. A secret Gist can be read by anyone who has its URL, and the doc is read by people the user does not choose.

- No Gist URL, Gist ID, clone path or Gist file name (`00-index.md`, `90-decisions.md`, ...) anywhere in the doc, its captions, its images or its comments.
- Do not mention that a Gist or another, more detailed design exists. Write nothing like "詳細は別資料".
- Do not carry over the Gist's own IDs (Q1, D9, S1a, ...). Name what they stand for instead.
- A figure taken from `80-diagrams.html` must not show its header (the Gist revision) or its links to Gist files.

The Gist may point to the doc; the doc never points back.

## 1. Read the Gist

- Pull the clone and read `00-index.md`, the design files and `90-decisions.md`, as gist-plan's resume step says.
- If open questions in the Gist touch the core of the design, tell the user before going on: a doc for review with its core undecided will be sent back.
- Read what the doc's readers will check it against: the code it changes, the issue it belongs to.

## 2. Show the outline and get it approved

Before creating anything, find where the doc goes and show the user its outline in chat.

- Where it goes: the user's organization usually keeps design docs in a Notion database with a template and a page on how to write one. Search Notion for them and read the template and the guide; follow the template's sections and the guide's rules. When there is none, use: background, goals and non-goals, the design, security, rollout, operations, open questions.
- The outline:
  - each section with one line of what it will say, and whether it is thick (the core) or thin;
  - each figure, what it shows, and whether it will be Mermaid or a PNG;
  - what will be left out on purpose, and why (details kept in the Gist, the history of decisions, anything that must not be shared widely).
- Template sections with nothing to say yet are dropped and named in the outline.
- Write the doc only after the user approves the outline.

## 3. Write

- In Japanese, follow the japanese-tech-writing skill.
- Assume anyone in the organization can read the doc. Leave out credentials, and the steps to exploit a weakness that is not fixed yet: write that it exists and is shared separately, and tell the user who needs to hear it.
- Write the conclusion of each thick section first, then what it rests on. Tables for comparisons (today against after, an attack against how it is blocked).
- State the open questions that remain as questions for the reviewers, in plain words, with the recommendation.

### Figures

- Use Mermaid for what it draws well: flowcharts, sequence diagrams, ER diagrams, state diagrams.
- Draw anything else as HTML and put it in as a PNG: time axes, before-and-after layouts, tables with marks, figures whose layout carries meaning. One HTML file per figure, in the session's scratchpad.
  - Light theme only, a fixed width of about 760px, no page margin around the figure.
  - Render with headless Chrome at device scale factor 2: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --screenshot=<png> --window-size=760,<height> --force-device-scale-factor=2 --hide-scrollbars file://<html>`. Fit the height to the figure.
  - Read each PNG before uploading it. Fix text that overflows a box, arrows over labels, and anything cut off.
- Give each figure a caption of a line or two saying what to read from it.
- A figure shows only what the Gist or the code says.

## 4. Put it in Notion

- Read the Notion-flavored Markdown spec (`notion://docs/notion-flavored-markdown-spec`) before writing the page. HTML tags other than Notion's are saved as literal text.
- Notion cannot show HTML: neither an embed nor an uploaded HTML file displays for readers. Figures go in as images.
- Upload each PNG with `notion-create-file-upload`, then send the file to the returned `upload_url` with `curl -X POST`, the returned headers and the file in the form field it names. The headers hold a token: do not print them. Put the image in the page with `<image source="file-upload://<id>">caption</image>`.
- Mermaid goes in as a ```` ```mermaid ```` code block. Notion shows it as code until someone switches the block to preview, which the API cannot do; tell the user which blocks to switch.
- Create the page as a draft in the database (its in-progress status), with the reviewer left empty. Setting a reviewer or moving it to a review status notifies other people; leave both to the user, and say what each one will set off.
- Fetch the page after creating it, and check that every image shows and no tag was left as text.
- Record the doc's URL in the Gist's `00-index.md` and push.

In chat: the URL, the sections written thick, the figures and how each went in, what was left out on purpose, and what the user has to do before review (switch the Mermaid blocks, set the reviewer, tell someone about what was left out for safety).

## 5. Keep it in line with the Gist

The doc and the Gist diverge as the work goes on, and the user edits the doc by hand for its readers.

- When the Gist's design changes, the doc is out of date; gist-plan says so in one line. Change the doc only when the user asks.
- Before changing it, fetch the page: the user may have edited it since. Base each edit on the current text and keep the user's edits unless they contradict the Gist; if they do, ask.
- Change only the parts the Gist's change affects, and redraw only the figures they show. Upload a redrawn PNG under a new name.
- When the user asks whether the doc and the Gist agree, compare the core of the design, and list the differences that change what a reviewer would approve. Differences in wording made for readers are not differences.
- Reviewers' comments on the doc: read them, and propose replies and changes (to the doc, and to the Gist when the design changes) for the user to check one by one. Do not reply in Notion or change the doc until the user says so.
