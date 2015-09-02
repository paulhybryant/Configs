" Modeline {{{1
" vim: filetype=vim sw=2 ts=2 sts=2 expandtab tw=80
" vim: foldlevel=0 foldmethod=marker nospell
" }}}
" Globals {{{1
set nocompatible                                                                " Must be first line
set encoding=utf-8                                                              " Set text encoding default to utf-8
scriptencoding utf-8                                                            " Character encoding used in this script
let g:mapleader = ','
let g:maplocalleader = ',,'
" }}}
" Install NeoBundle if needed {{{1
function! s:InstallNeobundleIfNotPresent() " {{{3
  if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
    echo 'Installing neobundle...'
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim.git
          \ $HOME/.vim/bundle/neobundle.vim
  endif
endfunction
" }}}
call s:InstallNeobundleIfNotPresent()
" }}}
" Setup NeoBundle and OS.vim {{{1
filetype off
set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'                                           " Plugin manager
NeoBundle 'Shougo/neobundle-vim-recipes', { 'force' : 1 }                       " Recipes for plugins that can be installed and configured with NeoBundleRecipe
" NeoBundleFetch 'paulhybryant/neobundle.vim'                                   " Plugin manager
" NeoBundle 'MarcWeber/vim-addon-manager'                                       " Yet another vim plugin manager
" NeoBundle 'gmarik/Vundle.vim'                                                 " Yet another vim plugin manager
" NeoBundle 'junegunn/vim-plug'                                                 " Yet another vim plugin manager
" NeoBundle 'tpope/vim-pathogen'                                                " Yet another vim plugin manager
NeoBundle 'Rykka/os.vim', { 'force' : 1 }                                       " Provides consistency across OSes
let g:OS = os#init()
" }}}
" Windows Compatible {{{1
if g:OS.is_windows
  source $VIMRUNTIME/mswin.vim
  behave mswin

  let $TERM='win32'
  " On Windows, also use '.vim' instead of 'vimfiles'. It makes synchronization
  " across (heterogeneous) systems easier.
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,
        \$HOME/.vim/after
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
else
  set shell=/bin/sh
endif
" }}}
" Shared plugin configurations {{{1
function! s:ConfigureRelatedFiles()
  for l:key in ['c', 'h', 't', 'b']
    execute 'nnoremap <leader>g' . l:key .
          \ ' :call relatedfiles#selector#JumpToRelatedFile("' .
          \ l:key . '")<CR>'
  endfor
endfunction

function! s:ConfigureYcm()
  nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
  let g:Show_diagnostics_ui = 1                                                 " default 1
  let g:ycm_always_populate_location_list = 1                                   " default 0
  let g:ycm_collect_identifiers_from_tags_files = 0                             " default 0
  let g:ycm_collect_identifiers_from_tags_files = 1                             " enable completion from tags
  let g:ycm_complete_in_strings = 1                                             " default 1
  let g:ycm_confirm_extra_conf = 1
  let g:ycm_enable_diagnostic_highlighting = 0
  let g:ycm_enable_diagnostic_signs = 1
  let g:ycm_filetype_whitelist = { 'c': 1, 'cpp': 1, 'python': 1 }
  let g:ycm_goto_buffer_command = 'same-buffer'                                 " [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
  let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_open_loclist_on_ycm_diags = 1                                       " default 1
  let g:ycm_path_to_python_interpreter = ''                                     " default ''
  let g:ycm_register_as_syntastic_checker = 1                                   " default 1
  let g:ycm_server_keep_logfiles = 10                                           " keep log files
  let g:ycm_server_log_level = 'info'                                           " default info
  let g:ycm_server_use_vim_stdout = 0                                           " default 0 (logging to console)
  let g:ycm_autoclose_preview_window_after_insertion = 1                        " Automatically close the preview window for completion
  let g:ycm_autoclose_preview_window_after_completion = 1                       " Automatically close the preview window for completion
endfunction
" }}}
" Google specific setup {{{1
let s:google_config = resolve(expand('~/.vimrc.google'))
let g:at_google = filereadable(s:google_config)
if g:at_google
  execute 'source' s:google_config
  " Register the bundles, but do not add them to rtp as they are already there
  NeoBundleFetch 'google/vim-maktaba'
  NeoBundleFetch 'google/vim-glaive'
  call s:ConfigureRelatedFiles()
  call s:ConfigureYcm()
endif
" }}}
" General Plugins {{{1
NeoBundle 'Lokaltog/vim-easymotion'                                             " Display hint for jumping to
NeoBundle 'Shougo/vimproc.vim'                                                  " Enable background process and multi-threading
NeoBundle 'bkad/CamelCaseMotion'                                                " Defines CamelCase text object
NeoBundle 'blueyed/vim-diminactive'                                             " Dim inactive windows
NeoBundle 'chase/vim-ansible-yaml'                                              " Syntax, formatting for ansible's YAML dialect
NeoBundle 'chrisbra/Recover.vim'                                                " Show diff between existing swap files and saved file
NeoBundle 'chrisbra/improvedft'                                                 " Improved f and t command for vim
NeoBundle 'cohama/agit.vim'                                                     " Git log viewer (Yet another gitk clone for Vim), prefer agit over gitv as gitv has some bugs
NeoBundle 'flazz/vim-colorschemes'                                              " Collection of vim colorschemes
NeoBundle 'honza/vim-snippets'                                                  " Collection of vim snippets
NeoBundle 'kana/vim-operator-user'                                              " User defined operator
NeoBundle 'kana/vim-textobj-user'                                               " Allow defining text object by user
NeoBundle 'kshenoy/vim-signature'                                               " Place, toggle and display marks
NeoBundle 'ntpeters/vim-better-whitespace',                                     " Highlight all types of whitespaces
NeoBundle 'paulhybryant/vim-argwrap'                                            " Automatically wrap arguments between brackets, TODO: Make it better support vim
NeoBundle 'sjl/splice.vim'                                                      " Vim three way merge tool
NeoBundle 'spf13/vim-autoclose'                                                 " Automatically close brackets
NeoBundle 'thinca/vim-quickrun'                                                 " Execute whole/part of currently edited file
NeoBundle 'thinca/vim-visualstar'                                               " Allow searching using '*' with visually selected text
NeoBundle 'tpope/vim-commentary'                                                " Plugin for adding comments
NeoBundle 'tpope/vim-endwise'                                                   " Automatically put end construct (e.g. endfunction)
NeoBundle 'tpope/vim-repeat'                                                    " Repeat any command with '.'
NeoBundle 'tpope/vim-scriptease'                                                " Plugin for developing vim plugins
NeoBundle 'tpope/vim-surround'                                                  " Useful mappings for surrounding text objects with a pair of chars
NeoBundle 'tpope/vim-unimpaired'                                                " Complementary pairs of mappings
NeoBundle 'tyru/capture.vim'                                                    " Capture Ex command output to buffer
NeoBundle 'ujihisa/unite-colorscheme'                                           " Browser colorscheme with unite
NeoBundle 'ujihisa/unite-locate'                                                " Use locate to find files with unite
NeoBundle 'vasconcelloslf/vim-foldfocus'                                        " Edit and read fold in a separate buffer
NeoBundle 'vitalk/vim-onoff'                                                    " Toggle vim options
NeoBundle 'wincent/loupe'                                                       " Enhanced in-file search for Vim
NeoBundle 'wincent/terminus'                                                    " Enhanced terminal integration for Vim (including bracketed-paste)
NeoBundle 'beloglazov/vim-textobj-quotes', {
      \ 'depends' : ['kana/vim-textobj-user'],
      \ }                                                                       " Text object between any type of quotes
