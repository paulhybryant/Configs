"=============================================================================
" paulhybryant.vim --- My private layer for SpaceVim
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


function! s:VimColorsSolarized() abort
  let g:solarized_diffmode = "high"
endfunction

function! s:VimAirline() abort
  let g:airline_detect_paste = 1
  let g:airline_detect_modified = 1
  let g:airline_theme = 'powerlineish'
  let g:airline_powerline_fonts = 1
endfunction

function! SpaceVim#layers#paulhybryant#plugins() abort
  let plugins = []
  call add(plugins, ['vim-airline/vim-airline', {
        \ 'merged' : 0,
        \ 'hook_source': function('s:VimAirline')
        \ }])
  call add(plugins, ['vim-airline/vim-airline-themes', {
        \ 'merged' : 0,
        \ }])
  call add(plugins, ['altercation/vim-colors-solarized', {
        \ 'merged' : 0,
        \ 'hook_source': function('s:VimColorsSolarized')
        \ }])
  return plugins
endfunction


function! SpaceVim#layers#paulhybryant#config() abort
endfunction
