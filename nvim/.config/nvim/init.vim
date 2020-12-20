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

"Clojure stuff:

Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'luochen1990/rainbow'
let g:rainbow_Active = "1"

Plug 'guns/vim-sexp',    {'for': 'clojure'}
Plug 'liquidz/vim-iced', {'for': 'clojure'}

call plug#end()

source ~/.config/nvim/001-coc.vim

source ~/.config/nvim/002-vimtest.vim

"Ranger-like file navigation
source ~/.config/nvim/plug-config/rnvimr.vim

source ~/.config/nvim/003-general.vim

source ~/.config/nvim/004-gruvbox.vim

source ~/.config/nvim/005-fzf.vim

"Clojure:
let g:iced_enable_default_key_mappings = v:true
