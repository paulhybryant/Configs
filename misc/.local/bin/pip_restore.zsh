#!/usr/bin/env zsh

pip install --upgrade -r /dev/stdin <<EOF
futures==3.0.5
greenlet==0.4.11
jedi==0.9.0
mercurial==4.0.1
msgpack-python==0.4.8
neovim==0.1.12
pdb-clone==1.10
pip-autoremove==0.9.0
pipdeptree==0.8.0
powerline-status==2.5
pyclewn==2.3
six==1.10.0
trash-cli==0.12.9.14.post0
trollius==2.1
EOF

pip3 install --upgrade -r /dev/stdin <<EOF
gnureadline==6.3.3
greenlet==0.4.11
msgpack-python==0.4.8
neovim==0.1.12
xonsh-apt-tabcomplete==0.1.4
xonsh-autoxsh==0.2
xontrib-prompt-ret-code==1.0.1
xontrib-z==0.2
EOF
