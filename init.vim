" Hunter Husar's Neovim Configuration

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
        autocmd BufWritePre * call StripTrailingWhitespaces()
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

" File handling
set noswapfile
set nobackup
set nowritebackup
set undofile
set undodir=~/.vim/undodir
set undolevels=1000

" Editor behavior
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set scrolloff=3
set splitbelow
set splitright

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
" }}}

" ============================================================================
" Core Plugins {{{
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

" Core Language Support
Plug 'leafgarland/typescript-vim'         " TypeScript
Plug 'keith/swift.vim'                    " Swift

" Additional Development Tools
Plug 'scrooloose/nerdcommenter'          " Code commenting
Plug 'junegunn/vim-easy-align'           " Alignment
Plug 'Shougo/unite.vim'                  " Fuzzy finding
Plug 'mhinz/vim-grepper'                 " Pattern searching

" Documentation and Note-taking
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'vimwiki/vimwiki'                  " Personal wiki
Plug 'xolox/vim-notes'                  " Note taking
Plug 'xolox/vim-misc'                   " Required for vim-notes

" Interface Enhancements
Plug 'enricobacis/vim-airline-clock'    " Clock in status line
Plug 't9md/vim-choosewin'              " Window selection

" Clojure Development
Plug 'tpope/vim-classpath'              " Classpath handling
Plug 'tpope/vim-fireplace'              " REPL integration
Plug 'guns/vim-clojure-static'          " Better syntax
Plug 'kien/rainbow_parentheses.vim'     " Rainbow parens
Plug 'jpalardy/vim-slime'              " REPL interaction

" Web Development
Plug 'wavded/vim-stylus'               " Stylus syntax
Plug 'digitaltoad/vim-jade'            " Jade/Pug syntax
Plug 'kchmck/vim-coffee-script'        " CoffeeScript

" Other Languages
Plug 'udalov/kotlin-vim'               " Kotlin
Plug 'sudar/vim-arduino-syntax'        " Arduino
"Plug 'slim-template/vim-slim'          " Slim templates

" Color Schemes
Plug 'mhinz/vim-janah'                 " Current theme
" Plug 'morhetz/gruvbox'                 " Alternative theme
" Plug 'freeo/vim-kalisi'               " Alternative theme

call plug#end()
" }}}

" ============================================================================
" Core Settings - Plugins {{{
" ============================================================================

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme="dark"  " Use dark theme for airline to match vim theme
let g:airline_section_b = ''         " Simplify section b

" NERDTree
let g:NERDTreeDirArrows = 1
let g:NERDTreeMinimalUI = 1
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', '*.o$', 'node_modules']

" DelimitMate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

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
    call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
    call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
    call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
augroup END

" }}}

" ============================================================================
" Core Key Mappings {{{
" ============================================================================

" Window Navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" File Navigation
nmap <silent> <C-a> :NERDTreeToggle<CR>
nnoremap <leader>l :nohls<CR><C-L>

" Terminal
tnoremap <Esc> <C-\><C-n>
" }}}

" ============================================================================
" Extended Features {{{
" ============================================================================

" Additional Development Tools
Plug 'scrooloose/nerdcommenter'          " Code commenting
Plug 'junegunn/vim-easy-align'           " Alignment
Plug 'Shougo/unite.vim'                  " Fuzzy finding
Plug 'mhinz/vim-grepper'                 " Pattern searching

" Documentation and Note-taking
Plug 'euclio/vim-markdown-composer'      " Markdown preview
Plug 'vimwiki/vimwiki'                  " Personal wiki
Plug 'xolox/vim-notes'                  " Note taking
Plug 'xolox/vim-misc'                   " Required for vim-notes

" Interface Enhancements
Plug 'enricobacis/vim-airline-clock'    " Clock in status line
Plug 't9md/vim-choosewin'              " Window selection
" }}}

" ============================================================================
" Language-Specific Settings {{{
" ============================================================================

