" {{{
" set highlight groups to lines of code

let s:isErrorMessageShown = 0

function! footprints#updatematches#UpdateMatches(groupName, bufnr, linenumbersList, historyDepth) abort
    let currentLine = line('.')
    call footprints#clearhighlights#ClearHighlights(a:groupName)

    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth]) 

    " Contentful message about https://github.com/axlebedev/footprints/issues/4
    if (!s:isErrorMessageShown && !hlexists(a:groupName.(a:historyDepth-1)))
        let s:isErrorMessageShown = 1
        echo "No highlight group found for g:footprintsHistoryDepth=".g:footprintsHistoryDepth.".
        \ You should call footprints#SetHistoryDepth(".g:footprintsHistoryDepth.")"
    endif

    while i < maxI
        let lineNr = a:linenumbersList[i]
        if g:footprintsOnCurrentLine || lineNr != currentLine
            let highlightGroupName = a:groupName.(maxI - i - 1)
            " silent!: Avoid crash message https://github.com/axlebedev/footprints/issues/4
            silent! let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -100009)
        endif
        let i = i + 1
    endwhile
endfunction
" }}}
