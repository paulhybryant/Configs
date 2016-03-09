" vim: ft=vim sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell

" Auto copy the mouse selection
noremap <LeftRelease> "+y<LeftRelease>

let g:solarized_termcolors=256
set guioptions-=T                                                               " Remove the toolbar
set guioptions-=m                                                               " Remove the menu
set guioptions-=r                                                               " Remove right-hand scrollbar
set lines=60                                                                    " 60 lines of text instead of 24
set columns=160                                                                 " 160 columns of text instead of 80
" set term=builtin_ansi                                                         " Make arrow and other keys work
if has('gui_gtk2')
  set guifont=Source\ Code\ Pro\ for\ Powerline\ Bold\ 11
elseif has('gui_macvim')
  " set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
  set guifont=Source\ Code\ Pro\ for\ Powerline:h13
  set transparency=5                                                            " Make the window slightly transparent
elseif has('gui_win32')
  set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
endif

if neobundle#is_installed('vim-vtd') && &background == 'light'
  hi! Ignore guifg=#FDF6E3
else
  hi! Ignore guifg=#002B36
endif

if neobundle#is_sourced('vimutils')
  for i in range(1,9)
    execute 'silent! nmap <silent> <unique> <M-'
      \ . i . '> <Plug>AirlineSelectTab' . i
  endfor
endif
