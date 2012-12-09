set nocompatible                       " turn off vi compatible, should be first

" ==========
" : Vundle :
" ==========

filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle (required!).
Bundle 'gmarik/vundle'

" --- Themes ---
Bundle 'sickill/vim-monokai'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" --- Temporary ---
Bundle 'dahu/VimRegexTutor'

" --- Additional Filetype Support ---
Bundle 'groenewege/vim-less'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'othree/html5.vim'
Bundle 'tpope/vim-git'
Bundle 'vim-ruby/vim-ruby'
Bundle 'xhr/vim-io'

Bundle 'VimClojure'

Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

" --- Plugins ---

Bundle 'alfredodeza/coveragepy.vim'
Bundle 'b4winckler/vim-angry'
Bundle 'ervandew/supertab'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'majutsushi/tagbar'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'mikewest/vimroom'
Bundle 'reinh/vim-makegreen'
Bundle 'scrooloose/syntastic'
Bundle 'sontek/rope-vim'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'

if has("python")
    " Bundle 'davidhalter/jedi-vim'
    Bundle 'SirVer/ultisnips'
endif

if !has("gui_running") || !has("clientserver")
    Bundle 'benmills/vimux'
    Bundle 'julienr/vimux-pyutils'
endif

Bundle 'Conque-Shell'
Bundle 'YankRing.vim'

Bundle 'git://git.wincent.com/command-t.git'

" --- Disabled / Saved ---
" Bundle 'KevinGoodsell/vim-csexact'
" Bundle 'skammer/vim-css-color'
" Bundle 'sjl/gundo.vim'

" Bundle 'Pydiction'

" =========
" : Basic :
" =========

filetype plugin indent on
syntax on

set encoding=utf8
set autoread                           " automatically reload unmodified bufs
set gdefault
set hidden
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set nowrap
set report=0                           " :cmd always shows changed line count
set textwidth=79

set pastetoggle=<F2>                   " use f2 to toggle paste mode

set tags=./tags;$HOME                  " look up until $HOME for tags

" ============
" : Bindings :
" ============

let mapleader = "\<space>"

" quick fingers
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
cnoreabbrev Q q

" don't use Ex mode, use Q for formatting
map Q gqap

" change Y to act like C, D
map Y y$

" swap ' and `
noremap ' `
noremap ` '
noremap g' g`
noremap g` g'
" sunmap ' sunmap ` sunmap g' sunmap g`

nnoremap <CR> :nohlsearch<CR>

" line numbers
nmap <C-N><C-N> :set invnumber<CR>
highlight LineNr term=bold cterm=NONE ctermfg=LightGrey gui=NONE guifg=LightGrey


" make undo less drastic + prevent accidental irreversible undo
" not sure why cr one is not working
inoremap <BS> <BS><C-G>u
" inoremap <CR> <C-G>u<CR>
inoremap <DEL> <DEL><C-G>u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" unbind cursor keys
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" completion
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
" TODO: add back <CR> map (see vim tips wiki), but I'm getting a bug
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"

" Toggle how long lines are displayed
nmap          <F11>             :set wrap!<CR>
" fix syntax highlighting errors
noremap       <F12>             <Esc>:syntax sync fromstart<CR>
inoremap      <F12>             <C-o>:syntax sync fromstart<CR>

nmap          <leader>a         :TagbarToggle<CR>
nmap          <leader>c         :set spell!<CR>
nmap          <leader>d         <C-W>0_
nmap          <leader>f         :CommandTBuffer<CR>
nmap          <leader>g         :CommandT<CR>
nmap          <leader>k         :call <SID>ToggleExpando()<CR>
nmap          <leader>l         :set list!<CR>
nmap          <leader>p         o<C-R>"<Esc>
nmap          <leader>q         :call <SID>ToggleQuickfix('c')<CR>
nmap          <leader>s         :!trial %<CR>
nmap          <leader>u         :GundoToggle<CR>
nmap          <leader>v         :call <SID>SplitByWidth('~/.vimrc')<CR>
nmap <silent> <leader>w         <Plug>VimroomToggle
nmap          <leader>y         "*y
nmap          <leader>z         :call <SID>SplitByWidth('~/.zshrc')<CR>

