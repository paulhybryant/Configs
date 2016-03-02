# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# {
  # Compile the completion dump to increase startup speed.
  # zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  # if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    # zcompile "$zcompdump"
  # fi
# } &!
[[ -f ~/.zlogin.local ]] && source ~/.zlogin.local                              # Local configurations