NeoBundle 'google/vim-maktaba', {
      \ 'disabled' : g:at_google,
      \ }                                                                       " Vimscript plugin library from google
NeoBundle 'google/vim-glaive', {
      \ 'depends' : ['google/vim-maktaba'],
      \ 'disabled' : g:at_google,
      \ }                                                                       " Plugin for better vim plugin configuration
NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/Align.vba.gz', {
      \ 'regular_namne' : 'Align',
      \ 'type' : 'vba',
      \ }                                                                       " Alinghing texts based on specific charater etc
NeoBundle 'kana/vim-textobj-fold', {
      \ 'depends' : 'kana/vim-textobj-user',
      \ }                                                                       " Text object for fold
NeoBundle 'paulhybryant/file-line', {
      \ 'type__protocol' : 'ssh',
      \ }                                                                       " Open files and go to specific line and column (original user not active)
NeoBundle 'paulhybryant/vim-scratch', {
      \ 'type__protocol' : 'ssh'
      \ }                                                                       " Creates a scratch buffer, fork of DeaR/vim-scratch, which is a fork of kana/vim-scratch
NeoBundle 'paulhybryant/vim-textobj-path', {
      \ 'depends' : ['kana/vim-textobj-user'],
      \ 'type__protocol' : 'ssh',
      \ }                                                                       " Text object for a file system path
NeoBundle 'rking/ag.vim', {
      \ 'disabled' : !executable('ag'),
      \ }                                                                       " Text based search tool using the silver searcher
" YouCompleteMe {{{2
NeoBundle 'Valloric/YouCompleteMe', {
      \ 'disabled' : g:at_google,
      \ }
let s:ycm = neobundle#get('YouCompleteMe')
function s:ycm.hooks.on_source(bundle)
  call s:ConfigureYcm()
endfunction
" }}}
" delimitMate {{{2
NeoBundle 'Raimondi/delimitMate'                                                " Automatic close of quotes etc. TODO: Make it add newline after {}, and only close <> in html / XML
let s:delimitmate = neobundle#get('delimitMate')
function s:delimitmate.hooks.on_source(bundle)
  let g:delimitMate_expand_cr = 1
endfunction
" }}}
" folddigest.vim {{{2
NeoBundle 'paulhybryant/folddigest.vim', {
      \ 'type__protocol' : 'ssh',
      \ }                                                                       " Outline explorer based on folds
let s:folddigest = neobundle#get('folddigest.vim')
function! s:folddigest.hooks.on_source(bundle)
  Glaive folddigest.vim plugin[mappings]
        \ vertical closefold flexnumwidth winsize=60 winpos='leftabove'
endfunction
" }}}
" myutils {{{2
NeoBundle 'paulhybryant/myutils', {
      \ 'depends' : ['vim-maktaba', 'vim-glaive', 'os.vim'],
      \ 'type__protocol' : 'ssh',
      \ }                                                                       " My vim customization (utility functions, syntax etc)
let s:myutils = neobundle#get('myutils')
function! s:myutils.hooks.on_source(bundle)
  " Close vim when the only buffer left is a special type of buffer
  Glaive myutils plugin[mappings]
        \ bufclose_skip_types=`[
        \  'gistls', 'nerdtree', 'indicator',
        \  'FoldDigest', 'Scratch', 'capture' ]`
  set spellfile=$HOME/.vim/bundle/myutils/spell/en.utf-8.add
  autocmd BufEnter * call myutils#SyncNTTree()

  command! -nargs=* -complete=file -bang E
        \ call myutils#MultiEdit('<bang>', <f-args>)
  command! -nargs=+ -complete=command DC call myutils#DechoCmd(<q-args>)
  command! -nargs=+ InsertRepeated call myutils#InsertRepeated(<f-args>)

  nnoremap <leader>hh :call myutils#HexHighlight()<CR>
  nnoremap <leader>kb :call myutils#SetupTablineMappings(g:OS)<CR>
  nnoremap <leader>ln :<C-u>execute 'call myutils#LocationNext()'<CR>
  nnoremap <leader>lp :<C-u>execute 'call myutils#LocationPrevious()'<CR>
  nnoremap <leader>tc :call myutils#ToggleColorColumn()<CR>
  nnoremap <leader>is :call myutils#FillWithCharTillN(' ', 80)<CR>
  noremap <leader>hl :call myutils#HighlightTooLongLines()<CR>
  vmap <leader>y :call myutils#CopyText()<CR>
  vnoremap <leader>sn :call myutils#SortWords(' ', 1)<CR>
  vnoremap <leader>sw :call myutils#SortWords(' ', 0)<CR>

  " Deprecated in favor of vim-onoff
  " command! -nargs=+ MapToggle call myutils#MapToggle(<f-args>)
  " command! -nargs=+ MapToggleVar call myutils#MapToggleVar(<f-args>)
  " Display-altering option toggles
  " nnoremap <leader>ts :let &spell = !&spell<CR>
  " MapToggle <F2> spell
endfunction
function! s:myutils.hooks.on_post_source(bundle)
  if $SSH_OS == 'Darwin'
    vmap Y y:call myutils#YankToRemoteClipboard()<CR>
  endif
  call myutils#SetupTablineMappings(g:OS)
endfunction
" }}}
" neocomplete.vim {{{2
NeoBundle 'Shougo/neocomplete.vim', {
      \ 'depends' : 'Shougo/context_filetype.vim',
      \ 'disabled' : !has('lua'),
      \ 'vim_version' : '7.3.885',
      \ }                                                                       " Code completion engine
