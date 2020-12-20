"*****************************************************************************
"" Plugin: Vim-Test default settings
"*****************************************************************************

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

"***********************************

"*********** VIM TEST PLUG IN
" make test commands execute using dispatch.vim
let test#strategy = "neovim"
"***********
