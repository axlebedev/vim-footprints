let s:factor = 0.1
let s:matchIds = {}
let s:isEnabled = 0

" {{{
" get list of linenumbers that should be highlighted

function! s:GetChangesList() abort
    let commandResult = ''
    set nomore
    redir => commandResult
    " change line col text
    changes
    redir END
    set more
    return commandResult
endfunction

let s:changesListStore = 0
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

function! s:GetChangesLinenumbersList(historyDepth) abort
    if s:changesListStore
        return s:changesListStore
    endif
    return s:GetChangesLinenumbersListInner(a:historyDepth)
endfunction

function! s:ClearChangesList() abort
    let s:changesListStore = 0
    return 1
endfunction
" }}}

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

function! s:GetIntermediateValue(accentColor, baseColor, step, factor) abort
    if a:step <= 0
        return a:accentColor
    endif
    let prevStepColor = s:GetIntermediateValue(a:accentColor, a:baseColor, a:step - 1, a:factor)
    return prevStepColor + (a:baseColor - prevStepColor) * a:factor
endfunction

function! s:GetIntermediateColor(accentColorStr, normalColorStr, step, totalSteps)
    let accentRed = str2nr(a:accentColorStr[1:2], 16)
    let normalRed = str2nr(a:normalColorStr[1:2], 16)
    let intermediateRed = float2nr(round(s:GetIntermediateValue(accentRed, normalRed, a:step, s:factor)))

    let accentGreen = str2nr(a:accentColorStr[3:4], 16)
    let normalGreen = str2nr(a:normalColorStr[3:4], 16)
    let intermediateGreen = float2nr(round(s:GetIntermediateValue(accentGreen, normalGreen, a:step, s:factor)))

    let accentBlue = str2nr(a:accentColorStr[5:6], 16)
    let normalBlue = str2nr(a:normalColorStr[5:6], 16)
    let intermediateBlue = float2nr(round(s:GetIntermediateValue(accentBlue, normalBlue, a:step, s:factor)))

    return '#'.s:DecToHex(intermediateRed).s:DecToHex(intermediateGreen).s:DecToHex(intermediateBlue)
endfunction

function! s:DeclareHighlights(accentColorStr, totalSteps) abort
    silent let normalBg = s:GetNormalBackgroundColor()
    let i = 0
    while i < a:totalSteps
        let color = s:GetIntermediateColor(a:accentColorStr, normalBg, i, a:totalSteps)
        silent execute 'highlight FootstepsStep'.i.' guibg='.color
        let i = i + 1
    endwhile
endfunction
" }}}

" {{{
" set highlight groups to lines of code

function! s:ClearHighlights(bufnr) abort
    if has_key(s:matchIds, a:bufnr)
        for id in s:matchIds[a:bufnr]
            silent! call matchdelete(id)
        endfor
        unlet s:matchIds[a:bufnr]
    endif
endfunction

function! s:ClearHighlightsInHiddenBuffers() abort
    for bufn in keys(s:matchIds)
        if bufwinnr(bufn) == -1
            call s:ClearHighlights(bufn)
        endif
    endfor
endfunction

function! s:ClearHighlightsInAllBuffers() abort
    for bufn in keys(s:matchIds)
        call s:ClearHighlights(bufn)
    endfor
endfunction

function! s:UpdateMatches(bufnr, linenumbersList, historyDepth) abort
    let currentLine = line('.')
    call s:ClearHighlights(a:bufnr)

    let s:matchIds[a:bufnr] = []
    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        if lineNr != currentLine
            let highlightGroupName = 'FootstepsStep'.(maxI - i - 1)
            let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -100009)
            call add(s:matchIds[a:bufnr], id)
        else 
            call add(s:matchIds[a:bufnr], 0)
        endif
        let i = i + 1
    endwhile
endfunction

function! s:UpdateMatchesOnMove(linenumbersList, historyDepth) abort
    let bufn = bufnr()
    if !has_key(s:matchIds, bufn) || !len(s:matchIds[bufn])
        return
    endif
    let currentLine = line('.')

    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth, len(s:matchIds[bufn])]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        if lineNr != currentLine && !s:matchIds[bufn][i]
            let highlightGroupName = 'FootstepsStep'.(maxI - i - 1)
            let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -1)
            let s:matchIds[bufn][i] = id
        elseif lineNr == currentLine && s:matchIds[bufn][i]
            call matchdelete(s:matchIds[bufn][i])
            let s:matchIds[bufn][i] = 0
        endif
        let i = i + 1
    endwhile
endfunction
" }}}

" {{{
" main

function! footprints#FootprintsInit() abort
    call s:DeclareHighlights(g:footprintsColor, g:footprintsHistoryDepth)
    let s:isEnabled = 1
endfunction

function! footprints#FootprintsInner(bufnr) abort
    if !s:isEnabled || !&modifiable || &diff || index(g:footprintsExcludeFiletypes, &filetype) > -1
        call s:ClearHighlights(a:bufnr)
        return
    endif
    call s:ClearChangesList()
    call s:UpdateMatches(a:bufnr, s:GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#Footprints() abort
    call footprints#FootprintsInner(bufnr())
endfunction

function! footprints#OnBufEnter() abort
    call s:ClearHighlightsInHiddenBuffers()
    call footprints#FootprintsInner(bufnr())
endfunction

function footprints#OnFiletypeSet() abort
    call s:ClearHighlightsInHiddenBuffers()
    call footprints#FootprintsInner(bufnr())
endfunction
"
function! footprints#OnCursorMove() abort
    if !s:isEnabled
        return
    endif
    call s:UpdateMatchesOnMove(s:GetChangesLinenumbersList(g:footprintsHistoryDepth), g:footprintsHistoryDepth)
endfunction

function! footprints#Disable() abort
    call s:ClearHighlightsInAllBuffers()
    let s:isEnabled = 0
endfunction

function! footprints#Enable() abort
    let s:isEnabled = 1
    windo call footprints#FootprintsInner(winbufnr(winnr()))
endfunction
