<img style="float:right" src="readme/footprints.png" />

# Footprints <small>vim plugin</small>

Footprints is a plugin thqt makes visualisation of command `:changes` on the fly.
It helps to keep focus on lines you are working on
TODO: gif

### USAGE
Change any text.  
That line will be highlighted.  
The older change - the dimmer highlight.

### CONFIGURATION
`g:footprintsColor` (default: `#6b4930`)  
Hex number. Color of the latest change highlight
```
  let g:footprintsColor = '#38403b'
```

`g:footprintsTermColor` (default: `208`)  
Number. Color of the latest changes highlights
In terminal it is one color for all footprints,
|g:footprintsEasingFunction| is ignored.
```
  let g:footprintsTermColor = '186'
```

`g:footprintsEasingFunction` (default: `'linear'`)
  One of `linear`, `easein`, `easeout`, `easeinout`.  
  How does footprint color 'cooldown' to usual background color
```
  let g:footprintsEasingFunction = 'easeinout'
```
TODO: image

`g:footprintsHistoryDepth` (default: `20`)
How many steps should be highlighted
```
  let g:footprintsHistoryDepth = 10
```

`g:footprintsExcludeFiletypes` (default: `[]`)
Which filetypes should not be processed by this plugin
```
  let g:footprintsExcludeFiletypes = '['magit', 'nerdtree', 'diff']'
```

`g:footprintsEnabledByDefault` (default: `1`)
Boolean. Define if this plugin is enabled on vim start 
```
  let g:footprintsEnabledByDefault = 1
```

`g:footprintsOnCurrentLine` (default: `0`)
Boolean. Define if current line should be highlighted or not.
```
  let g:footprintsOnCurrentLine = 0
```
TODO: image

### COMMANDS

`:FootprintsDisable`  
`:FootprintsEnable`  
`:FootprintsToggle`  

  Enable/disable Footprints globally  

`:FootprintsBufferDisable`  
`:FootprintsBufferEnable`  
`:FootprintsBufferToggle`  

  Enable/disable Footprints only in current buffer

`:FootprintsCurrentLineDisable`  
`:FootprintsCurrentLineEnable`  
`:FootprintsCurrentLineToggle`  

  Enable/disable Footprint highlight for current line

### API

`footprints#Footprints()`
Update footprints in current buffer
```
    call footprints#Footprints()
```

`footprints#OnBufEnter()`
Update footprints on bufenter or any other case when current window contains some older highlights
```
    call footprints#OnBufEnter()
```

`footprints#OnCursorMove()`
Update footprints when content was not changed, only update current line highlight
```
    call footprints#OnCursorMove()
```

`footprints#Disable(forCurrentBuffer: bool)`
`footprints#Enable(forCurrentBuffer: bool)`
`footprints#Toggle(forCurrentBuffer: bool)`
Disable, enable or toggle footprints.
`forCurrentBuffer == 0` - do it globally
`forCurrentBuffer == 1` - do only for current buffer
```
    call footprints#Disable(0)
    call footprints#Enable(1)
    call footprints#Toggle(1)
```

`footprints#EnableCurrentLine()`
`footprints#DisableCurrentLine()`
`footprints#ToggleCurrentLine()`
    Disable, enable or toggle footprint on current line.
```
    call footprints#DisableCurrentLine()
    call footprints#EnableCurrentLine()
    call footprints#ToggleCurrentLine()
```

### CONTRIBUTIONS
Contributions and pull requests are welcome.  
If you find a bug, or have an improvement suggestion -
please place an issue in this repository.

### TODO
FootprintsDisable should work immediately
