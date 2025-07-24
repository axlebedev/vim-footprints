vim9script

import autoload '../autoload/footprints.vim' as footprints

if exists("g:isLoadedFootprints")
    finish
endif

if &compatible
    echom 'Footprints load aborted: can not load if compatible'
    finish
endif

if v:version < 700
    echom 'Footprints load aborted: vim should be version 7+'
    finish
endif

if has('nvim') && !has('nvim-0.5')
    echom 'Footprints load aborted: NewVim should be version 0.5+'
    finish
endif

g:isLoadedFootprints = true

augroup footprints
    autocmd VimEnter * footprints.FootprintsInit()
    autocmd FileType * footprints.OnFiletypeSet()
    autocmd BufEnter * footprints.OnBufEnter()
    autocmd CursorMoved * footprints.OnCursorMove()
    autocmd TextChanged * footprints.Footprints()
    autocmd TextChangedI * footprints.Footprints()
    autocmd FileType * footprints.Footprints()
    autocmd BufEnter * footprints.Footprints()
    autocmd BufLeave * footprints.Footprints()
augroup END

command -bar FootprintsDisable footprints.FootprintsDisable()
command -bar FootprintsEnable footprints.FootprintsEnable()
command -bar FootprintsToggle footprints.FootprintsToggle()

command -bar FootprintsBufferDisable footprints.FootprintsDisable(true)
command -bar FootprintsBufferEnable footprints.FootprintsEnable(true)
command -bar FootprintsBufferToggle footprints.FootprintsToggle(true)

command -bar FootprintsDisableCurrentLine footprints.FootprintsDisableCurrentLine()
command -bar FootprintsEnableCurrentLine footprints.FootprintsEnableCurrentLine()
command -bar FootprintsToggleCurrentLine footprints.FootprintsToggleCurrentLine()
