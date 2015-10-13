# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: init.zsh - Library source guard implementation.

=head1 DESCRIPTION

The library file will be sourced, if it has not been sourced before or modified
since last time it was sourced. A guard variable will be defined, with the value
of the concatenation of the file path and modification time (kind of as a
signature) when this file is sourced to avoid sourcing it repetitively.

Put the following boilerplate at the start of all library files.

    source init.zsh
    base::sourced "${0:a}" && return

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

: <<=cut
=back
=cut
