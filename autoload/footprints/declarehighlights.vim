function! s:GetNormalBackgroundColor() abort
    " Store output of group to variable
    let output = execute('hi Normal')

    " Find the term we're looking for
    return matchstr(output, 'guibg=\zs\S*')
endfunction

function! s:DecToHex(value) abort
    return printf('%02x', a:value)
endfunction

function! s:GetIntermediateValue(accentColor, baseColor, step, totalSteps) abort
    if a:step <= 0
        return a:accentColor
    endif
    return a:baseColor + (a:accentColor - a:baseColor) * easings#EasingFunc(1 - (a:step + 0.0) / a:totalSteps)
endfunction

" {{{
" Declare 'FootprintsStep0', 'FootprintsStep1'...

function! s:GetIntermediateColor(accentColorStr, normalColorStr, step, totalSteps)
    let accentRed = str2nr(a:accentColorStr[1:2], 16)
    let normalRed = str2nr(a:normalColorStr[1:2], 16)
    let intermediateRed = float2nr(round(s:GetIntermediateValue(accentRed, normalRed, a:step, a:totalSteps)))

    let accentGreen = str2nr(a:accentColorStr[3:4], 16)
    let normalGreen = str2nr(a:normalColorStr[3:4], 16)
    let intermediateGreen = float2nr(round(s:GetIntermediateValue(accentGreen, normalGreen, a:step, a:totalSteps)))

    let accentBlue = str2nr(a:accentColorStr[5:6], 16)
    let normalBlue = str2nr(a:normalColorStr[5:6], 16)
    let intermediateBlue = float2nr(round(s:GetIntermediateValue(accentBlue, normalBlue, a:step, a:totalSteps)))

    return '#'.s:DecToHex(intermediateRed).s:DecToHex(intermediateGreen).s:DecToHex(intermediateBlue)
endfunction

function! footprints#declarehighlights#DeclareHighlights(groupName, accentColorStr, accentTermColorStr, totalSteps) abort
    silent let normalBg = s:GetNormalBackgroundColor()
    let i = 0
    while i < a:totalSteps
        let color = s:GetIntermediateColor(a:accentColorStr, normalBg, i, a:totalSteps)
        silent execute 'highlight '.a:groupName.i.' guibg='.color.' ctermbg='.a:accentTermColorStr
        let i = i + 1
    endwhile
endfunction
" }}}
