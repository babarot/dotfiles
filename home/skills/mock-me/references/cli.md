# CLI and TUI mocks

For a tool whose source you have and which draws in a terminal. Worked out on a mock of a TUI's list screen (a config of exclude rules, a list that drops matching rows, data arriving in two stages).

## Capture the real screen

Get what the program draws today, with its colors, at a fixed size.

- Best: the project's own test harness. Many TUIs (Bubble Tea, Ratatui, ...) have tests that render a model to a string. Add a temporary test that builds the screens you need from the project's fixtures, at the size the mock will use (for example 130×34), and writes the rendered string with its ANSI escapes to files in the scratchpad. Render each state the feature touches: each tab, a row selected, a group folded, the preview open, a loading state.
- Without such tests: run the program in tmux with fake data and `tmux capture-pane -e -p` (keeps the escapes), or record it with VHS.
- Turn the escapes into HTML spans (a short script that maps SGR codes to `color`, `background`, `font-weight`) and read off:
  - the theme's colors, each named by its role (text, muted, dim, accent, selection background, tab background, box lines);
  - the column widths and the gap between columns;
  - the glyphs for each state (cursor, unread, check passed or failed, a cell not read yet) and the box drawing of panes;
  - fixed text: the tab bar, column heads, the status line, the key hints.
- Read the code for what a capture does not show: how a cell is cut when too long (`…`), which column gives way when the terminal is narrow, how ages and sizes are written.
- Delete the temporary test and any files it wrote in the repository; `git status` should be clean.

## Draw the screen

- A fixed `W×H` in cells. The screen is one `<pre>` in a monospace font, rebuilt on every change.
- A line is a list of segments `[text, fg, bg, bold]`. Helpers: `fit(text, w)` cuts with `…` or pads, `cell(segments, w, right)` fits a cell, `padLine(line, bg)` fills to `W`, `onBg(line, bg)` paints a selected row. One function turns segments into spans.
- Use only glyphs that are one cell wide. `⋅` (U+22C5) is one cell, `·` (U+00B7) is East Asian Ambiguous and can take two; check any new glyph the same way, or the columns after it move.
- Copy the colors into a palette object with the role names, and use only those.
- Build the screen top to bottom as the real one is: tab bar, column heads, rows, filler to the pane, the preview pane, status line, key hints. Count the rows the list gets from `H` minus everything else, and keep the cursor's row in view with an offset.
- Keys: a `tabindex="0"` container takes `keydown`; a row of buttons under it sends the same keys.

## Motion

- Spinner: the frames the real tool uses (`⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏` is common), picked from `Date.now()` so every spinner on screen agrees.
- Shimmer or any sweep: color each character by its distance from a position that moves with `Date.now()`, over the column it belongs to only. All rows sweep together unless the real tool staggers them.
- Redraw on a 40 to 100 ms interval only while something moves, to keep the page idle otherwise.
- Data in stages (a quick search first, slow fields later): mark each record with what has arrived, draw the real tool's placeholder in the cells still missing, and deliver the rest with timers in batches.

## Checks

- Every line of every state is exactly `W` cells (count with `[...text].length` after stripping tags). Run it headless for each tab and switch.
- In the screenshot, compare with the capture: column positions, colors of each state, the cut of long titles, box corners meeting.
