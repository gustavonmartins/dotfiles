call plug#begin()

"Support for language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Support for Elixir
Plug 'elixir-editors/vim-elixir'

"Support for rebar
Plug 'gleam-lang/gleam.vim'

"Support for Elm
Plug 'andys8/vim-elm-syntax'

"Support for Rust
Plug 'rust-lang/rust.vim'

"Support for Clojure
Plug 'Olical/conjure'

Plug 'eraserhd/parinfer-rust', {'do':
        \  'cargo build --release'}

"Support for relative and absolute line numbering
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"Fuzzy finder. I heard that skim is quicker than fzf
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'lotabout/skim.vim'

"Uses FZF for CocList
"Plug 'antoinemadec/coc-fzf' Disabled because of skim

"Git information on files
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"Testing capabilities
Plug 'vim-test/vim-test'

"Time management
Plug 'wakatime/vim-wakatime'"

"Makes menu bar under look nicer
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

"Automatically create matching brackets and etc
Plug 'jiangmiao/auto-pairs'

"Ranger file explorer
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

call plug#end()

source ~/.config/nvim/coccfg.vim

"*****************************************************************************
"" Plugin: Vim-Test default settings
"*****************************************************************************

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

"Ranger-like file navigation
source $HOME/.config/nvim/plug-config/rnvimr.vim

"*****************************************************************************
"" Self made
"*****************************************************************************
set mouse=a
set number relativenumber
set foldlevelstart=1
set foldmethod=syntax
set ignorecase
set smartcase
set noswapfile
set foldopen+=jump
set clipboard+=unnamedplus
let g:airline#extensions#tabline#enabled = 1

"For gruvbox
let g:gruvbox_italic=1
autocmd vimenter * colorscheme gruvbox
set termguicolors
"gruvbox end


"Will almost auto read file if you type  :e
set autoread 

"*********** VIM TEST PLUG IN
" make test commands execute using dispatch.vim
let test#strategy = "neovim"
"***********

"*****************************************************************************
"" Self made: FZF
"*****************************************************************************
nmap <unique> <C-p> :SK<CR>

