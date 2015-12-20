" vim: filetype=vim shiftwidth=2 tabstop=2 softtabstop=2 expandtab textwidth=80
" vim: foldlevel=0 foldmethod=marker nospell
" Globals {{{1
set nocompatible                                                                " Must be first line
set encoding=utf-8                                                              " Set text encoding default to utf-8
scriptencoding utf-8                                                            " Character encoding used in this script
let g:mapleader = ','
let g:maplocalleader = ',,'
let g:sh_fold_enabled = 1                                                       " Enable syntax folding for sh, ksh and bash
let g:disabled_bundles = {}
let g:vimsyn_folding = 'af'                                                     " Syntax fold vimscript augroups and functions
let s:vimplugin_priority = str2nr($VIMPLUGINS)
" let $PYTHONPATH = $PYTHONPATH . expand(':$HOME/.pyutils')
" }}}
" Shared plugin configurations {{{1
function! s:OSDetect()
  let l:is_unix = has('unix')
  let l:is_windows =
    \ has('win16') || has('win32') || has('win64') || has('win95')
  let l:is_cygwin = has('win32unix')
  let l:is_mac = $SSH_OS == 'Darwin' || !l:is_windows && !l:is_cygwin
    \ && (has('mac') || has('macunix') || has('gui_macvim'))
  let l:is_linux = l:is_unix && !l:is_mac && !l:is_cygwin

  let g:OS = {
    \ 'is_unix'     :  l:is_unix,
    \ 'is_windows'  :  l:is_windows,
    \ 'is_cygwin'   :  l:is_cygwin,
    \ 'is_mac'      :  l:is_mac,
    \ 'is_linux'    :  l:is_linux,
    \ }
endfunction

function! g:ConfigureRelatedFiles()
  Glaive relatedfiles plugin[mappings]=0
  for l:key in ['c', 'h', 't', 'b']
    execute 'nnoremap <unique> <silent> <leader>g' . l:key .
      \ ' :call relatedfiles#selector#JumpToRelatedFile("' .
      \ l:key . '")<CR>'
  endfor
  nnoremap <unique> <silent> <leader>rw :RelatedFilesWindow<CR>
endfunction

function! g:ConfigureYcm()
  nnoremap <unique> <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
  let g:ycm_always_populate_location_list = 1                                   " Default 0
  let g:ycm_auto_trigger = 1
  let g:ycm_autoclose_preview_window_after_completion = 1                       " Automatically close the preview window for completion
  let g:ycm_autoclose_preview_window_after_insertion = 1                        " Automatically close the preview window for completion
  let g:ycm_collect_identifiers_from_tags_files = 1                             " Enable completion from tags
  let g:ycm_complete_in_comments = 1
  let g:ycm_complete_in_strings = 1
  let g:ycm_confirm_extra_conf = 1
  let g:ycm_enable_diagnostic_highlighting = 1
  let g:ycm_enable_diagnostic_signs = 1
  let g:ycm_error_symbol = '>>'
  let g:ycm_filetype_blacklist = {}
  let g:ycm_filetype_specific_completion_to_disable = { 'gitcommit': 1 }
  let g:ycm_filetype_whitelist = { 'c' : 1, 'cpp' : 1, 'python' : 1, 'go' : 1 }
  let g:ycm_goto_buffer_command = 'same-buffer'                                 " [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
  let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_min_num_identifier_candidate_chars = 0
  let g:ycm_min_num_of_chars_for_completion = 2
  let g:ycm_open_loclist_on_ycm_diags = 1
  let g:ycm_path_to_python_interpreter = '/usr/bin/python'
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
  let g:ycm_server_keep_logfiles = 10                                           " Keep log files
  let g:ycm_server_log_level = 'debug'                                          " Default info
  let g:ycm_server_use_vim_stdout = 1                                           " Set to 0 if ycm server crashes to debug
  let g:ycm_show_diagnostics_ui = 1
  let g:ycm_warning_symbol = '>>'
endfunction
" }}}
" Setup NeoBundle {{{1
filetype off
if has('vim_starting')
  let s:bundle_base_path = expand('~/.vim/bundle/')
  call s:OSDetect()
  execute 'set runtimepath+=' . s:bundle_base_path . 'neobundle.vim/'
