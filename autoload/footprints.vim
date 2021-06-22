let s:historyDepth = 10
let s:bgColor = '#4f422b'

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
    let lines = lines[-(min([a:historyDepth, len(lines)]))+1:] " remove first line with headers
    let lineNumbers = []
    for line in lines
        let lineSpl = split(line)
        if (len(lineSpl) >= 3)
            call add(lineNumbers, lineSpl[1])
        endif
    endfor
    return lineNumbers
endfunction

" =====
" Part: Declare 'FootprintsStep0', 'FootprintsStep1'...

function! s:DecToHex(value) abort
    return printf('%x', a:value)
endfunction

function! s:GetIntermediateColor(accentColorStr, normalColorStr, step, totalSteps)
    let stepMult = (a:step * 1.0) / a:totalSteps " *1.0 - convert to float

    let accentRed = str2nr(a:accentColorStr[1:2], 16)
    let normalRed = str2nr(a:normalColorStr[1:2], 16)
    let intermediateRed = float2nr(round(accentRed + (normalRed - accentRed) * stepMult))

    let accentGreen = str2nr(a:accentColorStr[3:4], 16)
    let normalGreen = str2nr(a:normalColorStr[3:4], 16)
    let intermediateGreen = float2nr(round(accentGreen + (normalGreen - accentGreen) * stepMult))

    let accentBlue = str2nr(a:accentColorStr[5:6], 16)
    let normalBlue = str2nr(a:normalColorStr[5:6], 16)
    let intermediateBlue = float2nr(round(accentBlue + (normalBlue - accentBlue) * stepMult))

    return '#'.s:DecToHex(intermediateRed).s:DecToHex(intermediateGreen).s:DecToHex(intermediateBlue)
endfunction

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

let s:matchIds = {}
function! s:UpdateMatches(linenumbersList) abort
    let bufn = bufnr()
    if has_key(s:matchIds, bufn)
        for id in s:matchIds[bufn]
            silent! call matchdelete(id)
        endfor
    endif
    let s:matchIds[bufn] = []

    let i = 0 
    let maxI = min([len(a:linenumbersList), s:historyDepth]) 
    while i < maxI
        let lineNr = a:linenumbersList[i]
        let highlightGroupName = 'FootstepsStep'.(maxI - i - 1)

        let id = matchadd(highlightGroupName, '\%'.lineNr.'l')
        call add(s:matchIds[bufn], id)
        let i = i + 1
    endwhile
endfunction

" =====
" int main

function! footprints#FootprintsInit() abort
    call s:DeclareHighlights(s:bgColor, s:historyDepth)
endfunction

function! footprints#Footprints() abort
    if !&modifiable
        return
    endif
    call s:UpdateMatches(s:GetChangesLinenumbersList(s:historyDepth))
endfunction
