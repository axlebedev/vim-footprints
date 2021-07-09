let g:footprintsExcludeFiletypes = ['magit', 'nerdtree']

let g:footprintsHistoryDepth = 20

" Cold: 38403b
" Warm: 412d1e
let g:footprintsColor = '#6b4930'

autocmd VimEnter * call footprints#FootprintsInit()

autocmd FileType * call footprints#OnFiletypeSet()

autocmd BufLeave * call footprints#BufLeaved()

autocmd TextChanged * call footprints#Footprints()
autocmd BufEnter * call footprints#Footprints()
autocmd InsertLeave * call footprints#Footprints() 
autocmd TextChangedI * call footprints#Footprints() 
autocmd TextChangedP * call footprints#Footprints() 
autocmd TextYankPost * call footprints#Footprints() 
