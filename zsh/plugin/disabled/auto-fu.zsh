# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

zstyle ':completion:*' completer _oldlist _complete
hooks-add-hook zle_line_init_hook auto-fu-init
hooks-define-hook zle-keymap-select
hooks-add-hook zle_keymap_select_hook auto-fu-zle-keymap-select
