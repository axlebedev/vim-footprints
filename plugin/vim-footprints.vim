let g:footprintsExcludeFiletypes = ['magit', 'nerdtree']

let g:footprintsHistoryDepth = 20

" Cold: 38403b
" Warm: 412d1e
let g:footprintsColor = '#6b4930'

autocmd VimEnter * call footprints#FootprintsInit()

autocmd FileType * call footprints#OnFiletypeSet()

autocmd BufLeave * call footprints#BufLeaved()
" autocmd BufWinLeave * call footprints#BufLeaved()
" autocmd BufHidden * call footprints#BufLeaved()

autocmd BufEnter * call footprints#OnBufEnter()
" autocmd BufWinEnter * call footprints#OnBufEnter()
" autocmd BufNew * call footprints#OnBufEnter()
" autocmd BufCreate * call footprints#OnBufEnter()

autocmd CursorMoved * call footprints#OnCursorMove()

autocmd TextChanged * call footprints#Footprints()
autocmd TextChangedI * call footprints#Footprints() 
autocmd FileType * call footprints#Footprints()
autocmd BufEnter * call footprints#Footprints()
autocmd BufLeave * call footprints#Footprints()
" autocmd InsertLeave * call footprints#Footprints() 
" autocmd TextYankPost * call footprints#Footprints() 