let s:neocomplete = neobundle#get('neocomplete.vim')
function! s:neocomplete.hooks.on_source(bundle)
  let g:acp_enableAtStartup = 0                                                 " Disable AutoComplPop.
  let g:neocomplete#enable_at_startup = 1                                       " Use neocomplete.
  let g:neocomplete#enable_smart_case = 1                                       " Use smartcase.
  let g:neocomplete#sources#syntax#min_keyword_length = 3                       " Set minimum syntax keyword length.
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  let g:neocomplete#sources#dictionary#dictionaries = {
    \   'default' : '',
    \   'vimshell' : $HOME.'/.vimshell_hist',
    \   'scheme' : $HOME.'/.gosh_completions'
    \ }                                                                         " Define dictionary.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}                                     " Define keyword.
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
" nerdcommenter {{{2
NeoBundle 'scrooloose/nerdcommenter'                                            " Plugin for adding comments
let s:nerdcommenter = neobundle#get('nerdcommenter')
function! s:nerdcommenter.hooks.on_source(bundle)
  let g:NERDCreateDefaultMappings = 1
  let g:NERDCustomDelimiters = {
        \ 'cvim' : { 'left' : '"', 'leftAlt' : ' ', 'rightAlt' : ' ' }
        \ }
  let g:NERDSpaceDelims = 1
  let g:NERDUsePlaceHolders = 0
  " nmap <leader>ci <Plug>NERDCommenterInvert
  " xmap <leader>ci <Plug>NERDCommenterInvert
  " nmap <leader>cc <Plug>NERDCommenterComment
  " xmap <leader>cc <Plug>NERDCommenterComment
endfunction
" }}}
" nerdtree {{{2
NeoBundle 'scrooloose/nerdtree'                                                 " File explorer inside vim
let s:nerdtree = neobundle#get('nerdtree')
function! s:nerdtree.hooks.on_source(bundle)
  let g:NERDShutUp=1
  let g:NERDTreeChDirMode=1
  let g:NERDTreeIgnore=[
        \ '\.pyc', '\~$', '\.swo$', '\.swp$',
        \ '\.git', '\.hg', '\.svn', '\.bzr']
  let g:NERDTreeMouseMode=2
  let g:NERDTreeQuitOnOpen = 0                                                  " Keep NERDTree open after click
  let g:NERDTreeShowBookmarks=1
  let g:NERDTreeShowHidden=1
  let g:nerdtree_tabs_open_on_gui_startup=0
  nnoremap <C-e> :NERDTreeToggle %<CR>
endfunction
" }}}
" operator-camelize {{{2
NeoBundle 'tyru/operator-camelize.vim', {
      \ 'depends' : ['kana/vim-operator-user'],
      \ }                                                                       " Convert variable to / from camelcase form
let s:camelize = neobundle#get('operator-camelize.vim')
function! s:camelize.hooks.on_source(bundle)
  map <leader>lc <Plug>(operator-camelize)
  map <leader>lC <Plug>(operator-decamelize)
endfunction
" }}}
" relatedfiles {{{2
NeoBundle 'paulhybryant/relatedfiles', {
      \ 'disabled' : g:at_google,
      \ 'type__protocol' : 'ssh',
      \ }
let s:relatedfiles = neobundle#get('relatedfiles')
function s:relatedfiles.hooks.on_source(bundle)
  call s:SetupRelatedFiles()
endfunction
" }}}
" signify {{{2
NeoBundle 'paulhybryant/vim-signify', {
      \ 'type__protocol' : 'ssh',
      \ }                                                                       " Show the sign at changes from last git commit
let s:signify = neobundle#get('vim-signify')
function! s:signify.hooks.on_source(bundle)
  let g:signify_vcs_list=['git']
  " let g:signify_line_highlight=1
  let g:signify_sign_show_count=1
  nmap <leader>gj <plug>(signify-next-hunk)
  nmap <leader>gk <plug>(signify-prev-hunk)
endfunction
" }}}
" syntastic {{{2
NeoBundle 'scrooloose/syntastic'                                                " Check syntax with external syntax checker
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
" }}}
" unite.vim {{{2
NeoBundle 'Shougo/unite.vim', {
      \ 'recipe' : 'unite',
      \ }                                                                       " Unite plugins: https://github.com/Shougo/unite.vim/wiki/unite-plugins
let s:unite = neobundle#get('unite.vim')
function! s:unite.hooks.on_source(bundle)
  let g:unite_data_directory = $HOME . '/.cache/unite'
  let g:unite_abbr_highlight = 'Keyword'
  if (!isdirectory(g:unite_data_directory))
    call mkdir(g:unite_data_directory, 'p')
  endif
  nnoremap <C-p> :Unite file_rec/async<CR>
  let g:unite_enable_start_insert=1
  let g:unite_prompt='» '
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
endfunction
" }}}
" ultisnips {{{2
NeoBundle 'SirVer/ultisnips', {
      \ 'disabled' : !has('python'),
      \ }                                                                       " Define and insert snippets
let s:ultisnips = neobundle#get('ultisnips')
function! s:ultisnips.hooks.on_source(bundle)
  " Remap Ultisnips for compatibility for YCM
  let g:UltiSnipsExpandTrigger="<tab>"
endfunction
" }}}
" vim-airline {{{2
NeoBundle 'bling/vim-airline'                                                   " Lean & mean status/tabline for vim that's light as air
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
" }}}
" vim-better-whitespace {{{2
let s:betterws = neobundle#get('vim-better-whitespace')
function! s:betterws.hooks.on_source(bundle)
  let g:strip_whitespace_on_save = 1
  nnoremap <leader>sw :ToggleStripWhitespaceOnSave<CR>
endfunction
" }}}
" vim-buffergator {{{2
NeoBundle 'jeetsukumaran/vim-buffergator'                                       " Buffer selector in vim
let s:buffergator = neobundle#get('vim-buffergator')
function! s:buffergator.hooks.on_source(bundle)
  let g:buffergator_suppress_keymaps=1
  noremap <leader>bf :BuffergatorOpen<CR>
endfunction
" }}}
" vim-colors-solarized {{{2
NeoBundle 'altercation/vim-colors-solarized'                                    " Vim colorscheme solarized
let s:solarized = neobundle#get('vim-colors-solarized')
function! s:solarized.hooks.on_source(bundle)
  let g:solarized_diffmode="high"
endfunction
" }}}
" vim-codefmt {{{2
NeoBundle 'google/vim-codefmt', {
      \ 'depends' : ['google/vim-codefmtlib', 'google/vim-glaive'],
      \ 'disabled' : g:at_google,
      \ }                                                                       " Code formating plugin from google
let s:vimcodefmt = neobundle#get('vim-codefmt')
function! s:vimcodefmt.hooks.on_source(bundle)
  Glaive codefmt plugin[mappings]
