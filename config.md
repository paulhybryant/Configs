Configurations
==========
* Disable sticky edges between monitors
* Disable overlay Scrollbars: `gsettings set com.canonical.desktop.interface scrollbar-mode normal`
* Fix flickering terminal

    `cd /tmp`

    `wget https://rapture-prod.corp.google.com/pool/nvidia-perf-switcher_1.3_all_83f800242c1dff0b17f6fb9f0f1a0585b239555bf1dfce876da61c4430530a7f.deb`

    `sudo dpkg -i nvidia-perf-switcher_1.3_all_83f800242c1dff0b17f6fb9f0f1a0585b239555bf1dfce876da61c4430530a7f.deb`

    `nohup nvidia-perf-switcher &`

* Disable defalut keymapping for alt+space. Set it for synapse.
* Change Alt+Tab behavior [instructions](http://askubuntu.com/questions/68151/how-do-i-revert-alt-tab-behavior-to-switch-between-windows-on-the-current-worksp).
* Keyboard shortcut for moving window between screens by enabling put in CCSM under window management [instructions](http://askubuntu.com/questions/152304/send-or-move-a-window-from-one-monitor-to-another-with-a-shortcut-key-under-ubun).
* Enable window always on top [instructions](http://askubuntu.com/questions/126233/how-to-set-a-shortcut-for-always-on-top-for-window). Install compiz-plugins-extra and enable Extra WM Actions in CCSM.

Install
==========
* terminator
* tmux from source (libevent-dev, automake)
* powerline-shell
* powerline
* checkinstall
* automake
* python-pip
* ag (the silver searcher, libpcre3-dev, liblzma)
* vim-gtk (update alternatives for vim, gvim, vimdiff etc.)
* compizconfig-settings-manager

Manual Install
==========
* unity-tweak-tool
* synergy
* sogou pinyin
* tmuxinator
* compizconfig-settings-manager
* vim-pager (git clone git://github.com/rkitover/vimpager)
* uudecode (sudo apt-get install sharutils)

Misc
==========
xmodmap for using Mode_switch + hjkl to simulate vim keys. Need to run `xmodmap ~/.xmodmap` to make the key map effective. Original link [here](http://shellhell.wordpress.com/2012/01/31/hello-world/)
