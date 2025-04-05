"==============================================================================
"   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"   █                                                                    █
"   █                     Hunter Husar's Neovim Terminal                 █
"   █                        [ Command Interface ]                       █
"   █                                                                    █
"   █              Ready for deep space text editing, Captain            █
"   █                                                                    █
"   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

" ============================================================================
" Functions {{{
" ============================================================================

" Build markdown composer
function! BuildComposer(info)
    [[ a:info.status != 'unchanged' || a:info.force ]] && !cargo build --release
endfunction

" NERDTree file highlighting (one-line)
function! NERDTreeHL(e, f, b, gf, gb)
    exec 'au FileType nerdtree hi ' . a:e .' ctermfg='. a:f .' ctermbg='. a:b .' guifg='. a:gf .' guibg='. a:gb .' | syn match ' . a:e .' #^\s\+.*'. a:e .'$#'
endfunction

" Toggle whitespace stripping
let g:strip_ws = 0 | function! ToggleWS()
    let g:strip_ws = !g:strip_ws | if g:strip_ws | aug strip_ws | au! | au BufWritePre * %s/\s\+$//e | aug END | else | au! strip_ws | endif
endfunction

" }}}

" ============================================================================
" Core Settings {{{
" ============================================================================

"------------------------------------------------------------------------------
" Leader & Basic Setup
"------------------------------------------------------------------------------
let mapleader = ","                    " Set leader key to comma (easier to reach than backslash)
syntax on                              " Enable syntax highlighting
set nocompatible                       " Disable vi compatibility mode
filetype plugin indent on              " Enable filetype detection, plugins, and indentation

"------------------------------------------------------------------------------
" Essential Behavior & Performance
"------------------------------------------------------------------------------
set encoding=utf-8                     " Use UTF-8 encoding for proper unicode support
set hidden                            " Allow switching buffers without saving
set ttyfast                           " Faster terminal connection (modern terminals)
set history=1000                      " Store last 1000 commands in history
set backspace=indent,eol,start        " Modern backspace behavior
set autoread                          " Reload files changed outside vim
set autowrite                         " Auto-save before commands like :next and :make
set noerrorbells                      " Disable error bells
set visualbell                        " Use visual bell instead of beeping
set t_vb=                            " Disable visual bell flash
set clipboard=unnamed                 " Use system clipboard for yank and paste

