---
name: mock-me
description: Build a mock of a real screen (a CLI or TUI, a web app, or a screen known only from a screenshot such as GitHub's) as a local interactive HTML file, so the user can try a feature under design before it is built: change the inputs, flip the undecided design options, and watch the copied screen respond. A replica of the screen, not an explanation. Use only when the user asks for a mock by that word ("モックが見たい", "モックを作って", "画面のモック", "モックで試したい"). Not for an HTML page that explains a design (teach-me) or a mechanism shown through a worked example (explain-me), even when those are interactive.
---

# mock-me

The user is designing a feature and wants to see it work: what the screen does when they change a setting, press a key, or wait for data. A design document says what should happen; the mock lets them watch it happen and judge it. Build one local HTML file that looks like the real UI and behaves like the feature would. The page is a replica of the screen, not an explanation: no chapters, no diagrams of the mechanism, text only to label the controls. When the user wants the design explained, that is teach-me.

What made users send mocks back:

- It did not look like the real thing. The user compares the mock with the UI they use every day; colors, widths, glyphs or layout that are off distract from the feature and make them doubt the rest. Take the look from the real UI, not from memory or an old reference.
- A switch between design options showed no difference. The options differed only in a state the default data never reached (a slow load that had already finished, a condition no preset used). Every switch must change what is on screen from the first load.
- Controls were far from what they affect. Keep the generated artifact and its apply button next to the screen it changes.

## 1. Decide what the mock shows

Before writing anything, name these from the conversation and the design document:

- Inputs: what the user of the feature writes or does. A config file, a query, a form, keys or clicks.
- The artifact, if the feature turns the inputs into one the user would see: the config file, an API request, a command line. Show it, generated live; it is half of what the user wants to check.
- The screen: which views, tabs or states of the real UI the feature touches.
- Undecided design options. When a design document lists open questions (Q1, Q2, ...), each one the screen can show becomes a switch. Implement the recommended answer for the rest and say so.
- Time: anything that arrives later (loading, async results, a background job, a push from elsewhere). Its in-between states are often where the options differ.

## 2. Take the look from the real UI

Pick the reference by what you have, read it, and follow it:

| You have | Read |
|---|---|
| The source, and it draws in a terminal | [references/cli.md](references/cli.md) |
| The source, and it draws in a browser | [references/web.md](references/web.md) |
| No source to run: a third-party screen (GitHub, Slack, ...) or only an image | [references/screenshot.md](references/screenshot.md) |

- When the user gives a reference page or image and it disagrees with what the current code draws, the current code wins for the screen; the reference can still set the page around it. Say which you followed.
- Anything you add to a repository to capture the real UI (a temporary test, a script) is removed before you hand over, and you say so.

## 3. Lay out the page

- A header with the switches for undecided options, each with one line saying what it does, and the speed control (below).
- The inputs: an editor for what the user would write, with presets for the typical cases. Validate as the real tool does when you know its rules, and show the error next to the field.
- The artifact, regenerated on every change, next to the screen.
- When the real tool reads its input at start (a config file), separate the draft from what is applied: an apply button ("保存して起動") restarts the fake tool with the draft, and a badge says when the draft has changes not applied. When the real UI reacts at once, skip this.
- The screen, operable with the real keys or clicks. For keys, also put buttons under it, since the screen needs focus to take them.
- A short log of what happened (started with N rules, data arrived, a push came in) when the screen changes on its own.
- Text on the page is in the user's language; text on the fake screen is whatever the real UI shows.

## 4. Make the differences visible

- Data: made up, every repository, person and value invented, nothing from work. Cover every case the feature distinguishes (a bot, a draft, a merged one, unread, a long title that gets cut), so each condition has something to match.
- Defaults: the first load must already show what each switch changes. Put a preset in the initial input that reaches the state where the options differ.
- Time: simulate what arrives later with timers, in small batches so the change is visible. Offer speeds from instant to very slow, plus "stop" (it never arrives, as when the request fails); default to slow. Changing the speed resumes what is left.
- Keep what the real UI already does apart from what is proposed. Where the mock draws something that does not exist yet (a new mark, a new line of text), it is a proposal; list those in the report.

## 5. Check it before handing over

- Run the logic headless (`node` on the script, with the DOM calls stubbed or the logic split out): for each switch and preset, what is shown, hidden or changed. Compare with what the design says.
- Check the layout invariants the reference names (for a terminal, every line exactly as wide as the screen).
- Look at it. Take a screenshot with headless Chrome, which both Macs have, and read the image:

  ```bash
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu \
    --hide-scrollbars --window-size=1600,1100 --virtual-time-budget=4000 \
    --screenshot="$SCRATCHPAD/shot.png" "file://$MOCK"
  ```

  `--virtual-time-budget` lets the page's timers run first; without it the shot shows the first frame, usually a loading state. Lower it to catch an in-between state. Put the screenshot next to the capture of the real UI and fix what differs.

## 6. Hand over

- One `.html` in the session's scratchpad (otherwise a new `mktemp -d` directory), named after the feature, with `-mock` at the end. Self-contained: inline CSS and JS. A stylesheet or font from a CDN only when the reference says so, pinned to an exact version. Not in the repository unless asked.
- In chat: the full absolute path, how to use it in a few numbered steps, and what to look at for each point the user cares about (which preset, which switch, which speed). Then what is a proposal rather than current behavior, what you simplified (batch sizes, timings, data), and what you could not check.
- When there is a design document, map its open questions to the mock: which ones it implements as recommended, which ones are switches, which ones it does not show. List where the mock and the document disagree, and offer to write the new findings back into the document.
- On a follow-up, revise the same file. After each change, run the checks again and take a new screenshot.
