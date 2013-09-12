set nocompatible                       " turn off vi compatible, should be first

let mapleader = "\<space>"
let maplocalleader = ","

" ===========
" : Plugins :
" ===========

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

let s:load_dynamic_plugins=$VIM_LOAD_DYNAMIC_PLUGINS != "false"

function! <SID>Develop(bundle)
    let bundle_directory = $DEVELOPMENT . '/' . a:bundle
    if isdirectory(bundle_directory)
        let &runtimepath .= ',' . bundle_directory
    else
        call neobundle#parser#bundle("'Julian/" . a:bundle . "'")
    endif
endfunction
command! -nargs=1 Develop call <SID>Develop('<args>')

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'

" --- Themes ---

NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'chriskempson/tomorrow-theme', {'rtp' : 'vim/'}
NeoBundle 'noahfrederick/Hemisu'
NeoBundle 'sickill/vim-monokai'

" --- Additional Filetype Support ---

NeoBundle 'guns/vim-clojure-static'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'tpope/vim-fireplace'
NeoBundle 'tpope/vim-git'
NeoBundle 'vim-ruby/vim-ruby'

" --- Plugins ---

NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'alfredodeza/coveragepy.vim'
NeoBundle 'alfredodeza/pytest.vim'
NeoBundle 'b4winckler/vim-angry'
NeoBundle 'godlygeek/tabular'
NeoBundle 'kana/vim-vspec'
NeoBundle 'kana/vim-submode'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'jmcantrell/vim-diffchanges'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mhinz/vim-signify'
NeoBundle 'mbbill/undotree'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-obsession'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-rhubarb'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-tbone'

NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'bps/vim-textobj-python'
NeoBundle 'kana/vim-textobj-syntax'
NeoBundle 'kana/vim-textobj-user'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'tsukkee/unite-tag'

Develop vim-runt
Develop vim-textobj-brace
Develop vim-textobj-variable-segment

if s:load_dynamic_plugins
    NeoBundle 'Valloric/YouCompleteMe'
endif

if has("python") && s:load_dynamic_plugins
    NeoBundle 'SirVer/ultisnips'
endif

silent! runtime macros/matchit.vim


" =========
" : Basic :
" =========

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set encoding=utf8
set autoread                           " automatically reload unmodified bufs
set gdefault
set hidden
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set report=0                           " :cmd always shows changed line count
set textwidth=79

set nowrap
set showbreak=↪\ 

set fillchars=diff:·

set pastetoggle=<F2>                   " use f2 to toggle paste mode

silent! set cryptmethod=blowfish       " use blowfish for encryption

set isfname-==                         " remove =, which probably is an assign

set tags=.tags,tags,.git/tags;$HOME    " look up until $HOME for tags

" ============
" : Bindings :
" ============

if has("user_commands")
    " quick fingers
    command! -bang -complete=file -nargs=? E e<bang> <args>
    command! -bang -complete=file -nargs=? Sp sp<bang> <args>
    command! -bang -complete=file -nargs=? Vsp vsp<bang> <args>
    command! -bang -complete=file -nargs=? W w<bang> <args>
    command! -bang -complete=file -nargs=? WQ wq<bang> <args>
    command! -bang -complete=file -nargs=? Wq wq<bang> <args>
    command! -bang Q q<bang>
    command! -bang Qa qa<bang>
    command! -bang QA qa<bang>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
endif

" this one is reserved unfortunately, but for encryption just use vim -xn
cnoreabbrev X x

" don't use Ex mode, use Q for formatting
map Q gqap

" change Y to act like C, D
map Y y$

" swap ' and `
noremap ' `
noremap ` '
noremap g' g`
noremap g` g'
noremap ]' ]`
noremap ]` ]'
" sunmap ' sunmap ` sunmap g' sunmap g`

" Preserve flags for &, and add it in visual mode.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

nnoremap <silent> <C-L> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-L>

