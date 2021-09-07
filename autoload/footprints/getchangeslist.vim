" get list of linenumbers that should be highlighted
let s:changesListStore = 0
"
function! s:GetChangesList() abort
    let commandResult = ''
    let savedMore = &more
    set nomore
    redir => commandResult
    " change line col text
    changes
    redir END
    let &more = savedMore 
    return commandResult
endfunction

function! s:GetChangesLinenumbersListInner(historyDepth) abort
    silent let changesList = s:GetChangesList()
    let lines = split(changesList, "\n")
    let lines = lines[1:] " remove first line with headers
    let lines = lines[:-2] " remove last line with prompt
    if (len(lines) > a:historyDepth)
        let lines = lines[-a:historyDepth:] " get only needed
    endif
    let lineNumbers = []
    for line in lines
        let lineSpl = split(line)
        call add(lineNumbers, lineSpl[1])
    endfor
    return lineNumbers
endfunction

function! footprints#getchangeslist#GetChangesLinenumbersList(historyDepth) abort
    if s:changesListStore
        return s:changesListStore
    endif
    return s:GetChangesLinenumbersListInner(a:historyDepth)
endfunction

function! footprints#getchangeslist#ClearChangesList() abort
    let s:changesListStore = 0
    return 1
endfunction
" }}}
