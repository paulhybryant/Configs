# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: functions.zsh - My autoload functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

# library functions {{{
: <<=cut
=item Function C<time::getmtime>

Get last modification time of a file.
$1 Filename

@return string of the last modified time of a file.
=cut

: <<=cut
=item Function C<base::sourced>

$1 Absolute path to the file to be sourced.

@return 0 or 1, indicates whether latest version of this file is sourced.
=cut

: <<=cut
=item Function C<strings::strip-slash>

Strip trailing slash in the string.

$1 The string to apply the strip operation

@return the result string after stripping
=cut

: <<=cut
=item Function C<strings::join>

Join string with delimiter and prefix.

@return The resulting string after joining.
=cut

: <<=cut
=item Function C<shell::eval>

Eval the strings, and output logs based on verbose level.

@return NULL
=cut

: <<=cut
=item Function C<shell::exists>

Examples
  shell::exists --var "VAR"

Check whether something 'exists'

$1 The thing to be checked whether it exists.

@return 0 or 1. 0 exists, 1 not exists.
=cut

: <<=cut
=item Function C<io::yes_or_no>

Gets yes or no reply from user.

@return 0 if yes, 1 otherwise.
=cut

: <<=cut
=item Function C<io::vlog>

Print log message based on verbose level.

$1 Verbose level
$2 Message

@return NULL
=cut

: <<=cut
=item Function C<mode::verbose>

Whether the specified verbose level is satisfied

$1 Verbose level

@return 0 if satisfied, 1 otherwise
=cut

: <<=cut
=item Function C<mode::set_verbose>

Set verbose level of shell.

@return NULL
=cut

: <<=cut
=item Function C<mode::dryrun>

Whether it is in dryrun mode.

@return 0 if it is dryrun mode, 1 otherwise.
=cut

: <<=cut
=item Function C<mode::toggle_dryrun>

Toggle dryrun mode

@return NULL
=cut

: <<=cut
=item Function C<mode::set_dryrun>

Set dryrun mode to true

@return NULL
=cut

: <<=cut
=item Function C<time::human-readable-date>

Print time in human readable format.

$1 Current time in seconds since epoch

@return string in human readable format for the specified time.
=cut

: <<=cut
=item Function C<time::_seconds>

Print current time in seconds since epoch.

@return string of current time in seconds since epoch
=cut
# }}}
# colors utils {{{
: <<=cut
=item Function C<colors::define>

Define color env variables.

@return NULL
=cut

: <<=cut
=item Function C<colors::manpage>

Make man page colorful.

@return NULL
=cut
# }}}
# file utils {{{
: <<=cut
=item Function C<file::find-ignore-dir>

Find in current directory, with dir $1 ignored.
TODO: Make $1 an array, and ignore a list of dirs.

$1 The directory to ignore.

@return NULL
=cut

: <<=cut
=item Function C<file::find-ignore-git>

Find in current directory, with dir .git ignored.
A shortcut for file::find-ignore-dir for git.

@return NULL
=cut

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

: <<=cut
=item Function C<file::ls>

List files in long format.

@return NULL
=cut
# }}}
# git utils {{{
: <<=cut
=item Function C<git::check-dirty-repos>

Check subdirs of current directory, and report repos that are dirty
Number of arguments accepted: --no-detached

@return NULLPTR
=cut

: <<=cut
=item Function C<git::has-branch>

Whether a branch exists in current depo.

@return 0 if exists, 1 otherwise.
=cut

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

: <<=cut
=item Function C<git::new-workdir>

Create a new git working dir based on existing repo, and create a new branch in
the new workign dir.

$1 Source git working directory
$2 New git working directory
$3 New branch name

@return NULL
=cut

: <<=cut
=item Function C<git::submodule-url>

List of url of all submodules.

@return NULL
=cut

: <<=cut
=item Function C<git::submodule-mv>

Move submodule with a single command.

@return NULL
=cut
# }}}
# misc utils {{{
: <<=cut
=item Function C<util::geoinfo>

Get the geo location information.

@return list of values for requested fields.
=cut

: <<=cut
=item Function C<util::start-ssh-agent>

Start ssh agent if not yet.

@return NULL
=cut

: <<=cut
=item Function C<util::ta>

Tmux attach wrapper, which updates tmux environment as configured.

@return NULL
=cut

: <<=cut
=item Function C<util::histgrep>

Grep in reverse order in history.

@return NULL
=cut

: <<=cut
=item Function C<util::setup-abbrevs>

Setup zsh abbreviations.

@return NULL
=cut

: <<=cut
=item Function C<util::vim>

Open files with vim in a single vim instance in one tmux window.

@return NULL
=cut

: <<=cut
=item Function C<util::gvim>

Open files with gvim in a single gvim instance.

@return NULL
=cut

: <<=cut
=item Function C<util::check-test-coverage>

Check test coverage for zsh functions.

@return NULL
=cut
# }}}
# net utils {{{
: <<=cut
=item Function C<net::external-ip>

Get the external ip address for current host.

@return string of external ip address.
=cut

: <<=cut
=item Function C<net::ssh>

Utility function that set some env variables by default when connected through ssh.
Arguments will be passed through to ssh

@return NULL
=cut

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
# }}}

: <<=cut
=back
=cut
