vim9script

import autoload './clearhighlights.vim' as clearhighlights

var isErrorMessageShown: bool = false

export def UpdateMatches(groupName: string, bufnr: number, 
                                      linenumbersList: list<number>, historyDepth: number)
    var currentLine = line('.')
    clearhighlights.ClearHighlights(groupName)

    var i = 0 
    var maxI = min([len(linenumbersList), historyDepth]) 

    if !isErrorMessageShown && !hlexists(groupName .. (historyDepth - 1))
        isErrorMessageShown = true
        echo "No highlight group found for g:footprintsHistoryDepth=" .. g:footprintsHistoryDepth ..
             ". You should call footprints#SetHistoryDepth(" .. g:footprintsHistoryDepth .. ")"
    endif

    while i < maxI
        var lineNr = linenumbersList[i]
        if g:footprintsOnCurrentLine || lineNr != currentLine
            var highlightGroupName = groupName .. (maxI - i - 1)
            silent! var id = matchadd(highlightGroupName, '\%' .. lineNr .. 'l', -100009)
        endif
        i += 1
    endwhile
enddef
