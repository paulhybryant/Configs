FROM linuxbrew/brew

MAINTAINER paulhybryant <paulhybryant@gmail.com>

ENV TZ 'Asia/Chongqing'

USER root
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y iputils-ping stow vim tmux \
      zsh locales jq silversearcher-ag locate gawk python-pip trash-cli \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 \
    && curl -L https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb -o /tmp/bat.deb \
    && dpkg -i /tmp/bat.deb \
    && curl -L 'http://paulhybryant.myqnapcloud.com:8880/kodexplorer/index.php?user/publicLink&fid=1a13Nx54XO5WUkiKaT9fg-iVHIAImculBfkfpcunXXynpMMZdYRQ7lVv5tEfo4pJAnf7ajS7UiJE2oVy8X8FA2hixDn6HL4n9KGYIrQJPlCzsDVPUF-NBtlMj3EEJYJwkoQd022x76byYxsTtJ4-TCtWL2lfEvZh3Q&file_name=/fsqlf_20181130-1_amd64.deb' -o /tmp/fsqlf.deb \
    && dpkg -i /tmp/fsqlf.deb
USER linuxbrew
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/paulhybryant/dotfiles/master/install.sh)" \
    && curl -L https://github.com/junegunn/fzf/archive/0.17.5.tar.gz -o /tmp/fzf.tgz \
    && tar -xzvf /tmp/fzf.tgz -C /tmp \
    && /tmp/fzf-0.17.5/install --bin --64 --no-bash --no-zsh --no-fish --no-update-rc --no-completion --no-key-bindings \
    && mv /tmp/fzf-0.17.5/bin/fzf /home/linuxbrew/.linuxbrew/bin \
    && curl -L https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz -o /tmp/ccat.tgz \
    && tar -xzvf /tmp/ccat.tgz -C /tmp && mv /tmp/linux-amd64-1.1.0/ccat /home/linuxbrew/.linuxbrew/bin \
    && vim -c 'set nomore' -c 'NeoBundleInstall' -c 'q'
COPY linuxbrew.zsh /tmp
RUN /tmp/linuxbrew.zsh
CMD ["exec", "/home/linuxbrew/.linuxbrew/bin/zsh"]
