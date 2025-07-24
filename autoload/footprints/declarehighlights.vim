vim9script

import autoload '../easings.vim' as easings

def GetNormalBackgroundColor(): string
    var output = execute('hi Normal')
    return matchstr(output, 'guibg=\zs\S*')
enddef

def DecToHex(value: number): string
    return printf('%02x', value)
enddef

def GetIntermediateValue(accentColor: number, baseColor: number, step: number, totalSteps: number): float
    if step <= 0
        return accentColor * 1.0
    endif
    return baseColor + (accentColor - baseColor) * easings.EasingFunc(1 - (step + 0.0) / totalSteps)
enddef

def GetIntermediateColor(accentColorStr: string, normalColorStr: string, step: number, totalSteps: number): string
    var accentRed = str2nr(accentColorStr[1 : 2], 16)
    var normalRed = str2nr(normalColorStr[1 : 2], 16)
    var intermediateRed = float2nr(round(GetIntermediateValue(accentRed, normalRed, step, totalSteps)))

    var accentGreen = str2nr(accentColorStr[3 : 4], 16)
    var normalGreen = str2nr(normalColorStr[3 : 4], 16)
    var intermediateGreen = float2nr(round(GetIntermediateValue(accentGreen, normalGreen, step, totalSteps)))

    var accentBlue = str2nr(accentColorStr[5 : 6], 16)
    var normalBlue = str2nr(normalColorStr[5 : 6], 16)
    var intermediateBlue = float2nr(round(GetIntermediateValue(accentBlue, normalBlue, step, totalSteps)))

    return '#' .. DecToHex(intermediateRed) .. DecToHex(intermediateGreen) .. DecToHex(intermediateBlue)
enddef

export def DeclareHighlights(groupName: string, accentColorStr: string, 
                                              accentTermColorStr: string, totalSteps: number)
    silent var normalBg = GetNormalBackgroundColor()
    var i = 0
    while i < totalSteps
        var color = GetIntermediateColor(accentColorStr, normalBg, i, totalSteps)
        silent execute 'highlight ' .. groupName .. i .. ' guibg=' .. color .. ' ctermbg=' .. accentTermColorStr
        i += 1
    endwhile
    while hlexists(groupName .. i)
        execute('highlight clear ' .. groupName .. i)
        i += 1
    endwhile
enddef
