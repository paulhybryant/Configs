set NEWPROFILE="D:\Users\Yu"

mklink %USERPROFILE%\.vimrc %~dp0%\.vimrc
mklink %USERPROFILE%\.gvimrc %~dp0%\.gvimrc
mklink %USERPROFILE%\.vimrc.local %~dp0%\.vimrc.personal
mklink %USERPROFILE%\.gitconfig %~dp0%\..\misc\.gitconfig-windows
mklink /J %USERPROFILE%\Notes %~dp0%\..\notes
mklink /J %USERPROFILE%\.ctagscnf %~dp0%\..\ctags

mklink %USERPROFILE%\.bashrc %NEWPROFILE%\.bashrc
mklink %USERPROFILE%\.bash_history %NEWPROFILE%\.bash_history
mklink /J %USERPROFILE%\.vim %NEWPROFILE%\.vim
mklink /J %USERPROFILE%\.vimbackup %NEWPROFILE%\.vimbackup
mklink /J %USERPROFILE%\.vimswap %NEWPROFILE%\.vimswap
mklink /J %USERPROFILE%\.vimundo %NEWPROFILE%\.vimundo
mklink /J %USERPROFILE%\.vimviews %NEWPROFILE%\.vimviews
mklink /J %USERPROFILE%\.ssh %NEWPROFILE%\.ssh
mklink /J %USERPROFILE%\.cache %NEWPROFILE%\.cache