" make undo less drastic + prevent accidental irreversible undo
" not sure why cr one is not working
inoremap <BS> <BS><C-G>u
" inoremap <CR> <C-G>u<CR>
inoremap <DEL> <DEL><C-G>u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" delete a surrounding function call (which surround doesn't support OOTB)
nmap dsc :call search('\<', 'bc')<CR>dt(ds)

" quote a word
nmap yq ysiw"

let s:all_modes_mappings = {
    \   '<F5>'  : ':<C-U>SignifyToggle<CR>',
    \   '<F6>'  : ':<C-U>IndentGuidesToggle<CR>',
    \   '<F7>'  : ':<C-U>TagbarToggle<CR>',
    \   '<F8>'  : ':<C-U>UndotreeToggle<CR>',
    \   '<F9>'  : ':<C-U>make<CR>',
    \   '<F10>' : ':<C-U>set list!<CR>',
    \   '<F11>' : ':<C-U>set spell!<CR>',
    \   '<F12>' : ':<C-U>set wrap!<CR>',
    \
    \   '<Up>' : '<Nop>',
    \   '<Down>' : '<Nop>',
    \   '<Left>' : '<Nop>',
    \   '<Right>' : '<Nop>'
    \
    \}

for [key, value] in items(s:all_modes_mappings)
    execute 'nnoremap ' . key . ' ' . value
    execute 'inoremap ' . key . ' <C-O>' . value
    execute 'vnoremap ' . key . ' ' . value
endfor

" Leader mappings
" ---------------
"
" Here are explanations for non-self-explanatory ones:
"
"   b : paste last deletion on its own line despite it being charwise
"   n : search forward, but not anything currently displayed
"   u : undo/redo toggle
"   B : paste system clipboard on its own line despite it not having a newline
"   N : search backward, but not anything currently displayed
"   S : remove trailing whitespace
"   0 : minimize a window
"   . : set the working directory in the local window

nnoremap        <leader><leader>  :Unite buffer file file_mru tag<CR>


nnoremap        <leader>b         o<C-R>"<Esc>
nnoremap        <leader>d         :<C-U>DiffChangesDiffToggle<CR>
nnoremap        <leader>e         :<C-U>SplitSensibly<CR>:Unite -no-split file_rec/async:
nnoremap        <leader>f         :<C-U>Unite -no-split -buffer-name=buffers buffer_tab<CR>
nnoremap        <leader>g         :<C-U>Unite -no-split -buffer-name=files file_rec/async<CR>
nnoremap        <leader>j         :<C-U>Unite -no-split -buffer-name=files file<CR>
nnoremap        <leader>h         :<C-U>Unite -no-split -buffer-name=tags tag<CR>
nnoremap        <leader>k         :call <SID>ToggleExpando()<CR>
nnoremap        <leader>l         :<C-U>Unite -no-split -buffer-name=lines line<CR>
nmap            <leader>m         <Plug>(quickhl-toggle)
nnoremap        <leader>n         <C-F>n
nnoremap        <leader>p         "*p
nnoremap        <leader>r         :<C-u>Unite -no-split -buffer-name=mru file_mru<CR>
nnoremap        <leader>s         :<C-U>Switch<CR>
nnoremap        <leader>u         :<C-U>set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nnoremap        <leader>v         :<C-U>SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>y         "*y

nmap            <leader>ch        daAbvaAo<Esc>P
nmap            <leader>cl        daavaa<Esc>p

nnoremap        <leader>ta        :Tabularize /
nnoremap        <leader>tl        :ToggleTestLock<CR>
nnoremap        <leader>to        :topleft split TODO<CR><C-W>6_
nnoremap        <leader>tt        :Dispatch! tox<CR>
nnoremap        <leader>ts        :Dispatch! RunTestSuite(expand("%")))<CR>
nnoremap        <leader>tq        :Copen<CR>
nnoremap        <leader>t<leader> :Dispatch<CR>