endfunction
" }}}
" vim-diff-indicator {{{2
NeoBundle 'paulhybryant/vim-diff-indicator', {
      \ 'depends' : [
      \   'paulhybryant/vim-signify',
      \   'google/vim-maktaba',
      \   'google/vim-glaive'
      \ ],
      \ 'type__protocol' : 'ssh',
      \ }                                                                       " Diff indicator based on vim-signify
let s:indicator = neobundle#get('vim-diff-indicator')
function! s:indicator.hooks.on_source(bundle)
  Glaive vim-diff-indicator plugin[mappings]
endfunction
" }}}
" vim-expand-region {{{2
NeoBundle 'terryma/vim-expand-region'                                           " Expand visual selection by text object
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
  nnoremap <leader>ll <Plug>(expand_region_expand)
  nnoremap <leader>hh <Plug>(expand_region_shrink)
endfunction
" }}}
" vim-multiple-cursors {{{2
NeoBundle 'terryma/vim-multiple-cursors'                                        " Insert words at multiple places simultaneously
let s:vimmulticursors = neobundle#get('vim-multiple-cursors')
function! s:vimmulticursors.hooks.on_source(bundle)
  nnoremap <leader>mcf
        \ :execute 'MultipleCursorsFind \<' . expand('<cword>') . '\>'<CR>
endfunction
" }}}
" vim-notes {{{2
NeoBundle 'xolox/vim-notes', {
      \ 'depends' : ['xolox/vim-misc'],
      \ }                                                                       " Note taking with vim
let s:vimnotes = neobundle#get('vim-notes')
function! s:vimnotes.hooks.on_source(bundle)
  let g:notes_directories = ['~/.myconfigs/notes']
  let g:notes_suffix = '.txt'
  let g:notes_indexfile = '~/.myconfigs/notes.idx'
  let g:notes_tagsindex = '~/.myconfigs/notes.tags'
endfunction
" }}}
" vim-tmux-navigator {{{2
NeoBundle 'christoomey/vim-tmux-navigator'                                      " Allow using the same keymap to move between tmux panes and vim splits seamlessly
let s:tmux_navigator = neobundle#get('vim-tmux-navigator')
function! s:tmux_navigator.hooks.on_source(bundle)
  " Allow jumping to other tmux pane in insert mode
  imap <C-j> <ESC><C-j>
  imap <C-h> <ESC><C-h>
  imap <C-l> <ESC><C-l>
  imap <C-k> <ESC><C-k>
endfunction
" }}}
" }}}
" Filetype specific plugins {{{1
" vtd {{{2
NeoBundle 'chiphogg/vim-vtd', {
      \ 'autoload' : { 'filetypes' : ['vtd'] },
      \ 'lazy' : 1,
      \ }
let s:vimvtd = neobundle#get('vim-vtd')
function! s:vimvtd.hooks.on_source(bundle)
  Glaive vtd plugin[mappings]='vtd' files+=`[expand('%:p')]`
  if &background == 'light'
    hi! Ignore guifg=#FDF6E3
  else
    hi! Ignore guifg=#002B36
  endif
endfunction
" }}}
" sql {{{2
NeoBundle 'jphustman/SQLUtilities', {
      \ 'autoload' : { 'filetypes' : ['sql'] },
      \ 'depends' : ['Align'],
      \ 'lazy' : 1,
      \ }                                                                       " Utilities for editing SQL scripts (v7.0)
let s:sqlutilities = neobundle#get('SQLUtilities')
function! s:sqlutilities.hooks.on_source(bundle)
  let g:sqlutil_align_comma=0

  function! s:FormatSql()
    execute ':SQLUFormatter'
    execute ':%s/$\n\\(\\s*\\), /,\\r\\1'
  endfunction

  " TODO: Integrate this with codefmt
  command! Fsql call s:FormatSql()
endfunction
NeoBundle 'vim-scripts/SQLComplete.vim', {
      \ 'autoload' : { 'filetypes' : ['sql'] },
      \ 'lazy' : 1,
      \ }                                                                       " SQL script completion
NeoBundle 'vim-scripts/sql.vim--Stinson', {
      \ 'autoload' : { 'filetypes' : ['sql'] },
      \ 'lazy' : 1,
      \ }                                                                       " Better SQL syntax highlighting
" }}}
" html {{{2
NeoBundle 'rstacruz/sparkup', {
      \ 'autoload' : { 'filetypes' : ['html'] },
      \ 'lazy' : 1,
      \ 'rtp': 'vim',
      \ }                                                                       " Write HTML code faster
NeoBundle 'Valloric/MatchTagAlways', {
      \ 'autoload' : { 'filetypes' : ['html', 'xml'] },
      \ 'disabled' : !has('python'),
      \ 'lazy' : 1,
      \ }
NeoBundle 'vim-scripts/closetag.vim', {
      \ 'autoload' : { 'filetypes' : ['html'] },
      \ 'lazy' : 1,
      \ }                                                                       " Automatically close html/xml tags
NeoBundle 'vim-scripts/HTML-AutoCloseTag', {
      \ 'autoload' : { 'filetypes' : ['html'] },
      \ 'lazy' : 1,
      \ }                                                                       " Automatically close html tags
let s:autoclosetag = neobundle#get('HTML-AutoCloseTag')
function! s:autoclosetag.hooks.on_source(bundle)
  autocmd FileType xml,xhtml execute 'source'
        \ '$HOME/.vim/bundle/HTML-AutoCloseTag/ftplugin/html_autoclosetag.vim'
endfunction
" }}}
" tmux {{{2
NeoBundle 'tmux-plugins/vim-tmux', {
      \ 'autoload' : { 'filetypes' : ['tmux'] },
      \ 'lazy' : 1,
      \ }                                                                       " Vim plugin for editing .tmux.conf
NeoBundle 'wellle/tmux-complete.vim', {
      \ 'autoload' : { 'filetypes' : ['tmux'] },
      \ 'lazy' : 1,
      \ }                                                                       " Insert mode completion of words in adjacent panes
" NeoBundle 'zaiste/tmux.vim', {
      " \ 'autoload' : { 'filetypes' : ['tmux'] },
      " \ 'lazy' : 1,
      " \ }                                                                     " Tmux syntax highlight
" }}}
" shell {{{2
NeoBundle 'vim-scripts/bash-support.vim', {
      \ 'autoload' : { 'filetypes' : ['sh'] },
      \ 'disabled' : 1,
      \ 'lazy' : 1,
      \ }                                                                       " Make vim an IDE for writing bash
let s:bash_support = neobundle#get('bash-support.vim')
function! s:bash_support.hooks.on_source(bundle)
  let g:BASH_MapLeader  = g:maplocalleader
  let g:BASH_GlobalTemplateFile = expand(
        \ '$HOME/.vim/bundle/' .
        \ 'bash-support.vim/bash-support/templates/Templates')
