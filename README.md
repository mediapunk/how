# How
_A Static Website Built from Markdown Content_

## Build

Markdown content in the `content/` directory is converted to HTML via scripts:

- `build-all.sh`
- `build-page.sh`

which rely on Pandoc (https://pandoc.org) for the conversion.

To build the entire site, run:


```
./build-all.sh
```

which will put all of the HTML and CSS into a `_site` directory.

## Deploy

Github deploys the HTML static site to GitHub Pages, using the workflow in:

- `.github/workflows/pandoc-gh-pages.yaml`


## Dev

This repo also features a pre-commit hook to check that YAML files are valid. Run:
```
cd dev
./setup.sh
```
to install the pre-commit hook.


