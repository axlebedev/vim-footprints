let g:footprintsHistoryDepth = get(g:, 'footprintsHistoryDepth', 20)
let g:footprintsExcludeFiletypes = get(g:, 'footprintsExcludeFiletypes', ['magit', 'nerdtree', 'diff'])
let g:footprintsEasingFunction = get(g:, 'footprintsEasingFunction', 'easeInOut')
let g:footprintsEnabledByDefault = get(g:, 'footprintsEnabledByDefault', 1)
let g:footprintsOnCurrentLine = get(g:, 'footprintsOnCurrentLine', 0)
" Cold: 38403b
" Warm: 412d1e
let g:footprintsColor = get(g:, 'footprintsColor', '#6b4930')

let s:isEnabled = 0

let s:groupName = 'FootstepsStep'

" {{{
" Get Background Color

function! s:GetNormalBackgroundColor() abort
    let commandResult = ''
    redir => commandResult
    highlight Normal
    redir END
    let normalColorsArray = split(commandResult)
    let guibg = 0
    for item in normalColorsArray
        if item =~? 'guibg='
            let guibg = item[match(item, '=')+1:]
        endif
    endfor
    return guibg
endfunction
" }}}

" {{{
" Declare 'FootprintsStep0', 'FootprintsStep1'...

function! s:DecToHex(value) abort
    return printf('%x', a:value)
endfunction

function! s:GetIntermediateValue(accentColor, baseColor, step, totalSteps) abort
    if a:step <= 0
        return a:accentColor
    endif
    return a:baseColor + (a:accentColor - a:baseColor) * easings#EasingFunc(1 - (a:step + 0.0) / a:totalSteps)
endfunction

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

function! s:DeclareHighlights(accentColorStr, totalSteps) abort
    silent let normalBg = s:GetNormalBackgroundColor()
    let i = 0
    while i < a:totalSteps
        let color = s:GetIntermediateColor(a:accentColorStr, normalBg, i, a:totalSteps)
        silent execute 'highlight '.s:groupName.i.' guibg='.color
        let i = i + 1
    endwhile
endfunction
" }}}

" {{{
" set highlight groups to lines of code

function! s:UpdateMatches(bufnr, linenumbersList, historyDepth) abort
    let currentLine = line('.')
    call footprints#clearhighlights#ClearHighlights(s:groupName)

    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        if g:footprintsOnCurrentLine || lineNr != currentLine
            let highlightGroupName = s:groupName.(maxI - i - 1)
            let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -100009)
        endif
        let i = i + 1
    endwhile
endfunction
" }}}

" {{{
" main
"
function! s:FootprintsInner(bufnr) abort
    if !s:isEnabled || !&modifiable || &diff || index(g:footprintsExcludeFiletypes, &filetype) > -1
        call footprints#clearhighlights#ClearHighlights(s:groupName)
        return
    endif
    call footprints#getchangeslist#ClearChangesList()
    call s:UpdateMatches(a:bufnr, footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#FootprintsInit() abort
    call s:DeclareHighlights(g:footprintsColor, g:footprintsHistoryDepth)
    let s:isEnabled = g:footprintsEnabledByDefault
endfunction

function! footprints#Footprints() abort
    call s:FootprintsInner(bufnr())
endfunction

function! footprints#OnBufEnter() abort
    call footprints#clearhighlights#ClearHighlights(s:groupName)
    call s:FootprintsInner(bufnr())
endfunction

function footprints#OnFiletypeSet() abort
    call footprints#clearhighlights#ClearHighlights(s:groupName)
    call s:FootprintsInner(bufnr())
endfunction

function! footprints#OnCursorMove() abort
    if !s:isEnabled || !&modifiable || &diff || index(g:footprintsExcludeFiletypes, &filetype) > -1 || g:footprintsOnCurrentLine
        return
    endif
    call s:UpdateMatches(bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#Disable() abort
    call s:footprints#clearhighlights#ClearHighlightsInAllBuffers(s:groupName)
    let s:isEnabled = 0
endfunction

function! footprints#Enable() abort
    let s:isEnabled = 1
    windo call footprints#FootprintsInner(winbufnr(winnr()))
endfunction

function! footprints#Toggle() abort
    if s:isEnabled
        call footprints#Disable()
    else
        call footprints#Enable()
    endif
endfunction

function! footprints#EnableCurrentLine() abort
    let g:footprintsOnCurrentLine = 1
    call s:UpdateMatches(bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#DisableCurrentLine() abort
    let g:footprintsOnCurrentLine = 0
    call s:UpdateMatches(bufnr(), footprints#getchangeslist#GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#ToggleCurrentLine() abort
    if g:footprintsOnCurrentLine
        call footprints#DisableCurrentLine()
    else
        call footprints#EnnableCurrentLine()
    endif
endfunction
