function! s:GetMatches(groupName) abort
    let res = filter(getmatches(), { i, v -> l:v.group =~# a:groupName })
    let mapped = map(res, { i, item  -> item.id })
    return mapped
endfunction

function! footprints#clearhighlights#ClearHighlights(groupName) abort
    call map(s:GetMatches(a:groupName), { i, id -> matchdelete(id) })
endfunction

function! footprints#clearhighlights#ClearHighlightsInAllBuffers(groupName) abort
    let curwinnr = winnr()
    windo call map(s:GetMatches(a:groupName), { i, id -> matchdelete(id, winnr()) })
    execute curwinnr.' wincmd w'
endfunction