endfunction
" }}}
" vim {{{2
NeoBundle 'vim-scripts/ReloadScript', {
      \ 'autoload' : { 'filetypes' : ['vim'] },
      \ 'lazy' : 1,
      \ }                                                                       " Reload vim script without having to restart vim
let s:reload_script = neobundle#get('ReloadScript')
function! s:reload_script.hooks.on_source(bundle)
  map <leader>rl :ReloadScript %:p<CR>
endfunction
NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/Decho.vba.gz', {
      \ 'autoload' : { 'filetypes' : ['vim'] },
      \ 'lazy' : 1,
      \ 'type' : 'vba',
      \ }                                                                       " Debug echo for debuging vim plugins
let s:decho = neobundle#get('Decho')
function! s:decho.hooks.on_source(bundle)
  let g:dechofuncname = 1
  let g:decho_winheight = 10
endfunction
NeoBundle 'syngan/vim-vimlint', {
      \ 'autoload' : { 'filetypes' : ['vim'] },
      \ 'depends' : 'ynkdir/vim-vimlparser',
      \ 'lazy' : 1,
      \ }                                                                       " Syntax checker for vimscript
NeoBundle 'vim-scripts/Vim-Support', {
      \ 'autoload' : { 'filetypes' : ['vim'] },
      \ 'disabled' : 1,
      \ 'lazy' : 1,
      \ }                                                                       " Make vim an IDE for writing vimscript
NeoBundle 'google/vim-ft-vroom', {
      \ 'autoload' : { 'filetypes' : ['vroom'] },
      \ 'lazy' : 1,
      \ }                                                                       " Filetype plugin for vroom
" NeoBundle 'kana/vim-vspec', {
      " \ 'autoload' : { 'filetypes' : ['vim'] },
      " \ 'lazy' : 1,
      " \ }                                                                     " Testing framework for vimscript
" NeoBundle 'thinca/vim-themis', {
      " \ 'autoload' : { 'filetypes' : ['vim'] },
      " \ 'lazy' : 1,
      " \ }                                                                     " Testing framework for vimscript
" NeoBundle 'junegunn/vader.vim', {
      " \ 'autoload' : { 'filetypes' : ['vim'] },
      " \ 'lazy' : 1,
      " \ }                                                                     " Testing framework for vimscript
" let g:Vim_MapLeader  = g:maplocalleader
" NeoBundle 'dbakker/vim-lint', {
      " \ 'filetypes' : ['vim'],
      " \ 'lazy' : 1,
      " \ }                                                                     " Syntax checker for vimscript
" }}}
" git {{{2
NeoBundle 'tpope/vim-git', {
      \ 'autoload' : { 'filetypes' : ['gitcommit'] },
      \ 'lazy' : 1,
      \ }                                                                       " Syntax highlight for git
" }}}
" markdown {{{2
NeoBundle 'plasticboy/vim-markdown', {
      \ 'autoload' : { 'filetypes' : ['markdown'] },
      \ 'lazy' : 1,
      \ }                                                                       " Yet another markdown syntax highlighting
NeoBundle 'isnowfy/python-vim-instant-markdown', {
      \ 'autoload' : { 'filetypes' : ['markdown'] },
      \ 'lazy' : 1,
      \ }                                                                       " Start a http server and preview markdown instantly
" NeoBundle 'tpope/vim-markdown', {
      " \ 'autoload' : { 'filetypes' : ['markdown'] },
      " \ 'lazy' : 1,
      " \ }                                                                     " Syntax highlighting for markdown
" NeoBundle 'suan/vim-instant-markdown'
      " \ 'autoload' : { 'filetypes' : ['markdown'] },
      " \ 'lazy' : 1,
      " \ }
" }}}
" cpp {{{2
NeoBundle 'vim-jp/cpp-vim', {
      \ 'autoload' : { 'filetypes' : ['cpp'] },
      \ 'lazy' : 1,
      \ }
NeoBundle 'octol/vim-cpp-enhanced-highlight', {
      \ 'autoload' : { 'filetypes' : ['cpp'] },
      \ 'lazy' : 1,
      \ }                                                                       " Enhanced vim cpp highlight
NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/blockhl.vba.gz', {
      \ 'autoload' : { 'filetypes' : ['cpp'] },
      \ 'lazy' : 1,
      \ 'type' : 'vba',
      \ }                                                                       " Highlights in block level
NeoBundle 'jaxbot/semantic-highlight.vim', {
      \ 'autoload' : { 'filetypes' : ['cpp'] },
      \ 'lazy' : 1,
      \ }                                                                       " General semantic highlighting for vim
let s:semantic_highlight = neobundle#get('semantic-highlight.vim')
function! s:semantic_highlight.hooks.on_source(bundle)
  let g:semanticTermColors =
        \ [1,2,3,5,6,7,9,10,11,13,14,15,33,34,46,124,125,166,219,226]
endfunction
" }}}
" js {{{2
NeoBundle 'maksimr/vim-jsbeautify', {
      \ 'filetypes' : ['javascript'],
      \ 'lazy' : 1,
      \ }                                                                     " Javascript formatting
NeoBundle 'pangloss/vim-javascript', {
      \ 'filetypes' : ['javascript'],
      \ 'lazy' : 1,
      \ }                                                                       " Javascript syntax folding
let s:jssyntax = neobundle#get('vim-javascript')
function s:jssyntax.hooks.on_source(bundle)
  setlocal regexpengine=1
  setlocal foldmethod=syntax
  setlocal conceallevel=1
  let g:javascript_enable_domhtmlcss=1
  let g:javascript_conceal_function   = 'ƒ'
  let g:javascript_conceal_null       = 'ø'
  let g:javascript_conceal_NaN        = 'ℕ'
  " let g:javascript_conceal_this       = '@'
  " let g:javascript_conceal_return     = '⇚'
  " let g:javascript_conceal_undefined  = '¿'
  " let g:javascript_conceal_prototype  = '¶'
  " let g:javascript_conceal_static     = '•'
  " let g:javascript_conceal_super      = 'Ω'
endfunction
" }}}
" json {{{2
NeoBundle 'elzr/vim-json', {
      \ 'filetypes' : ['json'],
      \ 'lazy' : 1,
      \ }                                                                       " Json highlight in vim
let s:vimjson = neobundle#get('vim-json')
function s:vimjson.hooks.on_source(bundle)
  autocmd FileType json set autoindent |
        \ set formatoptions=tcq2l |
        \ set textwidth=80 shiftwidth=2 |
        \ set softtabstop=2 tabstop=8 |
        \ set expandtab |
        \ set foldmethod=syntax