nmap          <leader>td        :topleft split TODO<CR><C-W>6_
nmap          <leader>tj        :call VimuxRunCommand(<SID>RunTestFile(FindTestFile(expand("%"))))<CR>
nmap          <leader>t<leader> :VimuxRunLastCommand<CR>
nmap          <leader>tt        :call VimuxRunCommand("clear; tox")<CR>
nmap          <leader>t,        :call VimuxRunCommand("clear; tox -e py27")<CR>
nmap          <leader>tq        :VimuxCloseRunner<CR>

nmap          <leader>j         :call MakeGreen()<CR>

" reverse line join
nnoremap      <leader>J         ddpkJ
nnoremap      <leader>P         o<C-R>*<Esc>
" Remove trailing whitespace
nnoremap      <leader>S         :%s/\s\+$//<cr>:let @/=''<CR>

" set working directory
nnoremap      <leader>.         :lcd %:p:h<CR>
nmap          <leader>]         :RopeGotoDefinition<CR>
nmap          <leader>[         :RopeRename<CR>

nmap          <leader><tab>     :b#<CR>

vmap          <leader>y         "*y


" ==============
" : Completion :
" ==============

" insert mode completion
set completeopt=menuone,longest,preview " follow type in autocomplete
set pumheight=6                        " Keep a small completion window

set showcmd		               " display incomplete commands

set wildmenu                           " file completion helper window
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.swp,*.bak,*.git,*.pyc,**/_trial_temp/**,*.egg-info/**,**/build/**,**/htmlcov/**,**/dist/**,MANIFEST,**/_build/**
set suffixes+=.backup

if filereadable("/usr/share/dict/words") "
    set dictionary+=/usr/share/dict/words
endif


augroup cursorMove
    " close preview window automatically when we move around
    au!
    autocmd CursorMovedI * if pumvisible() == 0|silent! pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
augroup END

" ===========
" : Folding :
" ===========

set foldmethod=indent
set foldlevel=99

" ==========
" : Guides :
" ==========

set cursorline                         " hilight current line

set showmatch                          " show matching brackets for a moment
set matchpairs+=<:>
set matchtime=5                        " show for how long

" show a line at column 79
if exists("&colorcolumn")
    highlight ColorColumn guibg=#2d2d2d
    set colorcolumn=+1
endif

" ===========
" : History :
" ===========

set history=256		               " command line history
set viminfo='1000,f1,:1000,/1000       " more viminfo

set backup
set backupdir=~/.vim/sessions,~/tmp,/tmp    " put backups and...

set undodir=~/.vim/sessions,~/tmp,/tmp    " put backups and...
set undofile
set undolevels=500                     " more undo

set directory=~/.vim/sessions,~/tmp,/tmp    " swap files here instead of .

" =============
" : Interface :
" =============

set background=dark                    " make sure this is before colorschemes

if &t_Co > 8
    set t_Co=256
    colorscheme Tomorrow-Night-Eighties
else
    colorscheme desert
endif


set formatoptions-=r                   " do not insert comment char after enter

set laststatus=2                       " always show status line

" doesn't actually do anything since we've got Powerline but kept just in case
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}

set confirm                            " show confirm dialog instead of warn
set display+=lastline                  " show as much of lastline possible
set listchars=tab:▸\ ,eol:¬
set shortmess+=atI                     " show shorter messages
set title                              " change window title to filename

set equalalways                        " hopefully fix how often :sp's mess up
set splitbelow                         " new :sp go on bottom
set splitright                         " new :vsp go on right

set timeoutlen=500                     " shorten the amount of time to wait

" no bells or blinking
set noerrorbells
set novisualbell
set vb t_vb=


if has('mouse')
  set mouse=a
  set mousemodel=popup
endif

" ============
" : Movement :
" ============

set backspace=indent,eol,start         " backspacing over everything in insert
set nostartofline                      " never jump back to start of line
set ruler		               " show the cursor position all the time

set scrolloff=2                        " keep lines above and below cursor
set sidescrolloff=2                    " same for horizontal

set virtualedit=block

" ==========
" : Search :
" ==========

set ignorecase
set smartcase                          " case-sensitive if upper in search term
set incsearch		               " do incremental searching
set hlsearch                           " hilight searches

if filereadable("/usr/local/bin/grep") " if there's a newer grep, use it
    set grepprg=/usr/local/bin/grep
endif

" ============
" : Spelling :
" ============

set spellfile=~/.vim/spellfile.add

" ==============
" : Whitespace :
" ==============

set autoindent

set expandtab               " insert space instead of tab
set shiftround              " rounds indent to a multiple of shiftwidth
set shiftwidth=4            " makes # of spaces = 4 for new tab
set softtabstop=4           " makes the spaces feel like tab
set tabstop=8               " makes # of spaces = 8 for preexisitng tab

" ===================
" : Plugin Settings :
" ===================

let g:is_posix = 1

if filereadable('/usr/local/bin/ctags')
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
else
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
endif

" Clear the CommandT window with any of these
let g:CommandTCancelMap=['<ESC>', '<C-c>', '<C-[>']

let g:pydiction_location = '$HOME/.vim/bundle/Pydiction'

let yankring_history_dir = '$HOME/.vim'
let yankring_history_file = '.yankring_history'

" Yankring nnoremaps to remap Y. See :h yankring-custom-maps
function! YRRunAfterMaps()
    nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

let g:Powerline_symbols = 'unicode'

" Supertab
let g:SuperTabDefaultCompletionType = "context"  " try to guess completion
let g:SuperTabLongestEnhanced = 1                " enhanced longest complete
let g:SuperTabLongestHighlight = 1               " preselect first result

" Syntastic
let g:syntastic_error_symbol="✖"
let g:syntastic_warning_symbol="✦"

" UltiSnips
let g:UltiSnipsListSnippets = "<C-K>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"        " appears needed to overwrite

" VimClojure
let g:vimclojure#ParenRainbow = 1

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#goto_command = "<leader>\\"
let g:jedi#get_definition_command = "<leader>`"

" ============
" : Autocmds :
" ============

if has("eval")

    " Split a window vertically if it would have at least 79 chars plus a bit
    " of padding, otherwise split it horizontally
    function! <SID>SplitByWidth(path)
        let padding = 5  " columns
        let path_to_split = a:path

        if winwidth(0) >= (79 + padding) * 2
            exec 'vsplit ' . path_to_split
            wincmd L
        else
            exec 'split ' . path_to_split
        endif
    endfun

    " If we're in a wide window, enable line numbers.
    function! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=2
            setlocal relativenumber
        else
            setlocal norelativenumber
            setlocal foldcolumn=0
        endif
    endfun

    " Toggle the quick fix window
    function! <SID>ToggleQuickfix(bind_key)
        " This is broken if someone decides to do copen or cclose without using
        " the mapping, but just look at the ugliness required to do it properly
        " http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
        let key = a:bind_key

        if !exists("s:quickfix_open")
            let s:quickfix_open = 0
            return <SID>ToggleQuickfix(key)
        else
            if s:quickfix_open
                :cclose
                let s:quickfix_open = 0
            else
                :copen
                let s:quickfix_open = 1
            endif
        endif
    endfun

    " Expand the active window
    function! <SID>ToggleExpando()
        if !exists("s:expando_enabled")
            let s:expando_enabled = 0
            30wincmd >
            return <SID>ToggleExpando()
        else
            augroup expando
                au!
                if !s:expando_enabled
                    au WinEnter * :45wincmd >
                    let s:expando_enabled = 1
                else
                    let s:expando_enabled = 0
                endif
            augroup END
        endif
    endfun

    function! <SID>RunTestFile(path)
        let runner = b:test_runner
        return "clear; " . runner . " " . a:path
    endfunction

    function! <SID>FindTestFile(path)
        return a:path
    endfunction

endif

if has("autocmd") && has("eval")

    augroup misc
        au!

        " Automagic line numbers
        autocmd BufEnter * :call <SID>WindowWidth()

        " Always do a full syntax refresh
        autocmd BufEnter * syntax sync fromstart

        " For help files, make <Return> behave like <C-]> (jump to tag)
        autocmd FileType help nmap <buffer> <Return> <C-]>

        " Jump to the last known cursor position if it's valid (from the docs)
        autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif
    augroup END

endif


" =====================
" : FileType Specific :
" =====================

augroup filetypes
    au!
    autocmd BufNewFile,BufRead *.j2 setlocal filetype=jinja
    autocmd BufNewFile,BufRead *.mako,*.mak setlocal filetype=html
    autocmd BufNewFile,BufRead *.tac setlocal filetype=python

    " Compile coffeescript on write (requires vim-coffee-script)
    autocmd BufWritePost *.coffee silent CoffeeMake!

    autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

let g:tex_flavor='latex'

" TODO: Mapping / something to split 2 windows at 79 chars, toggling the right
" one on and off (like a test_ file), with tags (,a) at the left
