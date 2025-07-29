# Footprints vim plugin   <img src="readme/footprints.webp" height="48" />
Highlight last edited lines: visualisation of `:changes` command on the fly.
It helps to keep focus on lines you are working on  

### USAGE
Change any text.  
That's it. That line will be highlighted.  
The older change - the dimmer highlight.  

##### For Vim8 users
If you use vim8, you should use branch [vim8](https://github.com/axlebedev/vim-footprints/tree/vim8)

### DEMO

https://user-images.githubusercontent.com/3949614/158836795-809abfeb-1e6a-4af9-8129-6ba278376bd3.mp4

---

### INSTALLATION
Example of installation and setting configs
```
  Plug 'axlebedev/footprints'
  g:footprintsColor = '#3A3A3A'
  g:footprintsTermColor = '208'
  g:footprintsEasingFunction = 'linear'
  g:footprintsHistoryDepth = 20
  g:footprintsExcludeFiletypes = ['magit', 'nerdtree', 'diff']
  g:footprintsEnabledByDefault = 1
  g:footprintsOnCurrentLine = 0
```

---

### CONFIGURATION
##### `g:footprintsColor`
Default: `'#3A3A3A'` or `'#C1C1C1'` depending on `&background` setting  
Hex number. Color of the latest change highlight. Used in gui or if `&termguicolors`  
Older highlights will be dimmed to 'Normal' background according to `g:footprintsEasingFunction`.  
`g:footprintsColor = '#275970'`

##### `g:footprintsTermColor`
Default: `208`  
Number. Color of the latest change highlight. Used in terminal if not `&termguicolors`  
`g:footprintsEasingFunction` is ignored.  
`g:footprintsTermColor = '186'`

##### `g:footprintsEasingFunction`
Default: `'linear'`  
One of `linear`, `easein`, `easeout`, `easeinout`.  
How does footprint color 'cooldown' to usual background color  
`g:footprintsEasingFunction = 'easeinout'`  
![Easings example](readme/easings.png)

##### `g:footprintsHistoryDepth`
Default: `20`  
How many steps should be highlighted  
`g:footprintsHistoryDepth = 10`  

##### `g:footprintsExcludeFiletypes`
Default: `[]`  
Which filetypes should not be processed by this plugin  
`g:footprintsExcludeFiletypes = ['magit', 'nerdtree', 'diff']`  

##### `g:footprintsEnabledByDefault`
Default: `1`  
Boolean. Define if this plugin is enabled on vim start  
`g:footprintsEnabledByDefault = 1`  

##### `g:footprintsOnCurrentLine`
Default: `0`  
Boolean. Define if current line should be highlighted or not.  
`g:footprintsOnCurrentLine = 0`  

---

### COMMANDS

`:FootprintsDisable`  
`:FootprintsEnable`  
`:FootprintsToggle`  

  Enable/disable Footprints globally  

---

`:FootprintsBufferDisable`  
`:FootprintsBufferEnable`  
`:FootprintsBufferToggle`  

  Enable/disable Footprints only in current buffer

---

`:FootprintsCurrentLineDisable`  
`:FootprintsCurrentLineEnable`  
`:FootprintsCurrentLineToggle`  

  Enable/disable Footprint highlight for current line

---

### API
First, import these functions:  
`import 'footprints.vim'`

##### `footprints.SetColor(hexColor: string)`
Set `g:footprintsColor` and update highlights to new color.  
Note: this change will not be saved to next vim run, use `g:footprintsColor` for persistent change.  
`footprints.SetColor('#FF0000')`  

##### `footprints.SetTermColor(termColorCode: number)`
Set `g:footprintsTermColor` and update highlights to new color.  
Note: this change will not be saved to next vim run, use `g:footprintsTermColor` for persistent change.  
`footprints.SetTermColor(200)`  

##### `footprints.SetHistoryDepth(depth: number)`
Set `g:footprintsHistoryDepth` and update highlights to new depth.  
Note: this change will not be saved to next vim run, use `g:footprintsHistoryDepth` for persistent change.  
`footprints.SetHistoryDepth(200)`  

##### `footprints.Footprints()`
Update footprints in current buffer  
`footprints.Footprints()`  

##### `footprints.OnBufEnter()`
Update footprints on bufenter or any other case when current window contains some older highlights  
`footprints.OnBufEnter()`  

##### `footprints.OnCursorMove()`
Update footprints when content was not changed, only update current line highlight  
`footprints.OnCursorMove()`  

##### `footprints.FootprintsDisable(forCurrentBuffer: bool = false)`
##### `footprints.FootprintsEnable(forCurrentBuffer: bool = false)`
##### `footprints.FootprintsToggle(forCurrentBuffer: bool = false)`
Disable, enable or toggle footprints.
```
    footprints.FootprintsDisable(false)
    footprints.FootprintsEnable(true)
    footprints.FootprintsToggle(true)
```

##### `footprints.FootprintsEnableCurrentLine()`
##### `footprints.FootprintsDisableCurrentLine()`
##### `footprints.FootprintsToggleCurrentLine()`
Disable, enable or toggle footprint on current line.
```
footprints.FootprintsDisableCurrentLine()
footprints.FootprintsEnableCurrentLine()
footprints.FootprintsToggleCurrentLine()
```

---

### TROUBLESHOOTING
If you use NeoVim, version 0.5+ is required

### NOTES
If you find a bug, or have an improvement suggestion -
please place an issue in this repository.

---

Check out my other Vim plugins:   
https://github.com/axlebedev
