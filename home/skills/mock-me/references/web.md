# Web app mocks

For a web app whose source you have and can run.

Untested: no mock has been built this way yet. Revise this page from the first session that does, and drop what did not work.

## Capture the real page

- Run the app locally with its dev server and fake or seed data, never against production.
- Screenshot the screens the feature touches with headless Chrome (the command in SKILL.md, pointed at the dev server's URL), at the widths that matter (desktop, and phone width when the screen is used there).
- Save the rendered HTML of each screen: `--dump-dom` instead of `--screenshot` in the same command. A page behind a login needs a session; ask the user for a saved page or a seed user rather than their credentials.

## Reuse the real styles

Do not pick colors off the screenshot when the styles are in the repository.

- Find where the look is defined: CSS variables or design tokens, a Tailwind config, a component library and its theme.
- Inline the built CSS in the mock (the stylesheet the dev server serves, or the tokens and the component styles the screen uses), so the mock's markup gets the same look from the same classes.
- Copy the screen's markup from the saved DOM and keep its class names. Replace the content with made-up data, and drop scripts, tracking and framework attributes.
- Icons: inline the SVGs the app uses.

## Behavior

- Write the feature's behavior in plain JS over the copied markup, not in the app's framework, so the file stays self-contained.
- Reproduce loading and empty states the way the app draws them (its skeletons, spinners and messages), since these are often where design options differ.

## Checks

- Screenshot the mock at the same widths as the capture and compare them side by side.
- Check light and dark when the app has both.
