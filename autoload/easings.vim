let s:PI = 3.141592

function! s:Linear(x) 
    return a:x
endfunction

function! s:EaseInOutSine(x) 
    return -(cos(s:PI * a:x) - 1) / 2
endfunction

function s:EaseOutCubic(x)
    return 1 - pow(1 - a:x, 3)
endfunction

function s:EaseInCubic(x)
    return pow(a:x, 3)
endfunction

" Get intermediate value from 0 to 1 accordinng to easing curve
function! easings#EasingFunc(x)
    if g:footprintsEasingFunction == 'linear'
        return s:Linear(a:x)
    elseif g:footprintsEasingFunction == 'easein'
        return s:EaseInCubic(a:x)
    elseif g:footprintsEasingFunction == 'easeout'
        return s:EaseOutCubic(a:x)
    endif

    return s:EaseInOutSine(a:x)
endfunction