" Clojure Development
Plug 'tpope/vim-classpath'              " Classpath handling
Plug 'tpope/vim-fireplace'              " REPL integration
Plug 'guns/vim-clojure-static'          " Better syntax
Plug 'kien/rainbow_parentheses.vim'     " Rainbow parens
Plug 'jpalardy/vim-slime'              " REPL interaction

" Web Development
Plug 'wavded/vim-stylus'               " Stylus syntax
Plug 'digitaltoad/vim-jade'            " Jade/Pug syntax
Plug 'kchmck/vim-coffee-script'        " CoffeeScript

" Other Languages
Plug 'udalov/kotlin-vim'               " Kotlin
Plug 'sudar/vim-arduino-syntax'        " Arduino
Plug 'slim-template/vim-slim'          " Slim templates
" }}}

" ============================================================================
" Optional Enhancements {{{
" ============================================================================

" Color Schemes
Plug 'mhinz/vim-janah'                 " Current theme
Plug 'morhetz/gruvbox'                 " Alternative theme
Plug 'freeo/vim-kalisi'               " Alternative theme

" Utility Functions
function! s:StripTrailingWhitespaces()
    let l:l = line(".")
    let l:c = col(".")
    %s/\s\+$//e
    call cursor(l:l, l:c)
endfunction

" Optional Key Mappings
nnoremap <Leader>w :call ToggleStripWhitespaceOnSave()<CR>
nnoremap <leader>c :g#\({\n\)\@<=#.,/\.*[{}]\@=/-1 sort
" }}}

" ============================================================================
" Plugin Management {{{
" ============================================================================
call plug#begin('~/.config/nvim/plugged')

" Language Support
" Kotlin: Official Kotlin language support
Plug 'udalov/kotlin-vim'
" TypeScript: Syntax highlighting and indenting for TypeScript
Plug 'leafgarland/typescript-vim'
" Swift: Apple's Swift language support
Plug 'keith/swift.vim'
" CoffeeScript: Syntax, indenting, and compiling for CoffeeScript
Plug 'kchmck/vim-coffee-script'
" Stylus: CSS preprocessor syntax
Plug 'wavded/vim-stylus'
" Jade/Pug: Template engine syntax
Plug 'digitaltoad/vim-jade'
" Arduino: Syntax highlighting for Arduino sketches
Plug 'sudar/vim-arduino-syntax'
" Slim: Template language syntax
Plug 'slim-template/vim-slim'

" Color Schemes
" Awesome Colorschemes: A collection of high-quality color schemes
Plug 'rafi/awesome-vim-colorschemes'
" Space-vim-dark: Dark theme inspired by Spacemacs
Plug 'liuchengxu/space-vim-dark'
" Pencil: Clean, distraction-free color scheme
Plug 'reedes/vim-colors-pencil'
Plug 'reedes/vim-pencil'
" Seoul256: Low-contrast color scheme
Plug 'junegunn/seoul256.vim'
" Janah: Dark color scheme optimized for terminal use
Plug 'mhinz/vim-janah'
" Paramount: Minimal, low-contrast dark theme
Plug 'owickstrom/vim-colors-paramount'
" Gotham: Dark blue theme inspired by Batman
Plug 'whatyouhide/vim-gotham'
" Deus: Dark color scheme inspired by Atom
Plug 'ajmwagar/vim-deus'
" OceanicNext: Sublime Text theme port
Plug 'mhartington/oceanic-next'
" Kalisi: Light and dark themes with vibrant colors
Plug 'freeo/vim-kalisi'
" Gruvbox: Retro groove color scheme
Plug 'morhetz/gruvbox'

" Interface Enhancements
" Airline: Lean & mean status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" NERDTree: File system explorer
Plug 'scrooloose/nerdtree'
" Airline Clock: Displays current time in the status line
Plug 'enricobacis/vim-airline-clock'
" Choosewin: Window chooser like tmux's display-pane
Plug 't9md/vim-choosewin'
" ScrollColors: Colorscheme scroller, chooser, and browser
Plug 'vim-scripts/ScrollColors'

