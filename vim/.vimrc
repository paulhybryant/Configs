" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Environment {{{

  set nocompatible                                                              " Must be first line
  set encoding=utf-8                                                            " Set text encoding default to utf-8
  scriptencoding utf-8                                                          " Character encoding used in this script

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
    function! InitUndoSwapViews()
      let l:prefix = expand("$HOME/.vim")
      let l:dir_list = {
            \ 'backup': 'backupdir',
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

  " Whether the specific plugins are disabled {{{
    function! PluginDisabled(plugin)
      return has_key(g:disabled_plugins, a:plugin)
    endfunction
  " }}}

  " Windows Compatible {{{
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if WINDOWS()
      source $VIMRUNTIME/mswin.vim
      behave mswin

      let $TERM='win32'
      let $PATH="C:/Users/Yu/AppData/Local/GitHub/PortableGit_ed44d00daa128db527396557813e7b68709ed0e2/bin;" . $PATH
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

  function! Dos2unixFunction()
      let _s=@/
      let l = line(".")
      let c = col(".")
      try
          set ff=unix
          w!
          "%s/\%x0d$//e
      catch /E32:/
          echo "Sorry, the file is not saved."
      endtry
      let @/=_s
      call cursor(l, c)
  endfun
  command! Dos2Unix keepjumps call Dos2unixFunction()
  " au BufReadPost * keepjumps call Dos2unixFunction()

" }}}

" Plugins {{{

  let g:mapleader = ','
  let g:maplocalleader = ',,'
  let g:disabled_plugins = {
        \ 'Vim-Support' : 'Conflicting key mapping <C-j> with tmux navigation',
        \ 'bash-support.vim' : 'Conflicting key mapping <C-j> with tmux navigation'
        \ }

  let g:google_config = resolve(expand("~/.vimrc.google"))
  if filereadable(g:google_config)
    exec "source " . g:google_config
    let b:reason = 'Included by customized vim distribution'
    let g:disabled_plugins['vim-maktaba'] = b:reason
    let g:disabled_plugins['vim-glaive'] = b:reason
    let g:disabled_plugins['vim-codefmt'] = b:reason
    let g:disabled_plugins['vim-better-whitespace'] = b:reason
    let g:disabled_plugins['vim-trailing-whitespace'] = b:reason
  endif

  " Plugin infrastructure {{{
  if !isdirectory(expand("$HOME/.vim/bundle/neobundle.vim"))
    echo "Installing neobundle..."
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim
  endif

  filetype off
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
  call neobundle#begin('$HOME/.vim/bundle')

  NeoBundleFetch 'Shougo/neobundle.vim'                                         " Plugin manager
  NeoBundle 'Shougo/neobundle-vim-recipes', { 'force' : 1 }                     " Recipes for plugins that can be installed and configured with NeoBundleRecipe
  " NeoBundle 'junegunn/vim-plug'                                                 " Yet another vim plugin manager
  " NeoBundle 'gmarik/Vundle.vim'                                                 " Yet another vim plugin manager
  " NeoBundle 'tpope/vim-pathogen'                                                " Yet another vim plugin manager

  NeoBundle 'google/vim-maktaba', {
        \ 'disabled' : PluginDisabled('vim-maktaba'),
        \ 'force' : 1,
        \ }
  NeoBundle 'google/vim-glaive', {
        \ 'disabled' : PluginDisabled('vim-glaive'),
        \ 'depends' : 'google/vim-maktaba',
        \ 'force' : 1
        \ }
  call glaive#Install()
  " }}}

  " Nativation {{{
  NeoBundle 'Lokaltog/vim-easymotion'                                           " Display hint for jumping to
  NeoBundle 'bkad/CamelCaseMotion'                                              " Defines CamelCase text object
  NeoBundle 'christoomey/vim-tmux-navigator'                                    " Allow using the same keymap to move between tmux panes and vim splits seamlessly
  " NeoBundle 'justinmk/vim-sneak'                                                " Easy motion within one line
  " }}}

  " Plugins that change vim UI {{{
  NeoBundle 'blueyed/vim-diminactive'                                           " Dim inactive windows
  NeoBundle 'mhinz/vim-signify'                                                 " Show the sign at changes from last git commit
  NeoBundle 'altercation/vim-colors-solarized'                                  " Vim colorscheme solarized
  NeoBundle 'bling/vim-airline'
  let s:airline = neobundle#get('vim-airline')
  function! s:airline.hooks.on_source(bundle)
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_tab_type = 1
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    " let g:airline#extensions#tabline#formatter = 'customtab'
    " let g:airline#extensions#taboo#enabled = 1
    " Disable this for plugin Tmuxline
    " let g:airline#extensions#tmuxline#enabled = 1
    " let g:airline#extensions#tmuxline#color_template = 'normal'
  endfunction

  " NeoBundle 'MattesGroeger/vim-bookmarks'
  " NeoBundle 'sjl/gundo.vim'                                                     " Visualize undo tree
  " NeoBundle 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
  " NeoBundle 'paulhybryant/tmuxline.vim'                                       " Change tmux theme to be consistent with vim statusline
  " NeoBundle 'edkolev/promptline.vim'
  " let g:tmuxline_theme = 'airline'
  " let g:tmuxline_preset = 'tmux'
  " NeoBundle 'airblade/vim-gitgutter', {
        " \ 'disabled' : PluginDisabled('vim-gitgutter')
        " \ }                                                                     " Prefer vim-signify
  " NeoBundle 'myusuf3/numbers.vim', {
        " \ 'disabled' : PluginDisabled('numbers.vim')
        " \ }                                                                     " Automatically toggle line number for certain filetypes
  " let s:numbers = neobundle#get('numbers.vim')
  " function! s:numbers.hooks.on_source(bundle)
    " let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m']
  " endfunction
  NeoBundle 'flazz/vim-colorschemes'                                            " Collection of vim colorschemes
  " NeoBundle 'Kshitij-Banerjee/vim-github-colorscheme'                           " Vim colorscheme github
  " NeoBundle 'itchyny/landscape.vim'                                             " Vim colorscheme landscape
  " NeoBundle 'tomasr/molokai'                                                    " Vim colorscheme molokai
  " NeoBundle 'tpope/vim-vividchalk'                                              " Vim colorscheme vividchalk
  " NeoBundle 'vim-scripts/candy.vim'                                             " Vim colorscheme candy
  " NeoBundle 'bronzehedwick/impactjs-colorscheme', {
        " \ 'script_type' : 'colorscheme'
        " \ }
  " NeoBundle 'Lokaltog/vim-distinguished'                                        " Vim colorscheme distinguished
  " let g:rehash256 = 1
  " NeoBundle 'mattn/vim-airline-weather'                                       " Vim airline extension to show weather
  " let g:weather#area='Sunnyvale'
  " }}}

  " Coding assistance {{{
  if !WINDOWS()
    NeoBundle 'Valloric/YouCompleteMe'
    let s:ycm = neobundle#get('YouCompleteMe')
    function! s:ycm.hooks.on_source(bundle)
      nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
      let g:Show_diagnostics_ui = 1                                             " default 1
      let g:ycm_always_populate_location_list = 1                               " default 0
      let g:ycm_collect_identifiers_from_tags_files = 0                         " default 0
      let g:ycm_collect_identifiers_from_tags_files = 1                         " enable completion from tags
      let g:ycm_complete_in_strings = 1                                         " default 1
      let g:ycm_confirm_extra_conf = 1
      let g:ycm_enable_diagnostic_highlighting = 0
      let g:ycm_enable_diagnostic_signs = 1
      let g:ycm_filetype_whitelist = { 'c': 1, 'cpp': 1, 'python': 1 }
      let g:ycm_goto_buffer_command = 'same-buffer'                             " [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
      let g:ycm_key_invoke_completion = '<C-Space>'
      let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
      let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
      let g:ycm_open_loclist_on_ycm_diags = 1                                   " default 1
      let g:ycm_path_to_python_interpreter = ''                                 " default ''
      let g:ycm_register_as_syntastic_checker = 1                               " default 1
      let g:ycm_server_keep_logfiles = 10                                       " keep log files
      let g:ycm_server_log_level = 'info'                                       " default info
      let g:ycm_server_use_vim_stdout = 0                                       " default 0 (logging to console)
    endfunction
  endif

  NeoBundle 'kana/vim-operator-user'                                            " User defined operator
  " NeoBundle 'kana/vim-operator-replace', {
        " \ 'depends' : 'kana/vim-operator-user'
        " \ }                                                                     " Vim operator for replace
  NeoBundle 'tyru/operator-camelize.vim', {
        \ 'depends' : 'kana/vim-operator-user'
        \ }                                                                     " Convert variable to / from camelcase form
  let s:camelize = neobundle#get('operator-camelize.vim')
  function! s:camelize.hooks.on_source(bundle)
    map <leader>lc <Plug>(operator-camelize)
    map <leader>lC <Plug>(operator-decamelize)
  endfunction

  NeoBundle 'tpope/vim-endwise'                                                 " Automatically put end construct (e.g. endfunction)
  " TODO: Make delimiMate add newline after closing {}, and only close <> in
  " html / XML
  NeoBundle 'Raimondi/delimitMate'                                              " Automatic close quotes etc, with some syntax awareness
  let s:delimitmate = neobundle#get('delimitMate')
  function s:delimitmate.hooks.on_source(bundle)
    let g:delimitMate_expand_cr = 1
  endfunction
  " NeoBundle 'spf13/vim-autoclose'                                               " Automatically close brackets
  " NeoBundle 'Shougo/neocomplcache.vim'
  " NeoBundleLazy 'Rip-Rip/clang_complete', {
        " \ 'autoload' : { 'filetypes' : ['cpp', 'c'] }
        " \ }                                                                     " Completion for c-family language
  NeoBundle 'Shougo/neocomplete.vim', {
      \ 'depends' : 'Shougo/context_filetype.vim',
      \ 'disabled' : !has('lua'),
      \ 'vim_version' : '7.3.885'
      \ }
  let s:neocomplete = neobundle#get('neocomplete.vim')
  function! s:neocomplete.hooks.on_source(bundle)
    let g:acp_enableAtStartup = 0                                               " Disable AutoComplPop.
    let g:neocomplete#enable_at_startup = 1                                     " Use neocomplete.
    let g:neocomplete#enable_smart_case = 1                                     " Use smartcase.
    let g:neocomplete#sources#syntax#min_keyword_length = 3                     " Set minimum syntax keyword length.
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#sources#dictionary#dictionaries = {
      \   'default' : '',
      \   'vimshell' : $HOME.'/.vimshell_hist',
      \   'scheme' : $HOME.'/.gosh_completions'
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
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()

    " For cursor moving in insert mode(Not recommended)
    " inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    " inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    " inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    " inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1
    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1
    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

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
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    " let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " Do not use NeoComplete for these file types
    autocmd FileType c,cpp,python NeoCompleteLock
  endfunction

  " NeoBundle 'xolox/vim-easytags', {
        " \ 'depends' : 'xolox/vim-misc',
        " \ 'disabled' : executable('ctags') || PluginDisabled('vim-easytags')
        " \ }                                                                     " Vim integration with ctags
  " NeoBundle 'majutsushi/tagbar', {
        " \ 'disabled' : executable('ctags') || PluginDisabled('vim-tagbar')
        " \ }
  " let s:tagbar = neobundle#get('tagbar')
  " function! s:tagbar.hooks.on_source(bundle)
    " let g:tagbar_type_autohotkey = {
          " \ 'ctagstype' : 'autohotkey',
          " \   'kinds' : [
          " \     's:sections',
          " \     'g:graphics:0:0',
          " \     'l:labels',
          " \     'r:refs:1:0',
          " \     'p:pagerefs:1:0'
          " \   ],
          " \   'sort'  : 0,
          " \   'deffile' : '$HOME/.ctagscnf/autohotkey.cnf'
          " \ }
  " endfunction
  " NeoBundle 'sjl/splice.vim'                                                    " Vim three way merge tool
  " NeoBundle 'tpope/vim-fugitive', { 'disabled' : !executable('git') }           " Commands for working with git
  " let s:fugitive = neobundle#get('vim-fugitive')
  " function! s:fugitive.hooks.on_source(bundle)
    " nnoremap <silent> <leader>gs :Gstatus<CR>
    " nnoremap <silent> <leader>gd :Gdiff<CR>
    " nnoremap <silent> <leader>gm :Gcommit<CR>
    " nnoremap <silent> <leader>gb :Gblame<CR>
    " nnoremap <silent> <leader>gl :Glog<CR>
    " nnoremap <silent> <leader>gp :Git push<CR>
    " nnoremap <silent> <leader>gr :Gread<CR>
    " nnoremap <silent> <leader>gw :Gwrite<CR>
    " nnoremap <silent> <leader>ge :Gedit<CR>
    " nnoremap <silent> <leader>gi :Git add -p %<CR>
  " endfunction

  " Prefer agit as gitv has some bugs
  NeoBundle 'cohama/agit.vim'                                                   " Git log viewer (Yet another gitk clone for Vim)
  " NeoBundle 'gregsexton/gitv', { 'depends' : 'tpope/vim-fugitive' }             " Git log viewer (Yet another gitk clone for Vim)
  " }}}

  " Auto-formatting {{{
  NeoBundle 'google/vim-codefmt', {
        \ 'disabled' : PluginDisabled('vim-codefmt'),
        \ 'depends' : ['google/vim-codefmtlib', 'google/vim-glaive']
        \ } " Code formating plugin from google
  let s:vimcodefmt = neobundle#get('vim-codefmt')
  function! s:vimcodefmt.hooks.on_source(bundle)
    Glaive codefmt plugin[mappings]
  endfunction
  " NeoBundle 'Chiel92/vim-autoformat'                                            " Easy code formatting with external formatter
  NeoBundle 'ntpeters/vim-better-whitespace',                                   " Highlight all types of whitespaces
  let s:betterws = neobundle#get('vim-better-whitespace')
  function! s:betterws.hooks.on_source(bundle)
    let g:strip_whitespace_on_save = 1
    nnoremap <leader>sw :ToggleStripWhitespaceOnSave<CR>
  endfunction
  " NeoBundle 'bronson/vim-trailing-whitespace'                                   " Highlight trailing whitespaces
  NeoBundle 'scrooloose/nerdcommenter'                                          " Add comments
  let s:nerdcommenter = neobundle#get('nerdcommenter')
  function! s:nerdcommenter.hooks.on_source(bundle)
    let g:NERDSpaceDelims = 1
    let g:NERDCustomDelimiters = {}
    let g:NERDCreateDefaultMappings = 0
    nmap <leader>ci <Plug>NERDCommenterInvert
    xmap <leader>ci <Plug>NERDCommenterInvert
  endfunction
  " }}}

  " Mappings {{{
  NeoBundle 'tpope/vim-repeat'                                                  " Repeat any command with '.'
  NeoBundle 'tpope/vim-surround'                                                " Useful mappings for surrounding text objects with a pair of chars
  " NeoBundle 'tpope/vim-unimpaired'                                              " Complementary pairs of mappings
  " }}}

  " TextObjects {{{
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
    nnoremap <leader>L <Plug>(expand_region_expand)
    nnoremap <leader>H <Plug>(expand_region_shrink)
  endfunction

  " TODO: For vim-textobj-quotes, va' seems to select the space before the quote, need to be fixed.
  " Also, try to map vi' to viq etc

  NeoBundle 'kana/vim-textobj-user'                                                                 " Allow defining text object by user
  " NeoBundle 'Julian/vim-textobj-brace', { 'depends' : 'kana/vim-textobj-user' }                     " Text object between braces
  " NeoBundle 'Julian/vim-textobj-variable-segment', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'Raimondi/VimLTextObjects', { 'depends' : 'kana/vim-textobj-user' }                     " Text object for vimscript
  " NeoBundle 'Raimondi/vim_search_objects', { 'depends' : 'kana/vim-textobj-user' }                  " Text object for a search pattern
  " NeoBundle 'beloglazov/vim-textobj-punctuation', { 'depends' : 'kana/vim-textobj-user' }
  NeoBundle 'beloglazov/vim-textobj-quotes', { 'depends' : 'kana/vim-textobj-user' }                " Text object between any type of quotes
  " NeoBundle 'gilligan/textobj-gitgutter', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'glts/vim-textobj-comment', { 'depends' : 'kana/vim-textobj-user' }                     " Text object for comments
  " NeoBundle 'glts/vim-textobj-indblock', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'jceb/vim-textobj-uri', { 'depends' : 'kana/vim-textobj-user' }                         " Text object for uri
  " NeoBundle 'kana/vim-textobj-datetime', { 'depends' : 'kana/vim-textobj-user' }                    " Text object for datetime format
  " NeoBundle 'kana/vim-textobj-diff', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'kana/vim-textobj-entire', { 'depends' : 'kana/vim-textobj-user' }                       " Text object for the entire buffer
  " NeoBundle 'kana/vim-textobj-fold', { 'depends' : 'kana/vim-textobj-user' }                        " Text object for fold
  " NeoBundle 'kana/vim-textobj-function', { 'depends' : 'kana/vim-textobj-user' }                    " Text object for function
  " NeoBundle 'kana/vim-textobj-indent', { 'depends' : 'kana/vim-textobj-user' }                      " Text object for indent
  " NeoBundle 'kana/vim-textobj-jabraces', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'kana/vim-textobj-lastpat', { 'depends' : 'kana/vim-textobj-user' }                     " Text object for last searched pattern
  " NeoBundle 'kana/vim-textobj-line', { 'depends' : 'kana/vim-textobj-user' }                        " Text object for a line
  " NeoBundle 'kana/vim-textobj-syntax', { 'depends' : 'kana/vim-textobj-user' }
  NeoBundle 'killphi/vim-textobj-signify-hunk', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'lucapette/vim-textobj-underscore', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'mattn/vim-textobj-url', { 'depends' : 'kana/vim-textobj-user' }
  NeoBundle 'paulhybryant/vim-textobj-path', { 'depends' : 'kana/vim-textobj-user' }                " Text object for a file system path
  " NeoBundle 'reedes/vim-textobj-quote', { 'depends' : 'kana/vim-textobj-user' }                     " Text object between also typographic ('curly') quote characters
  " NeoBundle 'reedes/vim-textobj-sentence', { 'depends' : 'kana/vim-textobj-user' }                  " Text object for a sentence
  " NeoBundle 'rhysd/vim-textobj-clang', { 'depends' : 'kana/vim-textobj-user' }                      " Text object for c family languages
  " NeoBundle 'rhysd/vim-textobj-continuous-line', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'saaguero/vim-textobj-pastedtext', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'saihoooooooo/vim-textobj-space', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'sgur/vim-textobj-parameter', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'thinca/vim-textobj-between', { 'depends' : 'kana/vim-textobj-user' }                   " Text object between a char
  " NeoBundle 'thinca/vim-textobj-comment', { 'depends' : 'kana/vim-textobj-user' }                   " Text object  for comments
  " NeoBundle 'whatyouhide/vim-textobj-erb', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'whatyouhide/vim-textobj-xmlattr', { 'depends' : 'kana/vim-textobj-user' }
  " NeoBundle 'michaeljsmith/vim-indent-object'                                                       " Text object based on indent levels
  " NeoBundle 'gcmt/wildfire.vim'
  " }}}

  " Syntax and highlighting {{{
  NeoBundle 'scrooloose/syntastic'                                              " Check syntax with external syntax checker
  let s:syntastic = neobundle#get('syntastic')
  function! s:syntastic.hooks.on_source(bundle)
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_mode_map = {
          \ 'mode': 'passive',
          \ 'active_filetypes': [],
          \ 'passive_filetypes': ['vim']
          \ }
    nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
  endfunction

  " NeoBundle 'google/vim-syncopate'                                              " Makes it easy to copy syntax highlighted code and paste in emails
  " let s:vimsyncopate = neobundle#get('vim-syncopate')
  " function! s:vimsyncopate.hooks.on_source(bundle)
    " Glaive syncopate plugin[mappings] colorscheme=putty
    " let g:html_number_lines = 0
  " endfunction

  " NeoBundle 'kien/rainbow_parentheses.vim'                                      " Colorful parentheses
  " let s:rainbow_parentheses = neobundle#get('rainbow_parentheses.vim')
  " function! s:rainbow_parentheses.hooks.on_source(bundle)
    " let g:rbpt_max = 16
    " let g:rbpt_loadcmd_toggle = 0
    " autocmd VimEnter * RainbowParenthesesToggle
    " autocmd Syntax * RainbowParenthesesLoadRound
    " autocmd Syntax * RainbowParenthesesLoadSquare
    " autocmd Syntax * RainbowParenthesesLoadBraces
  " endfunction

  " NeoBundle 'paulhybryant/hilinks'                                              " Show highlight group the item under corsor is linked to
  " NeoBundle 'paulhybryant/mark'                                                 " Highlight multiple patterns with different color (Host latest version 2.8.5)
  " let s:mark = neobundle#get('mark')
  " function! s:mark.hooks.on_source(bundle)
    " nnoremap <leader>mc :MarkClear<CR>
    " nnoremap <leader>m/ :Mark <C-R>/<CR>
  " endfunction
  " NeoBundle 'vim-scripts/ShowMarks', {
        " \ 'disabled' : PluginDisabled('ShowMarks')
        " \ }                                                                     " Use gutter to show location of marks
  " NeoBundle 'vim-scripts/SemanticHL', { 'disabled' : !has('gui_running') }      " Semantic highlighting for C / C++
  " NeoBundle 'nathanaelkane/vim-indent-guides'
  " let s:vimindentguides = neobundle#get('vim-indent-guides')
  " function! s:vimindentguides.hooks.on_source(bundle)
    " let g:indent_guides_auto_colors = 0
    " hi IndentGuidesOdd  guibg=red   ctermbg=3
    " hi IndentGuidesEven guibg=green ctermbg=4
  " endfunction
  " NeoBundle 'vim-scripts/TagHighlight'
  " NeoBundle 'vim-scripts/utl.vim'
  " }}}

  " Explorers in vim {{{
  NeoBundle 'Shougo/unite.vim', { 'recipe' : 'unite' }
  let s:unite = neobundle#get('unite.vim')
  function! s:unite.hooks.on_source(bundle)
    let g:unite_data_directory = $HOME . '/.cache/unite'
    let g:unite_abbr_highlight = 'Keyword'
    if (!isdirectory(g:unite_data_directory))
      call mkdir(g:unite_data_directory, "p")
    endif
    nnoremap <C-p> :Unite file_rec/async<CR>
    let g:unite_enable_start_insert=1
    let g:unite_prompt='» '
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
  endfunction

  " Unite plugins: https://github.com/Shougo/unite.vim/wiki/unite-plugins
  " NeoBundle 'ujihisa/unite-colorscheme'
  " NeoBundle 'ujihisa/unite-locate'
  " NeoBundle 'h1mesuke/unite-outline'
  " NeoBundle 'thinca/vim-unite-history'
  " NeoBundle 'mattn/unite-gist'
  " NeoBundle 'Shougo/unite-build'
  " NeoBundle 'Shougo/unite-sudo'
  " NeoBundle 'Shougo/unite-ssh'
  " NeoBundle 'tsukkee/unite-help'
  " NeoBundle 'kopischke/unite-spell-suggest'
  " NeoBundle 'tyru/unite-screen.sh'

  NeoBundle 'jistr/vim-nerdtree-tabs', { 'depends' : 'scrooloose/nerdtree' }    " One NERDTree only, shared among buffers / tabs
  NeoBundle 'scrooloose/nerdtree'                                               " File explorer inside vim
  let s:nerdtree = neobundle#get('nerdtree')
  function! s:nerdtree.hooks.on_source(bundle)
    let g:NERDShutUp=1
    let g:NERDTreeChDirMode=1
    let g:NERDTreeIgnore=[
          \ '\.pyc', '\~$', '\.swo$', '\.swp$',
          \ '\.git', '\.hg', '\.svn', '\.bzr']
    let g:NERDTreeMouseMode=2
    let g:NERDTreeQuitOnOpen = 0                                                " Keep NERDTree open after click
    let g:NERDTreeShowBookmarks=1
    let g:NERDTreeShowHidden=1
    let g:nerdtree_tabs_open_on_gui_startup=0
    noremap <C-e> :NERDTreeToggle %<CR>
  endfunction

  " NeoBundle 'tpope/vim-vinegar', { 'disabled' : PluginDisabled('vim-vinegar') } " NERDTree enhancement
  " NeoBundle 'eiginn/netrw'                                                      " NERDTree plugin for network
  " let s:netrw = neobundle#get('netrw')
  " function! s:netrw.hooks.on_source(bundle)
    " let g:netrw_altfile = 1
  " endfunction

  " NeoBundle 'Shougo/vimfiler.vim', {
        " \   'depends' : 'Shougo/unite.vim',
        " \   'commands' : [
        " \     { 'name' : ['VimFiler', 'Edit', 'Write'],
        " \       'complete' : 'customlist,vimfiler#complete' },
        " \     'Read',
        " \     'Source'
        " \   ],
        " \   'mappings' : '<Plug>',
        " \   'explorer' : 1,
        " \   'recipe' : 'vimfiler',
        " \ }                                                                     " File explorer inside vim

  " NeoBundle 'osyo-manga/vim-over'                                               " Preview changes to be made
  " let s:vimover = neobundle#get('vim-over')
  " function! s:vimover.hooks.on_source(bundle)
    " map <leader>o :OverCommandLine<CR>
  " endfunction

  " NeoBundle 'wincent/Command-T'
  " }}}

  " Row-/column-wise editing {{{
  NeoBundle 'paulhybryant/Align'                                                " Alinghing texts based on specific charater etc (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/dotfill', { 'depends' : ['Align'] }                   " Align the texts by repeatedly filling blanks with specified charater.
  NeoBundle 'jlemetay/permut'
  " NeoBundle 'godlygeek/tabular'
  " if filereadable(g:google_config)
    " NeoBundle 'paulhybryant/foldcol', { 'depends' : ['Align'] }                   " Fold columns selected in visual block mode
  " else
    " NeoBundle 'paulhybryant/foldcol', { 'depends' : ['vim-maktaba', 'Align'] }    " Fold columns selected in visual block mode
  " endif
  " let s:foldcol = neobundle#get('foldcol')
  " function! s:foldcol.hooks.on_source(bundle)
    " Glaive foldcol plugin[mappings]
  " endfunction
  " NeoBundle 'junegunn/vim-easy-align'
  " NeoBundle 'paulhybryant/vissort'                                              " Allow sorting lines by using a visual block (column) (Host up-to-date version from Dr. Chip)
  " }}}

  NeoBundle 'tpope/vim-scriptease'                                              " Plugin for developing vim plugins
  NeoBundle 'bronson/vim-visual-star-search'                                    " Use * to search for selected text from visual mode
  NeoBundle 'Shougo/vimproc.vim'                                                " Background process for unite.vim
  NeoBundle 'ConradIrwin/vim-bracketed-paste'                                   " Automatically toggle paste mode when pasting in insert mode
  NeoBundle 'chrisbra/Recover.vim'                                              " Show diff between existing swap files and saved file
  NeoBundle 'paulhybryant/file-line'                                            " Open files and go to specific line and column (original user not active)
  " NeoBundle 'aperezdc/vim-template'
  NeoBundle 'honza/vim-snippets'                                                " Collection of vim snippets
  NeoBundle 'SirVer/ultisnips', { 'disabled' : !has('python') }
  let s:ultisnips = neobundle#get('ultisnips')
  function! s:ultisnips.hooks.on_source(bundle)
    " Remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger="<tab>"
  endfunction
  " NeoBundle 'Shougo/neosnippet.vim', { 'disabled' : has('python') }             " Snippet support for vim

  " NeoBundle 'tpope/vim-dispatch'                                                " Run command asyncroneously in vim
  NeoBundle 'mhinz/vim-hugefile'                                                " Make edit / view of huge files better
  let s:vimhugefile = neobundle#get('vim-hugefile')
  function! s:vimhugefile.hooks.on_source(bundle)
    " let l:plugin = maktaba#plugin#Get('vim-hugefile')
    " call l:plugin.Flag('trigger_size', 50)
    let g:hugefile_trigger_size = 50                                            " In MB
  endfunction
  " NeoBundle 'paulhybryant/vim-LargeFile', {
        " \ 'disabled' : PluginDisabled('vim-LargeFile')
        " \ }                                                                     " Allows much quicker editing of large files, at the price of turning off events, undo, syntax highlighting, etc.
  " NeoBundle 'janko-m/vim-test'                                                  " Run tests at different granularity for different languages
  " NeoBundle 'calebsmith/vim-lambdify'
  " NeoBundle 'paulhybryant/AnsiEsc.vim'
  " NeoBundle 'chrisbra/vim-diff-enhanced'                                        " Enhanced vimdiff

  " NeoBundle 'tpope/vim-speeddating'
  " NeoBundle 'chrisbra/NrrwRgn'
  " NeoBundle 'vitalk/vim-onoff'                                                  " Mapping for toggle vim option on and off
  " NeoBundle 'benmills/vimux'                                                    " Interact with tmux from vim
  " NeoBundle 'paulhybryant/conque'                                               " Split window for shell command line
  " NeoBundle 'Shougo/vimshell.vim', { 'recipe' : 'vimshell.vim' }                " Shell implemented with vimscript
  " let s:vimshell = neobundle#get('vimshell.vim')
  " function! s:vimshell.hooks.on_source(bundle)
    " let g:vimshell_popup_command = 'belowright split'
    " let g:vimshell_popup_height = 20
  " endfunction
  " NeoBundle 'thinca/vim-quickrun'                                               " Execute whole/part of currently edited file
  " NeoBundle 'danro/rename.vim'                                                  " Rename the underlying filename of the buffer
  " NeoBundle 'xolox/vim-shell', { 'depends' : 'xolox/vim-misc' }                 " Better integration between vim and shell
  NeoBundle 'xolox/vim-notes', {
        \ 'depends' : ['xolox/vim-misc']
        \ }                                                                     " Note taking with vim
  let s:vimnotes = neobundle#get('vim-notes')
  function! s:vimnotes.hooks.on_source(bundle)
    let g:notes_directories = ['~/Notes']
    let g:notes_suffix = '.txt'
    let g:notes_indexfile = '~/Notes/notes.idx'
    let g:notes_tagsindex = '~/Notes/notes.tags'
  endfunction
  " NeoBundle 'mattn/gist-vim', {'depends' : 'mattn/webapi-vim'}                  " Post, view and edit gist in vim
  " NeoBundle 'Keithbsmiley/gist.vim'                                             " Use gist from vim

  " NeoBundle 'Shougo/vinarise.vim', {
        " \ 'recipe' : 'vinarise.vim',
        " \ }                                                                     " Ultimate hex editing system with vim
  " NeoBundle 'glts/vim-radical', { 'disabled' : PluginDisabled('vim-radical') }  " Show number under cursor in hex, octal, binary
  " NeoBundle 'glts/vim-magnum', { 'disabled' : PluginDisabled('vim-magnum') }    " Big integer library for vim
  " NeoBundle 'tpope/vim-eunuch'                                                  " Vim sugar for the UNIX shell commands that need it the most
  " NeoBundle 'vim-scripts/scratch.vim'                                           " Creates a scratch buffer
  " NeoBundle 'kana/vim-submode'                                                  " Supporting defining submode in vim
  " NeoBundle 'kana/vim-arpeggio'                                                 " Define keymappings start with simultaneous key presses
  " NeoBundle 'kana/vim-nickblock'                                                " Make visual block mode more useful
  " NeoBundle 'kana/vim-fakeclip'                                                 " Fake clipboard for vim
  NeoBundle 'paulhybryant/vim-scratch'                                          " Creates a scratch buffer, fork of DeaR/vim-scratch, which is a fork of kana/vim-scratch
  NeoBundle 'tyru/capture.vim'                                                  " Capture Ex command output to buffer
  " NeoBundle 'tyru/emap.vim'                                                     " Extensible mappings
  NeoBundle 'tyru/open-browser.vim'                                             " Open browser and search from within vim
  let s:open_browser = neobundle#get('open-browser.vim')
  function! s:open_browser.hooks.on_source(bundle)
    nmap <leader>cr <Plug>(openbrowser-open)
    vmap <leader>cr <Plug>(openbrowser-open)
    nmap <leader>cs <Plug>(openbrowser-smart-search)
    vmap <leader>cs <Plug>(openbrowser-smart-search)
  endfunction
  " NeoBundle 'Raimondi/VimRegEx.vim'                                             " Regex dev and test env in vim
  " NeoBundle 'Shougo/echodoc.vim'                                                " Displays information in echo area from echodoc plugin
  " NeoBundle 'guns/xterm-color-table.vim'                                        " Show xterm color tables in vim
  " NeoBundle 'tpope/vim-abolish.git'                                             " Creates set of abbreviations for spell correction easily
  " NeoBundle 'paulhybryant/manpageview'                                          " Commands for viewing man pages in vim (Host up-to-date version from Dr. Chip)
  " NeoBundle 'paulhybryant/visualincr.vim'                                       " Increase integer values in visual block (Host up-to-date version from Dr. Chip)

  " NeoBundle 'chrisbra/Colorizer'                                                " Highlight hex / color name with the actual color
  " NeoBundle 'gorodinskiy/vim-coloresque'
  if filereadable(g:google_config)
    NeoBundle 'paulhybryant/vim-custom'                                           " My vim customization (utility functions, syntax etc)
  else
    NeoBundle 'paulhybryant/vim-custom', { 'depends' : 'vim-maktaba' }            " My vim customization (utility functions, syntax etc)
  endif
  let s:vimcustom = neobundle#get('vim-custom')
  function! s:vimcustom.hooks.on_source(bundle)
    set spellfile=$HOME/.vim/bundle/vim-custom/spell/en.utf-8.add
    let g:myutils#special_bufvars = ['gistls', 'NERDTreeType']
    autocmd BufEnter * call myutils#SyncNTTree()
    inoremap <C-q> <ESC>:Bclose<cr>
    nnoremap <C-q> :Bclose<cr>
    nnoremap <leader>gc :call myutils#EditCC()<CR>
    nnoremap <leader>gh :call myutils#EditHeader()<CR>
    nnoremap <leader>gt :call myutils#EditTest()<CR>
    nnoremap <leader>hh :call myutils#HexHighlight()<CR>
    nnoremap <leader>kl :call myutils#SetupTablineMappingForLinux()<CR>
    nnoremap <leader>km :call myutils#SetupTablineMappingForMac()<CR>
    nnoremap <leader>kw :call myutils#SetupTablineMappingForWindows()<CR>
    nnoremap <leader>ln :<C-u>exe 'call myutils#LocationNext()'<CR>
    nnoremap <leader>lp :<C-u>exe 'call myutils#LocationPrevious()'<CR>
    nnoremap <leader>tc :call myutils#ToggleColorColumn()<CR>
    nnoremap <leader>is :call myutils#FillWithCharTillN(' ', 80)<CR>
    noremap <leader>hl :call myutils#HighlightTooLongLines()<CR>
    vmap <leader>y :call myutils#CopyText()<CR>
    vnoremap <leader>sn :call myutils#SortWords(' ', 1)<CR>
    vnoremap <leader>sw :call myutils#SortWords(' ', 0)<CR>

    command! -nargs=* -complete=file -bang E call myutils#MultiEdit("<bang>", <f-args>)
    command! -nargs=+ -complete=command DC call myutils#DechoCmd(<q-args>)
    command! -nargs=+ InsertRepeated call myutils#InsertRepeated(<f-args>)
    command! -nargs=+ MapToggle call myutils#MapToggle(<f-args>)
    command! -nargs=+ MapToggleVar call myutils#MapToggleVar(<f-args>)
    command! Bclose call myutils#BufcloseCloseIt(1)
    " TODO: Integrate this with codefmt
    command! Fsql call myutils#FormatSql()

    " Display-altering option toggles
    MapToggle <F1> spell

    if len($SSH_CLIENT) > 0
      if $SSH_OS == "Darwin"
        call myutils#SetupTablineMappingForMac()
      elseif $SSH_OS == "Linux"
        call myutils#SetupTablineMappingForLinux()
      endif
    else
      if OSX()
        call myutils#SetupTablineMappingForMac()
      elseif LINUX()
        call myutils#SetupTablineMappingForLinux()
      elseif WINDOWS()
        call myutils#SetupTablineMappingForWindows()
      endif
    endif
  endfunction

  " NeoBundle 'vim-jp/vital.vim'
  " NeoBundle 'Shougo/eev.vim'                                                    " Evaluate vimscript one liner

  NeoBundle 'terryma/vim-multiple-cursors'                                      " Insert words at multiple places simutaneously
  let s:vimmulticursors = neobundle#get('vim-multiple-cursors')
  function! s:vimmulticursors.hooks.on_source(bundle)
    nnoremap <leader>mcf :exec 'MultipleCursorsFind \<' . expand("<cword>") . '\>'<CR>
  endfunction

  NeoBundle 'rking/ag.vim', { 'disabled' : !executable('ag') }
  " NeoBundle 'gabesoft/vim-ags', { 'disabled' : !executable('ag') }
  NeoBundle 'mileszs/ack.vim', {
        \ 'disabled' : !executable('ag') && !executable('ack') && !executable('ack-grep')
        \ }
  let s:ack = neobundle#get('ack.vim')
  function! s:ack.hooks.on_source(bundle)
    if executable('ag')
      let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
      let g:unite_source_grep_command='ag'
      let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
      let g:unite_source_grep_recursive_opt=''
    elseif executable('ack-grep')
      NeoBundle 'mileszs/ack.vim'
      let g:ackprg="ack-grep -H --nocolor --nogroup --column"
      let g:unite_source_grep_command='ack'
      let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
      let g:unite_source_grep_recursive_opt=''
    elseif executable('ack')
      NeoBundle 'mileszs/ack.vim'
      let g:unite_source_grep_command='ack'
      let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
      let g:unite_source_grep_recursive_opt=''
    endif
  endfunction
  " NeoBundle 'jceb/vim-orgmode'

  if WINDOWS()
    NeoBundle 'vim-scripts/Tail-Bundle'                                           " Tail for windows in vim
  endif

  " NeoBundle 'tyru/winmove.vim'
  " NeoBundle 'tyru/wim'
  " NeoBundle 'tomtom/tcomment_vim', {
        " \ 'disabled' : PluginDisabled('tcomment_vim'),
        " \ 'depends' : 'tomtom/tlib.vim'
        " \ }                                                                     " Add comments
  " NeoBundle 'tpope/vim-commentary', {
        " \ 'disabled' : PluginDisabled('vim-commentary')
        " \ }                                                                     " Add comments
  " NeoBundle 'rhysd/libclang-vim', { 'disabled' : PluginDisabled('libclang-vim') }
  " NeoBundle 'szw/vim-ctrlspace', {
        " \ 'disabled' : PluginDisabled('vim-ctrlspace')
        " \ }                                                                     " Vim workspace manager
  " NeoBundle "Rykka/os.vim"
  " NeoBundle "Rykka/clickable-things"
  " NeoBundle "Rykka/clickable.vim", { 'depends' : ['Rykka/os.vim', 'Rykka/clickable-things'] }
  " let s:clickable = neobundle#get('clickable.vim')
  " function! s:clickable.hooks.on_source(bundle)
    " call os#init()
    " let g:clickable_browser = "google-chrome"
  " endfunction
  " NeoBundle 'bruno-/vim-vertical-move'                                          " Move in visual block mode as much as possible
  " NeoBundle 'dhruvasagar/vim-prosession', { 'depends': 'tpope/vim-obsession' , 'disabled' : PluginDisabled('vim-prosession') }
  " NeoBundle 'dhruvasagar/vim-dotoo'
  " NeoBundle 'gelguy/Cmd2.vim'
  " NeoBundle 'gcmt/taboo.vim'
  " NeoBundle 'akesling/ondemandhighlight'
  " NeoBundle 'neitanod/vim-ondemandhighlight'
  " NeoBundle 'thinca/vim-localrc', { 'type' : 'svn', 'disabled' : PluginDisabled('vim-localrc') }          " Enable vim configuration file for each directory
  " NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim', {'script_type' : 'plugin'}    " For ruby development
  " NeoBundle 'vimwiki/vimwiki', { 'rtp': "~/.vim/bundle/vimwiki/src" }

  " Lazily load Filetype specific bundles {{{
  NeoBundleLazy 'chiphogg/vim-vtd', {
        \ 'autoload' : { 'filetypes' : ['vtd'] },
        \ }
  let s:vimvtd = neobundle#get('vim-vtd')
  function! s:vimvtd.hooks.on_source(bundle)
    Glaive vtd plugin[mappings]='vtd' files+=`[expand('%:p')]`
    if &background == "light"
      hi! Ignore guifg=#FDF6E3
    else
      hi! Ignore guifg=#002B36
    endif
  endfunction

  NeoBundleLazy 'paulhybryant/SQLUtilities', {
        \ 'autoload' : { 'filetypes' : ['sql'] }
        \ }                                                                     " Utilities for editing SQL scripts (v7.0)
  let s:sqlutilities = neobundle#get('SQLUtilities')
  function! s:sqlutilities.hooks.on_source(bundle)
    let g:sqlutil_align_comma=0
  endfunction
  NeoBundleLazy 'vim-scripts/SQLComplete.vim', {
        \ 'autoload' : { 'filetypes' : ['sql'] }
        \ }                                                                     " SQL script completion
  NeoBundleLazy 'vim-scripts/sql.vim--Stinson', {
        \ 'autoload' : { 'filetypes' : ['sql'] }
        \ }       " Better SQL syntax highlighting

  NeoBundleLazy 'rstacruz/sparkup', {
        \ 'rtp': 'vim',
        \ 'autoload' : { 'filetypes' : ['html'] }
        \ }                                                                     " Write HTML code faster
  NeoBundleLazy 'Valloric/MatchTagAlways', {
        \ 'disabled' : !has('python'),
        \ 'autoload' : { 'filetypes' : ['html', 'xml'] }
        \ }
  NeoBundleLazy 'vim-scripts/closetag.vim', {
        \ 'autoload' : { 'filetypes' : ['html'] }
        \ }                                                                     " Automatically close html/xml tags
  NeoBundleLazy 'vim-scripts/HTML-AutoCloseTag', {
        \ 'autoload' : { 'filetypes' : ['html'] }
        \ }                                                                     " Automatically close html tags
  let s:autoclosetag = neobundle#get('HTML-AutoCloseTag')
  function! s:autoclosetag.hooks.on_source(bundle)
    autocmd FileType xml,xhtml execute "source " . "$HOME/.vim/bundle/HTML-AutoCloseTag/ftplugin/html_autoclosetag.vim"
  endfunction

  NeoBundleLazy 'tmux-plugins/vim-tmux', {
        \ 'autoload' : { 'filetypes' : ['tmux'] }
        \ }                                                                     " Vim plugin for editing .tmux.conf
  NeoBundleLazy 'zaiste/tmux.vim', {
        \ 'autoload' : { 'filetypes' : ['tmux'] }
        \ }                                                                     " Tmux syntax highlight
  NeoBundleLazy 'wellle/tmux-complete.vim', {
        \ 'autoload' : { 'filetypes' : ['tmux'] }
        \ }                                                                     " Insert mode completion of words in adjacent panes

  NeoBundleLazy 'vim-scripts/bash-support.vim', {
        \ 'autoload' : { 'filetypes' : ['sh'] },
        \ 'disabled' : PluginDisabled('bash-support.vim'),
        \ }                                                                     " Make vim an IDE for writing bash
  let s:bash_support = neobundle#get('bash-support.vim')
  function! s:bash_support.hooks.on_source(bundle)
    let g:BASH_MapLeader  = g:maplocalleader
    let g:BASH_GlobalTemplateFile = expand("$HOME/.vim/bundle/bash-support.vim/bash-support/templates/Templates")
  endfunction

  " Vimscript scripting {{{
  " NeoBundleLazy 'kana/vim-vspec', {
        " \ 'autoload' : { 'filetypes' : ['vim'] }
        " \ }                                                                     " Testing framework for vimscript
  " NeoBundleLazy 'thinca/vim-themis', {
        " \ 'autoload' : { 'filetypes' : ['vim'] }
        " \ }                                                                     " Testing framework for vimscript
  " NeoBundleLazy 'junegunn/vader.vim', {
        " \ 'autoload' : { 'filetypes' : ['vim'] }
        " \ }                                                                     " Testing framework for vimscript
  NeoBundleLazy 'vim-scripts/ReloadScript', {
        \ 'autoload' : { 'filetypes' : ['vim'] }
        \ }                                                                     " Reload vim script without having to restart vim
  let s:reload_script = neobundle#get('ReloadScript')
  function! s:reload_script.hooks.on_source(bundle)
    map <leader>rl :ReloadScript %:p<CR>
  endfunction
  NeoBundleLazy 'paulhybryant/Decho.vim', {
        \ 'autoload' : { 'filetypes' : ['vim'] }
        \ }                                                                     " Debug echo for debuging vim plugins (Host up-to-date version from Dr. Chip, with minor enhancement)
  let s:decho = neobundle#get('Decho.vim')
  function! s:decho.hooks.on_source(bundle)
    let g:dechofuncname = 1
    let g:decho_winheight = 10
  endfunction
  NeoBundleLazy 'syngan/vim-vimlint', {
        \ 'autoload' : { 'filetypes' : ['vim'] },
        \ 'depends' : 'ynkdir/vim-vimlparser'
        \ }                                                                     " Syntax checker for vimscript
  " let g:Vim_MapLeader  = g:maplocalleader
  " NeoBundleLazy 'dbakker/vim-lint', { 'filetypes' : ['vim'] }                     " Syntax checker for vimscript
  NeoBundleLazy 'vim-scripts/Vim-Support', {
        \ 'autoload' : { 'filetypes' : ['vim'] },
        \ 'disabled' : PluginDisabled('Vim-Support'),
        \ }                                                                     " Make vim an IDE for writing vimscript
  " }}}

  NeoBundleLazy 'tpope/vim-git', { 'autoload' : { 'filetypes' : ['gitcommit'] } } " Syntax highlight for git

  NeoBundleLazy 'google/vim-ft-vroom', {
        \ 'autoload' : { 'filetypes' : ['vroom'] }
        \ }                                                                     " Filetype plugin for vroom

  NeoBundleLazy 'plasticboy/vim-markdown', {
        \ 'autoload' : { 'filetypes' : ['markdown'] }
        \ }                                                                     " Yet another markdown syntax highlighting
  NeoBundleLazy 'isnowfy/python-vim-instant-markdown', {
        \ 'autoload' : { 'filetypes' : ['markdown'] }
        \ }                                                                     " Start a http server and preview markdown instantly
  " NeoBundleLazy 'tpope/vim-markdown', {
        " \ 'autoload' : { 'filetypes' : ['markdown'] }
        " \ }                                                                     " Syntax highlighting for markdown
  " NeoBundle 'suan/vim-instant-markdown'
        " \ 'autoload' : { 'filetypes' : ['markdown'] }
        " \ }

  NeoBundleLazy 'vim-jp/cpp-vim', { 'autoload' : { 'filetypes' : ['cpp'] } }
  NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', {
        \ 'autoload' : { 'filetypes' : ['cpp'] }
        \ }                                                                     " Enhanced vim cpp highlight
  NeoBundleLazy 'jaxbot/semantic-highlight.vim', {
        \ 'autoload' : { 'filetypes' : ['cpp'] }
        \ }                                                                     " General semantic highlighting for vim
  let s:semantic_highlight = neobundle#get('semantic-highlight.vim')
  function! s:semantic_highlight.hooks.on_source(bundle)
    let g:semanticTermColors = [1,2,3,5,6,7,9,10,11,13,14,15,33,34,46,124,125,166,219,226]
  endfunction

  NeoBundleLazy 'maksimr/vim-jsbeautify', {
        \ 'filetypes' : ['javascript']
        \ }                                                                     " Javascript formatting
  NeoBundleLazy 'pangloss/vim-javascript', {
        \ 'filetypes' : ['javascript']
        \ }                                                                     " Javascript syntax folding
  let s:jssyntax = neobundle#get('vim-javascript')
  function s:jssyntax.hooks.on_source(bundle)
    setlocal regexpengine=1
    setlocal foldmethod=syntax
    setlocal conceallevel=1
    let g:javascript_enable_domhtmlcss=1
    let g:javascript_conceal_function   = "ƒ"
    let g:javascript_conceal_null       = "ø"
    " let g:javascript_conceal_this       = "@"
    " let g:javascript_conceal_return     = "⇚"
    " let g:javascript_conceal_undefined  = "¿"
    let g:javascript_conceal_NaN        = "ℕ"
    " let g:javascript_conceal_prototype  = "¶"
    " let g:javascript_conceal_static     = "•"
    " let g:javascript_conceal_super      = "Ω"
  endfunction

  " NeoBundleLazy 'elzr/vim-json', {
        " \ 'filetypes' : ['json']
        " \ }                                                                     " Json highlight in vim
  " let s:vimjson = neobundle#get("vim-json")
  " function s:vimjson.hooks.on_source(bundle)
    " autocmd FileType json set autoindent |
          " \ set formatoptions=tcq2l |
          " \ set textwidth=78 shiftwidth=2 |
          " \ set softtabstop=2 tabstop=8 |
          " \ set expandtab |
          " \ set foldmethod=syntax
  " endfunction
  " }}}

  call neobundle#end()

  NeoBundleCheck

  " if filereadable(expand("~/.vimrc.local"))
    " source $HOME/.vimrc.local
  " endif

