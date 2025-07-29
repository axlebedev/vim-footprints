vim9script

import autoload '../autoload/footprints.vim' as footprints

export def SetColor(color: string)
    footprints.SetColor(color)
enddef


export def SetTermColor(color: string)
    footprints.SetTermColor(color)
enddef

export def SetHistoryDepth(newDepth: number)
    footprints.SetHistoryDepth(newDepth)
enddef

export def Footprints()
    footprints.Footprints()
enddef

export def OnBufEnter()
    footprints.OnBufEnter()
enddef


export def OnCursorMove()
    footprints.OnCursorMove()
enddef

export def FootprintsDisable(isBufLocal: bool = false)
    footprints.FootprintsDisable(isBufLocal)
enddef

export def FootprintsEnable(isBufLocal: bool = false)
    footprints.FootprintsEnable(isBufLocal)
enddef

export def FootprintsToggle(isBufLocal: bool = false)
    footprints.FootprintsToggle(isBufLocal)
enddef

export def FootprintsDisableCurrentLine()
    footprints.FootprintsDisableCurrentLine()
enddef

export def FootprintsEnableCurrentLine()
    footprints.FootprintsEnableCurrentLine()
enddef

export def FootprintsToggleCurrentLine()
    footprints.FootprintsToggleCurrentLine()
enddef
