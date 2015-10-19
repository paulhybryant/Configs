# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: file.zsh - File system related utility functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

: <<=cut
=item Function C<file::find-ignore-dir>

Find in current directory, with dir $1 ignored.
TODO: Make $1 an array, and ignore a list of dirs.

$1 The directory to ignore.

@return NULL
=cut
autoload -Uz file::find-ignore-dir

: <<=cut
=item Function C<file::find-ignore-git>

Find in current directory, with dir .git ignored.
A shortcut for file::find-ignore-dir for git.

@return NULL
=cut
autoload -Uz file::find-ignore-git

: <<=cut
=item Function C<file::rm>

Use trash to remove files so it can be recovered!
Accepts rm arguments to be compatible wit rm.
Usually we define alias for it.

Examples
  source file.zsh
  alias rm=file::rm

Arguments
  Same as rm

@return NULL
=cut
autoload -Uz file::rm

: <<=cut
=item Function C<file::ls>

List files in long format.

@return NULL
=cut
autoload -Uz file::ls

alias la='file::ls -a'
alias ll='file::ls -l'
alias lla='file::ls -la'
alias ls='file::ls'
alias rm='file::rm'

: <<=cut
=back
=cut
