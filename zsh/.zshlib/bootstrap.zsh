# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

function bootstrap() {
  setopt localoptions err_return

  [[ $# -eq 1 ]]
  source "$1/init.zsh"
  source "$1/base.zsh"
  source "$1/configs.zsh"
  source "$1/file.zsh"
  source "$1/io.zsh"
  source "$1/os.zsh"

  configs::bootstrap
  io::msg "Installing ${BREWVERSION} dependencies..."
  os::LINUX && sudo apt-get install build-essential curl git m4 ruby texinfo \
    libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev \
    trash-cli clipit xclip x11-xkb-utils

  if ! base::exists "${BREWHOME}"; then
    io::msg "Cloning ${BREWVERSION}"
    git clone "https://github.com/Homebrew/${BREWVERSION}" "${BREWHOME}"
  fi

  brew install coreutils stow
  io::msg "Creating symlinks with stow"
  mkdir -p "$HOME/.tmux/plugins"
  for module in misc tmux tmuxinator vim x11 zsh; do
    stow "${module}"
  done

  io::msg "Tapping extra repositories"
  brew tap paulhybryant/myformulae
  brew tap homebrew/x11
  brew tap homebrew/dupes
  brew tap homebrew/completions
  brew tap iveney/mocha

  io::msg "Installing softwares"
  brew install --HEAD paulhybryant/myformulae/powerline-shell \
    paulhybryant/myformulae/zsh-completions
  brew install --with-gssapi --with-libssh2 --with-rtmpdump curl
  brew install --disable-nls --override-system-vi --with-client-server \
    --with-lua --with-luajit --with-gui vim
  brew install brew-gem cmake ctags git htop python python3 \
    the_silver_searcher tmux vimpager zsh netcat dos2unix
  brew gem install tmuxinator npm
  brew install --HEAD vimdoc vroom
  npm install -g urchin

  os::OSX && io::msg "Installing extra stuff for OSX" && \
    brew install brew-cask clipper macvim trash lsof \
    reattach-to-user-namespace paulhybryant/myformulae/gnu-getopt

  pip install powerline-status advanced-ssh-config neovim Terminator

  io::msg "All Done!"
}

setopt local_options
bootstrap "${0:a:h}"