" }}}

" Mappings and autocommands {{{

  " Disable key to enter ex mode
  nnoremap Q <nop>

  " Wrapped lines goes down/up to next row, rather than next line in file.
  nnoremap j gj
  nnoremap gj j
  nnoremap k gk
  nnoremap gk k

  " Concatenate two lines without whitespace at the end
  noremap J gJ
  noremap gJ J

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Use C-b to enter visual block mode from normal mode
  nnoremap <C-b> <C-v>

  " Use C-b to enter literal inputs in command mode
  cnoremap <C-b> <C-v>
  inoremap <C-b> <C-v>

  " Ctrl-Tab only works in gvim
  if has('gui_running')
      nnoremap <C-Tab> :bn<CR>
      nnoremap <C-S-Tab> :bp<CR>
  else
      " The keycodes received by vim for <Tab> and <C-Tab> from most terminal
      " emulators are the same. So <Tab> is mapped here but one can also use
      " <C-Tab> to switch buffers. Same for <S-Tab>.
      nnoremap <Tab> :bn<CR>
      nnoremap <S-Tab> :bp<CR>
  endif

  " Paste from the yank register, which only gets overwriten by yanking but
  " not deleting.
  noremap <leader>p "0p

  " Switch CWD to the directory of the open buffer
  noremap <leader>cd :lcd %:p:h<cr>:pwd<CR>

  " Print current file's full name (including path)
  noremap <leader>fn :echo expand('%:p')<CR>

  " Replaced by tyru/operator-camelize
  " Mapping for camelcase and underscore variable name conversion Change
  " CamelCase to underscore (camel_case)
  " noremap <leader>lc viw:s#\C\(\u[a-z0-9]\+\\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g<CR>
  " Change underscore to CamelCase, first letter not capitalized
  " noremap <leader>lC viw:s#_\(\l\)#\u\1#g<CR>
  " Change underscore to CamelCase, first letter also capitalized
  " noremap <leader>ua viw:s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g<CR>
  " cab lc s#\C\(\u[a-z0-9]\+\\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
  " cab ua s#\(\%(\<\l\+\)\%(_\)\@=\)\\|_\(\l\)#\u\1\2#g

  " Clear search register, stop highlighting current search text
  nnoremap <silent> <leader>c/ :let @/=""<CR>

  " Save the current window / tab
  nnoremap <c-s> :w<cr>
  inoremap <c-s> <ESC>:w<cr>

  " Some helpers to edit mode http://vimcasts.org/e/14
  cnoremap %% <C-R>=expand('%:h').'/'<CR>
  " cabbr %% expand('%:p:h')

  " Toggle spell
  nnoremap <leader>ts :let &spell = !&spell<CR>

  " For wrap text using textwidth when formatting text
  nnoremap <leader>tw :setlocal formatoptions-=t<CR>

  " Adjust viewports to the same size
  map <leader>=w <C-w>=

  " Write to files owned by root and is not opened with sudo
  cmap w!! w !sudo tee > /dev/null %

  " Adding newline and stay in normal mode.
  " <S-Enter> is not reflected, maybe captured by the tmux binding
  " nnoremap <Enter> o<ESC>

  " Improve completion popup menu
  " http://vim.wikia.com/wiki/Improve_completion_popup_menu
  " inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
  " inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
  inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
  inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
  inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
  inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
  inoremap <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

  " Identify the syntax highlighting group used at the cursor
  map <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

  imap <C-j> <ESC><C-j>
  imap <C-h> <ESC><C-h>
  imap <C-l> <ESC><C-l>
  imap <C-k> <ESC><C-k>

  " Open all folds in the direct fold that contains current location
  nnoremap zO [zzczO<C-O>

  " Mapping for quoting a string, <leader>qi (quote it)
  " noremap <leader>qi ciw"<C-r>""
  " noremap <leader>qs ciw'<C-r>"'

  " Make a simple 'search' text object
  " http://vim.wikia.com/wiki/Copy_or_change_search_hit
  " http://vimcasts.org/episodes/operating-on-search-matches-using-gn/
  " vnoremap <silent> t //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
      " \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
  " omap t :normal vt<CR>

  " Automatically jump to end of text pasted
  " vnoremap <silent> y y`]
  " vnoremap <silent> p p`]
  " nnoremap <silent> p p`]`

  " <leader>w= is mapped in Align.vim
  " <leader>w is used by CamelCaseMotion for moving
  " The mapping from Align make the motion slow because vim needs to wait for some
  " time in case '=' is pressed after <leader>w. Is that a better way to avoid
  " this?
  silent! unmap <leader>w=
  silent! unmap <leader>m=

  augroup FiletypeFormat
    autocmd!
    autocmd BufRead *.cc setlocal foldmethod=syntax
    " Disable spell check for log file and BUILD
    autocmd BufRead BUILD,*.log setlocal nospell
    autocmd FileType conf setlocal nospell
    autocmd BufRead *.vim setlocal sw=2 | setlocal ts=2 | setlocal sts=2 | set ft=vim | set foldmethod=marker
    autocmd VimEnter * if expand('%') == "" | exec "ScratchOpen"
    autocmd BufRead *.json setlocal filetype=json
  augroup END

" }}}

" Settings {{{

  filetype plugin indent on                                                     " Automatically detect file types.
  syntax on                                                                     " Syntax highlighting
  set autoindent                                                                " Indent at the same level of the previous line
  set autoread                                                                  " Automatically load changed files
  set autowrite                                                                 " Automatically write a file when leaving a modified buffer
  set background=dark                                                           " Assume a dark background
  set backspace=indent,eol,start                                                " Backspace for dummies
  set backup                                                                    " Whether saves a backup before editing
  set cursorline                                                                " Highlight current line
  set expandtab                                                                 " Tabs are spaces, not tabs
  set foldenable                                                                " Auto fold code
  set hidden                                                                    " Allow buffer switching without saving
  set history=1000                                                              " Store a ton of history (default is 20)
  set hlsearch                                                                  " Highlight search terms
  set ignorecase                                                                " Case insensitive search
  set imdisable                                                                 " Disable IME in vim
  set incsearch                                                                 " Find as you type search
  set laststatus=2                                                              " Always show statusline
  set linespace=0                                                               " No extra spaces between rows
  set list                                                                      " Display unprintable characters
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:.                                " Highlight problematic whitespace
  set matchpairs+=<:>                                                           " Match, to be used with %
  set modeline                                                                  " Mac disables modeline by default
  set modelines=4                                                               " Mac sets it to 0 by default
  set mouse=a                                                                   " Automatically enable mouse usage
  set mousehide                                                                 " Hide the mouse cursor while typing
  set number                                                                    " Line numbers on
  set pastetoggle=<F12>                                                         " pastetoggle (sane indentation on paste)
  set ruler                                                                     " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)                            " A ruler on steroids
  set scrolljump=5                                                              " Lines to scroll when cursor leaves screen
  set scrolloff=0                                                               " Minimum lines to keep above and below cursor
  set shiftround                                                                " Round indent to multiple of shiftwidth
  set shiftwidth=2                                                              " Use indents of 2 spaces
  set shortmess+=filmnrxoOtT                                                    " Abbrev. of messages (avoids 'hit enter')
  set showcmd                                                                   " Show partial commands in status line and selected text in visual mode
  set showmatch                                                                 " Show matching brackets/parenthesis
  set showmode                                                                  " Display the current mode
  set showtabline=2                                                             " Always show the tabline
  set smartcase                                                                 " Case sensitive when uppercase present
  set softtabstop=2                                                             " Let backspace delete indent
  " set splitbelow                                                                " Create the split at the bottom when split horizontally
  " set splitright                                                                " Create the split on the right when split vertically
  set t_Co=256                                                                  " Set number of colors supported by term
  set tabstop=2                                                                 " An indentation every two columns
  set term=$TERM                                                                " Make arrow and other keys work
  set undofile                                                                  " Persists undo
  set undolevels=1000                                                           " Maximum number of changes that can be undone
  set undoreload=10000                                                          " Save the whole buffer for undo when reloading it
  set viewoptions=folds,options,cursor,unix,slash                               " Better Unix / Windows compatibility
  set whichwrap=b,s,h,l,<,>,[,]                                                 " Backspace and cursor keys wrap too
  set wildmenu                                                                  " Show list instead of just completing
  set wildmode=list:longest,full                                                " Command <Tab> completion, list matches, then longest common part, then all
  set winminheight=0                                                            " Windows can be 0 line high
  set wrap                                                                      " Wrap long lines
  set wrapscan                                                                  " Make regex search wrap to the start of the file
  set comments=sl:/*,mb:*,elx:*/                                                " auto format comment blocks

  if &diff
    set nospell                                                                 " No spellcheck
    colorscheme putty
  else
    set spell                                                                   " Spellcheck
    colorscheme solarized
  endif

  if has ('x11') && (LINUX() || OSX())                                          " On Linux and mac use + register for copy-paste
    set clipboard=unnamedplus
  else                                                                          " On Windows, use * register for copy-paste
    set clipboard=unnamed
  endif

" }}}
