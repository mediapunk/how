---
title: BASH Snippets
date: August 8, 2024
css-path: ../css/custom.css
---

## Resolve Links and Get Absolute Path

```
$(readlink -f -- "$FILE_SYS_PATH" )
```