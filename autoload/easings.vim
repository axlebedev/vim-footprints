vim9script

const PI = 3.141592

def Linear(x: float): float
    return x
enddef

def EaseInOutSine(x: float): float
    return -(cos(PI * x) - 1) / 2
enddef

def EaseOutCubic(x: float): float
    return 1 - pow(1 - x, 3)
enddef

def EaseInCubic(x: float): float
    return pow(x, 3)
enddef

# Get intermediate value from 0 to 1 according to easing curve
export def EasingFunc(x: float): float
    if g:footprintsEasingFunction ==? 'linear'
        return Linear(x)
    elseif g:footprintsEasingFunction ==? 'easein'
        return EaseInCubic(x)
    elseif g:footprintsEasingFunction ==? 'easeout'
        return EaseOutCubic(x)
    endif

    return EaseInOutSine(x)
enddef