endfunction
NeoBundle 'Quramy/vison'                                                        " For writting JSON with JSON Schema
" }}}
" }}}
" Disabled plugins {{{1
for bundle in ['delimitMate']
  execute 'NeoBundleDisable' bundle
endfor
" }}}
" Unused plugins {{{1
" TextObjects {{{2
" TODO: For vim-textobj-quotes, va' seems to select the space before the
" quote, need to be fixed.  Also, try to map vi' to viq etc
" NeoBundle 'Julian/vim-textobj-brace', {
      " \ 'depends' : 'kana/vim-textobj-user'
      " \ }                                                                     " Text object between braces
" NeoBundle 'Julian/vim-textobj-variable-segment', {
      " \ 'depends' : 'kana/vim-textobj-user'
      " \ }
" NeoBundle 'Raimondi/VimLTextObjects', {
      " \ 'depends' : 'kana/vim-textobj-user'
      " \ }                                                                     " Text object for vimscript
" NeoBundle 'Raimondi/vim_search_objects', {
      " \ 'depends' : 'kana/vim-textobj-user'
      " \ }                                                                     " Text object for a search pattern
" NeoBundle 'beloglazov/vim-textobj-punctuation', {
      " \ 'depends' : 'kana/vim-textobj-user'
      " \ }
" NeoBundle 'gilligan/textobj-gitgutter', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'glts/vim-textobj-comment', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for comments
" NeoBundle 'glts/vim-textobj-indblock', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'jceb/vim-textobj-uri', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for uri
" NeoBundle 'kana/vim-textobj-datetime', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for datetime format
" NeoBundle 'kana/vim-textobj-diff', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'kana/vim-textobj-entire', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for the entire buffer
" NeoBundle 'kana/vim-textobj-function', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for function
" NeoBundle 'kana/vim-textobj-indent', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for indent
" NeoBundle 'kana/vim-textobj-jabraces', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'kana/vim-textobj-lastpat', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for last searched pattern
" NeoBundle 'kana/vim-textobj-line', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for a line
" NeoBundle 'kana/vim-textobj-syntax', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'lucapette/vim-textobj-underscore', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'mattn/vim-textobj-url', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'reedes/vim-textobj-quote', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object between also typographic ('curly') quote characters
" NeoBundle 'reedes/vim-textobj-sentence', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for a sentence
" NeoBundle 'rhysd/vim-textobj-clang', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object for c family languages
" NeoBundle 'rhysd/vim-textobj-continuous-line', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'saaguero/vim-textobj-pastedtext', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'saihoooooooo/vim-textobj-space', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'sgur/vim-textobj-parameter', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'thinca/vim-textobj-between', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object between a char
" NeoBundle 'thinca/vim-textobj-comment', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }                                                                     " Text object  for comments
" NeoBundle 'whatyouhide/vim-textobj-erb', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'whatyouhide/vim-textobj-xmlattr', {
      " \ 'depends' : 'kana/vim-textobj-user',
      " \ }
" NeoBundle 'michaeljsmith/vim-indent-object'                                   " Text object based on indent levels
" NeoBundle 'gcmt/wildfire.vim'
" }}}
" NeoBundle 'embear/vim-localvimrc'                                               " Load local vimrc in parent dirs of currently opened file
" NeoBundle 'mattboehm/vim-unstack'                                               " View call stacks in vim
" NeoBundle 'mhinz/vim-hugefile'                                                  " Make edit / view of huge files better
" let s:vimhugefile = neobundle#get('vim-hugefile')
" function! s:vimhugefile.hooks.on_source(bundle)
  " let g:hugefile_trigger_size = 50                                              " In MB
" endfunction
" NeoBundle 'tyru/open-browser.vim'                                               " Open browser and search from within vim
" let s:open_browser = neobundle#get('open-browser.vim')
" function! s:open_browser.hooks.on_source(bundle)
  " nmap <leader>cr <Plug>(openbrowser-open)
  " vmap <leader>cr <Plug>(openbrowser-open)
  " nmap <leader>cs <Plug>(openbrowser-smart-search)
  " vmap <leader>cs <Plug>(openbrowser-smart-search)
" endfunction
" NeoBundle 'mattn/emmet-vim'
" NeoBundle 'aquach/vim-http-client'                                              " Make http request in vim, and show the response
" NeoBundle 'jlemetay/permut'                                                     " Swap fields separated by delimiter
" NeoBundle 'paulhybryant/foldcol', {
      " \ 'depends' : ['vim-maktaba', 'Align'],
      " \ 'type__protocol' : 'ssh'
      " \ }                                                                       " Fold columns selected in visual block mode
" let s:foldcol = neobundle#get('foldcol')
" function! s:foldcol.hooks.on_source(bundle)
  " Glaive foldcol plugin[mappings]
" endfunction
" NeoBundle 'paulhybryant/tmuxline.vim', {
      " \ 'type__protocol' : 'ssh'
      " \ }                                                                     " Change tmux theme to be consistent with vim statusline
" NeoBundle 'mileszs/ack.vim', {
      " \ 'disabled' : !executable('ag') && !executable('ack') &&
      " \              !executable('ack-grep'),
      " \ }                                                                       " Text based search tool using ack
" let s:ack = neobundle#get('ack.vim')
" function! s:ack.hooks.on_source(bundle)
  " if executable('ag')
    " let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
    " let g:unite_source_grep_command = 'ag'
    " let g:unite_source_grep_default_opts =
          " \ '--nocolor --line-numbers --nogroup -S -C4'
    " let g:unite_source_grep_recursive_opt = ''
  " elseif executable('ack-grep')
    " NeoBundle 'mileszs/ack.vim'
    " let g:ackprg='ack-grep -H --nocolor --nogroup --column'
    " let g:unite_source_grep_command='ack'
    " let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
    " let g:unite_source_grep_recursive_opt=''
  " elseif executable('ack')
    " NeoBundle 'mileszs/ack.vim'
    " let g:unite_source_grep_command='ack'
    " let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
    " let g:unite_source_grep_recursive_opt=''
  " endif
" endfunction
" NeoBundle 'junegunn/fzf.vim', {
      " \ 'depends' : ['gunegunn/fzf'],
      " \ }
" NeoBundle 'junegunn/fzf'
" NeoBundle 'jistr/vim-nerdtree-tabs', {
      " \ 'depends' : ['scrooloose/nerdtree'],
      " \ }                                                                       " One NERDTree only, shared among buffers / tabs
" NeoBundle 'Shougo/vimfiler.vim', {
      " \   'commands' : [
      " \     { 'name' : ['VimFiler', 'Edit', 'Write'],
      " \       'complete' : 'customlist,vimfiler#complete' },
      " \     'Read',
      " \     'Source'
      " \   ],
      " \   'depends' : 'Shougo/unite.vim',
      " \   'disabled' : 1,
      " \   'explorer' : 1,
      " \   'lazy' : 1,
      " \   'mappings' : '<Plug>',
      " \   'recipe' : 'vimfiler',
      " \ }                                                                       " File explorer inside vim