endif
call neobundle#begin(s:bundle_base_path)
NeoBundleFetch 'Shougo/neobundle.vim'                                           " Plugin manager
NeoBundle 'Shougo/neobundle-vim-recipes', { 'force' : 1 }                       " Recipes for plugins that can be installed and configured with NeoBundleRecipe
" }}}
" Windows Compatible {{{1
if g:OS.is_windows
  source $VIMRUNTIME/mswin.vim
  behave mswin

  let $TERM = 'win32'
  " On Windows, also use '.vim' instead of 'vimfiles'. It makes synchronization
  " across (heterogeneous) systems easier.
  set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
  " Be nice and check for multi_byte even if the config requires
  " multi_byte support most of the time
  if has('multi_byte')
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
  NeoBundle 'vim-scripts/Tail-Bundle'                                           " Tail for windows in vim
  NeoBundle 'wincent/Command-T'
  " {{{2
  NeoBundle 'sgur/unite-everything', {
    \ 'depends' : [ 'Shougo/unite.vim' ],
    \ }                                                                         " Unite source for everything
  " }}}
else
  set shell=/bin/sh
endif
" }}}
" Local setup (before) {{{1
if filereadable(expand('~/.vimrc.local.before'))
  execute 'source' expand('~/.vimrc.local.before')
endif
" }}}
" Bundles that might be disabled by local configurations {{{1
  " {{{2
  NeoBundle 'google/vim-maktaba', {
    \ 'disabled' : has_key(g:disabled_bundles, 'vim-maktaba'),
    \ 'force' : 1,
    \ }                                                                         " Vimscript plugin library from google
  " }}}
  " {{{2
  NeoBundle 'google/vim-glaive', {
    \ 'depends' : ['google/vim-maktaba'],
    \ 'disabled' : has_key(g:disabled_bundles, 'vim-glaive'),
    \ 'force' : 1,
    \ }                                                                         " Plugin for better vim plugin configuration
  " }}}
  " {{{2
  NeoBundle 'Valloric/YouCompleteMe', {
    \ 'on_ft' : ['c', 'cpp', 'go', 'python'],
    \ 'disabled' : has_key(g:disabled_bundles, 'YouCompleteMe'),
    \ 'lazy' : 1,
    \ }                                                                         " Python based multi-language completion engine
  let s:ycm = neobundle#get('YouCompleteMe')
  function s:ycm.hooks.on_source(bundle)
    call g:ConfigureYcm()
  endfunction
  " }}}
  " {{{2
  NeoBundle 'google/vim-codefmt', {
    \ 'on_ft' : ['cpp', 'javascript', 'sql'],
    \ 'depends' : ['google/vim-maktaba', 'google/vim-glaive'],
    \ 'disabled' : has_key(g:disabled_bundles, 'vim-codefmt'),
    \ 'lazy' : 1,
    \ }                                                                         " Code formating plugin from google
  let s:vimcodefmt = neobundle#get('vim-codefmt')
  function! s:vimcodefmt.hooks.on_source(bundle)
    Glaive vim-codefmt plugin[mappings]
    " python formatter: https://github.com/google/yapf
    " java formatter: https://github.com/google/google-java-format
  endfunction
  " }}}
  " {{{2
  NeoBundle 'paulhybryant/relatedfiles', {
    \ 'on_ft' : ['cpp'],
    \ 'disabled' : has_key(g:disabled_bundles, 'relatedfiles'),
    \ 'lazy' : 1,
    \ 'type__protocol' : 'ssh',
    \ }                                                                         " Open related files in C++
  let s:relatedfiles = neobundle#get('relatedfiles')
  function s:relatedfiles.hooks.on_source(bundle)
    call g:ConfigureRelatedFiles()
  endfunction
  " }}}
  " ft-python {{{2
  NeoBundle 'klen/python-mode', {
    \ 'disabled' : has_key(g:disabled_bundles, 'python-mode'),
    \ 'on_ft' : ['python'],
    \ 'lazy' : 1,
    \ }                                                                         " Python dev env
  NeoBundle 'xolox/vim-pyref', {
    \ 'depends' : ['xolox/vim-misc'],
    \ 'on_ft' : ['python'],
    \ 'lazy' : 1,
    \ }
  " }}}
  call glaive#Install()
