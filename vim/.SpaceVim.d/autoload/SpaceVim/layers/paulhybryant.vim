"=============================================================================
" paulhybryant.vim --- My private layer for SpaceVim
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


function! SpaceVim#layers#paulhybryant#plugins() abort
  let plugins = []
  call add(plugins, ['altercation/vim-colors-solarized', {'merged' : 0}])
  call add(plugins, ['vim-airline/vim-airline', {'merged' : 0}])
  call add(plugins, ['vim-airline/vim-airline-themes', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#paulhybryant#config() abort
  let g:solarized_diffmode = "high"

  let g:airline_detect_paste = 1
  let g:airline_detect_modified = 1
  let g:airline_theme = 'powerlineish'
  let g:airline_powerline_fonts = 1
endfunction
