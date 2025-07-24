vim9script

def GetMatches(groupName: string): list<number>
    var res = getmatches()->filter((_, v) => v.group =~# groupName)
    return res->mapnew((_, item) => item.id)
enddef

export def ClearHighlights(groupName: string)
    map(GetMatches(groupName), (_, id) => matchdelete(id))
enddef

export def ClearHighlightsInAllBuffers(groupName: string)
    for bufn in tabpagebuflist()
        var winn = bufwinnr(bufn)
        map(GetMatches(groupName), (_, id) => matchdelete(id))
    endfor
enddef
