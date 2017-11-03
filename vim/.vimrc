" vim: ft=vim sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell
" Globals {{{1
set nocompatible                                                                " Must be first line
set encoding=utf-8                                                              " Set text encoding default to utf-8
scriptencoding utf-8                                                            " Character encoding used in this script
let g:mapleader = ','
let g:maplocalleader = ',,'
let g:sh_fold_enabled = 1                                                       " Enable syntax folding for sh, ksh and bash
let g:vimsyn_folding = 'af'                                                     " Syntax fold vimscript augroups and functions
if has('nvim')
  let g:python_host_prog = $BREWHOME . "/bin/python2"
  let g:python3_host_prog = $BREWHOME . "/bin/python3"
endif
" }}}
" NeoBundle {{{1
let s:bundle_base_path = expand('~/.vim/bundle/')
if isdirectory(s:bundle_base_path . 'neobundle.vim/')
  execute 'set runtimepath+=' . s:bundle_base_path . 'neobundle.vim/'
  call neobundle#begin(s:bundle_base_path)
  NeoBundleFetch 'Shougo/neobundle.vim'                                         " Install NeoBundle itself
  NeoBundle 'ConradIrwin/vim-bracketed-paste'                                   " Automatically toggle paste mode
  NeoBundle 'LnL7/vim-nix', {'on_ft' : ['nix']}                                 " Syntax highlight for nix
  NeoBundle 'benmills/vimux'
  NeoBundle 'chrisbra/Recover.vim'                                              " Show diff between swap and saved file
  NeoBundle 'dag/vim-fish'
  NeoBundle 'edkolev/tmuxline.vim'
  NeoBundle 'epeli/slimux'
  NeoBundle 'ekalinin/Dockerfile.vim', {'on_ft' : ['docker']}                   " Syntax highlight for docker
  NeoBundle 'godlygeek/tabular'
  NeoBundle 'google/vim-maktaba'                                                " Vimscript plugin library from google
  NeoBundle 'google/vim-searchindex'                                            " Display and index search matches
  NeoBundle 'haya14busa/vim-operator-flashy'
  NeoBundle 'kana/vim-operator-user'                                            " User defined operator
  NeoBundle 'kana/vim-textobj-user'                                             " Allow defining text object by user
  NeoBundle 'luochen1990/rainbow'
  NeoBundle 'octol/vim-cpp-enhanced-highlight', {'on_ft' : ['cpp']}             " Enhanced vim cpp highlight
  NeoBundle 'metakirby5/codi.vim'
  NeoBundle 'bogado/file-line'                                                  " Open files and go to specific line and column (original user not active)
  NeoBundle 'somini/vim-autoclose'                                              " Automatically close brackets
  NeoBundle 'plasticboy/vim-markdown', {'on_ft' : ['markdown']}                 " Yet another markdown syntax highlighting
  NeoBundle 'rking/ag.vim', {'disabled' : !executable('ag')}                    " Text based search tool using the silver searcher
  NeoBundle 'thinca/vim-ft-markdown_fold', {'on_ft' : ['markdown']}             " Fold markdown
  NeoBundle 'tmux-plugins/vim-tmux', {'on_ft' : ['tmux']}                       " Vim plugin for editing .tmux.conf
  NeoBundle 'tmux-plugins/vim-tmux-focus-events'
  " NeoBundle 'junegunn/vim-slash'
  " NeoBundle 'pgdouyon/vim-evanesco'
  NeoBundle 'tpope/vim-endwise'                                                 " Automatically put end constructs
  NeoBundle 'tpope/vim-repeat'                                                  " Repeat any command with '.'
  NeoBundle 'tpope/vim-surround'                                                " Mappings for surrounding text objects
  NeoBundle 'tyru/capture.vim', {'on_cmd' : ['Capture']}                        " Capture Ex command output to buffer
  NeoBundle 'vim-ruby/vim-ruby', {'on_ft' : ['ruby']}                           " Vim plugin for editing ruby files.
  NeoBundle 'vitalk/vim-shebang'                                                " Detect shell file types by shell bang
  NeoBundle 'zplug/vim-zplug', {'on_ft' : ['zplug']}                            " Syntax highlight for zplug
  " {{{2
  NeoBundle 'Shougo/neocomplete.vim', {
    \ 'depends' : ['Shougo/context_filetype.vim'],
    \ 'disabled' : !has('lua'),
    \ }                                                                         " Code completion engine
  let s:neocomplete = neobundle#get('neocomplete.vim')
  function! s:neocomplete.hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup = 1                                     " Use neocomplete.
    let g:neocomplete#enable_smart_case = 1                                     " Use smartcase.
    let g:neocomplete#sources#syntax#min_keyword_length = 3                     " Set minimum syntax keyword length.
    let g:neocomplete#enable_auto_select = 1
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      " return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
    " <C-h>, <BS>: close popup and delete backword char.
    " Do not use NeoComplete for these file types
    autocmd FileType c,cpp,go,python NeoCompleteLock
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Shougo/unite.vim'                                                  " Unite plugins: https://github.com/Shougo/unite.vim/wiki/unite-plugins
  let s:unite = neobundle#get('unite.vim')
  function! s:unite.hooks.on_source(bundle)
    let g:unite_abbr_highlight = 'Keyword'
    let g:unite_enable_start_insert = 1
    let g:unite_prompt = '» '
    nnoremap <unique> <C-p> :Unite file_rec/async<CR>
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    function! s:unite.hooks.on_open()
      nmap <buffer> <ESC> <Plug>(unite_exit)
      imap <buffer> <ESC> <Plug>(unite_exit)
    endfunction
    autocmd FileType unite call s:unite.hooks.on_open()
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Shougo/vimproc.vim', {
    \   'build' : {
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \   }
    \ }                                                                         " Enable background process and multi-threading
  " }}}
  " {{{2
  NeoBundle 'SirVer/ultisnips', {'disabled' : !has('python')}                   " Define and insert snippets
  let s:ultisnips = neobundle#get('ultisnips')
  " If there are multiple ft.snippet files, UltiSnips will only load the first.
  function! s:ultisnips.hooks.on_source(bundle)
    " Remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = "<tab>"
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Valloric/YouCompleteMe'                                            " Python based multi-language completion engine
  let s:ycm = neobundle#get('YouCompleteMe')
  function s:ycm.hooks.on_source(bundle)
    nnoremap <unique> <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    let g:ycm_always_populate_location_list = 1                                 " Default 0
    let g:ycm_autoclose_preview_window_after_completion = 1                     " Automatically close the preview window for completion
    let g:ycm_autoclose_preview_window_after_insertion = 1                      " Automatically close the preview window for completion
    let g:ycm_collect_identifiers_from_tags_files = 1                           " Enable completion from tags
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_confirm_extra_conf = 1
    let g:ycm_error_symbol = '!!'
    let g:ycm_filetype_blacklist = {}
    let g:ycm_filetype_specific_completion_to_disable = {'gitcommit': 1}
    let g:ycm_filetype_whitelist = {'c' : 1, 'cpp' : 1, 'python' : 1, 'go' : 1}
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'], 'cpp,objcpp' : ['->', '.', '::'],
      \   'java,javascript,python' : ['.'], 'ruby' : ['.', '::'],
      \ }
    let g:ycm_warning_symbol = '>>'
  endfunction
  " }}}
  " {{{2
  NeoBundle 'airblade/vim-gitgutter', {'disabled' : &diff}                      " Show sign at changes from last commit
  let s:gitgutter = neobundle#get('vim-gitgutter')
  function! s:gitgutter.hooks.on_source(bundle)
    let g:gitgutter_highlight_lines = 1
  endfunction
  " }}}
  " {{{2
  NeoBundle 'altercation/vim-colors-solarized'                                  " Vim colorscheme solarized
  let s:solarized = neobundle#get('vim-colors-solarized')
  function! s:solarized.hooks.on_source(bundle)
    let g:solarized_diffmode = "high"
    colorscheme solarized
  endfunction
  " }}}
  " {{{2
  NeoBundle 'bkad/CamelCaseMotion'                                              " Defines CamelCase text object
  let s:camelcasemotion = neobundle#get('CamelCaseMotion')
  function s:camelcasemotion.hooks.on_source(bundle)
    call camelcasemotion#CreateMotionMappings('<leader>')
  endfunction
  " }}}
  " {{{2
  NeoBundle 'christoomey/vim-tmux-navigator'                                    " Allow using the same keymap to move between tmux panes and vim splits seamlessly
  let s:tmux_navigator = neobundle#get('vim-tmux-navigator')
  function! s:tmux_navigator.hooks.on_source(bundle)
    inoremap <unique> <C-j> <ESC><C-j>
    inoremap <unique> <C-h> <ESC><C-h>
    inoremap <unique> <C-l> <ESC><C-l>
    inoremap <unique> <C-k> <ESC><C-k>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'google/vim-codefmt', {'on_ft' : ['cpp', 'javascript', 'sql', 'xml']}      " Code formating plugin from google, python formatter: https://github.com/google/yapf, java formatter: https://github.com/google/google-java-format
  let s:vimcodefmt = neobundle#get('vim-codefmt')
  function! s:vimcodefmt.hooks.on_source(bundle)
    Glaive vim-codefmt plugin[mappings]
  endfunction
  " }}}
  " {{{2
  NeoBundle 'google/vim-glaive'                                                 " Plugin for better vim plugin configuration
  let s:glaive = neobundle#get('vim-glaive')
  function s:glaive.hooks.on_source(bundle)
    call glaive#Install()
  endfunction
  " }}}
  " {{{2
  NeoBundle 'haya14busa/incsearch.vim'                                          " Enhanced incremental search
  let s:incsearch = neobundle#get('incsearch.vim')
  function! s:incsearch.hooks.on_source(bundle)
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
  endfunction
  " }}}
  " {{{2
  NeoBundle 'haya14busa/incsearch-fuzzy.vim', {
    \ 'depends' : ['haya14busa/incsearch.vim'],
    \ }                                                                         " Fuzzy incremental search
  " }}}
  " {{{2
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/' .
    \ 'dotfiles/master/archive/blob/vba/pyclewn-2.3.vmb', {'name' : 'pyclewn',
    \ 'regular_name' : 'pyclewn', 'frozen' : 1, 'type' : 'vba'
    \ }                                                                         " Vim runtime file for pyclewn
  " }}}
  " {{{2
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/' .
    \ 'dotfiles/master/archive/blob/vba/PreserveNoEOL-1.01.vmb', {
    \ 'name' : 'PreserveNoEOL', 'regular_name' : 'PreserveNoEOL',
    \ 'frozen' : 1, 'type' : 'vba'
    \ }                                                                         " Do not preserve EOL plugin
  " }}}
  " {{{2
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/' .
    \ 'dotfiles/master/archive/blob/vba/mark-2.8.5.vba.gz', {'name' : 'Mark',
    \ 'regular_name' : 'Mark', 'frozen' : 1, 'type' : 'vba'
    \ }                                                                         " Highlight multiple words
  let s:mark = neobundle#get('Mark')
  function! s:mark.hooks.on_source(bundle)
    nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
    nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
  endfunction
  " }}}
  " {{{2
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/' .
    \ 'dotfiles/master/archive/blob/vba/vis-v21f.vba.gz', {
    \ 'name' : 'VisualBlockCommands', 'regular_name' : 'VisualBlockCommands',
    \ 'frozen' : 1, 'type' : 'vba'
    \ }                                                                         " Visual Block Commands
  " }}}
  " {{{2
  NeoBundle 'jeetsukumaran/vim-buffergator'                                     " Buffer selector in vim
  let s:buffergator = neobundle#get('vim-buffergator')
  function! s:buffergator.hooks.on_source(bundle)
    let g:buffergator_viewport_split_policy = 'L'
    let g:buffergator_autodismiss_on_select = 0
    let g:buffergator_autoupdate = 1
    let g:buffergator_suppress_keymaps = 1
    noremap <unique> <leader>bg :BuffergatorOpen<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'ntpeters/vim-better-whitespace'                                    " Highlight all types of whitespaces
  let s:betterws = neobundle#get('vim-better-whitespace')
  function! s:betterws.hooks.on_source(bundle)
    let g:strip_whitespace_on_save = 1
    nnoremap <unique> <leader>sw :ToggleStripWhitespaceOnSave<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'paulhybryant/relatedfiles', {
    \ 'on_ft' : ['cpp']
    \ }                                                                         " Open related files in C++
  let s:relatedfiles = neobundle#get('relatedfiles')
  function s:relatedfiles.hooks.on_source(bundle)
    Glaive relatedfiles plugin[mappings]=0
    for l:key in ['c', 'h', 't', 'b']
      execute 'nnoremap <unique> <silent> <leader>g' . l:key .
        \ ' :call relatedfiles#selector#JumpToRelatedFile("' . l:key . '")<CR>'
    endfor
    nnoremap <unique> <silent> <leader>rw :RelatedFilesWindow<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'scrooloose/nerdcommenter'                                          " Plugin for adding comments
  let s:nerdcommenter = neobundle#get('nerdcommenter')
  function! s:nerdcommenter.hooks.on_source(bundle)
    let g:NERDCreateDefaultMappings = 1
    let g:NERDCustomDelimiters = {
      \ 'cvim' : {'left' : '"', 'leftAlt' : ' ', 'rightAlt' : ' '},
      \ 'zplug' : {'left' : '#', 'leftAlt' : ' ', 'rightAlt' : ' '}}
    let g:NERDSpaceDelims = 1
    let g:NERDUsePlaceHolders = 0
  endfunction
  " }}}
  " {{{2
  NeoBundle 'scrooloose/syntastic'                                              " Check syntax with external syntax checker
  let s:syntastic = neobundle#get('syntastic')
  function! s:syntastic.hooks.on_source(bundle)
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': [ 'zsh', 'sh', 'cpp' ],
      \ 'passive_filetypes': [ 'vim' ] }
    nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'thinca/vim-textobj-between', {
    \ 'depends' : 'kana/vim-textobj-user',
    \ }                                                                         " Text object between a char
  " }}}
  " {{{2
  NeoBundle 'terryma/vim-expand-region'                                         " Expand visual selection by text object
  let s:expand_region = neobundle#get('vim-expand-region')
  function! s:expand_region.hooks.on_source(bundle)
    let g:expand_region_text_objects = {'iw' : 0, 'iW' : 0, 'i"' : 0, 'i''': 0,
      \ 'i]' : 1, 'ib' : 1, 'iB' : 1, 'il' : 0, 'ip' : 0, 'ie' : 0, }
  endfunction
  function! s:expand_region.hooks.on_post_source(bundle)
    call expand_region#custom_text_objects('ruby', {'im': 0, 'am': 0})
  endfunction
  " }}}
  " {{{2
  NeoBundle 'vim-airline/vim-airline'                                           " Lean & mean status/tabline for vim
  let s:airline = neobundle#get('vim-airline')
  function! s:airline.hooks.on_source(bundle)
    let g:airline_detect_paste = 1
    let g:airline_detect_modified = 1
    " let g:airline#extensions#tabline#enabled = 1
    " let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline_theme = 'powerlineish'
    let g:airline_powerline_fonts = 1
  endfunction
  " }}}
  " {{{2
  NeoBundle 'vim-airline/vim-airline-themes', {
    \ 'depends' : ['vim-airline/vim-airline'],
    \ }                                                                         " vim-airline themes
  " }}}
  " {{{2
  NeoBundle 'paulhybryant/vimutils'                                             " My vim utils
  let s:vimutils = neobundle#get('vimutils')
  function! s:vimutils.hooks.on_source(bundle)
    Glaive vimutils plugin[mappings]
      \ bufclose_skip_types=`[
      \  'gistls', 'nerdtree', 'indicator', 'folddigest', 'capture' ]`
    execute 'set spellfile=' . a:bundle.path . '/spell/en.utf-8.add'
    call vimutils#InitUndoSwapViews()
  endfunction
  function! s:vimutils.hooks.on_post_source(bundle)
    if !has('gui_running')
      for i in range(1,9)
        execute 'silent! nmap <silent> <unique> '
          \ . i . '<Plug>AirlineSelectTab' . i
      endfor
    endif
    let l:codefmt_registry = maktaba#extension#GetRegistry('codefmt')
    call l:codefmt_registry.AddExtension(vimutils#fsqlf#GetSQLFormatter())
    call l:codefmt_registry.AddExtension(vimutils#xmlformatter#GetXMLFormatter())
  endfunction
  " }}}
  " Local bundles {{{2
  call neobundle#local("~/.vim/bundle", {}, ['pyclewn'])
  if filereadable(expand('~/.local/.vimrc'))
    execute 'source' expand('~/.local/.vimrc')
  endif
  " }}}
  call neobundle#end()
  NeoBundleCheck
endif
" }}}
" Options {{{1
filetype plugin indent on                                                       " Automatically detect file types.
syntax on                                                                       " Syntax highlighting
" The let syntax is useful for setting option with another option's value.
" let &wrapscan = 0 equals set nowrapscan
" let &l:wrapscan = 0 equals setlocal nowrapscan
set autoindent                                                                  " Indent at the same level of the previous line
set autoread                                                                    " Automatically load changed files
set autowrite                                                                   " Automatically write a file when leaving a modified buffer
set background=dark                                                             " Assume a dark background
set backspace=indent,eol,start                                                  " Backspace for dummies
set backup                                                                      " Whether saves a backup before editing
set cmdheight=2                                                                 " Height of the cmd line
set comments=sl:/*,mb:*,elx:*/                                                  " auto format comment blocks
set cursorcolumn                                                                " Highlight current line
set cursorline                                                                  " Highlight current line
set expandtab                                                                   " Tabs are spaces, not tabs
set foldcolumn=5                                                                " Fold indicators on the left
set foldenable                                                                  " Auto fold code
set hidden                                                                      " Allow buffer switching without saving
set history=1000                                                                " Store a ton of history (default is 20)
set hlsearch                                                                    " Highlight search terms
set ignorecase                                                                  " Case insensitive search
set imdisable                                                                   " Disable IME in vim
set incsearch                                                                   " Find as you type search
set laststatus=2                                                                " Always show statusline
set linespace=0                                                                 " No extra spaces between rows
set list                                                                        " Display unprintable characters
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.                                  " Highlight problematic whitespace
set matchpairs+=<:>                                                             " Match, to be used with %
set modeline                                                                    " Mac disables modeline by default
set modelines=5                                                                 " Mac sets it to 0 by default
set mouse=a                                                                     " Automatically enable mouse usage
set mousehide                                                                   " Hide the mouse cursor while typing
set nowrapscan                                                                  " Make regex search wrap to the start of the file
set number                                                                      " Line numbers on
set ruler                                                                       " Show the ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)                              " A ruler on steroids
set scrolljump=5                                                                " Lines to scroll when cursor leaves screen
set scrolloff=0                                                                 " Minimum lines to keep above and below cursor
set shiftround                                                                  " Round indent to multiple of shiftwidth
set shiftwidth=2                                                                " Use indents of 2 spaces
set shortmess+=filmnrxoOtT                                                      " Abbrev. of messages (avoids 'hit enter')
set showcmd                                                                     " Show partial commands in status line and selected text in visual mode
set showmatch                                                                   " Show matching brackets/parenthesis
set showmode                                                                    " Display the current mode
set showtabline=0                                                               " Always show the tabline
set smartcase                                                                   " Case sensitive when uppercase present
set softtabstop=2                                                               " Let backspace delete indent
set splitright                                                                  " Create the split on the right when split vertically
set t_Co=256                                                                    " Set number of colors supported by term
set tabstop=2                                                                   " An indentation every two columns
set undofile                                                                    " Persists undo
set undolevels=1000                                                             " Maximum number of changes that can be undone
set undoreload=10000                                                            " Save the whole buffer for undo when reloading it
set viewoptions=folds,options,cursor,unix,slash                                 " Better Unix / Windows compatibility
set whichwrap=b,s,h,l,<,>,[,]                                                   " Backspace and cursor keys wrap too
set wildmenu                                                                    " Show list instead of just completing
set wildmode=list:longest,full                                                  " Command <Tab> completion, list matches, then longest common part, then all
set winminheight=0                                                              " Windows can be 0 line high
set wrap                                                                        " Wrap long lines
" let &shellcmdflag = '-f ' . &shellcmdflag                                     " For zsh to not load any RC file
" set shell=/bin/sh                                                             " Sometimes shell can cause vim system command to be slow
if &shell =~# 'fish$'
  set shell=sh
endif
if &diff
  set nospell                                                                   " No spellcheck
else
  set spell                                                                     " Spellcheck
endif
if has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamedplus                                                       " Which clipboard */+ to use
endif
" }}}