nnoremap        <leader>B         o<C-R>*<Esc>
nnoremap  <expr><leader>C         ":<C-U>SplitSensibly<CR>:Unite -no-split -buffer-name=config file_rec/async:" . $XDG_CONFIG_HOME . "<CR>"
nmap            <leader>M         <Plug>(quickhl-reset)
nnoremap        <leader>N         <C-F>N
nnoremap        <leader>P         "*P
nnoremap        <leader>S         :<C-U>%s/\s\+$//<cr>:let @/=''<CR>
nnoremap        <leader>U         :<C-U>Unite -auto-quit -log -no-start-insert -wrap neobundle/update<CR>
nnoremap        <leader>Z         :<C-U>SplitSensibly $ZDOTDIR/.zshrc<CR>

nnoremap        <leader>DD        :<C-U>profile start profile.log<CR>:profile func *<CR>:profile file *<CR>
nnoremap        <leader>DQ        :<C-U>profile pause<CR>:noautocmd quitall!<CR>


nnoremap        <leader>0         :wincmd _<CR>


nnoremap        <leader>`         :<C-U>call <SID>DoCommentTagFormat()<CR>
nnoremap        <leader>.         :<C-U>lcd %:p:h<CR>
nnoremap        <leader>;         :lprevious<CR>
nnoremap        <leader>'         :lnext<CR>
nnoremap        <leader>[         :cprevious<CR>
nnoremap        <leader>]         :cnext<CR>
nnoremap        <leader>{         :cpfile<CR>
nnoremap        <leader>}         :cnfile<CR>
nnoremap        <leader>-         :previous<CR>
nnoremap        <leader>=         :next<CR>
nnoremap        <leader><BS>      :earlier 1f<CR>
nnoremap        <leader>\         :later 1f<CR>
nnoremap        <leader>/         :<C-U>Unite -no-split -buffer-name=grep grep:.<CR>


nnoremap        <leader><tab>     <C-^>


vmap            <leader>m         <Plug>(quickhl-toggle)
vnoremap        <leader>p         "*p
vnoremap        <leader>y         "*y


" ==============
" : Completion :
" ==============

" insert mode completion
set completeopt=menuone,longest,preview     " follow type in autocomplete
set pumheight=6                             " Keep a small completion window

set showcmd                                 " display incomplete commands

set suffixes+=.backup,.hbm,.ini             " lower priority when completing

set wildmenu                                " file completion helper window
set wildmode=longest:full,full

set wildignore+=*.db,*.o,*.obj
set wildignore+=*.swp,*.bak,*.lock
set wildignore+=*.git,*.svn
set wildignore+=MANIFEST,*.pyc,**/_trial_temp/**,*.egg-info/**,*.egg/**,**/build/**,**/htmlcov/**,**/dist/**,**/_build/**,**/.tox/**
set wildignore+=**/.vim-flavor/**
set wildignore+=*DS_Store*
set wildignore+=**/tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.app,*.dmg,*.pdf,*.so

set complete-=i                             " this is slow apparently.

if filereadable("/usr/share/dict/words")
    set dictionary+=/usr/share/dict/words
endif

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
set matchtime=5                        " show for how long (*tenths* of second)

" show a line at column 79
if exists("&colorcolumn")
    highlight ColorColumn guibg=#2d2d2d
    set colorcolumn=+1
endif

" ===========
" : History :
" ===========

set directory=$XDG_CACHE_HOME/vim/swap,~/tmp,/tmp   " sawp files
set history=10000                                   " command line history
set viminfo='50,s100,n$XDG_CACHE_HOME/vim/info      " 50 marks, unhuge register

set backup
set backupdir=$XDG_CACHE_HOME/vim/backups,~/tmp,/tmp

if exists("&undofile")
    set undofile
    set undodir=$XDG_CACHE_HOME/undo,~/tmp,/tmp
endif

set undolevels=500                                  " more undo


" =============
" : Interface :
" =============

set background=dark                    " make sure this is before colorschemes

let g:preferred_colorscheme = 'hemisu'

if has('gui_running')
    execute 'silent colorscheme ' . g:preferred_colorscheme
elseif &t_Co > 8
    set t_Co=256
    execute 'silent colorscheme ' . g:preferred_colorscheme
elseif &t_Co == 8
    if $TERM !~# '^linux'
        set t_Co=16
    endif

    colorscheme desert
endif

set laststatus=2                       " always show status line

if &statusline!~?'airline\|powerline' && (!exists("g:powerline_loaded") || !g:powerline_loaded)
    set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})
    if exists("g:loaded_fugitive")
        set statusline+=\ %{fugitive#statusline()}
    endif
endif

set confirm                            " show confirm dialog instead of warn
set display+=lastline                  " show as much of lastline possible
set listchars=tab:▸\ ,eol:¬
set shortmess+=atI                     " show shorter messages
set title                              " change window title to filename

set equalalways                        " hopefully fix how often :sp's mess up
set splitbelow                         " new :sp go on bottom
set splitright                         " new :vsp go on right

set winminheight=0                     " allow totally minimizing a window

set timeoutlen=500                     " shorten the amount of time to wait

" no bells or blinking
set noerrorbells
set novisualbell
set vb t_vb=


if has('mouse')
  set mouse=v                          " ugh no mouse while typing, just visual
  set mousemodel=popup
endif

" ============
" : Movement :
" ============

set backspace=indent,eol,start         " backspacing over everything in insert
set nostartofline                      " never jump back to start of line
set ruler                              " show the cursor position all the time

set scrolloff=2                        " keep lines above and below cursor
set sidescrolloff=2                    " same for horizontal

set virtualedit=block

" ==========
" : Search :
" ==========

set ignorecase
set smartcase                          " case-sensitive if upper in search term
set incsearch                          " do incremental searching
set hlsearch                           " hilight searches

if executable("ag")                        " if the silver searcher's around...
    set grepprg=ag\ --column\ --nogroup\ --nocolor\ --smart-case
    set grepformat=%f:%l:%c:%m,%f
elseif filereadable("/usr/local/bin/grep") " or if there's a newer grep...
    set grepprg=/usr/local/bin/grep
endif

" ==============
" : Formatting :
" ==============

if executable("par")
    set formatprg=par
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

let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_linecolumn_prefix = '␤ '
let g:airline_branch_prefix = '⎇ '

if filereadable('/usr/local/bin/ctags')
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
else
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
endif

" Syntastic
let g:syntastic_error_symbol="✖"
let g:syntastic_warning_symbol="✦"
let g:syntastic_mode_map = {"mode" : "passive"}

let g:tcommentMaps = 0

" UltiSnips
let g:UltiSnipsListSnippets = "<C-K>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"        " appears needed to overwrite

let g:undotree_TreeNodeShape = '✷'

" more stupid things with default mappings
let g:signify_mapping_next_hunk = '<nop>'
let g:signify_mapping_prev_hunk = '<nop>'
let g:signify_mapping_toggle_highlight = '<nop>'
let g:signify_mapping_toggle = '<nop>'

" Vimple
nmap <nop> <Plug>VimpleMRU

" ============
" : Autocmds :
" ============

if has("eval")

    " Split a window vertically if it would have at least 79 chars plus a bit
    " of padding, otherwise split it horizontally
    function! s:SplitSensiblyCommand(qargs)
        let padding = 5  " columns

        if bufname('%') == '' && getline(1, '$') == ['']
            if a:qargs == ''
                return
            endif

            execute 'edit ' . a:qargs
        elseif winwidth(0) >= (79 + padding) * 2
            execute 'vsplit ' . a:qargs
            wincmd L
        else
            execute 'split ' . a:qargs
        endif
    endfunction

    function! SplitSensibly(path)
        <SID>SplitSensiblyCommand(a:path)
    endfun

    command! -nargs=* -complete=file SplitSensibly call <SID>SplitSensiblyCommand('<args>')
    command! -nargs=* -complete=file Ss call <SID>SplitSensiblyCommand('<args>')

    " If we're in a wide window, enable line numbers.
    function! <SID>WindowWidth()
        if winwidth(0) > 90
            if exists("&relativenumber")
                setlocal relativenumber
            elseif exists("&number")
                setlocal number
            endif
        else
            if exists("&relativenumber")
                setlocal norelativenumber
            elseif exists("&number")
                setlocal nonumber
            endif
        endif
    endfun

    " Toggle the quick fix window
    function! <SID>ToggleQuickfix()
        " This is broken if someone decides to do copen or cclose without using
        " the mapping, but just look at the ugliness required to do it properly
        " http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
        if !exists("s:quickfix_open")
            let s:quickfix_open = 0
            return <SID>ToggleQuickfix()
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
            return <SID>ToggleExpando()
        else
            augroup expando
                autocmd!
                if !s:expando_enabled
                    autocmd WinEnter * :45wincmd >
                    let s:expando_enabled = 1
                    30wincmd >
                else
                    let s:expando_enabled = 0
                    wincmd =
                endif
            augroup END
        endif
    endfun

    " Format tagged comment blocks based on the post-tag indentation
    let b:comment_tags = ['TODO', 'XXX', 'FIXME']
    function! CommentTagFormat()
        let line_number = v:lnum
        let first_line = getline(line_number)
        let comment_leader = split(&commentstring, '%s')[0]
        let comment = '^\s*' . comment_leader . '\s*'

        for pattern in map(copy(b:comment_tags), 'comment . v:val . ":\\?\\s*"')
            if first_line =~ pattern
                let indent = len(matchstr(first_line, pattern)) - len(comment_leader)
                let second_line = getline(line_number + 1)
                call setline(line_number + 1, substitute(second_line, comment, comment_leader . repeat(' ', indent), ''))
                break
            endif
        endfor
        return 1
    endfunction

    function! <SID>DoCommentTagFormat()
        setlocal formatoptions+=2
        setlocal formatexpr=CommentTagFormat()
    endfunction
endif

if has("autocmd") && has("eval")

    augroup misc
        autocmd!

        " Keep splits equal on resize
        autocmd VimResized * :wincmd =

        " Automagic line numbers
        autocmd BufEnter * :call <SID>WindowWidth()

        " Always do a full syntax refresh
        autocmd BufEnter * syntax sync fromstart

        " For help files, make <Return> behave like <C-]> (jump to tag)
        autocmd FileType help nmap <buffer> <Return> <C-]>

        " Jump to the last known cursor position if it's valid (from the docs)
        autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$")                  |
            \   execute "normal! g`\""                                             |
            \ endif

    augroup END

endif


" =====================
" : FileType Specific :
" =====================

augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.jinja2,*.j2 setlocal filetype=jinja
    autocmd BufNewFile,BufRead *.mako,*.mak setlocal filetype=html
    autocmd BufNewFile,BufRead *.tac setlocal filetype=python

    " Compile coffeescript on write (requires vim-coffee-script)
    autocmd BufWritePost *.coffee silent CoffeeMake!

    autocmd BufWritePost .vimrc source $MYVIMRC

    " Auto-close fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

augroup formatstupidity
    " ftplugins are stupid and try to mess with formatoptions
    autocmd!
    autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
    autocmd BufNewFile,BufRead * silent! setlocal formatoptions+=j
augroup END

let g:tex_flavor='latex'

" ============================
" : Local / Project Specific :
" ============================

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

if filereadable('.vimrc.local')
    source .vimrc.local
endif