" Development Tools
" Syntastic: Syntax checking and linting
Plug 'scrooloose/syntastic'
" Fugitive: Git wrapper so awesome it should be illegal
Plug 'tpope/vim-fugitive'
" NERDCommenter: Code commenting made easy
Plug 'scrooloose/nerdcommenter'
" EasyAlign: Alignment plugin
Plug 'junegunn/vim-easy-align'
" Unite: Search and display information from arbitrary sources
Plug 'Shougo/unite.vim'
" Grepper: Helps you search for patterns in multiple files
Plug 'mhinz/vim-grepper'
" Split Expander: Easily resize split windows
Plug 'blarghmatey/split-expander'

" Text Editing
" DelimitMate: Auto-completion for quotes, parens, brackets
Plug 'Raimondi/delimitMate'
" Surround: Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Clojure Development
" Classpath: Sets Vim's classpath from your Leiningen or Boot config
Plug 'tpope/vim-classpath'
" Fireplace: Clojure REPL support
Plug 'tpope/vim-fireplace'
" Clojure Static: Better Clojure static syntax highlighting
Plug 'guns/vim-clojure-static'
" Rainbow Parentheses: Color nested parentheses differently
Plug 'kien/rainbow_parentheses.vim'
" Slime: REPL interaction
Plug 'jpalardy/vim-slime'

" Markdown and Documentation
" Markdown Composer: Asynchronous markdown preview
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
" VimWiki: Personal wiki for Vim
Plug 'vimwiki/vimwiki'
" Notes: Note taking in Vim
Plug 'xolox/vim-notes'

" Utility and Integration
" Vimproc: Asynchronous execution library
Plug 'Shougo/vimproc', {'do' : 'make'}
" Node Host: Node.js provider for Neovim
Plug 'neovim/node-host'
" Misc: Miscellaneous auto-load scripts
Plug 'xolox/vim-misc'
" Session: Extended session management
Plug 'xolox/vim-session'
" Origami: Fold text into pretty patterns
Plug 'kshenoy/vim-origami'
" Tmux Navigator: Seamless navigation between tmux panes and vim splits
Plug 'christoomey/vim-tmux-navigator'
" Emoji: Emoji completion
Plug 'junegunn/vim-emoji'
" Tutor Mode: Interactive Vim tutorial
Plug 'fmoralesc/vim-tutor-mode'

call plug#end()
" }}}

" ============================================================================
" Plugin Settings {{{
" ============================================================================

" Airline: Status line customization
let g:airline_powerline_fonts = 1    " Use powerline fonts
let g:airline_theme="dark"         " Use dark theme for airline to match vim theme
let g:airline_section_b = ''         " Simplify section b

" Syntastic: Syntax checking settings
let g:syntastic_always_populate_loc_list = 1  " Auto-populate location list
let g:syntastic_auto_loc_list = 1             " Auto-open location list
let g:syntastic_check_on_open = 1             " Check syntax on file open
let g:syntastic_check_on_wq = 0               " Don't check syntax on write-quit
let g:syntastic_javascript_checkers = ['eslint']  " Use ESLint for JavaScript

" Markdown Composer: Live preview settings
let g:markdown_composer_open_browser = 1   " Auto-open preview in browser
let g:markdown_composer_port = 63229       " Use specific port for preview server

" Session Management: Auto-save configuration
let g:session_autosave = 'no'             " Disable automatic session saving

" IndentLine: Indent guides
let g:indentLine_color_term=238           " Terminal color for indent lines
let g:indentLine_color_gui='#565656'      " GUI color for indent lines
let g:indentLine_char='â€¢'               " Character for indent lines

" NERDTree: File explorer settings
let g:NERDSpaceDelims = 1                 " Add spaces after comment delimiters
let g:NERDTreeDirArrows = 1               " Use arrows for directory structure
let g:NERDTreeDirArrowExpandable = '▸'    " Expandable directory icon
let g:NERDTreeDirArrowCollapsible = '▾'   " Collapsible directory icon
let NERDTreeHighlightCursorline = 1       " Highlight current line in NERDTree
let NERDTreeMinimalUI = 1                 " Use minimal UI
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index',
                  \ 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json',
                  \ '.*\.o$', 'db.db']    " Files to ignore in NERDTree