" NeoBundle 'killphi/vim-textobj-signify-hunk', {
      " \ 'depends' : ['kana/vim-textobj-user'],
      " \ }                                                                       " Text object for a hunk of diffs
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/help.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                       " Syntax highlight for help file
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/hicolors.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                       " Shows highlighting colors in their own colors, plus a colorscheme editor
" NeoBundle 'vim-scripts/ShowMarks'                                               " Use gutter to show location of marks
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/HiMarks.vba.gz', {
      " \ 'depends' : ['ShowMarks'],
      " \ 'type' : 'vba',
      " \ }                                                                       " Highlights marks by using the signs feature
" NeoBundle 'bronson/vim-visual-star-search'                                      " Use * to search for selected text from visual mode
" NeoBundle 'ConradIrwin/vim-bracketed-paste'                                     " Automatically toggle paste mode when pasting in insert mode
" NeoBundle 'wincent/ferret'                                                      " Enhanced multi-file search for Vim
" NeoBundle 'wincent/vim-clipper'                                                 " Clipper integratino for Vim
" NeoBundle 'h1mesuke/unite-outline'
" NeoBundle 'Xuyuanp/nerdtree-git-plugin'
" NeoBundle 'mbbill/undotree'
" NeoBundle 'thinca/vim-unite-history'
" NeoBundle 'mattn/unite-gist'
" NeoBundle 'Shougo/unite-build'
" NeoBundle 'Shougo/unite-sudo'
" NeoBundle 'Shougo/unite-ssh'
" NeoBundle 'tsukkee/unite-help'
" NeoBundle 'kopischke/unite-spell-suggest'
" NeoBundle 'tyru/unite-screen.sh'
" NeoBundle 'tpope/vim-vinegar'                                                 " NERDTree enhancement
" NeoBundle 'eiginn/netrw'                                                      " NERDTree plugin for network
" let s:netrw = neobundle#get('netrw')
" function! s:netrw.hooks.on_source(bundle)
  " let g:netrw_altfile = 1
" endfunction
" NeoBundle 'osyo-manga/vim-over'                                               " Preview changes to be made
" let s:vimover = neobundle#get('vim-over')
" function! s:vimover.hooks.on_source(bundle)
  " map <leader>o :OverCommandLine<CR>
" endfunction
" NeoBundle 'wincent/Command-T'
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/DotFill.vba.gz', {
      " \ 'depends' : ['Align'],
      " \ 'type' : 'vba',
      " \ }                                                                     " Align the texts by repeatedly filling blanks with specified charater.
" NeoBundle 'godlygeek/tabular'
" NeoBundle 'junegunn/vim-easy-align'
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/hilinks.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                     " Highlight group of item under corsor is linked to
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                     " Commands for viewing man pages in vim
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/vissort.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                     " Allow sorting lines by using a visual block (column)
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/visincr.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                     " Increase integer values in visual block
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/AnsiEsc.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                     " TODO: Add comments
" NeoBundle 'http://www.drchip.org/astronaut/vim/vbafiles/LargeFile.vba.gz', {
      " \ 'type' : 'vba',
      " \ }                                                                     " Allows much quicker editing of large files, at the price of turning off events, undo, syntax highlighting, etc.
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
" NeoBundle 'vim-scripts/mark'                                                  " Highlight multiple patterns with different color
" let s:mark = neobundle#get('mark')
" function! s:mark.hooks.on_source(bundle)
  " nnoremap <leader>mc :MarkClear<CR>
  " nnoremap <leader>m/ :Mark <C-R>/<CR>
" endfunction
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
" NeoBundle 'bronson/vim-trailing-whitespace'                                   " Highlight trailing whitespaces
" NeoBundle 'Chiel92/vim-autoformat'                                            " Easy code formatting with external formatter
" NeoBundle 'xolox/vim-easytags', {
      " \ 'depends' : 'xolox/vim-misc',
      " \ 'disabled' : executable('ctags')
      " \ }                                                                     " Vim integration with ctags
" NeoBundle 'majutsushi/tagbar', {
      " \ 'disabled' : executable('ctags')
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
" NeoBundle 'gregsexton/gitv', { 'depends' : 'tpope/vim-fugitive' }             " Git log viewer (Yet another gitk clone for Vim)
" NeoBundle 'kana/vim-operator-replace', {
      " \ 'depends' : 'kana/vim-operator-user'
      " \ }                                                                     " Vim operator for replace
" NeoBundle 'Shougo/neocomplcache.vim'
" NeoBundle 'Rip-Rip/clang_complete', {
      " \ 'autoload' : { 'filetypes' : ['cpp', 'c'] },
      " \ 'lazy' : 1,
      " \ }                                                                     " Completion for c-family language
" NeoBundle 'tyru/restart.vim', {
      " \ 'autoload' : { 'commands' : 'Restart' },
      " \ 'gui' : 1,
      " \ 'lazy' : 1,
      " \ }                                                                     " Restart gVim
" NeoBundle 'justinmk/vim-sneak'                                                " Easy motion within one line
" NeoBundle 'MattesGroeger/vim-bookmarks'
" NeoBundle 'sjl/gundo.vim'                                                     " Visualize undo tree
" NeoBundle 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
" NeoBundle 'edkolev/promptline.vim'
" let g:tmuxline_theme = 'airline'
" let g:tmuxline_preset = 'tmux'
" NeoBundle 'airblade/vim-gitgutter'}                                           " Prefer vim-signify
" NeoBundle 'myusuf3/numbers.vims'                                              " Automatically toggle line number for certain filetypes
" let s:numbers = neobundle#get('numbers.vim')
" function! s:numbers.hooks.on_source(bundle)
  " let g:numbers_exclude = [
        " \ 'unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m']
" endfunction
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
" NeoBundle 'mattn/vim-airline-weather'                                         " Vim airline extension to show weather
" let g:weather#area='Sunnyvale'

