call plug#begin()

"Support for language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Easy motion
Plug 'easymotion/vim-easymotion'

"Better defaults
Plug 'tpope/vim-sensible'

"Support for Elixir
Plug 'elixir-editors/vim-elixir'

"Support for rebar
Plug 'gleam-lang/gleam.vim'

"Support for Elm
Plug 'andys8/vim-elm-syntax'

"Support for Rust
Plug 'rust-lang/rust.vim'

"Support for Haskell
Plug 'neovimhaskell/haskell-vim'

"Support for Clojure
Plug 'Olical/conjure'

"Neoformat
Plug 'sbdchd/neoformat'

"Support for relative and absolute line numbering
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"Fuzzy finder. I heard that skim is quicker than fzf
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'lotabout/skim.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

"Harpoon
Plug 'ThePrimeagen/harpoon'

"Uses FZF for CocList
"Plug 'antoinemadec/coc-fzf' Disabled because of skim

"Git information on files
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"Testing capabilities
Plug 'vim-test/vim-test'


"Makes menu bar under look nicer
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

"Automatically create matching brackets and etc
Plug 'jiangmiao/auto-pairs'


"Clojure stuff:

Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'luochen1990/rainbow'
let g:rainbow_Active = "1"

Plug 'guns/vim-sexp',    {'for': 'clojure'}
Plug 'liquidz/vim-iced', {'for': 'clojure'}

call plug#end()

source ~/.config/nvim/003-coc.vim

source ~/.config/nvim/002-vimtest.vim

source ~/.config/nvim/001-general.vim

source ~/.config/nvim/004-gruvbox.vim

source ~/.config/nvim/005-fzf.vim

source ~/.config/nvim/006-telescope.vim

"****************************************************************************
"* Plugin: Vim-easymotion
let g:EasyMotion_smartcase = 1
"****************************************************************************

"*****************************************************************************
"" Self made
"*****************************************************************************
let g:airline#extensions#tabline#enabled = 1


"For gruvbox
let g:gruvbox_italic=1
autocmd vimenter * colorscheme gruvbox
set termguicolors
"gruvbox end



"*********** VIM TEST PLUG IN
" make test commands execute using dispatch.vim
let test#strategy = "neovim"
"***********


"Clojure:
let g:iced_enable_default_key_mappings = v:true
