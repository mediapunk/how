# Creating a Visual Studio Code Theme


> **TL;DR** :
> Visual Studio Code does not seem to allow for customizing more than just colors and icons

## Customizing Color for the Workspace

Open the workspace .code-workspace file, and add some settings such as:

    {
        ...
        "settings": {
            ...
            "workbench.colorTheme": "Kimbie Dark",  // Choose  a default starting point

            "workbench.colorCustomizations": {
                // Main background colors (alpha is useless)
                "titleBar.activeBackground":"#4d4c4a",
                "activityBar.background":"#314108",
                "sideBar.background": "#262d26",
                "editor.background":"#383e3b",
            
                // Use alpha to blend with background colors
                "foreground":"#ffffe2cc",              // Basic text color
                "list.hoverBackground": "#ffff0033",   // File explorer hover
            }


## Custom Theme if You Really Want To

Visual Studio Code ships with extensions--including themes--which I found here:

    VSCODE_CONTENTS="/Applications/Visual Studio Code.app/Contents"
    VSCODE_EXT="$VSCODE_CONTENTS/Resources/app/extensions"

And third-party extensions were here:

    USER_EXT="$HOME/.vscode/extensions"


So first I duplicated one of the default theme extensions to my user extensions directory.

> ⚠️ **Warning** :
> Note the trailing slash in `$USER_EXT/`

    cd "$VSCODE_EXT"
    rsync -amv theme-tomorrow-night-blue "$USER_EXT/"

Inside the directory theme-tomorrow-night-blue we have

    theme-tomorrow-night-blue
    ├── package.json
    ├── package.nls.json
    └── themes
        └── tomorrow-night-blue-color-theme.json

All the json in the files is compacted to a single line.
To expand all of the JSON and edit the files in place, I did this:

    find . -type f -exec bash -c "jq '.' {} | sponge {}"  \;  


- Rename themes/tomorrow-night-blue-theme.json to themes/blue.json

      mv themes/tomorrow-night-blue-color-theme.json themes/blue.json

      find . -type f -name "*.json" -exec sed -i '' -E 's_("path": *")[^"]*_\1./themes/blue.json_g' {} \;



- Replace tomorrow-night-blue with mpnk-blue:

      find . -type f -name "*.json" -exec sed -i '' 's:tomorrow-night-blue:mpnk-blue:g' {} \;

- Replace "Tomorrow Night Blue" with "MPNK Blue":

      find . -type f -name "*.json" -exec sed -i '' 's:[Tt]omorrow [Nn]ight [Bb]lue:MPNK Blue:g' {} \;

- Switch the publisher:

      find . -type f -name "*.json" -exec sed -i '' -E 's_("publisher": *")[^"]*_\1Media Punk Studios, LLC_g' {} \;




#### Notes

Version: 1.92.2 (Universal)
OS: Darwin arm64 23.5.0

#### Homebrew Installations I used:
- `brew install tree` for showing a directory tree
- `brew install moreutils` for the `sponge` command
