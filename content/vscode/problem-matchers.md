
# VS Code Problem Matchers

### Documentation

https://code.visualstudio.com/Docs/editor/tasks#_defining-a-problem-matcher

### Examples

Defined with a task:

```
"tasks": [
    { ... },
    { 
        ...
        "problemMatcher": { ... }
        ...
    },
```

I think that the owner might be arbitrary text. Haven't seen any official list owners for problem matchers.

Whole-File (No Line Number) Problem Matchers.
For this kind, there is no need to provide a line or location property.

```
"problemMatcher": {
    "owner": "preflight-checks",
    "fileLocation": "autoDetect",
    "pattern": [{
```
```json
        "kind": "file", // this kind handles whole-file errors, not line errors
```
```
        "regexp": "^\\[(.*)\\]\\s*error: (.*)$",
        "file": 1,
        "message": 2,
    }]
}
```

Line Problem Matchers

```
"problemMatcher": {
    "owner": "python",
    "fileLocation": "autoDetect",
    "pattern": [
        {
            "file": 1,
            "line": 2,
            "message": 3,
            "regexp": "^.*File \\\"(.+)\\\", line (\\d+), (.*)$"
        }
    ]
},

```
"problemMatcher": {
    "owner": "python",
    "fileLocation": "autoDetect",
    "pattern": [
        {
            "file": 3,
            "message": 2,
            "severity": 1
            "regexp": "^\** *([A-Z]*) *(.*) ([^ ]*)$"
        }
    ]
},



Multi Line Problem Matchers

first regular expression to capture the file name and the second to capture the line, column, severity, message, and error code

```json
"pattern": [
{
    "regexp": "^([^\\s].*)$",
    "file": 1
},
{
    "regexp": "^\\s+(\\d+):(\\d+)\\s+(error|warning|info)\\s+(.*)\\s\\s+(.*)$",
    "line": 1,
    "column": 2,
    "severity": 3,
    "message": 4,
    "code": 5
```
```json
    "loop": true // optional -- repeats the last pattern as long as it keeps matching
```
```
}
]
```


### Example `regexp` Patterns

Note that backslashes `\` are escaped `\\`.

```sh
^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$
```