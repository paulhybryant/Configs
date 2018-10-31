# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell
declare -U path manpath fpath
# Previusly brew failed to update if nix is enabled and sets SSL_CERT_FILE.
# source ${HOME}/.nix-profile/etc/profile.d/nix.sh
if [[ "${OSTYPE}" == "darwin"* ]]; then
  declare -xg BREWVERSION="homebrew" BREWHOME="/usr/local" CMDPREFIX="g"
else
  declare -xg BREWVERSION="linuxbrew" BREWHOME="${HOME}/.linuxbrew" CMDPREFIX=""
fi
declare -xg EDITOR='vim' VISUAL="vim" LANG='en_US.UTF-8' \
  PYTHONSTARTUP="${HOME}/.pythonrc" GOPATH="${BREWHOME}/opt/go/libexec" \
  HOMEBREW_NO_AUTO_UPDATE=1
path=(~/.local/bin ${BREWHOME}/bin ${BREWHOME}/sbin ${path[@]})
manpath=(${BREWHOME}/share/man)
infopath=(${BREWHOME}/share/info)
unset SSL_CERT_FILE

# coreutils
alias date='${CMDPREFIX}\date'
alias dircolors='${CMDPREFIX}\dircolors'
alias ls='${CMDPREFIX}\ls --color=auto'
alias mktemp='${CMDPREFIX}\mktemp'
alias stat='${CMDPREFIX}\stat'
alias tac='${CMDPREFIX}\tac'
# path=(${BREWHOME}/opt/coreutils/libexec/gnubin ${path[@]})

# gnu-sed
alias sed='${CMDPREFIX}\sed'
# path=(${BREWHOME}/opt/gnu-sed/libexec/gnubin ${path[@]})

# gnu-which
alias which='${CMDPREFIX}\which'

# gnu-tar
alias tar='${CMDPREFIX}\tar'
# path=(${BREWHOME}/opt/gnu-tar/libexec/gnubin ${path[@]})

# findutils
alias find='${CMDPREFIX}\find'
alias locate='${CMDPREFIX}\locate'
alias updatedb='${CMDPREFIX}\updatedb'
alias xargs='${CMDPREFIX}\xargs'
# path=(${BREWHOME}/opt/findutils/libexec/gnubin ${path[@]})

[[ -f ~/.local/.zshenv ]] && source ~/.local/.zshenv                            # Local configurations
