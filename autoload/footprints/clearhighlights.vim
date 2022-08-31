function! s:GetMatches(groupName) abort
    let res = filter(getmatches(), { i, v -> l:v.group =~# a:groupName })
    let mapped = map(res, { i, item  -> item.id })
    return mapped
endfunction

function! footprints#clearhighlights#ClearHighlights(groupName) abort
    call map(s:GetMatches(a:groupName), { i, id -> matchdelete(id) })
endfunction

function! footprints#clearhighlights#ClearHighlightsInAllBuffers(groupName) abort
    for bufn in tabpagebuflist()
        let winn = bufwinnr(bufn)
        call map(s:GetMatches(a:groupName), { i, id -> matchdelete(id, winn) })
    endfor
endfunction
