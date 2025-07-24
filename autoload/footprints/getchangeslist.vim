vim9script

var changesListStore: number = 0

def GetChangesList(): string
    var commandResult = ''
    var savedMore = &more
    &more = false
    redir => commandResult
    changes
    redir END
    &more = savedMore
    return commandResult
enddef

def GetChangesLinenumbersListInner(historyDepth: number): list<number>
    silent var changesList = GetChangesList()
    var lines = split(changesList, "\n")
    lines = lines[1 : ]  # remove first line with headers
    lines = lines[ : -2]  # remove last line with prompt
    if len(lines) > historyDepth
        lines = lines[-historyDepth : ]  # get only needed
    endif
    var lineNumbers: list<number> = []
    for line in lines
        var lineSpl = split(line)
        add(lineNumbers, str2nr(lineSpl[1]))
    endfor
    return lineNumbers
enddef

export def GetChangesLinenumbersList(historyDepth: number): list<number>
    if changesListStore
        return [changesListStore]
    endif
    return GetChangesLinenumbersListInner(historyDepth)
enddef

export def ClearChangesList(): bool
    changesListStore = 0
    return true
enddef
