if exists("g:isLoadedFootprints") || &compatible || v:version < 700
    finish
endif
let g:footprintsHistoryDepth = get(g:, 'footprintsHistoryDepth', 20)
let g:footprintsExcludeFiletypes = get(g:, 'footprintsExcludeFiletypes', ['magit', 'nerdtree', 'diff'])
let g:footprintsEasingFunction = get(g:, 'footprintsEasingFunction', 'easeInOut')
let g:footprintsEnabledByDefault = get(g:, 'footprintsEnabledByDefault', 1)
let g:footprintsOnCurrentLine = get(g:, 'footprintsOnCurrentLine', 0)
" Cold: 38403b
" Warm: 412d1e
let g:footprintsColor = get(g:, 'footprintsColor', '#6b4930')
let g:isLoadedFootprints = 1

autocmd VimEnter * call footprints#FootprintsInit()

autocmd FileType * call footprints#OnFiletypeSet()

" autocmd BufLeave * call footprints#BufLeaved()
" autocmd BufWinLeave * call footprints#BufLeaved()
" autocmd BufHidden * call footprints#BufLeaved()

autocmd BufEnter * call footprints#OnBufEnter()
" autocmd BufWinEnter * call footprints#OnBufEnter()
" autocmd BufNew * call footprints#OnBufEnter()
" autocmd BufCreate * call footprints#OnBufEnter()

autocmd CursorMoved * call footprints#OnCursorMove()

autocmd TextChanged * call footprints#Footprints()
autocmd TextChangedI * call footprints#Footprints() 
autocmd FileType * call footprints#Footprints()
autocmd BufEnter * call footprints#Footprints()
autocmd BufLeave * call footprints#Footprints()
" autocmd InsertLeave * call footprints#Footprints() 
" autocmd TextYankPost * call footprints#Footprints() 

command FootprintsDisable call footprints#Disable()
command FootprintsEnable call footprints#Enable()
command FootprintsToggle call footprints#Toggle()

command FootprintsDisableCurrentLine call footprints#DisableCurrentLine()
command FootprintsEnableCurrentLine call footprints#EnableCurrentLine()
command FootprintsToggleCurrentLine call footprints#ToggleCurrentLine()
