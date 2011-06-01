" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
" }

" Setup Bundle Support {
" The next lines ensure that the ~/.vim/bundle/ system works
    filetype off
    runtime! autoload/pathogen.vim
    silent! call pathogen#runtime_append_all_bundles()
    silent! call pathogen#helptags()
" }

" Basics {
    set nocompatible         " must be first line
    set background=dark     " Assume a dark background
" }

" Debian/Ubuntu {
    " This line should not be removed as it ensures that various options are
    " properly set to work with the Vim-related packages available in Debian.
     "runtime! debian.vim
" }

" General {
    filetype plugin indent on      " Automatically detect file types.
    syntax on                      " syntax highlighting
    set mouse=a                    " automatically enable mouse usage
    "set autochdir                 " always switch to the current file directory.. 
    " not every vim is compiled with this, use the following line instead
    "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    scriptencoding utf-8
    set autowrite
    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    " set spell                     " spell checking on
    set hidden                      " Turn on hidden mode
    set undofile                    " Turn on undofile functionality

    " Save on focus lost
    "au FocusLost * :wa
    
    " Setting up the directories {
        set backup                         " backups are nice ...
        set backupdir=$HOME/.vimbackup     " but not when they clog .
        set directory=$HOME/.vimswap       " Same for swap files
        set viewdir=$HOME/.vimviews        " same for view files
        set undodir=$HOME/.vimundo         " same for undo files
        
        " Creating directories if they don't exist
        silent execute '!mkdir -p $HOME/.vimbackup'
        silent execute '!mkdir -p $HOME/.vimswap'
        silent execute '!mkdir -p $HOME/.vimviews'
        silent execute '!mkdir -p $HOME/.vimundo'
        au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
        au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }
" }

" Programming {
    "set makeprg=$HOME/bin/vimAntAndroid
    "set keywordprg=$HOME/bin/php_doc

    function! OpenPhpFunction (keyword)
        let proc_keyword = substitute(a:keyword , '_', '-', 'g')
        exe 'split'
        exe 'enew'
        exe "set buftype=nofile"
        exe 'silent r!lynx -dump -nolist http://www.php.net/manual/en/print/function.'.proc_keyword.'.php'
            "exe 'silent r!lynx -dump -nolist http://php.net/'.proc_keyword
        exe 'norm gg'
        exe 'call search ("' . a:keyword .'")'
        exe 'norm dgg'
        exe 'call search("User Contributed Notes")'
        exe 'norm dGgg'
    endfunction
    au FileType php map K :call OpenPhpFunction('<C-r><C-w>')<CR>

    " Turn on JavaScript folding
    let b:javascript_fold=1

    au FileType tex set makeprg=pdflatex\ %<.tex

" }

" Vim UI {
    " Fix console Vim, which was giving A B C D when using arrow keys in
    " insert mode.
    set term=linux

    color desert256
    set tabpagemax=15               " only show 15 tabs
    set showmode                    " display the current mode

    set cursorline                  " highlight current line
    hi cursorline guibg=#333333     " highlight bg color of current line
    hi CursorColumn guibg=#333333   " highlight cursor

    set splitright                  " I want vertical windows to open on the right
    set splitbelow                  " I want horizontal windows to open on the bottom

    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=1             " show statusline only if there are > 1 windows
        " Use the commented line if fugitive isn't installed
        set statusline=%<%f\ %=\:\b%n%y%m%r%w\ %l,%c%V\ %P " a statusline, also on steroids
        "set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
    endif

    set backspace=indent,eol,start   " backspace for dummys
    set linespace=0                  " No extra spaces between rows
    "set number                       " Line numbers on
    set relativenumber              " Turn on relative number mode
    set showmatch                    " show matching brackets/parenthesis
    set incsearch                    " find as you type search
    set hlsearch                     " highlight search terms
    set winminheight=0               " windows can be 0 line high 
    set ignorecase                   " case insensitive search
    set smartcase                    " case sensitive when uc present
    set wildmenu                     " show list instead of just completing
    set wildmode=list:longest,full   " comand <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]    " backspace and cursor keys wrap to
    set scrolljump=5                 " lines to scroll when cursor leaves screen
    set scrolloff=3                  " minimum lines to keep above and below cursor
    set foldenable                   " auto fold code
    set gdefault                     " the /g flag on :s substitutions by default
    set switchbuf=usetab             " when opening a buffer from the list, use existing window first
    set colorcolumn=85               " visible wrap here/long line indicator

" }

" Formatting {
    set wrap                         " wrap long lines
    set autoindent                   " indent at the same level of the previous line
    set shiftwidth=4                 " use indents of 4 spaces
    set expandtab                    " tabs are tabs, not spaces
    set tabstop=4                    " an indentation every four columns
    "set matchpairs+=<:>             " match, to be used with % 
    set pastetoggle=<F12>            " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    "set foldmethod=syntax
" }