" }}}
" Debuging Plugins {{{1
if s:vimplugin_priority < 0
endif
" }}}
" Priority 0 Plugins {{{1
if s:vimplugin_priority >= 0
  NeoBundle 'ConradIrwin/vim-bracketed-paste'                                   " Automatically toggle paste mode
  NeoBundle 'FooSoft/vim-argwrap'                                               " Automatically wrap arguments between brackets
  let s:argwrap = neobundle#get('vim-argwrap')
  function! s:argwrap.hooks.on_source(bundle)
    autocmd FileType vim let g:argwrap_tail_comma = 1
    let g:argwrap_line_prefix = '\ '
  endfunction
  NeoBundle 'Shougo/context_filetype.vim'                                       " Context filetype
  NeoBundle 'blueyed/vim-diminactive'                                           " Dim inactive windows
  NeoBundle 'chrisbra/Recover.vim'                                              " Show diff between swap and saved file
  NeoBundle 'google/vim-searchindex'                                            " Display and index search matches
  NeoBundle 'honza/vim-snippets'                                                " Collection of vim snippets
  NeoBundle 'kana/vim-textobj-user'                                             " Allow defining text object by user
  NeoBundle 'thinca/vim-ref'                                                    " Ref sources: https://github.com/thinca/vim-ref/wiki/sources
  NeoBundle 'tpope/vim-endwise'                                                 " Automatically put end constructs
  NeoBundle 'vitalk/vim-shebang'                                                " Detect shell file types by shell bang
  " NeoBundle 'spf13/vim-autoclose'                                               " Automatically close brackets
  NeoBundle 'xolox/vim-misc'
  NeoBundle 'xolox/vim-reload', { 'depends' : 'xolox/vim-misc' }
  NeoBundle 'Townk/vim-autoclose'                                               " Automatically close brackets
  NeoBundle 'tpope/vim-surround'                                                " Mappings for surrounding text objects
  NeoBundle 'tpope/vim-repeat'                                                  " Repeat any command with '.'
  " {{{2
  NeoBundle 'DeaR/vim-scratch', {
    \ 'on_cmd' : ['ScratchOpen'],
    \ 'lazy' : 1,
    \ }                                                                         " Creates a scratch buffer, can evaluate the expression there
  let s:vimscratch = neobundle#get('vim-scratch')
  function! s:vimscratch.hooks.on_source(bundle)
    vnoremap <unique> <CR> <Plug>(scrath-evaluate)
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Shougo/neocomplete.vim', {
    \ 'depends' : 'Shougo/context_filetype.vim',
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
      \   'scheme' : expand('~/.gosh_completions'),
      \ }                                                                       " Define dictionary.
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}                                   " Define keyword.
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    " inoremap <expr><C-g>     neocomplete#undo_completion()
    " inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      " return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()

    " For cursor moving in insert mode(Not recommended)
    " inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    " inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    " inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    " inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    " let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    " let g:neocomplete#enable_insert_char_pre = 1
    " AutoComplPop like behavior.
    " let g:neocomplete#enable_auto_select = 1
    " Shell like behavior(not recommended).
    " set completeopt+=longest
    " let g:neocomplete#enable_auto_select = 1
    " let g:neocomplete#disable_auto_complete = 1
    " inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

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
    autocmd FileType c,cpp,python NeoCompleteLock
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Shougo/unite.vim', {
    \ 'recipe' : 'unite',
    \ }                                                                         " Unite plugins: https://github.com/Shougo/unite.vim/wiki/unite-plugins
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
  endfunction
  " }}}
  " {{{2
  NeoBundle 'Shougo/vimproc.vim', {
    \   'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \   }
    \ }                                                                         " Enable background process and multi-threading
  " }}}
  " {{{2
  NeoBundle 'SirVer/ultisnips', {
    \ 'disabled' : !has('python'),
    \ }                                                                         " Define and insert snippets
  let s:ultisnips = neobundle#get('ultisnips')
  function! s:ultisnips.hooks.on_source(bundle)
    " Remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = "<tab>"
    " If there are multiple ft.snippet files, UltiSnips will only load the first
    " one found.
    " let g:UltiSnipsSnippetDirectories = ["UltiSnips", "ultisnippets"]
  endfunction
  " }}}
  " {{{2
  NeoBundle 'airblade/vim-gitgutter'                                            " Show the sign at changes from last git commit
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
  NeoBundle 'bling/vim-airline'                                                 " Lean & mean status/tabline for vim that's light as air
  let s:airline = neobundle#get('vim-airline')
  function! s:airline.hooks.on_source(bundle)
    let g:airline#extensions#nrrwrgn#enabled = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_tab_type = 1
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline_theme = 'powerlineish'
    " let g:airline#extensions#tabline#formatter = 'customtab'
    " let g:airline#extensions#taboo#enabled = 1
    let g:airline#extensions#tmuxline#enabled = 1                               " Disable this for plugin tmuxline.vim
    let g:airline#extensions#tmuxline#color_template = 'normal'
    let g:airline#extensions#tmuxline#snapshot_file =
      \ '~/.tmux-statusline-colors.conf'
    let g:airline#extensions#hunks#enabled = 1
    let g:airline#extensions#whitespace#enabled = 1
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
  NeoBundle 'eiiches/vim-ref-info', {
    \ 'depends' : 'thinca/vim-ref',
    \ }                                                                         " Info help page source for vim-ref
  " }}}
  " {{{2
  NeoBundle 'paulhybryant/tmuxline.vim', {
    \ 'gui' : 0,
    \ 'lazy' : 1,
    \ }                                                                         " Consistent tmux theme with vim statusline. e.g. :Tmuxline airline_tabline
  " }}}
  " {{{2
  NeoBundle 'google/vim-syncopate'                                              " Makes it easy to copy syntax highlighted code and paste in emails
  let s:vimsyncopate = neobundle#get('vim-syncopate')
  function! s:vimsyncopate.hooks.on_source(bundle)
    Glaive syncopate plugin[mappings] colorscheme=putty
    let g:html_number_lines = 0
  endfunction
  " }}}
  " {{{2
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/dotfiles/master/blob/vba/Align.vba.gz', {
    \ 'name' : 'Align',
    \ 'frozen' : 1,
    \ 'regular_namne' : 'Align',
    \ 'type' : 'vba',
    \ }                                                                         " Alinghing texts based on specific charater etc
  " }}}
  " {{{2
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/dotfiles/master/blob/vba/mark-2.8.5.vba.gz', {
    \ 'name' : 'Mark',
    \ 'regular_namne' : 'Mark',
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
  NeoBundle 'jeetsukumaran/vim-buffergator', {
    \   'on_cmd' : [ 'BuffergatorOpen', 'BuffergatorToggle' ]
    \ }                                                                         " Buffer selector in vim
  let s:buffergator = neobundle#get('vim-buffergator')
  function! s:buffergator.hooks.on_source(bundle)
    let g:buffergator_viewport_split_policy = 'L'
    let g:buffergator_autodismiss_on_select = 0
    let g:buffergator_autoupdate = 1
    let g:buffergator_suppress_keymaps = 1
    noremap <unique> <leader>bf :BuffergatorOpen<CR>
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
  NeoBundle 'paulhybryant/file-line', {
    \ 'type__protocol' : 'ssh',
    \ }                                                                         " Open files and go to specific line and column (original user not active)
  " }}}
  " {{{2
  NeoBundle 'paulhybryant/myutils', {
    \ 'depends' : filter(
    \   ['vim-glaive', 'vim-maktaba'],
    \   '!has_key(g:disabled_bundles, v:val)'),
    \ 'type__protocol' : 'ssh',
    \ }                                                                         " My vim customization (utility functions, syntax etc)
  let s:myutils = neobundle#get('myutils')
  function! s:myutils.hooks.on_source(bundle)
    " Close vim when the only buffer left is a special type of buffer
    Glaive myutils plugin[mappings]
      \ bufclose_skip_types=`[
      \  'gistls', 'nerdtree', 'indicator',
      \  'folddigest', 'capture' ]`
    execute 'set spellfile=' . a:bundle.path . '/spell/en.utf-8.add'
    call myutils#InitUndoSwapViews()
  endfunction
  function! s:myutils.hooks.on_post_source(bundle)
    call myutils#SetupTablineMappings(g:OS)
    let l:codefmt_registry = maktaba#extension#GetRegistry('codefmt')
    call l:codefmt_registry.AddExtension(
      \ myutils#fsqlf#GetSQLFormatter())
  endfunction
  " }}}
  " {{{2
  NeoBundle 'rking/ag.vim', {
    \ 'disabled' : !executable('ag'),
    \ }                                                                         " Text based search tool using the silver searcher
  " }}}
  " {{{2
  NeoBundle 'scrooloose/nerdcommenter'                                          " Plugin for adding comments
  let s:nerdcommenter = neobundle#get('nerdcommenter')
  function! s:nerdcommenter.hooks.on_source(bundle)
    let g:NERDCreateDefaultMappings = 1
    let g:NERDCustomDelimiters = {
      \ 'cvim' : { 'left' : '"', 'leftAlt' : ' ', 'rightAlt' : ' ' }
      \ }
    let g:NERDSpaceDelims = 1
    let g:NERDUsePlaceHolders = 0
  endfunction
  " }}}
  " {{{2
  NeoBundle 'scrooloose/nerdtree'                                               " File explorer inside vim
  let s:nerdtree = neobundle#get('nerdtree')
  function! s:nerdtree.hooks.on_source(bundle)
    let g:NERDShutUp = 1
    let g:NERDTreeChDirMode = 1
    let g:NERDTreeIgnore = [
      \ '\.pyc', '\~$', '\.swo$', '\.swp$',
      \ '\.git', '\.hg', '\.svn', '\.bzr']
    let g:NERDTreeMouseMode = 2
    let g:NERDTreeQuitOnOpen = 0                                                " Keep NERDTree open after click
    let g:NERDTreeShowBookmarks = 1
    let g:NERDTreeShowHidden = 1
    let g:nerdtree_tabs_open_on_gui_startup = 0
    nnoremap <unique> <C-e> :NERDTreeToggle %<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'scrooloose/syntastic'                                              " Check syntax with external syntax checker
  let s:syntastic = neobundle#get('syntastic')
  function! s:syntastic.hooks.on_source(bundle)
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_mode_map = {
      \ 'mode': 'passive',
      \ 'active_filetypes': [ 'zsh', 'sh' ],
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
  NeoBundle 'terryma/vim-multiple-cursors'                                      " Insert words at multiple places simultaneously
  let s:vimmulticursors = neobundle#get('vim-multiple-cursors')
  function! s:vimmulticursors.hooks.on_source(bundle)
    nnoremap <unique> <leader>mcf
      \ :execute 'MultipleCursorsFind \<' . expand('<cword>') . '\>'<CR>
  endfunction
  " }}}
  " {{{2
  NeoBundle 'thinca/vim-textobj-between', {
    \ 'depends' : 'kana/vim-textobj-user',
    \ }                                                                         " Text object between a char
  " }}}
  " {{{2
  NeoBundle 'tyru/capture.vim', {
    \   'on_cmd' : ['Capture'],
    \ }                                                                         " Capture Ex command output to buffer
  " }}}
  " {{{2
  NeoBundle 'wellle/tmux-complete.vim', {
    \ 'disabled' : g:OS.is_mac,
    \ }                                                                         " Insert mode completion of words in adjacent panes
  " }}}
  " {{{2
  NeoBundle 'xolox/vim-notes', {
    \   'on_cmd' : [{'name' : [ 'Note' ],
    \                'complete' : 'customlist,xolox#notes#cmd_complete'}],
    \ 'depends' : ['xolox/vim-misc'],
    \ 'lazy' : 1,
    \ }                                                                         " Note taking with vim
  let s:vimnotes = neobundle#get('vim-notes')
  function! s:vimnotes.hooks.on_source(bundle)
    let g:notes_directories = ['~/.vim/.vimnotes']
    let g:notes_suffix = '.txt'
    let g:notes_indexfile = '~/.vim/.vimnotes/notes.idx'
    let g:notes_tagsindex = '~/.vim/.vimnotes/notes.tags'
  endfunction
  " }}}
  " ft-cpp {{{2
  NeoBundle 'octol/vim-cpp-enhanced-highlight', {
    \ 'on_ft' : ['cpp'],
    \ 'lazy' : 1,
    \ }                                                                         " Enhanced vim cpp highlight
  " }}}
  " ft-markdown {{{2
  NeoBundle 'plasticboy/vim-markdown', {
    \ 'on_ft' : ['markdown'],
    \ 'lazy' : 1,
    \ 'directory' : 'plasticboy-markdown',
    \ 'name' : 'plasticboy-markdown',
    \ 'regular_name' : 'plasticboy-markdown',
    \ }                                                                         " Yet another markdown syntax highlighting
  " NeoBundle 'tpope/vim-markdown', {
        " \ 'on_ft' : ['markdown'],
        " \ 'lazy' : 1,
        " \ 'directory' : 'tpope-markdown',
        " \ 'name' : 'tpope-markdown',
        " \ 'regular_name' : 'tpope-markdown',
        " \ }                                                                     " Yet another markdown syntax highlighting
  " NeoBundle 'hallison/vim-markdown', {
        " \ 'on_ft' : ['markdown'],
        " \ 'lazy' : 1,
        " \ 'directory' : 'hallison-markdown',
        " \ 'name' : 'hallison-markdown',
        " \ 'regular_name' : 'hallison-markdown',
        " \ }                                                                     " Yet another markdown syntax highlighting
  NeoBundle 'thinca/vim-ft-markdown_fold', {
    \ 'on_ft' : ['markdown'],
    \ 'lazy' : 1,
    \ }                                                                         " Fold markdown
  NeoBundle 'JamshedVesuna/vim-markdown-preview'                                " Makrdown preview with minimum dependencies
  " }}}
  " ft-ruby {{{2
  NeoBundle 'vim-ruby/vim-ruby', {
    \ 'on_ft' : ['ruby'],
    \ 'lazy' : 1,
    \ }                                                                         " Vim plugin for editing ruby files.
  " }}}
  " ft-sql {{{2
  NeoBundle 'jphustman/SQLUtilities', {
    \ 'on_ft' : ['sql'],
    \ 'depends' : ['Align'],
    \ 'lazy' : 1,
    \ }                                                                         " Utilities for editing SQL scripts (v7.0)
  let s:sqlutilities = neobundle#get('SQLUtilities')
  function! s:sqlutilities.hooks.on_source(bundle)
    let g:sqlutil_align_comma = 0
    if (neobundle#is_sourced('vim-codefmt') ||
      \ maktaba#plugin#IsRegistered('codefmt'))
      \ && neobundle#is_installed('myutils')
      let l:codefmt_registry = maktaba#extension#GetRegistry('codefmt')
      call l:codefmt_registry.AddExtension(
        \ myutils#sqlformatter#GetSQLFormatter())
    endif
  endfunction
  NeoBundle 'vim-scripts/SQLComplete.vim', {
    \ 'on_ft' : ['sql'],
    \ 'lazy' : 1,
    \ }                                                                         " SQL script completion
  NeoBundle 'vim-scripts/sql.vim--Stinson', {
    \ 'on_ft' : ['sql'],
    \ 'lazy' : 1,
    \ }                                                                         " Better SQL syntax highlighting
  " }}}
  " ft-tmux {{{2
  NeoBundle 'tmux-plugins/vim-tmux', {
    \ 'on_ft' : ['tmux'],
    \ 'lazy' : 1,
    \ }                                                                         " Vim plugin for editing .tmux.conf
  " }}}
  " ft-vim {{{2
  NeoBundle 'vim-scripts/ReloadScript', {
    \ 'on_cmd' : ['ReloadScript'],
    \ 'on_ft' : ['vim'],
    \ 'lazy' : 1,
    \ }                                                                         " Reload vim script without having to restart vim
  let s:reload_script = neobundle#get('ReloadScript')
  function! s:reload_script.hooks.on_source(bundle)
    nnoremap <unique> <leader>rl :ReloadScript %:p<CR>
  endfunction
  NeoBundle 'https://raw.githubusercontent.com/paulhybryant/dotfiles/master/blob/vba/Decho.vba.gz', {
    \ 'on_cmd' : ['Decho'],
    \ 'on_ft' : ['vim'],
    \ 'lazy' : 1,
    \ 'name' : 'Decho',
    \ 'regular_namne' : 'Decho',
    \ 'frozen' : 1,
    \ 'type' : 'vba',
    \ }                                                                         " Debug echo for debuging vim plugins
  let s:decho = neobundle#get('Decho')
  function! s:decho.hooks.on_source(bundle)
    let g:decho_enable = 0
    let g:dechofuncname = 1
    let g:decho_winheight = 10
  endfunction
  NeoBundle 'google/vim-ft-vroom', {
    \ 'on_ft' : ['vroom'],
    \ 'lazy' : 1,
    \ }                                                                         " Filetype plugin for vroom
  " }}}
  " ft-vtd {{{2
  NeoBundle 'chiphogg/vim-vtd', {
    \ 'on_ft' : ['vtd'],
    \ 'lazy' : 1,
    \ }
  let s:vimvtd = neobundle#get('vim-vtd')
  function! s:vimvtd.hooks.on_source(bundle)
    Glaive vtd plugin[mappings]=',v' files+=`[expand('%:p')]`
    if &background == 'light'
      hi! Ignore guifg=#FDF6E3
    else
      hi! Ignore guifg=#002B36
    endif
  endfunction
  " }}}
endif
" }}}
" Wrap up bundle setup {{{1
call neobundle#end()
NeoBundleCheck
filetype plugin indent on                                                       " Automatically detect file types.
" }}}
" Local setup (after) {{{1
if filereadable(expand('~/.vimrc.local.after'))
  execute 'source' expand('~/.vimrc.local.after')
endif
" }}}
" Settings {{{1
syntax on                                                                       " Syntax highlighting
set autoindent                                                                  " Indent at the same level of the previous line
set autoread                                                                    " Automatically load changed files
set autowrite                                                                   " Automatically write a file when leaving a modified buffer
set background=dark                                                             " Assume a dark background
set backspace=indent,eol,start                                                  " Backspace for dummies
set backup                                                                      " Whether saves a backup before editing
set cmdheight=2                                                                 " Height of the cmd line
set cursorline                                                                  " Highlight current line
set cursorcolumn                                                                " Highlight current line
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
set number                                                                      " Line numbers on
set pastetoggle=<F12>                                                           " pastetoggle (sane indentation on paste)
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
" set splitbelow                                                                " Create the split at the bottom when split horizontally
set splitright                                                                  " Create the split on the right when split vertically
set t_Co=256                                                                    " Set number of colors supported by term
set tabstop=2                                                                   " An indentation every two columns
" set term=$TERM                                                                " Make arrow and other keys work
set undofile                                                                    " Persists undo
set undolevels=1000                                                             " Maximum number of changes that can be undone
set undoreload=10000                                                            " Save the whole buffer for undo when reloading it
set viewoptions=folds,options,cursor,unix,slash                                 " Better Unix / Windows compatibility
set whichwrap=b,s,h,l,<,>,[,]                                                   " Backspace and cursor keys wrap too
set wildmenu                                                                    " Show list instead of just completing
set wildmode=list:longest,full                                                  " Command <Tab> completion, list matches, then longest common part, then all
set winminheight=0                                                              " Windows can be 0 line high
set wrap                                                                        " Wrap long lines
set nowrapscan                                                                  " Make regex search wrap to the start of the file
set comments=sl:/*,mb:*,elx:*/                                                  " auto format comment blocks

if &diff
  set nospell                                                                   " No spellcheck
else
  set spell                                                                     " Spellcheck
endif

if has ('x11') && (g:OS.is_linux || g:OS.is_mac)                                " On Linux and Mac use + register
  set clipboard=unnamedplus
else                                                                            " On Windows use * register
  set clipboard=unnamed
endif
" }}}
