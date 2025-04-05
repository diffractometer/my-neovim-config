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

" Markdown Composer Build
function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction

" NERDTree File Highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

" Strip Trailing Whitespace
function! s:StripTrailingWhitespaces()
    let l:l = line(".")
    let l:c = col(".")
    %s/\s\+$//e
    call cursor(l:l, l:c)
endfunction

" Toggle Whitespace Stripping
let g:auto_strip_whitespace_enabled = 0
function! ToggleStripWhitespaceOnSave()
    if g:auto_strip_whitespace_enabled
        autocmd! BufWritePre *
        let g:auto_strip_whitespace_enabled = 0
        echo "Whitespace strip on save: OFF"
    else
        autocmd BufWritePre * call s:StripTrailingWhitespaces()
        let g:auto_strip_whitespace_enabled = 1
        echo "Whitespace strip on save: ON"
    endif
endfunction

" }}}

" ============================================================================
" Core Settings {{{
" ============================================================================
let mapleader = ","
syntax on
set nocompatible
filetype plugin indent on

" Essential behavior
set encoding=utf-8
set hidden
set ttyfast
set history=1000
set backspace=indent,eol,start
set autoread
set autowrite
set noerrorbells
set visualbell
set t_vb=
set clipboard=unnamed

" File handling
set noswapfile
set nobackup
set nowritebackup
set undofile
set undodir=~/.vim/undodir
set undolevels=1000
set undoreload=10000
set backupskip=/tmp/*,/private/tmp/*

" Editor behavior
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set scrolloff=3
set splitbelow
set splitright
set wrap
set textwidth=120
set formatoptions=qrn1
set colorcolumn=120

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Display
set number
set ruler
set showcmd
set laststatus=2
set signcolumn=no
set guioptions-=L
set guioptions-=r
set guioptions-=m
set guioptions-=T

" Wildmenu
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn,*.pyc,*.o,*.obj,*.svn*,*.swp,*.DS_Store,*.luac,migrations,classes,lib
set wildignore+=*.aux,*.out,*.toc,*.jpg,*.bmp,*.gif,*.png,*.jpeg

" Folding
if v:version >= 600
    set nofoldenable
    set foldmethod=marker
    set sidescrolloff=5
    set mouse=nvi
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
Plug 'Shougo/unite.vim'                  " Fuzzy finding
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

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme="dark"
let g:airline_section_b = ''

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" NERDTree
let g:NERDTreeDirArrows = 1
let g:NERDTreeMinimalUI = 1
let g:NERDSpaceDelims = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', '*.o$', 'node_modules']

" DelimitMate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_smart_matchpairs = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_balance_matchpairs = 1
let g:delimitMate_autoclose = 1

" Unite
let g:unite_source_grep_default_opts = "-iRHn --exclude='*.svn*' --exclude='*.log*' --exclude='*tmp*' --exclude-dir='**/tmp' --exclude-dir='CVS' --exclude-dir='.svn' --exclude-dir='.git' --exclude-dir='node_modules'"

" Choosewin
let g:choosewin_overlay_enable = 1

" }}}

" ============================================================================
" Appearance {{{
" ============================================================================
set background=dark
" Set up Janah background color before loading colorscheme
augroup JanahColors
    autocmd!
    autocmd ColorScheme janah highlight Normal ctermbg=235
augroup END
colorscheme janah
hi Comment cterm=italic

" GUI Font
set guifont=Source\ Code\ Pro\ for\ Powerline:h13

" Highlight Settings
hi NonText ctermfg=darkgrey guifg=#565656
hi clear SpecialKey
hi link SpecialKey NonText

" }}}

" ============================================================================
" Key Mappings {{{
" ============================================================================

" Window Navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" File Navigation
nmap <silent> <C-a> :NERDTreeToggle<CR>
nnoremap <leader>l :nohls<CR><C-L>
nnoremap <leader>d :$

" Terminal
tnoremap <Esc> <C-\><C-n>

" Plugin Mappings
vnoremap <silent> <Enter> :EasyAlign<Enter>
nnoremap <Leader>w :call ToggleStripWhitespaceOnSave()<CR>
nnoremap <leader>c :g#\({\n\)\@<=#.,/\.*[{}]\@=/-1 sort
nnoremap <leader>/ :Unite -no-quit -keep-focus grep
nnoremap <leader>b :Unite -no-split -buffer-name=buffer -start-insert buffer<cr>
nmap  -  <Plug>(choosewin)

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
    call NERDTreeHighlightFile('js', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHighlightFile('tsx', 'blue', 'none', '#3366FF', '#151515')
    call NERDTreeHighlightFile('md', 'green', 'none', 'green', '#151515')
    call NERDTreeHighlightFile('scss', 'green', 'none', 'green', '#151515')
    call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
    call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
augroup END

" }}}

