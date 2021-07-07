let s:factor = 0.1
let s:isLaunched = 0

" =====
" Part: get list of linenumbers that should be highlighted

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

function! s:GetChangesLinenumbersList(historyDepth) abort
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

" =====
" Part: Get Background Color

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

" =====
" Part: Declare 'FootprintsStep0', 'FootprintsStep1'...

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

" =====
" Part: set highlight groups to lines of code

let s:leavedBufWinnr = { 'winn': -1, 'bufn': -1 }
let s:matchIds = {}
function! s:ClearHighlights(bufn) abort
    if has_key(s:matchIds, a:bufn)
        for id in s:matchIds[a:bufn]
            silent! call matchdelete(id)
        endfor
    endif
endfunction

function! s:UpdateMatches(linenumbersList, historyDepth) abort
    if (s:leavedBufWinnr.winn == winnr())
        call s:ClearHighlights(s:leavedBufWinnr.bufn)
    endif

    let bufn = bufnr()
    call s:ClearHighlights(bufn)
    let hasKey = has_key(s:matchIds, bufn)
    if hasKey && len(s:matchIds[bufn]) > a:historyDepth * 2
        let s:matchIds[bufn] = s:matchIds[bufn][-a:historyDepth:]
    endif

    if !hasKey
        let s:matchIds[bufn] = []
    endif

    let i = 0 
    let maxI = min([len(a:linenumbersList), a:historyDepth]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        let highlightGroupName = 'FootstepsStep'.(maxI - i - 1)

        let id = matchadd(highlightGroupName, '\%'.lineNr.'l', -1)
        call add(s:matchIds[bufn], id)
        let i = i + 1
    endwhile
endfunction

" =====
" int main

function! footprints#FootprintsInit() abort
    call s:DeclareHighlights(g:bgColor, g:historyDepth)
    let s:isLaunched = 1
endfunction

function! footprints#Footprints() abort
    if !&modifiable || !s:isLaunched || index(g:excludeFiletypes, &filetype) > -1
        return
    endif
    call s:UpdateMatches(s:GetChangesLinenumbersList(g:historyDepth), g:historyDepth)
endfunction

function! footprints#BufLeaved() abort
    let s:leavedBufWinnr = { 'winn': winnr(), 'bufn': bufnr() }
endfunction

function footprints#OnFiletypeSet() abort
    if index(g:excludeFiletypes, &filetype) > -1
        call s:ClearHighlights(bufnr())
    endif
endfunction