" Choosewin: Window selection
let g:choosewin_overlay_enable = 1        " Enable overlay feature

" YCM: YouCompleteMe
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'  " Python interpreter path

" Unite: Fuzzy finder and more
let g:unite_source_grep_default_opts = "-iRHn"
\ . " --exclude='*.svn*'"
\ . " --exclude='*.svn*'"
\ . " --exclude='*.log*'"
\ . " --exclude='*tmp*'"
\ . " --exclude-dir='**/tmp'"
\ . " --exclude-dir='CVS'"
\ . " --exclude-dir='.svn'"
\ . " --exclude-dir='.git'"
\ . " --exclude-dir='node_modules'"       " Unite search options

" DelimitMate: Auto-pairing settings
let g:delimitMate_expand_cr = 1           " Expand carriage returns
let g:delimitMate_expand_space = 1        " Expand spaces
let g:delimitMate_smart_matchpairs = 1    " Smart matching
let g:delimitMate_smart_quotes = 1        " Smart quotes
let g:delimitMate_balance_matchpairs = 1  " Balance pairs
let g:delimitMate_autoclose = 1           " Auto-close pairs

" }}}

" ============================================================================
" Appearance {{{
" ============================================================================
set background=dark
" Set Janah's terminal background color before loading the scheme
autocmd ColorScheme janah highlight Normal ctermbg=235
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

" Tab completion
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" EasyAlign
vnoremap <silent> <Enter> :EasyAlign<Enter>

" Window Navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Additional Navigation
nnoremap <leader>l :nohls<CR><C-L>
inoremap <leader>l <C-O>:nohls<CR>
nnoremap <leader>d :$
nmap <leader>z :SyntasticToggleMode

" Terminal
tnoremap <Esc> <C-\><C-n>

" Whitespace Toggle
nnoremap <Leader>w :call ToggleStripWhitespaceOnSave()<CR>

" SCSS Sort
nnoremap <leader>c :g#\({\n\)\@<=#.,/\.*[{}]\@=/-1 sort

" Unite Navigation
nnoremap <leader>/ :Unite -no-quit -keep-focus grep
nnoremap <leader>b :Unite -no-split -buffer-name=buffer -start-insert buffer<cr>

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
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" }}}

" Disable parinfer
" let g:parinfer_mode = "off"

" augroup Parinfer
  " autocmd FileType clojure,scheme,lisp,racket,hy
        " \ :autocmd! Parinfer BufEnter <buffer>
" augroup END

" Vim-Plug {
" let s:vim_plug_dir=expand($HOME.'/.config/nvim/autoload')
" if !filereadable(s:vim_plug_dir.'/plug.vim')
   " execute 'wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P '.s:vim_plug_dir
    " let s:install_plug=1
" endif

" Use deoplete.
" let g:deoplete#enable_at_startup = 1

" use tab to forward cycle
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

filetype plugin indent on     " Required!

" Airline...
let g:airline_theme="dark"
let g:airline_section_b = ''

"kill bell
set noerrorbells
set visualbell
set t_vb=

"stop shitting swps
set noswapfile
set nobackup
set nowritebackup

"easy align lynns:
vnoremap <silent> <Enter> :EasyAlign<Enter>

" Start interactive EasyAlign in visual mode
" vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
" nmap <Leader>a <Plug>(EasyAlign)

" stop undo files
set undofile
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" hilight indention tabs
hi NonText ctermfg=darkgrey guifg=#565656
hi clear SpecialKey
hi link SpecialKey NonText

" nvim settings
let g:indentLine_color_term=238
let g:indentLine_color_gui='#565656'
let g:indentLine_char='â€¢'

" use system clipboard
set clipboard=unnamed

if has("gui")
  set macmeta "use option (alt) as meta key
endif

