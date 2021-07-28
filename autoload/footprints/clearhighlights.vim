function! s:GetMatches(groupName) abort
    return filter(getmatches(), { i, v -> l:v.group =~# a:groupName })
endfunction

function! footprints#clearhighlights#ClearHighlights(groupName) abort
    call map(s:GetMatches(a:groupName), { i, item -> matchdelete(item.id) })
endfunction

function! footprints#clearhighlights#ClearHighlightsInAllBuffers(groupName) abort
    windo call map(s:GetMatches(a:groupName), { i, item -> matchdelete(item.id) })
endfunction
