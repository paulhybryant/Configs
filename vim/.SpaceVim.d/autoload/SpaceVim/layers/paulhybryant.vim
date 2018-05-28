"=============================================================================
" paulhybryant.vim --- My private layer for SpaceVim
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


let g:solarized_diffmode = "high"
function! SpaceVim#layers#paulhybryant#plugins() abort
  let plugins = []
  call add(plugins, ['altercation/vim-colors-solarized', {'merged' : 0}])
  return plugins
endfunction