"------------------------------------------------------------------------------
" File Management & Backup
"------------------------------------------------------------------------------
set noswapfile                        " Disable swap files (modern systems rarely need them)
set nobackup                          " Don't create backup files
set nowritebackup                     " Don't create backup files during writing
set undofile                          " Persistent undo history
set undodir=~/.vim/undodir            " Directory for storing undo files
set undolevels=1000                   " Maximum number of changes that can be undone
set undoreload=10000                  " Maximum number lines to save for undo on buffer reload
set backupskip=/tmp/*,/private/tmp/*  " Skip backup for temp files

"------------------------------------------------------------------------------
" Editor & Text Display
"------------------------------------------------------------------------------
set tabstop=4                         " Width of tab character
set shiftwidth=4                      " Width of indent when using >>, <<, or auto-indent
set softtabstop=4                     " Number of spaces tab counts for while editing
set expandtab                         " Convert tabs to spaces
set scrolloff=3                       " Keep 3 lines visible above/below cursor
set splitbelow                        " Open new splits below current one
set splitright                        " Open new vertical splits to the right
set wrap                             " Enable line wrapping
set textwidth=120                     " Maximum width of text being inserted
set formatoptions=qrn1                " q: allow formatting with gq
                                     " r: auto-insert comment leader on <Enter>
                                     " n: recognize numbered lists
                                     " 1: don't break line after one-letter word
set colorcolumn=120                   " Show vertical line at column 120

"------------------------------------------------------------------------------
" Search & Pattern Matching
"------------------------------------------------------------------------------
set ignorecase                        " Case-insensitive search by default
set smartcase                         " Case-sensitive if search contains uppercase
set incsearch                         " Show matches while typing search pattern
set hlsearch                          " Highlight all matches of search pattern

"------------------------------------------------------------------------------
" UI & Visual Feedback
"------------------------------------------------------------------------------
set number                            " Show line numbers
set ruler                            " Show cursor position in status line
set showcmd                          " Show partial command in last line
set laststatus=2                      " Always show status line
set signcolumn=auto                   " Show sign column when git/lint markers are present
set cmdheight=0                       " Hide command line until needed
set guioptions-=L                     " Remove left-hand scroll bar
set guioptions-=r                     " Remove right-hand scroll bar
set guioptions-=m                     " Remove menu bar
set guioptions-=T                     " Remove toolbar

"------------------------------------------------------------------------------
" File Finding & Completion
"------------------------------------------------------------------------------
set wildmenu                          " Enhanced command-line completion
set wildmode=list:longest             " List all matches and complete to longest
set wildignore+=.hg,.git,.svn         " Version control
set wildignore+=*.pyc,*.o,*.obj       " Compiled files
set wildignore+=*.swp,*.DS_Store      " System files
set wildignore+=*.luac                " Lua compiled
set wildignore+=migrations,classes,lib " Development directories
set wildignore+=*.aux,*.out,*.toc     " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif     " Binary images
set wildignore+=*.png,*.jpeg          " More binary images

"------------------------------------------------------------------------------
" Advanced Features
"------------------------------------------------------------------------------
if v:version >= 600
    set nofoldenable                  " Start with folds open
    set foldmethod=marker             " Use markers for folding
    set sidescrolloff=5              " Keep 5 columns visible when scrolling horizontally
    set mouse=nvi                     " Enable mouse in normal, visual, and insert modes
endif

" }}}

" ============================================================================
" Plugins {{{
" ============================================================================
call plug#begin('~/.config/nvim/plugged')

" Essential Development Tools
Plug 'scrooloose/syntastic'               " Syntax checking
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'scrooloose/nerdtree'               " File explorer
Plug 'tpope/vim-surround'                 " Text surroundings
Plug 'Raimondi/delimitMate'              " Auto-pairing
Plug 'vim-airline/vim-airline'           " Status line
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'          " Code commenting
Plug 'junegunn/vim-easy-align'           " Alignment
Plug 'enricobacis/vim-airline-clock'    " Clock in status line
Plug 't9md/vim-choosewin'              " Window selection

" Language Support
Plug 'leafgarland/typescript-vim'         " TypeScript
Plug 'udalov/kotlin-vim'                 " Kotlin
Plug 'pangloss/vim-javascript'           " JavaScript
Plug 'vim-python/python-syntax'          " Python
Plug 'tpope/vim-classpath'              " Clojure classpath
Plug 'tpope/vim-fireplace'              " Clojure REPL
Plug 'guns/vim-clojure-static'          " Clojure syntax
Plug 'kien/rainbow_parentheses.vim'     " Rainbow parens
Plug 'jpalardy/vim-slime'              " REPL interaction

" Documentation
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Theme
Plug 'mhinz/vim-janah'                 " Current theme

call plug#end()
" }}}

" ============================================================================
" Plugin Settings {{{
" ============================================================================

" Airline - Status line customization
let g:airline_powerline_fonts = 1              " Enable powerline symbols for status line
let g:airline_theme="dark"                     " Use dark theme for status line
let g:airline_section_b = ''                   " Clear section b (git branch) for cleaner look

" Syntastic - Syntax checking and linting
let g:syntastic_always_populate_loc_list = 1   " Always update the location list with errors
let g:syntastic_auto_loc_list = 1             " Automatically open location list with errors
let g:syntastic_check_on_open = 1             " Check syntax when opening files
let g:syntastic_check_on_wq = 0               " Don't check syntax when writing/quitting
let g:syntastic_javascript_checkers = ['eslint'] " Use ESLint for JavaScript files

" NERDTree - File explorer settings
let g:NERDTreeDirArrows = 1                   " Use nice arrow symbols for directories
let g:NERDTreeMinimalUI = 1                   " Minimal UI for cleaner look
let g:NERDSpaceDelims = 1                     " Add space after comment delimiters
let g:NERDTreeDirArrowExpandable = '▸'        " Symbol for expandable directories
let g:NERDTreeDirArrowCollapsible = '▾'       " Symbol for collapsed directories
let NERDTreeHighlightCursorline = 1           " Highlight the selected file/directory
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', '*.o$', 'node_modules']  " Files to hide

" DelimitMate - Auto-pairing of brackets, quotes, etc.
let g:delimitMate_expand_cr = 1               " Expand carriage returns between pairs
let g:delimitMate_expand_space = 1            " Expand spaces between pairs
let g:delimitMate_smart_matchpairs = 1        " Smart matching for pairs
let g:delimitMate_smart_quotes = 1            " Smart handling of quotes
let g:delimitMate_balance_matchpairs = 1      " Balance matching pairs
let g:delimitMate_autoclose = 1               " Automatically close pairs

" }}}

" ============================================================================
" Appearance {{{
" ============================================================================
set background=dark                            " Use dark color scheme base

" Set up Janah background color before loading colorscheme
" This ensures proper terminal background color (grey, not black)
augroup JanahColors
    autocmd!
    autocmd ColorScheme janah highlight Normal ctermbg=235  " Set background to medium-dark grey
augroup END

colorscheme janah                             " Load the Janah colorscheme
hi Comment cterm=italic                       " Make comments italic in terminal

" Note: For iTerm2 users:
" Font settings are managed in iTerm2 Preferences > Profiles > Text
" Current setup: Using Fira Code font in iTerm2
" Make sure 'Use built-in Powerline glyphs' is enabled in iTerm2 for airline symbols
" or use a Nerd Font patched version of Fira Code for additional symbols

" Highlight Settings - Customize special character appearances
hi NonText ctermfg=darkgrey guifg=#565656    " Make hidden characters less prominent
hi clear SpecialKey                          " Clear special key highlighting
hi link SpecialKey NonText                   " Link special keys to NonText style

" }}}

" ============================================================================
" Key Mappings {{{
" ============================================================================

" Window Navigation - Move between splits with Ctrl + hjkl
noremap <C-h> <C-w>h                         " Move to left split
noremap <C-j> <C-w>j                         " Move to split below
noremap <C-k> <C-w>k                         " Move to split above
noremap <C-l> <C-w>l                         " Move to right split

" File Navigation
nmap <silent> <C-a> :NERDTreeToggle<CR>      " Toggle file explorer with Ctrl+a
nnoremap <leader>l :nohls<CR><C-L>           " Clear search highlighting with ,l
nnoremap <leader>d :$                        " Jump to end of file with ,d

" Terminal - Make Esc work in terminal mode
tnoremap <Esc> <C-\><C-n>                    " Exit terminal mode with Esc

" Plugin Mappings
vnoremap <silent> <Enter> :EasyAlign<Enter>   " Start EasyAlign in visual mode (e.g. vipga)
nnoremap <Leader>w :call ToggleWS()<CR>  " Toggle whitespace stripping with ,w
nnoremap <leader>c :g#\({\n\)\@<=#.,/\.*[{}]\@=/-1 sort    " Sort CSS properties with ,c
nmap  -  <Plug>(choosewin)                   " Trigger window selection with -

" }}}

" ============================================================================
" Auto Commands {{{
" ============================================================================

" Clojure Rainbow Parentheses
augroup ClojureParens
    autocmd!
    au VimEnter *.clj RainbowParenthesesToggle
    au Syntax *.clj RainbowParenthesesLoadRound
    au Syntax *.clj RainbowParenthesesLoadSquare
    au Syntax *.clj RainbowParenthesesLoadBraces
augroup END

" Strip trailing whitespace on save
autocmd BufWritePre * :call s:StripTrailingWhitespaces()

" Initialize NERDTree Highlighting
augroup NERDTreeHighlighting
    autocmd!
    call NERDTreeHL('js', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHL('tsx', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHL('md', 'green', 'none', 'green', '#151515')
    call NERDTreeHL('scss', 'green', 'none', 'green', '#151515')
    call NERDTreeHL('ini', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHL('yml', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHL('config', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHL('conf', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHL('json', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHL('html', 'yellow', 'none', 'yellow', '#151515')
augroup END

" }}}

