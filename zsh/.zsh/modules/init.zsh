# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: functions.zsh - My autoload functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

source "${0:h}/options.zsh"
source "${0:h}/aliases.zsh"
source "${0:h}/keys.zsh"

source "${0:h}/util.zsh"

# net utils {{{
: <<=cut
=item Function C<net::external-ip>

Get the external ip address for current host.

@return string of external ip address.
=cut
autoload -Uz net::external-ip

: <<=cut
=item Function C<net::ssh>

Utility function that set some env variables by default when connected through ssh.
Arguments will be passed through to ssh

@return NULL
=cut
autoload -Uz net::ssh

: <<=cut
=item Function C<net::port-open>

Test whether a port / range of ports is / are open.

$1 Host address
$2 Port number

Example:
  net::port_open 127.0.0.1 80
  net::port_open 127.0.0.1 80 90
  net::port_open 127.0.0.1 80-90

@return 0 if the port is open on specified host, 1 otherwise.
=cut
autoload -Uz net::port-open

alias ssh='net::ssh'
# }}}
# colors utils {{{
[[ -f ~/.dircolors-solarized/dircolors.256dark ]] && \
  eval "$(${CMDPREFIX}dircolors $HOME/.dircolors-solarized/dircolors.256dark)"

: <<=cut
=item Function C<colors::define>

Define color env variables.

@return NULL
=cut
autoload -Uz colors::define && colors::define

: <<=cut
=item Function C<colors::manpage>

Make man page colorful.

@return NULL
=cut
autolaod -Uz colors::manpage && colors::manpage
# }}}
# git utils {{{
export GIT_EDITOR='vim'

: <<=cut
=item Function C<git::check-dirty-repos>

Check subdirs of current directory, and report repos that are dirty
Number of arguments accepted: --no-detached

@return NULLPTR
=cut
autoload -Uz git::check-dirty-repos

: <<=cut
=item Function C<git::has-branch>

Whether a branch exists in current depo.

@return 0 if exists, 1 otherwise.
=cut
autoload -Uz git::has-branch

: <<=cut
=item Function C<git::parent-branch>

# Get parent branch of a branch, defaults to current branch.
# How it works:
# 1| Display a textual history of all commits.
# 2| Ancestors of the current commit are indicated
#    by a star. Filter out everything else.
# 3| Ignore all the commits in the current branch.
# 4| The first result will be the nearest ancestor branch.
#    Ignore the other results.
# 5| Branch names are displayed [in brackets]. Ignore
#    everything outside the brackets, and the brackets.
# 6| Sometimes the branch name will include a ~2 or ^1 to
#    indicate how many commits are between the referenced
#    commit and the branch tip. We don't care. Ignore them.

@return NULL
=cut
autoload -Uz git::parent-branch

: <<=cut
=item Function C<git::new-workdir>

Create a new git working dir based on existing repo, and create a new branch in
the new workign dir.

$1 Source git working directory
$2 New git working directory
$3 New branch name

@return NULL
=cut
autoload -Uz git::new-workdir

: <<=cut
=item Function C<git::submodule-url>

List of url of all submodules.

@return NULL
=cut
autoload -Uz git::submodule-url

: <<=cut
=item Function C<git::submodule-mv>

Move submodule with a single command.

@return NULL
=cut
autoload -Uz git::submodule-mv
# }}}
# file system utils {{{
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
# }}}

: <<=cut
=back
=cut
