let g:historyDepth = 10
" Cold: 38403b
" Warm: 412d1e
let g:bgColor = '#412D1E'

autocmd VimEnter * call footprints#FootprintsInit()

autocmd TextChanged * call footprints#Footprints()
autocmd BufEnter * call footprints#Footprints()
autocmd InsertLeave * call footprints#Footprints() 
autocmd TextChangedI * call footprints#Footprints() 
autocmd TextChangedP * call footprints#Footprints() 
autocmd TextYankPost * call footprints#Footprints() 
