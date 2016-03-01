" vim: ft=vim sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell
" Globals {{{1
set nocompatible                                                                " Must be first line
set encoding=utf-8                                                              " Set text encoding default to utf-8
scriptencoding utf-8                                                            " Character encoding used in this script
let g:mapleader = ','
let g:maplocalleader = ',,'
let g:sh_fold_enabled = 1                                                       " Enable syntax folding for sh, ksh and bash
let g:vimsyn_folding = 'af'                                                     " Syntax fold vimscript augroups and functions
" }}}
" NeoBundle {{{1
let s:bundle_base_path = expand('~/.vim/bundle/')
if isdirectory(s:bundle_base_path . 'neobundle.vim/')
  execute 'set runtimepath+=' . s:bundle_base_path . 'neobundle.vim/'
  call neobundle#begin(s:bundle_base_path)
  NeoBundleFetch 'Shougo/neobundle.vim'                                         " Install NeoBundle itself
  " NeoBundle 'Shougo/neobundle-vim-recipes', {'force' : 1}                       " Recipes for plugins that can be installed and configured with NeoBundleRecipe
  NeoBundle 'ConradIrwin/vim-bracketed-paste'                                   " Automatically toggle paste mode
  NeoBundle 'chrisbra/Recover.vim'                                              " Show diff between swap and saved file
  NeoBundle 'ekalinin/Dockerfile.vim', {'on_ft' : ['docker']}
  NeoBundle 'google/vim-maktaba'                                                " Vimscript plugin library from google
  NeoBundle 'google/vim-searchindex'                                            " Display and index search matches
  " NeoBundle 'honza/vim-snippets'                                                " Collection of vim snippets
  NeoBundle 'kana/vim-textobj-user'                                             " Allow defining text object by user
  NeoBundle 'octol/vim-cpp-enhanced-highlight', {'on_ft' : ['cpp']}             " Enhanced vim cpp highlight
  NeoBundle 'paulhybryant/file-line', {'type__protocol' : 'ssh'}                " Open files and go to specific line and column (original user not active)
  NeoBundle 'paulhybryant/vim-autoclose', {'type__protocol' : 'ssh'}            " Automatically close brackets
  NeoBundle 'plasticboy/vim-markdown', {'on_ft' : ['markdown']}                 " Yet another markdown syntax highlighting
  NeoBundle 'rking/ag.vim', {'disabled' : !executable('ag')}                    " Text based search tool using the silver searcher
  NeoBundle 'thinca/vim-ft-markdown_fold', {'on_ft' : ['markdown']}             " Fold markdown
  NeoBundle 'tmux-plugins/vim-tmux', {'on_ft' : ['tmux']}                       " Vim plugin for editing .tmux.conf
  NeoBundle 'tpope/vim-endwise'                                                 " Automatically put end constructs
  NeoBundle 'tpope/vim-repeat'                                                  " Repeat any command with '.'
  NeoBundle 'tpope/vim-surround'                                                " Mappings for surrounding text objects
  NeoBundle 'tyru/capture.vim', {'on_cmd' : ['Capture']}                        " Capture Ex command output to buffer
  NeoBundle 'vim-ruby/vim-ruby', {'on_ft' : ['ruby']}                           " Vim plugin for editing ruby files.
  NeoBundle 'vitalk/vim-shebang'                                                " Detect shell file types by shell bang
  " {{{2
  NeoBundle 'Shougo/neocomplete.vim', {
    \ 'depends' : ['Shougo/context_filetype.vim'],
    \ 'disabled' : !has('lua'),
    \ 'vim_version' : '7.3.885',
    \ }                                                                         " Code completion engine
  let s:neocomplete = neobundle#get('neocomplete.vim')
  function! s:neocomplete.hooks.on_source(bundle)
    let g:acp_enableAtStartup = 0                                               " Disable AutoComplPop.
    let g:neocomplete#enable_at_startup = 1                                     " Use neocomplete.
    let g:neocomplete#enable_smart_case = 1                                     " Use smartcase.
    let g:neocomplete#sources#syntax#min_keyword_length = 3                     " Set minimum syntax keyword length.
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#sources#dictionary#dictionaries = {
      \   'default' : '',
      \   'vimshell' : expand('~/.vimshell_hist'),
      \ }                                                                       " Define dictionary.
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}                                   " Define keyword.
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      " return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()

    " AutoComplPop like behavior.
    " let g:neocomplete#enable_auto_select = 1
    inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    " let g:neocomplete#sources#omni#input_patterns.php =
          " \ '[^. \t]->\h\w*\|\h\w*::'
    " let g:neocomplete#sources#omni#input_patterns.c =
          " \ '[^.[:digit:] *\t]\%(\.\|->\)'
    " let g:neocomplete#sources#omni#input_patterns.cpp =
          " \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    " let g:neocomplete#sources#omni#input_patterns.perl =
          " \ '\h\w*->\h\w*\|\h\w*::'
    " Do not use NeoComplete for these file types
    autocmd FileType c,cpp,go,python NeoCompleteLock
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Shougo/unite.vim', {'recipe' : 'unite'}                            " Unite plugins: https://github.com/Shougo/unite.vim/wiki/unite-plugins
  let s:unite = neobundle#get('unite.vim')
  function! s:unite.hooks.on_source(bundle)
    let g:unite_data_directory = expand('~/.cache/unite')
    let g:unite_abbr_highlight = 'Keyword'
    if (!isdirectory(g:unite_data_directory))
      call mkdir(g:unite_data_directory, 'p')
    endif
    nnoremap <unique> <C-p> :Unite file_rec/async<CR>
    let g:unite_enable_start_insert = 1
    let g:unite_prompt = '» '
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
  NeoBundle 'Valloric/YouCompleteMe', {
    \ 'on_ft' : ['c', 'cpp', 'go', 'python'],
    \ }                                                                         " Python based multi-language completion engine
  let s:ycm = neobundle#get('YouCompleteMe')
  function s:ycm.hooks.on_source(bundle)
    nnoremap <unique> <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    let g:ycm_always_populate_location_list = 1                                 " Default 0
    let g:ycm_auto_trigger = 1
    let g:ycm_autoclose_preview_window_after_completion = 1                     " Automatically close the preview window for completion
    let g:ycm_autoclose_preview_window_after_insertion = 1                      " Automatically close the preview window for completion
    let g:ycm_collect_identifiers_from_tags_files = 1                           " Enable completion from tags
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_confirm_extra_conf = 1
    let g:ycm_enable_diagnostic_highlighting = 1
    let g:ycm_enable_diagnostic_signs = 1
    let g:ycm_error_symbol = '>>'
    let g:ycm_filetype_blacklist = {}
    let g:ycm_filetype_specific_completion_to_disable = {'gitcommit': 1}
    let g:ycm_filetype_whitelist = {'c' : 1, 'cpp' : 1, 'python' : 1, 'go' : 1}
    let g:ycm_goto_buffer_command = 'same-buffer'                               " [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
    let g:ycm_key_invoke_completion = '<C-Space>'
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_min_num_identifier_candidate_chars = 0
    let g:ycm_min_num_of_chars_for_completion = 2
    let g:ycm_open_loclist_on_ycm_diags = 1
    let g:ycm_register_as_syntastic_checker = 1
    let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'],
      \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
      \             're!\[.*\]\s'],
      \   'ocaml' : ['.', '#'],
      \   'cpp,objcpp' : ['->', '.', '::'],
      \   'perl' : ['->'],
      \   'php' : ['->', '::'],
      \   'cs,java,javascript,typescript' : ['.'],
      \   'd,python,perl6,scala,vb,elixir,go' : ['.'],
      \   'ruby' : ['.', '::'],
      \   'lua' : ['.', ':'],
      \   'erlang' : [':'],
      \ }
    let g:ycm_server_keep_logfiles = 10                                         " Keep log files
    let g:ycm_server_log_level = 'debug'                                        " Default info
    let g:ycm_server_use_vim_stdout = 1                                         " Set to 0 if ycm server crashes to debug
    let g:ycm_show_diagnostics_ui = 1
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
  NeoBundle 'chiphogg/vim-vtd', {'on_ft' : ['vtd']}                             " Manage TODO in vim
  let s:vimvtd = neobundle#get('vim-vtd')
  function! s:vimvtd.hooks.on_source(bundle)
    Glaive vtd plugin[mappings]=',v' files+=`[expand('%:p')]`
  endfunction
  " }}}
  " {{{2
  NeoBundle 'christoomey/vim-tmux-navigator'                                    " Allow using the same keymap to move between tmux panes and vim splits seamlessly
  let s:tmux_navigator = neobundle#get('vim-tmux-navigator')
  function! s:tmux_navigator.hooks.on_source(bundle)
    " Allow jumping to other tmux pane in insert mode
    inoremap <unique> <C-j> <ESC><C-j>
    inoremap <unique> <C-h> <ESC><C-h>
    inoremap <unique> <C-l> <ESC><C-l>
    inoremap <unique> <C-k> <ESC><C-k>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'google/vim-codefmt', {'on_ft' : ['cpp', 'javascript', 'sql']}      " Code formating plugin from google
  let s:vimcodefmt = neobundle#get('vim-codefmt')
  function! s:vimcodefmt.hooks.on_source(bundle)
    Glaive vim-codefmt plugin[mappings]
    " python formatter: https://github.com/google/yapf
    " java formatter: https://github.com/google/google-java-format
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
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/' .
    \ 'dotfiles/master/blob/vba/mark-2.8.5.vba.gz', {
    \ 'name' : 'Mark',
    \ 'regular_name' : 'Mark',
    \ 'frozen' : 1,
    \ 'type' : 'vba',
    \ }                                                                         " Highlight multiple workds
  let s:mark = neobundle#get('Mark')
  function! s:mark.hooks.on_source(bundle)
    nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
    nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
  endfunction
  " }}}
  " {{{2
  NeoBundle 'jeetsukumaran/vim-buffergator'                                     " Buffer selector in vim
  let s:buffergator = neobundle#get('vim-buffergator')
  function! s:buffergator.hooks.on_source(bundle)
    let g:buffergator_viewport_split_policy = 'L'
    let g:buffergator_autodismiss_on_select = 1
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
    \ 'on_ft' : ['cpp'],
    \ 'type__protocol' : 'ssh',
    \ }                                                                         " Open related files in C++
  let s:relatedfiles = neobundle#get('relatedfiles')
  function s:relatedfiles.hooks.on_source(bundle)
    Glaive relatedfiles plugin[mappings]=0
    for l:key in ['c', 'h', 't', 'b']
      execute 'nnoremap <unique> <silent> <leader>g' . l:key .
        \ ' :call relatedfiles#selector#JumpToRelatedFile("' .
        \ l:key . '")<CR>'
    endfor
    nnoremap <unique> <silent> <leader>rw :RelatedFilesWindow<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'paulhybryant/vimutils', {'type__protocol' : 'ssh'}                 " My vim customization (utility functions, syntax etc)
  let s:vimutils = neobundle#get('vimutils')
  function! s:vimutils.hooks.on_source(bundle)
    " Close vim when the only buffer left is a special type of buffer
    Glaive vimutils plugin[mappings]
      \ bufclose_skip_types=`[
      \  'gistls', 'nerdtree', 'indicator', 'folddigest', 'capture' ]`
    execute 'set spellfile=' . a:bundle.path . '/spell/en.utf-8.add'
    call vimutils#InitUndoSwapViews()
  endfunction
  function! s:vimutils.hooks.on_post_source(bundle)
    if !has('gui_running')
      silent! nmap <silent> <unique> 1 <Plug>AirlineSelectTab1
      silent! nmap <silent> <unique> 2 <Plug>AirlineSelectTab2
      silent! nmap <silent> <unique> 3 <Plug>AirlineSelectTab3
      silent! nmap <silent> <unique> 4 <Plug>AirlineSelectTab4
      silent! nmap <silent> <unique> 5 <Plug>AirlineSelectTab5
      silent! nmap <silent> <unique> 6 <Plug>AirlineSelectTab6
      silent! nmap <silent> <unique> 7 <Plug>AirlineSelectTab7
      silent! nmap <silent> <unique> 8 <Plug>AirlineSelectTab8
      silent! nmap <silent> <unique> 9 <Plug>AirlineSelectTab9
    endif
    let l:codefmt_registry = maktaba#extension#GetRegistry('codefmt')
    call l:codefmt_registry.AddExtension(vimutils#fsqlf#GetSQLFormatter())
  endfunction
  " }}}
  " {{{2
  NeoBundle 'scrooloose/nerdcommenter'                                          " Plugin for adding comments
  let s:nerdcommenter = neobundle#get('nerdcommenter')
  function! s:nerdcommenter.hooks.on_source(bundle)
    let g:NERDCreateDefaultMappings = 1
    let g:NERDCustomDelimiters = {
      \ 'cvim' : {'left' : '"', 'leftAlt' : ' ', 'rightAlt' : ' '}
      \ }
    let g:NERDSpaceDelims = 1
    let g:NERDUsePlaceHolders = 0
  endfunction
  " }}}
  " {{{2
  NeoBundle 'scrooloose/syntastic'                                              " Check syntax with external syntax checker
  let s:syntastic = neobundle#get('syntastic')
  function! s:syntastic.hooks.on_source(bundle)
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_mode_map = {
      \ 'mode': 'passive',
      \ 'active_filetypes': [ 'zsh', 'sh', 'cpp' ],
      \ 'passive_filetypes': [ 'vim' ]
      \ }
    nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'terryma/vim-expand-region'                                         " Expand visual selection by text object
  let s:expand_region = neobundle#get('vim-expand-region')
  function! s:expand_region.hooks.on_source(bundle)
    let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'i]'  :1,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }
  endfunction
  function! s:expand_region.hooks.on_post_source(bundle)
    call expand_region#custom_text_objects('ruby', {
      \ 'im' :0,
      \ 'am' :0,
      \ })
  endfunction
  " }}}
  " {{{2
  NeoBundle 'vim-airline/vim-airline'                                           " Lean & mean status/tabline for vim
  let s:airline = neobundle#get('vim-airline')
  function! s:airline.hooks.on_source(bundle)
    let g:airline_detect_paste = 1
    let g:airline_detect_modified = 1
    let g:airline#extensions#nrrwrgn#enabled = 1
    let g:airline#extensions#branch#use_vcscommand = 0
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_tab_type = 1
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#show_tabs = 1
    let g:airline#extensions#tabline#show_tabs_nr = 1
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline_theme = 'powerlineish'
    let g:airline#extensions#tmuxline#enabled = 1                               " Disable this for plugin tmuxline.vim
    let g:airline#extensions#tmuxline#color_template = 'normal'
    " let g:airline#extensions#tmuxline#snapshot_file =
      " \ '~/.tmux-statusline-colors.conf'
    let g:airline#extensions#hunks#enabled = 1
    let g:airline#extensions#whitespace#enabled = 1
    let g:airline_powerline_fonts = 1
  endfunction
  " }}}
  " {{{2
  NeoBundle 'vim-airline/vim-airline-themes', {
    \ 'depends' : ['vim-airline/vim-airline'],
    \ }                                                                         " vim-airline themes
  " }}}
  " Local bundles {{{2
  if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
  endif
  " }}}
  call neobundle#end()
  NeoBundleCheck
endif
" }}}
" Options {{{1
filetype plugin indent on                                                       " Automatically detect file types.
syntax on                                                                       " Syntax highlighting
" Can also use the let syntax to set these options. e.g. let &autoindent = 1
" let &wrapscan = 0 is the same as set nowrapscan
" let &l:wrapscan = 0 is the same as setlocal nowrapscan
" The let syntax is useful for setting option with another option's value.
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
set showtabline=2                                                               " Always show the tabline
set smartcase                                                                   " Case sensitive when uppercase present
set softtabstop=2                                                               " Let backspace delete indent
set splitright                                                                  " Create the split on the right when split vertically
set t_Co=256                                                                    " Set number of colors supported by term
" set term=$TERM                                                                " Make arrow and other keys work
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
if &diff
  set nospell                                                                   " No spellcheck
else
  set spell                                                                     " Spellcheck
endif
set clipboard=unnamedplus
" }}}
