" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Environment {{{

  set nocompatible                                    " Must be first line
  set encoding=utf-8                                                      " Set text encoding default to utf-8
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

" }}}

" Plugins {{{

  let g:mapleader = ','
  let g:maplocalleader = ',,'

  if empty($VIMPLUGINSDIR)
    let $VIMPLUGINSDIR=expand("$HOME/.linuxbrew/Cellar/vim/.vim/bundle")
    if !isdirectory($VIMPLUGINSDIR)
      let $VIMPLUGINSDIR=expand("$HOME/.vim/bundle")
    endif
  endif

  if !isdirectory(expand("$VIMPLUGINSDIR/neobundle.vim"))
    echo "Installing neobundle..."
    silent !mkdir -p $VIMPLUGINSDIR/
    silent !git clone https://github.com/Shougo/neobundle.vim.git $VIMPLUGINSDIR/neobundle.vim
  endif

  filetype off
  set runtimepath+=$VIMPLUGINSDIR/neobundle.vim/

  call neobundle#begin(expand('$VIMPLUGINSDIR/'))

  NeoBundleFetch 'Shougo/neobundle.vim'                                   " Plugin manager
  NeoBundle 'Shougo/neobundle-vim-recipes', { 'force' : 1 }               " Recipes for plugins that can be installed and configured with NeoBundleRecipe

  " Nativation
  NeoBundle 'Lokaltog/vim-easymotion'                                     " Display hint for jumping to
  NeoBundle 'bkad/CamelCaseMotion'                                        " Defines CamelCase text object
  NeoBundle 'christoomey/vim-tmux-navigator'                              " Allow using the same keymap to move between tmux panes and vim splits seamlessly
  NeoBundle 'justinmk/vim-sneak'                                          " Easy motion within one line

  " Plugins that change vim UI {{{
  NeoBundle 'blueyed/vim-diminactive'                                     " Dim inactive windows

  NeoBundle 'myusuf3/numbers.vim'                                         " Automatically toggle line number for certain filetypes
  let s:numbers = neobundle#get('numbers.vim')
  function! s:numbers.hooks.on_source(bundle)
    let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m']
  endfunction

  NeoBundle 'kien/rainbow_parentheses.vim'                                " Colorful parentheses
  let s:rainbow_parentheses = neobundle#get('rainbow_parentheses.vim')
  function! s:rainbow_parentheses.hooks.on_source(bundle)
    let g:rbpt_max = 16
    let g:rbpt_loadcmd_toggle = 0
    autocmd VimEnter * RainbowParenthesesToggle
    autocmd Syntax * RainbowParenthesesLoadRound
    autocmd Syntax * RainbowParenthesesLoadSquare
    autocmd Syntax * RainbowParenthesesLoadBraces
  endfunction

  NeoBundle 'altercation/vim-colors-solarized'                            " Vim colorscheme solarized
  NeoBundle 'flazz/vim-colorschemes'                                      " Collection of vim colorschemes
  NeoBundle 'Kshitij-Banerjee/vim-github-colorscheme'                     " Vim colorscheme github
  NeoBundle 'itchyny/landscape.vim'                                       " Vim colorscheme landscape
  NeoBundle 'tomasr/molokai'                                              " Vim colorscheme molokai
  NeoBundle 'tpope/vim-vividchalk'                                        " Vim colorscheme vividchalk
  NeoBundle 'vim-scripts/candy.vim'                                       " Vim colorscheme candy
  NeoBundle 'Lokaltog/vim-distinguished'                                  " Vim colorscheme distinguished
  let g:rehash256 = 1

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
    " let g:airline#extensions#tmuxline#enabled = 1                         " Disable this for plugin Tmuxline
    " let g:airline#extensions#tmuxline#color_template = 'normal'
  endfunction

  " NeoBundle 'mattn/vim-airline-weather'                                 " Vim airline extension to show weather
  " let g:weather#area='Sunnyvale'
  " NeoBundle 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
  " NeoBundle 'paulhybryant/tmuxline.vim'                                 " Change tmux theme to be consistent with vim statusline (Wait for response on PR)
  " NeoBundle 'edkolev/tmuxline.vim'                                      " Change tmux theme to be consistent with vim statusline
  " NeoBundle 'edkolev/promptline.vim'
  " let g:tmuxline_theme = 'airline'
  " let g:tmuxline_preset = 'tmux'
  " }}}

  NeoBundle 'spf13/vim-autoclose'                                         " Automatically close brackets
  NeoBundle 'tpope/vim-endwise'                                           " Automatically put end construct (e.g. endfunction)
  NeoBundle 'tpope/vim-surround', { 'disabled' : 1 }
  NeoBundle 'tpope/vim-repeat'                                            " Repeat any command with '.'
  NeoBundle 'tpope/vim-unimpaired'                                        " Complementary pairs of mappings
  NeoBundle 'terryma/vim-expand-region'                                   " Expand visual selection by text object
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
    map L <Plug>(expand_region_expand)
    map H <Plug>(expand_region_shrink)
  endfunction
  NeoBundle 'scrooloose/nerdcommenter'                                    " Add comments
  let s:nerdcommenter = neobundle#get('nerdcommenter')
  function! s:nerdcommenter.hooks.on_source(bundle)
    let g:NERDSpaceDelims = 1
    let g:NERDCustomDelimiters = {}
    " TODO(yuhuang): Move to .vimrc.local
    " let g:NERDCustomDelimiters = {
          " \   'rvl' : { 'left': '#' },
          " \   'borg' : { 'left' : '//' }
          " \ }
  endfunction
  " NeoBundle 'tomtom/tlib_vim', { 'disabled' : 1 }                         " Library utilities for plugin from tomtom
  " NeoBundle 'tomtom/tcomment_vim', { 'disabled' : 1 }                     " Add comments
  " NeoBundle 'tpope/vim-commentary', { 'disabled' : 1 }                    " Add comments

  NeoBundle 'kana/vim-textobj-user'                                       " Allow defining text object by user
  NeoBundle 'paulhybryant/vim-textobj-path'                               " Define text object for a file system path
  NeoBundle 'jceb/vim-textobj-uri'                                        " Define text object for uri
  NeoBundle 'kana/vim-textobj-line'                                       " Define text object for a line
  NeoBundle 'kana/vim-textobj-entire'                                     " Define text object for the entire buffer
  NeoBundle 'Raimondi/vim_search_objects'                                 " Define text object for a search pattern
  " NeoBundle 'Raimondi/VimLTextObjects', { 'disabled' : 1 }                " Define text object for vimscript
  " NeoBundle 'Julian/vim-textobj-brace', { 'disabled' : 1 }                " Define text object between braces
  " NeoBundle 'beloglazov/vim-textobj-quotes', { 'disabled' : 1 }           " Define text object between any type of quotes
  " NeoBundle 'glts/vim-textobj-comment', { 'disabled' : 1 }                " Define text object for comments
  " NeoBundle 'kana/vim-textobj-datetime', { 'disabled' : 1 }               " Define text object for datetime format
  " NeoBundle 'kana/vim-textobj-function', { 'disabled' : 1 }               " Define text object for function
  " NeoBundle 'kana/vim-textobj-indent', { 'disabled' : 1 }                 " Define text object for indent
  " NeoBundle 'reedes/vim-textobj-sentence', { 'disabled' : 1 }             " Define text obj for a sentence
  " NeoBundle 'rhysd/vim-textobj-clang', { 'disabled' : 1 }                 " Define text object for c family languages
  " NeoBundle 'reedes/vim-textobj-quote', { 'disabled' : 1 }                " Define text object between also typographic ('curly') quote characters
  " augroup textobj_quote
    " autocmd!
    " autocmd FileType markdown call textobj#quote#init()
    " autocmd FileType textile call textobj#quote#init()
    " autocmd FileType text call textobj#quote#init({'educate': 0})
  " augroup END

  NeoBundle 'Chiel92/vim-autoformat'                                      " Easy code formatting with external formatter
  NeoBundle 'ntpeters/vim-better-whitespace'                              " Highlight all types of whitespaces
  NeoBundle 'bronson/vim-trailing-whitespace'                             " Highlight trailing whitespaces
  NeoBundle 'scrooloose/syntastic'                                        " Check syntax with external syntax checker
  let s:syntastic = neobundle#get('syntastic')
  function! s:syntastic.hooks.on_source(bundle)
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': ['vim'] }
    nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
  endfunction

  NeoBundle 'ConradIrwin/vim-bracketed-paste'                             " Automatically toggle paste mode when pasting in insert mode
  NeoBundle 'chrisbra/Recover.vim'                                        " Show diff between existing swap files and saved file
  NeoBundle 'paulhybryant/file-line'                                      " Open files and go to specific line and column (original user not active)





  NeoBundle 'jlemetay/permut'
  NeoBundle 'benmills/vimux'                                              " Interact with tmux from vim
  NeoBundle 'Shougo/vimshell.vim', { 'recipe' : 'vimshell' }              " Shell implemented with vimscript
  NeoBundle 'xolox/vim-shell'                                             " Better integration between vim and shell
  NeoBundle 'xolox/vim-notes', {
        \ 'depends' : ['xolox/vim-misc', 'vim-scripts/utl.vim']
        \ }                                                               " Note taking with vim
  let g:notes_directories = ['~/Notes']
  let g:notes_suffix = '.txt'
  let g:notes_indexfile = '~/Notes/notes.idx'
  let g:notes_tagsindex = '~/Notes/notes.tags'

  NeoBundle 'Shougo/vinarise.vim', {
        \ 'recipe' : 'vinarise',
        \ 'disabled' : 1,
        \ }                                                               " Ultimate hex editing system with vim
  NeoBundle 'glts/vim-radical', { 'disabled' : 1 }                        " Show number under cursor in hex, octal, binary
  NeoBundle 'mattn/gist-vim', {'depends' : 'mattn/webapi-vim'}            " Post, view and edit gist in vim
  NeoBundle 'sjl/splice.vim'                                              " Vim three way merge tool
  NeoBundle 'chrisbra/vim-diff-enhanced'
  " NeoBundle 'junegunn/vim-plug'                                           " Yet another vim plugin manager
  " NeoBundle 'gmarik/Vundle.vim'                                           " Yet another vim plugin manager
  " NeoBundle 'tpope/vim-pathogen'                                          " Yet another vim plugin manager
  NeoBundle 'vim-scripts/scratch.vim'                                     " Creates a scratch buffer
  NeoBundle 'Raimondi/VimRegEx.vim'                                       " Regex dev and test env in vim
  NeoBundle 'Shougo/echodoc.vim'
  NeoBundle 'google/vim-syncopate'                                        " Makes it easy to copy syntax highlighted code and paste in emails
  NeoBundle 'google/vim-ft-vroom', { 'filetypes' : 'vroom' }              " Filetype plugin for vroom
  NeoBundle 'thinca/vim-themis'                                           " Testing framework for vimscript
  NeoBundle 'guns/xterm-color-table.vim'                                  " Show xterm color tables in vim
  NeoBundle 'tpope/vim-dispatch'                                          " Run command asyncroneously in vim
  NeoBundle 'tpope/vim-abolish.git', { 'disabled' : 1 }                   " Creates set of abbreviations for spell correction easily
  " NeoBundle 'rhysd/libclang-vim', { 'disabled' : 1 }
  " NeoBundle 'szw/vim-ctrlspace', { 'disabled' : 1 }                       " Vim workspace manager
  NeoBundle 'godlygeek/tabular'
  " NeoBundle 'junegunn/vim-easy-align'
  " NeoBundle 'paulhybryant/Align'                                          " Alinghing texts based on specific charater etc (Host up-to-date version from Dr. Chip)

  if executable('ctags')
    NeoBundle 'xolox/vim-easytags', {'depends' : 'xolox/vim-misc'}        " Vim integration with ctags
    NeoBundle 'majutsushi/tagbar'
    let g:tagbar_type_autohotkey = {
          \ 'ctagstype' : 'autohotkey',
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

  NeoBundle 'paulhybryant/manpageview'                                    " Commands for viewing man pages in vim (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/vissort'                                        " Allow sorting lines by using a visual block (column) (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/visualincr.vim'                                 " Increase integer values in visual block (Host up-to-date version from Dr. Chip)
  NeoBundle 'paulhybryant/mark'                                           " Highlight multiple patterns with different color (Host latest version 2.8.5)
  nnoremap <leader>mc :MarkClear<CR>
  nnoremap <leader>m/ :Mark <C-R>/<CR>
  " NeoBundle 'vim-scripts/ShowMarks', { 'disabled' : 1 }                   " Use gutter to show location of marks

  NeoBundle 'paulhybryant/vim-custom'                                     " My vim customization (utility function, mappings, autocmds, etc)
  let s:vimcustom = neobundle#get('vim-custom')
  function! s:vimcustom.hooks.on_source(bundle)
    set spellfile=$VIMPLUGINSDIR/vim-custom/spell/en.utf-8.add
    autocmd BufEnter * call myutils#SyncNTTree()
    nnoremap <leader>km :call myutils#SetupTablineMappingForMac()<CR>
    nnoremap <leader>kl :call myutils#SetupTablineMappingForLinux()<CR>
    nnoremap <leader>kw :call myutils#SetupTablineMappingForWindows()<CR>

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

  " NeoBundle 'paulhybryant/vim-LargeFile', { 'disabled' : 1 }              " Allows much quicker editing of large files, at the price of turning off events, undo, syntax highlighting, etc.
  NeoBundle 'mhinz/vim-hugefile'                                          " Make edit / view of huge files better
  let g:hugefile_trigger_size = 50                                        " In MB

  NeoBundle 'mhinz/vim-signify'                                           " Show the sign at changes from last git commit
  " NeoBundle 'airblade/vim-gitgutter', { 'disabled' : 1 }                  " Prefer vim-signify
  NeoBundle 'tpope/vim-fugitive'                                          " Commands for working with git
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gm :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gp :Git push<CR>
  nnoremap <silent> <leader>gr :Gread<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>ge :Gedit<CR>
  nnoremap <silent> <leader>gi :Git add -p %<CR>
  nnoremap <silent> <leader>gg :SignifyToggle<CR>

  if WINDOWS()
    NeoBundle 'vim-scripts/Tail-Bundle'                                   " Tail for windows in vim
  endif

  NeoBundle 'terryma/vim-multiple-cursors'                                " Insert words at multiple places simutaneously
  nnoremap <leader>mcf :exec 'MultipleCursorsFind \<' . expand("<cword>") . '\>'<CR>

  NeoBundle 'jistr/vim-nerdtree-tabs'                                     " One NERDTree only, shared among buffers / tabs
  NeoBundle 'scrooloose/nerdtree'                                         " File explorer inside vim
  " NeoBundle 'tpope/vim-vinegar', { 'disabled' : 1 }                       " NERDTree enhancement
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
        \   'recipe' : 'vimfiler',
        \ }
  " NeoBundle 'wincent/Command-T'
  NeoBundle 'osyo-manga/vim-over'                                         " Preview changes to be made
  map <leader>o :OverCommandLine<CR>
  noremap <C-e> :NERDTreeToggle %<CR>
  let g:NERDShutUp=1
  let g:NERDTreeChDirMode=1
  let g:NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
  let g:NERDTreeMouseMode=2
  let g:NERDTreeQuitOnOpen = 0                                            " Keep NERDTree open after click
  let g:NERDTreeShowBookmarks=1
  let g:NERDTreeShowHidden=1
  let g:nerdtree_tabs_open_on_gui_startup=0

  NeoBundle 'honza/vim-snippets'                                          " Collection of vim snippets
  if has('python')
    NeoBundle 'Valloric/MatchTagAlways'
    NeoBundle 'SirVer/ultisnips'
    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger="<tab>"
    " let g:UltiSnipsJumpForwardTrigger="<c-j>"
    " let g:UltiSnipsJumpBackwardTrigger="<c-k>"
  else
    NeoBundle 'neosnippet.vim'                                            " Snippet support for vim
  endif

  NeoBundle 'Shougo/vimproc.vim', {
        \   'build' : {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make -f make_mac.mak',
        \     'linux' : 'make',
        \     'unix' : 'gmake',
        \   },
        \ }                                                               " Background process for unite.vim

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
  NeoBundle 'h1mesuke/unite-outline'
  NeoBundle 'ujihisa/unite-colorscheme'
  NeoBundle 'thinca/vim-unite-history'
  NeoBundle 'mattn/unite-gist'
  NeoBundle 'Shougo/unite-build'
  NeoBundle 'Shougo/unite-sudo'
  NeoBundle 'Shougo/unite-ssh'
  NeoBundle 'tsukkee/unite-help'

  NeoBundle 'Shougo/eev.vim'

  if executable('ag')
    NeoBundle 'rking/ag.vim'
    NeoBundle 'mileszs/ack.vim'
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

  " NeoBundle 'thinca/vim-localrc', { 'type' : 'svn', 'disabled' : 1 }          " Enable vim configuration file for each directory
  " NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim', {'script_type' : 'plugin'}    " For ruby development
  " NeoBundle 'bronzehedwick/impactjs-colorscheme', {'script_type' : 'colorscheme'}
  " NeoBundle 'vimwiki/vimwiki', { 'rtp': "~/.vim/bundle/vimwiki/src" }

  " Lazily load Filetype specific bundles
  NeoBundleLazy 'chiphogg/vim-vtd', { 'fieltypes' : 'vtd' }

  NeoBundleLazy 'paulhybryant/SQLUtilities', { 'filetypes' : 'sql' }          " Utilities for editing SQL scripts (v7.0) ('vim-scripts/SQLUtilities' has only v6.0)
  NeoBundleLazy 'vim-scripts/SQLComplete.vim', { 'filetypes' : 'sql' }        " SQL script completion
  NeoBundleLazy 'vim-scripts/sql.vim--Stinson', { 'filetypes' : 'sql' }       " Better SQL syntax highlighting
  let g:sqlutil_align_comma=0

  NeoBundleLazy 'vim-scripts/HTML-AutoCloseTag', { 'filetypes' : 'sql' }      " Automatically close html tags
  NeoBundle 'rstacruz/sparkup', { 'rtp': 'vim', 'filetypes' : 'html' }        " Write HTML code faster

  NeoBundleLazy 'tmux-plugins/vim-tmux', { 'filetypes' : 'tmux' }             " Vim plugin for editing .tmux.conf
  NeoBundleLazy 'zaiste/tmux.vim', { 'filetypes' : 'tmux' }                   " Tmux syntax highlight
  NeoBundleLazy 'wellle/tmux-complete.vim', { 'filetype' : 'tmux' }           " Vim plugin for insert mode completion of words in adjacent tmux panes

  NeoBundleLazy 'vim-scripts/bash-support.vim', { 'filetypes' : 'sh' }        " Make vim an IDE for writing bash
  let g:BASH_MapLeader  = g:maplocalleader
  let g:BASH_GlobalTemplateFile = expand("$VIMPLUGINSDIR/bash-support.vim/bash-support/templates/Templates")

  NeoBundleLazy 'vim-scripts/ReloadScript', { 'filetypes' : 'vim' }           " Reload vim script without having to restart vim
  map <leader>rl :ReloadScript %:p<CR>
  NeoBundleLazy 'paulhybryant/Decho.vim', { 'filetypes' : 'vim' }             " Debug echo for debuging vim plugins (Host up-to-date version from Dr. Chip, with minor enhancement)
  let g:dechofuncname = 1
  let g:decho_winheight = 10
  NeoBundleLazy 'syngan/vim-vimlint', {
        \ 'filetypes' : 'vim',
        \ 'depends' : 'ynkdir/vim-vimlparser'}                                " Syntax checker for vimscript
  " NeoBundleLazy 'dbakker/vim-lint', { 'filetyps' : 'vim' }                  " Syntax checker for vimscript
  " NeoBundleLazy 'vim-scripts/Vim-Support', { 'filetypes' : 'vim' }            " Make vim an IDE for writing vimscript
  let g:Vim_MapLeader  = g:maplocalleader

  NeoBundleLazy 'tpope/vim-git', { 'filetypes' : 'gitcommit' }                " Syntax highlight for git

  " NeoBundle 'tpope/vim-markdown', { 'filetypes' : 'markdown' }              " Syntax highlighting for markdown
  NeoBundleLazy 'plasticboy/vim-markdown', { 'filetypes' : 'markdown' }       " Yet another markdown syntax highlighting
  NeoBundleLazy 'isnowfy/python-vim-instant-markdown', {
        \ 'filetypes' : 'markdown' }                                          " Start a http server and preview markdown instantly
  " NeoBundle 'suan/vim-instant-markdown'

  NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', { 'filetypes' : 'cpp' }   " Enhanced vim cpp highlight
  NeoBundleLazy 'jaxbot/semantic-highlight.vim', { 'filetypes' : 'cpp' }      " General semantic highlighting for vim
  let g:semanticTermColors = [1,2,3,5,6,7,9,10,11,13,14,15,33,34,46,124,125,166,219,226]

  NeoBundleLazy 'jelera/vim-javascript-syntax', { 'filetypes' : ['javascript'] }
  " NeoBundle 'glts/vim-magnum', { 'disabled' : 1, 'depends' : 'google/vim-maktaba' }
  " NeoBundle 'dhruvasagar/vim-prosession', {'depends': 'tpope/vim-obsession'}
  " NeoBundle 'dhruvasagar/vim-dotoo'
  " NeoBundle 'gelguy/Cmd2.vim'
  " NeoBundle 'gcmt/taboo.vim'

  if filereadable(expand("~/.vimrc.local"))
    source $HOME/.vimrc.local
  endif

  call neobundle#end()


  autocmd FileType vtd NeoBundleSource vim-vtd
        \ | Glaive vtd plugin[mappings]='vtd' files+=`[expand('%:p')]`

  Glaive syncopate plugin[mappings] colorscheme=putty
  let g:html_number_lines = 0

  NeoBundleCheck
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
  set expandtab                                                           " Tabs are spaces, not tabs
  set foldenable                                                          " Auto fold code
  set hidden                                                              " Allow buffer switching without saving
  set history=1000                                                        " Store a ton of history (default is 20)
  set hlsearch                                                            " Highlight search terms
  set ignorecase                                                          " Case insensitive search
  set imdisable                                                           " Disable IME in vim
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
  " colorscheme putty
  colorscheme solarized

  let g:omni_syntax_ignorecase=0

" }}}
