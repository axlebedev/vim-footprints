vim9script

import autoload './footprints/clearhighlights.vim' as clearhighlights
import autoload './footprints/declarehighlights.vim' as declarehighlights
import autoload './footprints/getchangeslist.vim' as getchangeslist
import autoload './footprints/updatematches.vim' as updatematches

g:footprintsHistoryDepth = get(g:, 'footprintsHistoryDepth', 20)
g:footprintsExcludeFiletypes = get(g:, 'footprintsExcludeFiletypes', ['magit', 'nerdtree', 'diff'])
g:footprintsEasingFunction = get(g:, 'footprintsEasingFunction', 'easeInOut')
g:footprintsEnabledByDefault = get(g:, 'footprintsEnabledByDefault', true)
g:footprintsOnCurrentLine = get(g:, 'footprintsOnCurrentLine', false)
g:footprintsColor = get(g:, 'footprintsColor', &background == 'dark' ? '#3A3A3A' : '#C1C1C1')
g:footprintsTermColor = get(g:, 'footprintsTermColor', '208')

var isEnabled = false
const groupName = 'FootprintsStep'

def GetIsEnabled(): bool
    if exists("b:isEnabled")
        return b:isEnabled
    endif
    return isEnabled
enddef

def ShouldUpdateMatches(): bool
    return GetIsEnabled() && &modifiable && !&diff && index(g:footprintsExcludeFiletypes, &filetype) == -1
enddef

def RunUpdateMatches()
    updatematches.UpdateMatches(
        groupName,
        bufnr(),
        getchangeslist.GetChangesLinenumbersList(g:footprintsHistoryDepth),
        g:footprintsHistoryDepth,
    )
enddef

def FootprintsInner(bufnr: number)
    if !ShouldUpdateMatches()
        clearhighlights.ClearHighlights(groupName)
        return
    endif
    getchangeslist.ClearChangesList()
    RunUpdateMatches()
enddef

export def FootprintsInit()
    declarehighlights.DeclareHighlights(groupName, g:footprintsColor, 
        g:footprintsTermColor, g:footprintsHistoryDepth)
    isEnabled = g:footprintsEnabledByDefault
enddef

export def SetColor(color: string)
    g:footprintsColor = color
    declarehighlights.DeclareHighlights(groupName, g:footprintsColor, 
        g:footprintsTermColor, g:footprintsHistoryDepth)
enddef

export def SetTermColor(color: string)
    g:footprintsTermColor = color
    declarehighlights.DeclareHighlights(groupName, g:footprintsColor, 
        g:footprintsTermColor, g:footprintsHistoryDepth)
enddef

export def Footprints()
    FootprintsInner(bufnr())
enddef

export def OnBufEnter()
    clearhighlights.ClearHighlights(groupName)
    FootprintsInner(bufnr())
enddef

export def OnFiletypeSet()
    clearhighlights.ClearHighlights(groupName)
    FootprintsInner(bufnr())
enddef

export def OnCursorMove()
    if !ShouldUpdateMatches() || g:footprintsOnCurrentLine
        return
    endif
    RunUpdateMatches()
enddef

export def FootprintsDisable(isBufLocal: bool = false)
    if isBufLocal
        b:isEnabled = false
    else
        isEnabled = false
    endif
    clearhighlights.ClearHighlightsInAllBuffers(groupName)
enddef

export def FootprintsEnable(isBufLocal: bool = false)
    if isBufLocal
        b:isEnabled = true
    else
        isEnabled = true
    endif
    var curwinnr = winnr()

    for bufn in tabpagebuflist()
        FootprintsInner(bufn)
    endfor
enddef

export def FootprintsToggle(isBufLocal: bool = false)
    if GetIsEnabled()
        FootprintsDisable(isBufLocal)
    else
        FootprintsEnable(isBufLocal)
    endif
enddef

export def FootprintsEnableCurrentLine()
    g:footprintsOnCurrentLine = true
    RunUpdateMatches()
enddef

export def FootprintsDisableCurrentLine()
    g:footprintsOnCurrentLine = false
    RunUpdateMatches()
enddef

export def FootprintsToggleCurrentLine()
    if g:footprintsOnCurrentLine
        FootprintsDisableCurrentLine()
    else
        FootprintsEnableCurrentLine()
    endif
enddef

export def SetHistoryDepth(newDepth: number)
    g:footprintsHistoryDepth = newDepth
    declarehighlights.DeclareHighlights(groupName, g:footprintsColor, 
        g:footprintsTermColor, g:footprintsHistoryDepth)
    RunUpdateMatches()
enddef
