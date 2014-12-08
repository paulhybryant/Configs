" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker filetype=vim nospell:

" Auto copy the mouse selection
noremap <LeftRelease> "+y<LeftRelease>

set guioptions-=T                                 " Remove the toolbar
set guioptions-=m                                 " Remove the menu
set guioptions-=r                                 " Remove right-hand scrollbar
set lines=60                                      " 40 lines of text instead of 24
set columns=160                                   " 160 columns of text instead of 80
if has("gui_gtk2")
  set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
elseif has("gui_mac")
  set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
elseif has("gui_win32")
  set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
endif
if has('gui_macvim')
  set transparency=5                              " Make the window slightly transparent
endif
let g:solarized_termcolors=256
colorscheme solarized

NeoBundle 'vim-scripts/SemanticHL'                " Semantic highlighting for C / C++

" set term=builtin_ansi                           " Make arrow and other keys work
