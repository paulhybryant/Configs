"=============================================================================
" Google.vim --- Google layer for SpaceVim
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


function! SpaceVim#layers#google#plugins() abort
  let plugins = []
  return plugins
endfunction

function! SpaceVim#layers#google#config() abort
  if filereadable('/usr/share/vim/google/google.vim')
    source /usr/share/vim/google/google.vim
    Glug magic
  endif
endfunction
