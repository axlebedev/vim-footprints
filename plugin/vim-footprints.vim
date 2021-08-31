if exists("g:isLoadedFootprints") || &compatible || v:version < 700
    finish
endif
let g:isLoadedFootprints = 1

autocmd VimEnter * call footprints#FootprintsInit()

autocmd FileType * call footprints#OnFiletypeSet()

autocmd BufEnter * call footprints#OnBufEnter()

autocmd CursorMoved * call footprints#OnCursorMove()

autocmd TextChanged * call footprints#Footprints()
autocmd TextChangedI * call footprints#Footprints() 
autocmd FileType * call footprints#Footprints()
autocmd BufEnter * call footprints#Footprints()
autocmd BufLeave * call footprints#Footprints()

command -bar FootprintsDisable call footprints#Disable()
command -bar FootprintsEnable call footprints#Enable()
command -bar FootprintsToggle call footprints#Toggle()

command -bar FootprintsBufferDisable call footprints#Disable(1)
command -bar FootprintsBufferEnable call footprints#Enable(1)
command -bar FootprintsBufferToggle call footprints#Toggle(1)

command -bar FootprintsDisableCurrentLine call footprints#DisableCurrentLine()
command -bar FootprintsEnableCurrentLine call footprints#EnableCurrentLine()
command -bar FootprintsToggleCurrentLine call footprints#ToggleCurrentLine()
