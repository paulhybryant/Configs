" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Environment {{{

  set nocompatible                                    " Must be first line
  scriptencoding utf-8                                " Character encoding used in this script

  " Identify platform {{{
    silent function! OSX()
      return has('macunix')
    endfunction
    silent function! LINUX()
      return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
      return  (has('win16') || has('win32') || has('win64'))
    endfunction
  " }}}

  " Initialization for undo etc {{{
    function InitUndoSwapViews()
      let l:prefix = $HOME . '/.vim'
      let l:dir_list = {
        \   'backup': 'backupdir',
        \   'views': 'viewdir',
        \   'swap': 'directory',
        \   'undo': 'undodir'
        \ }
      for [dirname, settingname] in items(l:dir_list)
        let l:directory = l:prefix . dirname . '/'
        if !isdirectory(l:directory)
          if exists("*mkdir")
            try
              call mkdir(l:directory, "p")
            catch /E739:/
              echo "Error: Failed to create directory: " . l:directory
            endtry
          else
            echo "Warning: mkdir not available. Unable to create directory: " . l:directory
          endif
        endif
        let l:directory = substitute(l:directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . l:directory
      endfor
    endfunction
    call InitUndoSwapViews()
  " }}}

  " Windows Compatible {{{
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if WINDOWS()
      source $VIMRUNTIME/mswin.vim
      behave mswin

      let $TERM='win32'
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
      " Be nice and check for multi_byte even if the config requires
      " multi_byte support most of the time
      if has("multi_byte")
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
      endif
      set shellslash
    else
      set shell=/bin/sh
    endif
  " }}}

" }}}

" Plugins {{{

  let g:mapleader = ','
  let g:maplocalleader = ',,'

  if !isdirectory(expand("~/.vim/bundle/neobundle.vim"))
    echo "Installing neobundle..."
    silent !mkdir -p $HOME/.vim/bundle/
    silent !git clone https://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim
  endif

  filetype on
  filetype off
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
  call neobundle#begin()

  NeoBundleFetch 'Shougo/neobundle.vim'                                   " Plugin manager
  NeoBundle 'ConradIrwin/vim-bracketed-paste'                             " Automatically toggle paste mode when pasting in insert mode
  NeoBundle 'Lokaltog/vim-easymotion'                                     " Display hint for jumping to
  NeoBundle 'Raimondi/VimRegEx.vim'                                       " Regex dev and test env in vim
  NeoBundle 'Shougo/neobundle-vim-recipes'                                " Recipes for plugins that can be installed and configured with NeoBundleRecipe
  NeoBundle 'Shougo/vimshell.vim'                                         " Shell implemented with vimscript
  NeoBundle 'bkad/CamelCaseMotion'                                        " Defines CamelCase text object
  NeoBundle 'chiphogg/vim-vtd'                                            " Advanced TODO list in vim (Uncomment after bug fix merged)
  NeoBundle 'chrisbra/Recover.vim'                                        " Show diff between existing swap files and saved file
  NeoBundle 'christoomey/vim-tmux-navigator'                              " Allow using the same keymap to move between tmux panes and vim splits seamlessly
  NeoBundle 'google/vim-syncopate'                                        " Makes it easy to copy syntax highlighted code and paste in emails
  NeoBundle 'guns/xterm-color-table.vim'                                  " Show xterm color tables in vim
  NeoBundle 'justinmk/vim-sneak'                                          " Easy motion within one line
  NeoBundle 'octol/vim-cpp-enhanced-highlight'                            " Enhanced vim cpp highlight
  NeoBundle 'sjl/splice.vim'                                              " Vim three way merge tool
  NeoBundle 'spf13/vim-autoclose'                                         " Automatically close brackets
  NeoBundle 'tpope/vim-dispatch'                                          " Run command asyncroneously in vim
  NeoBundle 'tpope/vim-endwise'                                           " Automatically put end construct (e.g. endfunction)
  NeoBundle 'tpope/vim-git'                                               " Syntax highlight for git
  NeoBundle 'tpope/vim-repeat'                                            " Repeat any command with '.'
  NeoBundle 'tpope/vim-unimpaired'                                      " Complementary pairs of mappings
  NeoBundle 'vim-scripts/HTML-AutoCloseTag'                               " Automatically close html tags
  NeoBundle 'vim-scripts/scratch.vim'                                     " Creates a scratch buffer
  NeoBundle 'xolox/vim-shell'                                             " Better integration between vim and shell
  NeoBundle 'zaiste/tmux.vim'                                             " Tmux syntax highlight
  NeoBundle 'mattn/gist-vim', {'depends' : 'mattn/webapi-vim'}            " Post, view and edit gist in vim

  NeoBundle 'vim-scripts/Vim-Support'                                     " Make vim an IDE for writing vimscript
  let g:Vim_MapLeader  = g:maplocalleader
  NeoBundle 'vim-scripts/bash-support.vim'                                " Make vim an IDE for writing bash
  let g:BASH_MapLeader  = g:maplocalleader

  " Note taking with vim
  NeoBundle 'xolox/vim-notes', {
    \   'depends' : ['xolox/vim-misc', 'vim-scripts/utl.vim']
    \ }
  let g:notes_directories = ['~/Notes']
  let g:notes_suffix = '.txt'
  let g:notes_indexfile = '~/Notes/notes.idx'
  let g:notes_tagsindex = '~/Notes/notes.tags'

  " NeoBundle 'mattn/vim-airline-weather'                                 " Vim airline extension to show weather
  " let g:weather#area='Sunnyvale'

  " NeoBundle 'szw/vim-ctrlspace'                                         " Vim workspace manager

  NeoBundle 'myusuf3/numbers.vim'                                         " Automatically toggle line number for certain filetypes
  " let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m']

  if executable('ctags')
    " NeoBundle 'xolox/easytags', {'depends' : 'xolox/vim-misc'}      " Vim integration with ctags
    NeoBundle 'majutsushi/tagbar'
    let g:tagbar_type_autohotkey = {
      \   'ctagstype' : 'autohotkey',
      \   'kinds' : [
      \     's:sections',
      \     'g:graphics:0:0',
      \     'l:labels',
      \     'r:refs:1:0',
      \     'p:pagerefs:1:0'
      \   ],
      \   'sort'  : 0,
      \   'deffile' : '$HOME/.ctagscnf/autohotkey.cnf'
      \ }
  endif

  NeoBundle 'kien/rainbow_parentheses.vim'                                " Colorful parentheses
  let g:rbpt_max = 16
  let g:rbpt_loadcmd_toggle = 0
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces

  " NeoBundle 'vinarise.vim'                                              " Ultimate hex editing system with vim
  " NeoBundle 'glts/vim-radical'                                          " Show number under cursor in hex, octal, binary

  " NeoBundle 'tpope/vim-markdown'                                        " Syntax highlighting for markdown
  NeoBundle 'plasticboy/vim-markdown'                                     " Yet another markdown syntax highlighting
  NeoBundle 'isnowfy/python-vim-instant-markdown'                         " Start a http server and preview markdown instantly

  NeoBundle 'kana/vim-textobj-user'                                       " Allow defining text object by user
  NeoBundle 'jceb/vim-textobj-uri'                                        " Define text object for uri
  NeoBundle 'kana/vim-textobj-line'                                       " Define text object for a line
  NeoBundle 'kana/vim-textobj-entire'                                     " Define text object for the entire buffer
  NeoBundle 'Raimondi/vim_search_objects'                                 " Define text object for a search pattern
  " NeoBundle 'Raimondi/VimLTextObjects'                                  " Define text object for vimscript
  " NeoBundle 'Julian/vim-textobj-brace'                                  " Define text object between braces
  " NeoBundle 'beloglazov/vim-textobj-quotes'                             " Define text object between any type of quotes
  " NeoBundle 'glts/vim-textobj-comment'                                  " Define text object for comments
  " NeoBundle 'kana/vim-textobj-datetime'                                 " Define text object for datetime format
  " NeoBundle 'kana/vim-textobj-function'                                 " Define text object for function
  " NeoBundle 'kana/vim-textobj-indent'                                   " Define text object for indent
  " NeoBundle 'reedes/vim-textobj-sentence'                               " Define text obj for a sentence
  " NeoBundle 'rhysd/vim-textobj-clang'                                   " Define text object for c family languages
  " NeoBundle 'reedes/vim-textobj-quote'                                  " Define text object between also typographic ('curly') quote characters
  " augroup textobj_quote
    " autocmd!
    " autocmd FileType markdown call textobj#quote#init()
    " autocmd FileType textile call textobj#quote#init()
    " autocmd FileType text call textobj#quote#init({'educate': 0})
  " augroup END

  NeoBundle 'osyo-manga/vim-over'                                         " Preview changes to be made
  map <leader>o :OverCommandLine<CR>

  NeoBundle 'syngan/vim-vimlint', {'depends' : 'ynkdir/vim-vimlparser'}   " Syntax checker for vimscript
  " NeoBundle 'dbakker/vim-lint'                                          " Syntax checker for vimscript

  NeoBundle 'paulhybryant/Align'                                          " Alinghing texts based on specific charater etc (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/file-line'                                      " Open files and go to specific line and column (original user not active)
  NeoBundle 'paulhybryant/manpageview'                                    " Commands for viewing man pages in vim (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/vim-textobj-path'                               " Define text object for a file system path
  NeoBundle 'paulhybryant/vissort'                                        " Allow sorting lines by using a visual block (column) (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/visualincr.vim'                                 " Increase integer values in visual block (Host up-to-date version from Dr. Chip)

  NeoBundle 'vim-scripts/ReloadScript'                                    " Reload vim script without having to restart vim
  map <leader>rl :ReloadScript %:p<CR>

  NeoBundle 'paulhybryant/mark'                                           " Highlight multiple patterns with different color (Host latest version 2.8.5)
  " NeoBundle 'vim-scripts/ShowMarks'                                     " Use gutter to show location of marks
  nnoremap <leader>mc :MarkClear<CR>
  nnoremap <leader>m/ :Mark <C-R>/<CR>

  NeoBundle 'paulhybryant/Decho.vim'                                      " Debug echo for debuging vim plugins (Host up-to-date version from Dr. Chip, with minor enhancement)
  let g:dechofuncname = 1
  let g:decho_winheight = 10

  NeoBundle 'paulhybryant/vim-custom'                                     " My vim customization (utility function, mappings, autocmds, etc)
  set spellfile=$HOME/.vim/bundle/vim-custom/spell/en.utf-8.add
  autocmd BufEnter * call myutils#SyncNTTree()

  NeoBundle 'paulhybryant/SQLUtilities'                                   " Utilities for editing SQL scripts (v7.0) ('vim-scripts/SQLUtilities' has only v6.0)
  let g:sqlutil_align_comma=0
  NeoBundle 'vim-scripts/SQLComplete.vim'                                 " SQL script completion
  NeoBundle 'vim-scripts/sql.vim--Stinson'                                " Better SQL syntax highlighting

  NeoBundle 'scrooloose/syntastic'                                        " Check syntax with external syntax checker
  let g:syntastic_always_populate_loc_list = 1

  NeoBundle 'mhinz/vim-signify'                                           " Show the sign at changes from last git commit
  if !WINDOWS()
    NeoBundle 'tpope/vim-fugitive'                                        " Commands for working with git
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
    " NeoBundle 'airblade/vim-gitgutter'                                  " Prefer vim-signify
  else
    NeoBundle 'vim-scripts/Tail-Bundle'                                   " Tail for windows in vim
  endif

  NeoBundle 'terryma/vim-multiple-cursors'                                " Insert words at multiple places simutaneously
  nnoremap <leader>mcf :exec 'MultipleCursorsFind \<' . expand("<cword>") . '\>'<CR>

  NeoBundle 'terryma/vim-expand-region'                                   " Expand visual selection by text object
  let g:expand_region_text_objects = {
    \   'iw'  :0,
    \   'iW'  :0,
    \   'i"'  :0,
    \   'i''' :0,
    \   'i]'  :1,
    \   'ib'  :1,
    \   'iB'  :1,
    \   'il'  :0,
    \   'ip'  :0,
    \   'ie'  :0,
    \ }
  map L <Plug>(expand_region_expand)
  map H <Plug>(expand_region_shrink)

  NeoBundle 'altercation/vim-colors-solarized'                            " Vim colorscheme solarized
  NeoBundle 'flazz/vim-colorschemes'                                      " Collection of vim colorschemes
  NeoBundle 'Kshitij-Banerjee/vim-github-colorscheme'                     " Vim colorscheme github
  NeoBundle 'itchyny/landscape.vim'                                       " Vim colorscheme landscape
  NeoBundle 'tomasr/molokai'                                              " Vim colorscheme molokai
  NeoBundle 'tpope/vim-vividchalk'                                        " Vim colorscheme vividchalk
  NeoBundle 'vim-scripts/candy.vim'                                       " Vim colorscheme candy
  NeoBundle 'Lokaltog/vim-distinguished'                                  " Vim colorscheme distinguished
  let g:rehash256 = 1

  " NeoBundle 'tomtom/tlib_vim'                                           " Library utilities for plugin from tomtom
  " NeoBundle 'tomtom/tcomment_vim'                                       " Add comments
  " NeoBundle 'tpope/vim-commentary'                                      " Add comments
  NeoBundle 'scrooloose/nerdcommenter'                                    " Add comments
  let g:NERDSpaceDelims = 1
  if exists('g:NERDCustomDelimiters')
    let g:NERDCustomDelimiters['rvl'] = { 'left': '#' }
  else
    let g:NERDCustomDelimiters = {
      \   'rvl' : { 'left': '#' },
      \   'borg' : { 'left' : '//' }
      \ }
  endif

  NeoBundle 'jistr/vim-nerdtree-tabs'                                     " One NERDTree only, shared among buffers / tabs
  NeoBundle 'scrooloose/nerdtree'                                         " File explorer inside vim
  NeoBundle 'tpope/vim-vinegar'                                           " NERDTree enhancement
  NeoBundle 'eiginn/netrw'                                                " NERDTree plugin for network
  let g:netrw_altfile = 1
  " File explorer inside vim
  NeoBundle 'Shougo/vimfiler.vim', {
    \   'depends' : 'Shougo/unite.vim',
    \   'commands' : [
    \     { 'name' : ['VimFiler', 'Edit', 'Write'],
    \       'complete' : 'customlist,vimfiler#complete' },
    \     'Read',
    \     'Source'
    \   ],
    \   'mappings' : '<Plug>',
    \   'explorer' : 1,
    \ }
  noremap <C-e> :NERDTreeToggle %<CR>
  " noremap <C-e> :NERDTreeTabsToggle<CR>
  " noremap <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
  " noremap <leader>e :NERDTreeFind<CR>
  " nnoremap <leader>nt :NERDTreeFind<CR>
  let g:NERDShutUp=1
  let g:NERDTreeChDirMode=1
  let g:NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
  let g:NERDTreeMouseMode=2
  let g:NERDTreeQuitOnOpen = 0                                            " Keep NERDTree open after click
  let g:NERDTreeShowBookmarks=1
  let g:NERDTreeShowHidden=1
  let g:nerdtree_tabs_open_on_gui_startup=0

  let g:semanticTermColors = [1,2,3,5,6,7,9,10,11,13,14,15,33,34,46,124,125,166,219,226]
  NeoBundle 'jaxbot/semantic-highlight.vim'                             " General semantic highlighting for vim
  NeoBundle 'paulhybryant/tmuxline.vim'                                 " Change tmux theme to be consistent with vim statusline (Wait for response on PR)
  " NeoBundle 'edkolev/tmuxline.vim'                                    " Change tmux theme to be consistent with vim statusline
  let g:tmuxline_theme = 'airline'
  " let g:tmuxline_preset = 'tmux'

  if executable('ag')
    NeoBundle 'rking/ag.vim'
    NeoBundle 'mileszs/ack.vim'
    let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
  elseif executable('ack-grep')
    NeoBundle 'mileszs/ack.vim'
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
  elseif executable('ack')
    NeoBundle 'mileszs/ack.vim'
  endif

  NeoBundle 'honza/vim-snippets'                                          " Collection of vim snippets
  if has('python')
    NeoBundle 'SirVer/ultisnips'
    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"
  else
    NeoBundle 'neosnippet.vim'                                            " Snippet support for vim
  endif

  if has('python')
    NeoBundle 'Valloric/MatchTagAlways'

    let g:statusline_use_airline = 1
    if g:statusline_use_airline
      NeoBundle 'bling/vim-airline'
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tmuxline#enabled = 0                       " Disable this for plugin Tmuxline
      let g:airline#extensions#tabline#left_sep = ''
      let g:airline#extensions#tabline#left_alt_sep = ''
      let g:airline#extensions#tabline#buffer_idx_mode = 1
    else
      NeoBundle 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
    endif
  endif

  " Background process for unite.vim
  NeoBundle 'Shougo/vimproc.vim', {
    \   'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \   },
    \ }
  NeoBundle 'Shougo/unite.vim'
  " Unite plugins: https://github.com/Shougo/unite.vim/wiki/unite-plugins
  NeoBundle 'h1mesuke/unite-outline'
  NeoBundle 'ujihisa/unite-colorscheme'
  NeoBundle 'thinca/vim-unite-history'
  NeoBundle 'mattn/unite-gist'
  let g:unite_data_directory = $HOME . '/.cache/unite'
  let g:unite_abbr_highlight = 'Keyword'
  if (!isdirectory(g:unite_data_directory))
    call mkdir(g:unite_data_directory, "p")
  endif
  nnoremap <C-p> :Unite file_rec/async<CR>
  let g:unite_enable_start_insert=1
  let g:unite_prompt='» '
  if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt=''
  elseif executable('ack')
    let g:unite_source_grep_command='ack'
    let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
    let g:unite_source_grep_recursive_opt=''
  endif
  " NeoBundle 'wincent/Command-T'

  if filereadable(expand("~/.vimrc.local"))
    source $HOME/.vimrc.local
  endif

  call neobundle#end()
  call glaive#Install()

  Glaive vtd plugin[mappings]='vtd'
  autocmd BufEnter * if &filetype == 'vtd' | Glaive vtd files+=`[expand('%:p')]`

  Glaive syncopate plugin[mappings] colorscheme=putty
  let g:html_number_lines = 0

  call unite#filters#matcher_default#use(['matcher_fuzzy'])

" }}}

" General {{{

  filetype plugin indent on                                               " Automatically detect file types.
  syntax on                                                               " Syntax highlighting
  set autoindent                                                          " Indent at the same level of the previous line
  set autoread                                                            " Automatically load changed files
  set autowrite                                                           " Automatically write a file when leaving a modified buffer
  set background=dark                                                     " Assume a dark background
  set backspace=indent,eol,start                                          " Backspace for dummies
  set backup                                                              " Whether saves a backup before editing
  set cursorline                                                          " Highlight current line
  set encoding=utf-8                                                      " Set text encoding default to utf-8
  set expandtab                                                           " Tabs are spaces, not tabs
  set foldenable                                                          " Auto fold code
  set hidden                                                              " Allow buffer switching without saving
  set history=1000                                                        " Store a ton of history (default is 20)
  set hlsearch                                                            " Highlight search terms
  set ignorecase                                                          " Case insensitive search
  set incsearch                                                           " Find as you type search
  set laststatus=2                                                        " Always show statusline
  set linespace=0                                                         " No extra spaces between rows
  set list                                                                " Display unprintable characters
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:.                          " Highlight problematic whitespace
  set matchpairs+=<:>                                                     " Match, to be used with %
  set modeline                                                            " Mac disables modeline by default
  set modelines=4                                                         " Mac sets it to 0 by default
  set mouse=a                                                             " Automatically enable mouse usage
  set mousehide                                                           " Hide the mouse cursor while typing
  set number                                                              " Line numbers on
  set pastetoggle=<F12>                                                   " pastetoggle (sane indentation on paste)
  set ruler                                                               " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)                      " A ruler on steroids
  set scrolljump=5                                                        " Lines to scroll when cursor leaves screen
  set scrolloff=3                                                         " Minimum lines to keep above and below cursor
  set shiftround                                                          " Round indent to multiple of shiftwidth
  set shiftwidth=2                                                        " Use indents of 2 spaces
  set shortmess+=filmnrxoOtT                                              " Abbrev. of messages (avoids 'hit enter')
  set showcmd                                                             " Show partial commands in status line and selected text in visual mode
  set showmatch                                                           " Show matching brackets/parenthesis
  set showmode                                                            " Display the current mode
  set showtabline=2                                                       " Always show the tabline
  set smartcase                                                           " Case sensitive when uppercase present
  set softtabstop=2                                                       " Let backspace delete indent
  set t_Co=256                                                            " Set number of colors supported by term
  set tabstop=2                                                           " An indentation every two columns
  set term=$TERM                                                          " Make arrow and other keys work
  set undofile                                                            " Persists undo
  set undolevels=1000                                                     " Maximum number of changes that can be undone
  set undoreload=10000                                                    " Save the whole buffer for undo when reloading it
  set viewoptions=folds,options,cursor,unix,slash                         " Better Unix / Windows compatibility
  set whichwrap=b,s,h,l,<,>,[,]                                           " Backspace and cursor keys wrap too
  set wildmenu                                                            " Show list instead of just completing
  set wildmode=list:longest,full                                          " Command <Tab> completion, list matches, then longest common part, then all
  set winminheight=0                                                      " Windows can be 0 line high
  set wrap                                                                " Wrap long lines
  set wrapscan                                                            " Make regex search wrap to the start of the file

  if &diff
    set nospell                                                           " No spellcheck
  else
    set spell                                                             " Spellcheck
  endif

  if has ('x11') && (LINUX() || OSX())                                               " On Linux and mac use + register for copy-paste
    set clipboard=unnamedplus
  else                                                                    " On Windows, use * register for copy-paste
    set clipboard=unnamed
  endif

  " Has to be after syntax on for colorscheme to work
  colorscheme putty

  let g:omni_syntax_ignorecase=0

" }}}