" Key Mappings {

    " Easier moving in tabs and windows
    map <C-H> <C-W>h
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <S-H> gT
    map <S-L> gt

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " clear highlighted seaches
    nnoremap <CR> :noh<CR><CR>

    " Buffers and Tabs
    map <Up> :bprev<CR>
    map <Down> :bnext<CR>
    "map <Left> :tabprev<CR>
    "map <Right> :tabnext<CR>

    " Shortcut mappings
    vmap Q gq
    nmap Q gqap

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h

    " Quickly enter paste mode
    set pastetoggle=<F2>

    " Save a write protected file when you forgot sudo
    cmap w!! w !sudo tee % >/dev/null

    " Map Esc alternatives
    imap ;; <Esc>
    "imap jj <Esc>

    " Use regular regexp for searches
    nnoremap / /\v
    vnoremap / /\v

    " Make tab key bounce between matches like '%'
    nnoremap <tab> %
    vnoremap <tab> %

    " Leader Key Mappings {
        " Firstly, define the <leader> key
        let mapleader = ","

        " This should be moved to a Textile specific config file
        nnoremap <leader>1 yypVr=

        " Strip all trailing whitespace in the current file
        nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

        " fold HMTL tag
        nnoremap <leader>ft Vatzf

        " sort CSS properties
        "nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
        nnoremap <leader>S Vi{:sort<CR>:noh<CR> "}

        " re-highlight text just pasted
        nnoremap <leader>v V`]

        " edit .vimrc in a vertical window
        nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

        " switch to alternate buffer
        nmap <silent><leader>, :buffer#<CR>

    " }
" }

" Plugins {

    " VCSCommand {
        let b:VCSCommandMapPrefix='<Leader>v'
        "let b:VCSCommandVCSType='git'
    " } 
    
    " PIV {
        let g:DisableAutoPHPFolding = 0

        let g:pdv_cfg_Package = "CellTrak"
        let g:pdv_cfg_Version = "1.74"
        let g:pdv_cfg_Author = "K. Gustavson"
        let g:pdv_cfg_Copyright = "Copyright (c) 2011 CellTrak Technologies, Inc. All Rights reserved."
        let g:pdv_cfg_License = "This is a CellTrak internal document. Do not duplicate or distribute."
        ""let b:match_words = b:match_words . ',{:},(:),[:]'
    " }
    
    " Supertab {
        let g:SuperTabDefaultCompletionType = "context"
        let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
    " }

    " Misc { 
        let g:checksyntax_auto = 0

        "comment out line(s) in visual mode
        vmap  o  :call NERDComment(1, 'toggle')<CR>
        let g:NERDShutUp=1

        let b:match_ignorecase = 1
    " }

    " ShowMarks {
        let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        " Don't leave on by default, use :ShowMarksOn to enable
        let g:showmarks_enable = 0
        " For marks a-z
        highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue
        " For marks A-Z
        highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed
        " For all other marks
        highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow
        " For multiple marks on the same line.
        highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen
    " }
    
    " OmniComplete {
        "if has("autocmd") && exists("+omnifunc")
            "autocmd Filetype *
                "\if &omnifunc == "" |
                "\setlocal omnifunc=syntaxcomplete#Complete |
                "\endif
        "endif

        " Popup menu hightLight Group
        "highlight Pmenu     ctermbg=13     guibg=DarkBlue
        highlight PmenuSel     ctermbg=7     guibg=DarkBlue         guifg=LightBlue
        "highlight PmenuSbar ctermbg=7     guibg=DarkGray
        "highlight PmenuThumb             guibg=Black

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " some convenient mappings 
        inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>        pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,longest,preview
    " }
    
    " Ctags {
        set tags=./tags;/,~/.vimtags
    " }

    " EasyTags {
        let g:easytags_cmd = '/usr/bin/ctags'
    " }

    " Delimitmate {
        "au FileType * let b:delimitMate_autoclose = 1

        " If using html auto complete (complete closing tag)
        "au FileType xml,html,xhtml let b:delimitMate_matchpairs = "(:),[:],{:}"
    " }
    
    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    " }
    
    " IndentConsistencyCop {
        " Disable IndentConsistencyCop
        let g:loaded_indentconsistencycop = 1
    " }

    " SnipMate {
        "let loaded_snips = 1 " Disable the plugin

        " Setting the author var
        let g:snips_author = 'Kevin Gustavson <kgust@pobox.com>'
        " Shortcut for reloading snippets, useful when developing
        nnoremap ,smr <esc>:exec ReloadAllSnippets()<cr>
    " }

    " ZenCoding {
        let g:user_zen_settings = {
        \    'php' : {
        \        'extends' : 'html',
        \        'filters' : 'c',
        \    },
        \    'xml' : {
        \        'extends' : 'html',
        \    },
        \    'haml' : {
        \        'extends' : 'html',
        \    },
        \}
    " }

    " AlignMaps {
        let g:DrChipTopLvlMenu= "Plugin."
    " }

    " Gundo {
        nnoremap <Leader>g :GundoToggle<CR>
    " }

    " Disabled {
        " Disable tinymode (currently causing errors)
        let loaded_tinymode_tml = 1
    " }
" }

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T              " remove the toolbar
        set lines=40                   " 40 lines of text instead of 24,
        "set guifont=Droid\ Sans\ Mono\ 9
        set guifont=Monospace\ 9
        color desert
    endif
" }

" Windows Compatible {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier. 
    if has('win32') || has('win64')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
" }
