let s:isEnabled = 0
let s:groupName = 'FootprintsStep'

function! s:GetIsEnabled()
    if exists("b:isEnabled")
        return b:isEnabled
    endif
    return s:isEnabled
endfunction

function! s:ShouldUpdateMatches() abort
    return s:GetIsEnabled() && &modifiable && !&diff && index(g:footprintsExcludeFiletypes, &filetype) == -1
endfunction

function! s:RunUpdateMatches()
    call footprints#updatematches#UpdateMatches(s:groupName, bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! s:FootprintsInner(bufnr) abort
    if !s:ShouldUpdateMatches()
        call footprints#clearhighlights#ClearHighlights(s:groupName)
        return
    endif
    call footprints#getchangeslist#ClearChangesList()
    call s:RunUpdateMatches()
endfunction

function! footprints#FootprintsInit() abort
    call footprints#declarehighlights#DeclareHighlights(s:groupName, g:footprintsColor, g:footprintsHistoryDepth)
    let s:isEnabled = g:footprintsEnabledByDefault
endfunction

function! footprints#Footprints() abort
    call s:FootprintsInner(bufnr())
endfunction

function! footprints#OnBufEnter() abort
    call footprints#clearhighlights#ClearHighlights(s:groupName)
    call s:FootprintsInner(bufnr())
endfunction

function footprints#OnFiletypeSet() abort
    call footprints#clearhighlights#ClearHighlights(s:groupName)
    call s:FootprintsInner(bufnr())
endfunction

function! footprints#OnCursorMove() abort
    if !s:ShouldUpdateMatches() || g:footprintsOnCurrentLine
        return
    endif
    call s:RunUpdateMatches()
endfunction

function! footprints#Disable() abort
    call s:footprints#clearhighlights#ClearHighlightsInAllBuffers(s:groupName)
    let s:isEnabled = 0
endfunction

function! footprints#Enable() abort
    let s:isEnabled = 1
    windo call footprints#FootprintsInner(winbufnr(winnr()))
endfunction

function! footprints#Toggle() abort
    if s:isEnabled
        call footprints#Disable()
    else
        call footprints#Enable()
    endif
endfunction

function! footprints#EnableCurrentLine() abort
    let g:footprintsOnCurrentLine = 1
    call s:RunUpdateMatches()
endfunction

function! footprints#DisableCurrentLine() abort
    l
    et g:footprintsOnCurrentLine = 0
    call s:RunUpdateMatches()
endfunction

function! footprints#ToggleCurrentLine() abort
    if g:footprintsOnCurrentLine
        call footprints#DisableCurrentLine()
    else
        call footprints#EnnableCurrentLine()
    endif
endfunction