" NeoBundle 'KabbAmine/vCoolor.vim'                                             " Color picker in gvim
" NeoBundle 'sheerun/vim-polyglot'                                              " Language packs
" NeoBundle 'gabesoft/vim-ags', { 'disabled' : !executable('ag') }
" NeoBundle 'aperezdc/vim-template'
" NeoBundle 'Shougo/neosnippet.vim', { 'disabled' : has('python') }             " Snippet support for vim
" NeoBundle 'Shougo/neosnippet-snippets', { 'depends' : ['neosnippet.vim'] }
" NeoBundle 'tpope/vim-dispatch'                                                " Run command asyncroneously in vim
" NeoBundle 'janko-m/vim-test'                                                  " Run tests at different granularity for different languages
" NeoBundle 'calebsmith/vim-lambdify'
" NeoBundle 'chrisbra/vim-diff-enhanced'                                        " Enhanced vimdiff
" NeoBundle 'tpope/vim-speeddating'
" NeoBundle 'chrisbra/NrrwRgn'
" NeoBundle 'vitalk/vim-onoff'                                                  " Mapping for toggle vim option on and off
" NeoBundle 'benmills/vimux'                                                    " Interact with tmux from vim
" NeoBundle 'Shougo/vimshell.vim', { 'recipe' : 'vimshell.vim' }                " Shell implemented with vimscript
" let s:vimshell = neobundle#get('vimshell.vim')
" function! s:vimshell.hooks.on_source(bundle)
  " let g:vimshell_popup_command = 'belowright split'
  " let g:vimshell_popup_height = 20
" endfunction
" NeoBundle 'danro/rename.vim'                                                  " Rename the underlying filename of the buffer
" NeoBundle 'xolox/vim-shell', { 'depends' : 'xolox/vim-misc' }                 " Better integration between vim and shell
" NeoBundle 'mattn/gist-vim', {'depends' : 'mattn/webapi-vim'}                  " Post, view and edit gist in vim
" NeoBundle 'Keithbsmiley/gist.vim'                                             " Use gist from vim
" NeoBundle 'Shougo/vinarise.vim', {
      " \ 'recipe' : 'vinarise.vim',
      " \ }                                                                     " Ultimate hex editing system with vim
" NeoBundle 'glts/vim-radical'                                                  " Show number under cursor in hex, octal, binary
" NeoBundle 'glts/vim-magnum'                                                   " Big integer library for vim
" NeoBundle 'tpope/vim-eunuch'                                                  " Vim sugar for the UNIX shell commands that need it the most
" NeoBundle 'vim-scripts/scratch.vim'                                           " Creates a scratch buffer
" NeoBundle 'kana/vim-submode'                                                  " Supporting defining submode in vim
" NeoBundle 'kana/vim-arpeggio'                                                 " Define keymappings start with simultaneous key presses
" NeoBundle 'kana/vim-nickblock'                                                " Make visual block mode more useful
" NeoBundle 'kana/vim-fakeclip'                                                 " Fake clipboard for vim
" NeoBundle 'tyru/emap.vim'                                                     " Extensible mappings
" NeoBundle 'Raimondi/VimRegEx.vim'                                             " Regex dev and test env in vim
" NeoBundle 'Shougo/echodoc.vim'                                                " Displays information in echo area from echodoc plugin
" NeoBundle 'guns/xterm-color-table.vim'                                        " Show xterm color tables in vim
" NeoBundle 'tpope/vim-abolish.git'                                             " Creates set of abbreviations for spell correction easily
" NeoBundle 'chrisbra/Colorizer'                                                " Highlight hex / color name with the actual color
" NeoBundle 'gorodinskiy/vim-coloresque'
" NeoBundle 'vim-jp/vital.vim'
" NeoBundle 'Shougo/eev.vim'                                                    " Evaluate vimscript one liner

" NeoBundle 'jceb/vim-orgmode'
" NeoBundle 'tyru/winmove.vim'
" NeoBundle 'tyru/wim'
" NeoBundle 'tomtom/tlib_vim'
" NeoBundle 'tomtom/ttoc_vim', {
      " \ 'depends' : 'tomtom/tlib_vim'
      " \ }                                                                       " A regexp-based table of contents of the current buffer for vim
" NeoBundle 'tomtom/tcomment_vim', {
      " \ 'depends' : 'tomtom/tlib_vim'
      " \ }                                                                     " Add comments
" NeoBundle 'rhysd/libclang-vim'
" NeoBundle 'szw/vim-ctrlspace'                                                 " Vim workspace manager
" NeoBundle 'Rykka/clickable-things'
" NeoBundle 'Rykka/clickable.vim', {
      " \ 'depends' : ['Rykka/os.vim','Rykka/clickable-things']
      " \ }
" let s:clickable = neobundle#get('clickable.vim')
" function! s:clickable.hooks.on_source(bundle)
  " call os#init()
  " let g:clickable_browser = 'google-chrome'
" endfunction
" NeoBundle 'bruno-/vim-vertical-move'                                          " Move in visual block mode as much as possible
" NeoBundle 'dhruvasagar/vim-prosession', { 'depends': 'tpope/vim-obsession' }
" NeoBundle 'dhruvasagar/vim-dotoo'
" NeoBundle 'gelguy/Cmd2.vim'                                                   " cmdline-mode enhancement for vim
" NeoBundle 'gcmt/taboo.vim'
" NeoBundle 'akesling/ondemandhighlight'
" NeoBundle 'neitanod/vim-ondemandhighlight'
" NeoBundle 'thinca/vim-localrc', { 'type' : 'svn' }                            " Enable vim configuration file for each directory
" NeoBundle 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim', {
      " \ 'script_type' : 'plugin'
      " \ }                                                                     " For ruby development
" NeoBundle 'vimwiki/vimwiki', { 'rtp': '~/.vim/bundle/vimwiki/src' }
" }}}
" Wrap up bundle setup {{{1
call neobundle#end()
NeoBundleCheck
call glaive#Install()
call myutils#InitUndoSwapViews()
colorscheme solarized
" }}}
" Settings {{{1
filetype plugin indent on                                                       " Automatically detect file types.
syntax on                                                                       " Syntax highlighting
set autoindent                                                                  " Indent at the same level of the previous line
set autoread                                                                    " Automatically load changed files
set autowrite                                                                   " Automatically write a file when leaving a modified buffer
set background=dark                                                             " Assume a dark background
set backspace=indent,eol,start                                                  " Backspace for dummies
set backup                                                                      " Whether saves a backup before editing
set cursorline                                                                  " Highlight current line
set expandtab                                                                   " Tabs are spaces, not tabs
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
set wrapscan                                                                    " Make regex search wrap to the start of the file
set comments=sl:/*,mb:*,elx:*/                                                  " auto format comment blocks

if &diff
  set nospell                                                                   " No spellcheck
else
  set spell                                                                     " Spellcheck
endif

if has ('x11') && (g:OS.is_linux || g:OS.is_mac)                                " On Linux and mac use + register for copy-paste
  " Remember to install clipit in ubuntu
  if empty($SSH_OS)
    set clipboard=unnamedplus
  else
    set clipboard=unnamed                                                       " use * register to pass the content back to ssh client
  endif
else                                                                            " On Windows, use * register for copy-paste
  set clipboard=unnamed
endif
" }}}
