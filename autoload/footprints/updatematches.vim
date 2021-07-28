" {{{
" set highlight groups to lines of code

function! footprints#updatematches#UpdateMatches(groupName, bufnr, linenumbersList, historyDepth) abort
    let currentLine = line('.')
    call footprints#clearhighlights#ClearHighlights(a:groupName)

    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        if g:footprintsOnCurrentLine || lineNr != currentLine
            let highlightGroupName = a:groupName.(maxI - i - 1)
            let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -100009)
        endif
        let i = i + 1
    endwhile
endfunction
" }}}