" Nerd space

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" nerd tree cusomiz
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('js', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('tsx', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('md', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('scss', 'green', 'none', 'green', '#151515')
"call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
"call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('js', 'Red', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

"Syntastic Toggle
nmap <leader>z :SyntasticToggleMode
"NERDTree
nmap <silent> <C-a> :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json', '.*\.o$', 'db.db']
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" emoji
set completefunc=emoji#complete


" ----------------------------------------
"delimitMate
let g:delimitMate_expand_cr          = 1
let g:delimitMate_expand_space       = 1
let g:delimitMate_smart_matchpairs   = 1
let g:delimitMate_smart_quotes       = 1
let g:delimitMate_balance_matchpairs = 1
let g:delimitMate_autoclose          = 1


"Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*

"Save when losing focus
"au FocusLost * :wa

" 120 gray bar
set colorcolumn=120

" Numbers and Borders`
" no line numbers (do we really need?)
"set number
" set nonumber
set signcolumn=no
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar

" Tabs, spaces, wrapping {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=120
set formatoptions=qrn1
"set colorcolumn=+1
"}}}

"folding settings {{{
if v:version >= 600
  set nofoldenable
  set foldmethod=marker   "fold based on indent
  " set printoptions=paper:letter
  set sidescrolloff=5
  set mouse=nvi
endif
"}}}

" Wildmenu completion {{{

set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code

" }}}

"Python/Django
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

"git
set wildignore=*.o,*.obj,.git,*.pyc,*~,fugitive*

"make <leader>l clear the highlight as well as redraw
nnoremap <leader>l :nohls<CR><C-L>
inoremap <leader>l <C-O>:nohls<CR>

"Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" Alphabetize SCSS!
nnoremap <leader>c :g#\({\n\)\@<=#.,/\.*[{}]\@=/-1 sort

" Choosewin
nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable=1

" terminal switch win
tnoremap <Esc> <C-\><C-n>

" OSX needs this...
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'

" General search
"nnoremap <leader>/ :Unite -no-quit -keep-focus grep
nnoremap <leader>/ :Unite -no-quit -keep-focus grep
nnoremap <leader>b :Unite -no-split -buffer-name=buffer -start-insert buffer<cr>

let g:unite_source_grep_default_opts = "-iRHn"
\ . " --exclude='*.svn*'"
\ . " --exclude='*.svn*'"
\ . " --exclude='*.log*'"
\ . " --exclude='*tmp*'"
\ . " --exclude-dir='**/tmp'"
\ . " --exclude-dir='CVS'"
\ . " --exclude-dir='.svn'"
\ . " --exclude-dir='.git'"
\ . " --exclude-dir='node_modules'"

" rainbos
au VimEnter *.clj RainbowParenthesesToggle
au Syntax *.clj RainbowParenthesesLoadRound
au Syntax *.clj RainbowParenthesesLoadSquare
au Syntax *.clj RainbowParenthesesLoadBraces

" - - - - - - - - - - - - - - - - - - - -
"for better split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
set noea

:let g:session_autoload = 'no'

" == Auto commands ==
autocmd BufWritePre * :call s:StripTrailingWhitespaces()                  "Auto-remove trailing spaces

" == Strip trailing whitespace ==
function! s:StripTrailingWhitespaces()
    let l:l = line(".")
    let l:c = col(".")
    %s/\s\+$//e
    call cursor(l:l, l:c)
endfunction

" == Navigation
nnoremap <leader>d :$

" Don't over-ride yanked shit!
xnoremap p "_dP!

" Toggle Auto-Removal of Whitespace on Save for Markdown Files
let g:auto_strip_whitespace_enabled = 0

function! ToggleStripWhitespaceOnSave()
  if g:auto_strip_whitespace_enabled
    autocmd! BufWritePre *
    let g:auto_strip_whitespace_enabled = 0
    echo "Whitespace strip on save: OFF"
  else
    autocmd BufWritePre * call StripTrailingWhitespaces()
    let g:auto_strip_whitespace_enabled = 1
    echo "Whitespace strip on save: ON"
  endif
endfunction

nnoremap <Leader>w :call ToggleStripWhitespaceOnSave()<CR>

