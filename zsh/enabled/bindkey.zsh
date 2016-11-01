# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# bindkey '^[OD' beginning-of-line                                              # Set left arrow as HOME
# bindkey '^[OC' end-of-line                                                    # Set right arrow as END
bindkey "[1;5D" beginning-of-line                                             # Set ctrl + left arrow as HOME
bindkey "[1;5C" end-of-line                                                   # Set ctrl + right arrow as END
bindkey -s 'OM' ''                                                          # Let enter in numeric keypad work as newline (return)
bindkey -r '^S'                                                                 # By default <C-S> is bind to self-insert, which presents vim from getting the combination.
autoload -Uz up-line-or-beginning-search                                        # Put cursor at end of line when using Up for command history
zle -N up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search                                      # Put cursor at end of line when using Down for command history
zle -N down-line-or-beginning-search
# bindkey '^R' history-incremental-pattern-search-backward                        # Search history backward incrementally
# bindkey '\C-R' history-incremental-pattern-search-backward                    # Search history backward incrementally
# bindkey 'r' history-incremental-pattern-search-backward                     # Search history backward incrementally
# bindkey -s 'd' ''
# bindkey -s 'z' ''
# bindkey -s 'c' ''
bindkey '^[[A' up-line-or-beginning-search                                      # Up
bindkey '^[[B' down-line-or-beginning-search                                    # Down
# bindkey '^I' expand-or-complete-prefix
# bindkey '^[[3~' delete-char
bindkey '\C-n' menu-complete
bindkey '\C-p' reverse-menu-complete
bindkey '^_' undo
bindkey '^B' vi-quoted-insert                                                   # Use ^B as ^V with which we can see the keycodes
