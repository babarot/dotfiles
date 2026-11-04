# Mocks from a screenshot

For a screen you cannot run from source: a third-party product (a GitHub page, Slack, a SaaS dashboard), or a screen the user only has as an image.

Untested: no mock has been built this way yet. Revise this page from the first session that does, and drop what did not work.

## Get the real screen

- Ask the user for screenshots of the screen and the states the feature touches, or for the page saved as HTML ("Save Page As", complete). A saved page gives the markup and the styles; an image gives only the look.
- A public page can be captured directly with headless Chrome (`--screenshot`, `--dump-dom`). A page behind a login cannot; do not ask for credentials.
- Note the theme (light or dark) and the width of what you were given, and build the mock at the same.

## Rebuild the look

- When the product publishes its design system, use it rather than imitating it by eye. GitHub's is Primer: Primer CSS and Octicons from a CDN, pinned to an exact version, with the color mode set to match the screenshot.
- From a saved page, copy the markup of the part you need and keep its class names, so the design system styles it. Replace content with made-up data.
- From an image only, rebuild the layout with the design system's components where it has them, and measure spacing and sizes from the image (at its device pixel ratio) where it does not.
- Draw only the part of the screen the feature changes, with enough around it to place it (the header, the column it sits in). A whole page copied by hand drifts from the original in many small places.
- Do not copy the product's logo or anything that would let the page pass as the real site.

## Checks

- Screenshot the mock at the size of the original and put them side by side. Fix spacing, font sizes and colors until the feature's part reads the same.
- Mark on the page that it is a mock with invented data.
