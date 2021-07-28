let s:isEnabled = 0

let s:groupName = 'FootstepsStep'


" {{{
" set highlight groups to lines of code

function! s:UpdateMatches(bufnr, linenumbersList, historyDepth) abort
    let currentLine = line('.')
    call footprints#clearhighlights#ClearHighlights(s:groupName)

    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        if g:footprintsOnCurrentLine || lineNr != currentLine
            let highlightGroupName = s:groupName.(maxI - i - 1)
            let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -100009)
        endif
        let i = i + 1
    endwhile
endfunction
" }}}

" {{{
" main
"
function! s:FootprintsInner(bufnr) abort
    if !s:isEnabled || !&modifiable || &diff || index(g:footprintsExcludeFiletypes, &filetype) > -1
        call footprints#clearhighlights#ClearHighlights(s:groupName)
        return
    endif
    call footprints#getchangeslist#ClearChangesList()
    call s:UpdateMatches(a:bufnr, footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
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
    if !s:isEnabled || !&modifiable || &diff || index(g:footprintsExcludeFiletypes, &filetype) > -1 || g:footprintsOnCurrentLine
        return
    endif
    call s:UpdateMatches(bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
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
    call s:UpdateMatches(bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#DisableCurrentLine() abort
    let g:footprintsOnCurrentLine = 0
    call s:UpdateMatches(bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#ToggleCurrentLine() abort
    if g:footprintsOnCurrentLine
        call footprints#DisableCurrentLine()
    else
        call footprints#EnnableCurrentLine()
    endif
endfunction
