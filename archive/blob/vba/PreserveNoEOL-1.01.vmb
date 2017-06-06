" Vimball Archiver by Charles E. Campbell
UseVimball
finish
autoload/escapings.vim	[[[1
288
" escapings.vim: Common escapings of filenames, and wrappers around new Vim 7.2
" fnameescape() and shellescape() functions.
"
" Copyright: (C) 2009-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	012	14-Dec-2012	Add escapings#autocmdescape().
"	011	05-Apr-2010	Add escapings#shellcmdescape().
"	010	12-Feb-2010	BUG: Emulation of shellescape(..., {special})
"				escaped wrong characters (e.g. ' \<[') via
"				fnameescape() and the escaping was done
"				inconsistently though only 9 lines apart.
"				Corrected and factored out the characters into
"				l:specialShellescapeCharacters.
"	009	27-Aug-2009	BF: Characters '[{$' must not be escaped on
"				Windows. Adapted pattern in
"				escapings#fnameescape() and
"				escapings#fnameunescape(). (This caused
"				ingobuffer#MakeScratchBuffer() to create an "foo
"				\[Scratch]" buffer on an unpatched Vim 7.1.)
"	008	19-Aug-2009	BF: escapings#shellescape() caused E118 on Vim
"				7.1. The shellescape({string}) function exists
"				since Vim 7.0.111, but shellescape({string},
"				{special}) was only introduced with Vim 7.2.
"				Now calling the one-argument function if no
"				{special} argument, and (crudely) emulating the
"				two-argument function for Vim versions that only
"				have the one-argument function.
"	007	27-May-2009	escapings#bufnameescape() now automatically
"				expands a:filespec to the required full absolute
"				filespec in the (default) full match mode.
"				BF: ',' must not be escaped in
"				escapings#bufnameescape(); it only has special
"				meaning inside { }, which never occurs in the
"				escaped pattern.
"	006	26-May-2009	escapings#fnameescape() emulation part now works
"				like fnameescape() on Windows: Instead of
"				converting backslashes to forward slashes, they
"				are not escaped. (But on non-Windows systems,
"				they are.)
"				Added and refined escapings#fnameunescape() from
"				dropquery.vim.
"	005	02-Mar-2009	Now explicitly checking for the new escape
"				functions instead of assuming they're in Vim 7.2
"				so that users of a patched Vim 7.1 also get the
"				benefit of them.
"	004	25-Feb-2009	Now using character list from ':help
"				fnameescape()' (plus converting \ to /).
"	003	17-Feb-2009	Added optional a:isFullMatch argument to
"				escapings#bufnameescape().
"				Cleaned up documentation.
"	002	05-Feb-2009	Added improved version of escapings#exescape()
"				that relies on fnameescape() to properly escape
"				all special Ex characters.
"	001	05-Jan-2009	file creation

function! s:IsWindowsLike()
    return has('dos16') || has('dos32') || has('win95') || has('win32') || has('win64')
endfunction

function! escapings#bufnameescape( filespec, ... )
"*******************************************************************************
"* PURPOSE:
"   Escape a normal filespec syntax so that it can be used for the bufname(),
"   bufnr(), bufwinnr(), ... commands.
"   Ensure that there are no double (back-/forward) slashes inside the path; the
"   anchored pattern doesn't match in those cases!
"
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	    normal filespec
"   a:isFullMatch   Optional flag whether only the full filespec should be
"		    matched (default=1). If 0, the escaped filespec will not be
"		    anchored.
"* RETURN VALUES:
"   Filespec escaped for the buf...() commands.
"*******************************************************************************
    let l:isFullMatch = (a:0 ? a:1 : 1)

    " For a full match, the passed a:filespec must be converted to a full
    " absolute path (with symlinks resolved, just like Vim does on opening a
    " file) in order to match.
    let l:escapedFilespec = (l:isFullMatch ? resolve(fnamemodify(a:filespec, ':p')) : a:filespec)

    " Backslashes are converted to forward slashes, as the comparison is done with
    " these on all platforms, anyway (cp. :help file-pattern).
    let l:escapedFilespec = tr(l:escapedFilespec, '\', '/')

    " Special file-pattern characters must be escaped: [ escapes to [[], not \[.
    let l:escapedFilespec = substitute(l:escapedFilespec, '[\[\]]', '[\0]', 'g')

    " The special filenames '#' and '%' need not be escaped when they are anchored
    " or occur within a longer filespec.
    let l:escapedFilespec = escape(l:escapedFilespec, '?*')

    " I didn't find any working escaping for {, so it is replaced with the ?
    " wildcard.
    let l:escapedFilespec = substitute(l:escapedFilespec, '[{}]', '?', 'g')

    if l:isFullMatch
	" The filespec must be anchored to ^ and $ to avoid matching filespec
	" fragments.
	return '^' . l:escapedFilespec . '$'
    else
	return l:escapedFilespec
    endif
endfunction

function! escapings#exescape( command )
"*******************************************************************************
"* PURPOSE:
"   Escape a shell command (potentially consisting of multiple commands and
"   including (already quoted) command-line arguments) so that it can be used in
"   ex commands. For example: 'hostname && ps -ef | grep -e "foo"'.
"
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:command	    Shell command-line.
"
"* RETURN VALUES:
"   Escaped shell command to be passed to the !{cmd} or :r !{cmd} commands.
"*******************************************************************************
    if exists('*fnameescape')
	return join(map(split(a:command, ' '), 'fnameescape(v:val)'), ' ')
    else
	return escape(a:command, '\%#|' )
    endif
endfunction

function! escapings#fnameescape( filespec )
"*******************************************************************************
"* PURPOSE:
"   Escape a normal filespec syntax so that it can be used in ex commands.
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	    normal filespec
"* RETURN VALUES:
"   Escaped filespec to be passed as a {file} argument to an ex command.
"*******************************************************************************
    if exists('*fnameescape')
	return fnameescape(a:filespec)
    else
	" Note: On Windows, backslash path separators and some other Unix
	" shell-specific characters mustn't be escaped.
	return escape(a:filespec, " \t\n*?`%#'\"|!<" . (s:IsWindowsLike() ? '' : '[{$\'))
    endif
endfunction

function! escapings#fnameunescape( exfilespec, ... )
"*******************************************************************************
"* PURPOSE:
"   Converts the passed a:exfilespec to the normal filespec syntax (i.e. no
"   escaping of ex special chars like [%#]). The normal syntax is required by
"   Vim functions such as filereadable(), because they do not understand the
"   escaping for ex commands.
"   Note: On Windows, fnamemodify() doesn't convert path separators to
"   backslashes. We don't force that neither, as forward slashes work just as
"   well and there is even less potential for problems.
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:exfilespec    Escaped filespec to be passed as a {file} argument to an ex
"		    command.
"   a:isMakeFullPath	Flag whether the filespec should also be expanded to a
"			full path, or kept in whatever form it currently is.
"* RETURN VALUES:
"   Unescaped, normal filespec.
"*******************************************************************************
    let l:isMakeFullPath = (a:0 ? a:1 : 0)
    return fnamemodify( a:exfilespec, ':gs+\\\([ \t\n*?`%#''"|!<' . (s:IsWindowsLike() ? '' : '[{$\') . ']\)+\1+' . (l:isMakeFullPath ? ':p' : ''))
endfunction

function! escapings#shellescape( filespec, ... )
"*******************************************************************************
"* PURPOSE:
"   Escape a normal filespec syntax so that it can be used in shell commands.
"   The filespec will be quoted properly.
"   When the {special} argument is present and it's a non-zero Number, then
"   special items such as "!", "%", "#" and "<cword>" will be preceded by a
"   backslash.  This backslash will be removed again by the |:!| command.
"
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	    normal filespec
"   a:special	    Flag whether special items will be escaped, too.
"
"* RETURN VALUES:
"   Escaped filespec to be used in a :! command or inside a system() call.
"*******************************************************************************
    let l:isSpecial = (a:0 ? a:1 : 0)
    let l:specialShellescapeCharacters = "\n%#'!"
    if exists('*shellescape')
	if a:0
	    if v:version < 702
		" The shellescape({string}) function exists since Vim 7.0.111,
		" but shellescape({string}, {special}) was only introduced with
		" Vim 7.2. Emulate the two-argument function by (crudely)
		" escaping special characters for the :! command.
		return shellescape((l:isSpecial ? escape(a:filespec, l:specialShellescapeCharacters) : a:filespec))
	    else
		return shellescape(a:filespec, l:isSpecial)
	    endif
	else
	    return shellescape(a:filespec)
	endif
    else
	let l:escapedFilespec = (l:isSpecial ? escape(a:filespec, l:specialShellescapeCharacters) : a:filespec)

	if s:IsWindowsLike()
	    return '"' . l:escapedFilespec . '"'
	else
	    return "'" . l:escapedFilespec . "'"
	endif
    endif
endfunction

function! escapings#shellcmdescape( command )
"******************************************************************************
"* PURPOSE:
"   Wrap the entire a:command in double quotes on Windows.
"   This is necessary when passing a command to cmd.exe which has arguments that
"   are enclosed in double quotes, e.g.
"	""%SystemRoot%\system32\dir.exe" /B "%ProgramFiles%"".
"
"* EXAMPLE:
"   execute '!' escapings#shellcmdescape(escapings#shellescape($ProgramFiles .
"   '/foobar/foo.exe', 1) . ' ' . escapings#shellescape(args, 1))
"
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:command	    Single shell command, with optional arguments.
"		    The shell command should already have been escaped via
"		    shellescape().
"* RETURN VALUES:
"   Escaped command to be used in a :! command or inside a system() call.
"******************************************************************************
    return (s:IsWindowsLike() ? '"' . a:command . '"' : a:command)
endfunction

function! escapings#autocmdescape( filespec )
"******************************************************************************
"* PURPOSE:
"   Escape a normal filespec syntax so that it can be used in an :autocmd.
"* ASSUMPTIONS / PRECONDITIONS:
"   None.
"* EFFECTS / POSTCONDITIONS:
"   None.
"* INPUTS:
"   a:filespec	    Normal filespec or file pattern.
"* RETURN VALUES:
"   Escaped filespec to be passed as a {pat} argument to :autocmd.
"******************************************************************************
    let l:filespec = a:filespec

    if s:IsWindowsLike()
	" Windows: Replace backslashes in filespec with forward slashes.
	" Otherwise, the autocmd won't match the filespec.
	let l:filespec = tr(l:filespec, '\', '/')
    endif

    " Escape spaces in filespec.
    " Otherwise, the autocmd will be parsed wrongly, taking only the first part
    " of the filespec as the file and interpreting the remainder of the filespec
    " as part of the command.
    return escape(l:filespec, ' ')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
autoload/PreserveNoEOL.vim	[[[1
62
" PreserveNoEOL.vim: Preserve missing EOL at the end of text files.
"
" DEPENDENCIES:
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.005	26-Apr-2013	Factor out s:ErrorMsg().
"				Receive possible error message from
"				g:PreserveNoEOL_Function and print it here
"				centrally, instead of having all strategies do
"				that on their own.
"	004	25-Mar-2012	Add :SetNoEOL command.
"	003	23-Mar-2012	Rename b:preservenoeol to b:PreserveNoEOL.
"	002	18-Nov-2011	Switched interface of Preserve() to pass
"				pre-/post-write flag instead of filespec.
"	001	18-Nov-2011	file creation

function! s:ErrorMsg( text )
    let v:errmsg = a:text
    echohl ErrorMsg
    echomsg v:errmsg
    echohl None
endfunction

function! PreserveNoEOL#HandleNoEOL( isPostWrite )
    if PreserveNoEOL#Info#IsPreserve()
	" The user has chosen to preserve the missing EOL in the last line.
	let l:errmsg = call(g:PreserveNoEOL_Function, [a:isPostWrite])
	if ! empty(l:errmsg)
	    call s:ErrorMsg("Failed to preserve 'noeol': " . l:errmsg)
	endif
    elseif a:isPostWrite
	" The buffer write has appended the missing EOL in the last line. Vim
	" does not reset 'noeol', but I prefer to have it reflect the actual
	" file status, so that a custom 'statusline' can have a more meaningful
	" status.
	setlocal eol
    endif
endfunction

function! PreserveNoEOL#SetPreserve( isSet )
    if &l:binary
	call s:ErrorMsg('This is a binary file')
    elseif &l:eol
	if a:isSet
	    setlocal noeol
	    let b:PreserveNoEOL = 1
	    echomsg 'This file will be written without EOL'
	else
	    call s:ErrorMsg('This file has a proper EOL ending')
	endif
    else
	let b:PreserveNoEOL = 1
	echomsg 'Missing EOL will be preserved'
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
autoload/PreserveNoEOL/Executable.vim	[[[1
47
" PreserveNoEOL/Executable.vim: Preserve EOL implementation via external "noeol"
" executable.
"
" DEPENDENCIES:
"   - PreserveNoEOL.vim autoload script
"   - "noeol" helper executable.
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.004	26-Apr-2013	Return the potential error message;
"				PreserveNoEOL#HandleNoEOL will print it.
"	003	23-Mar-2012	Renamed from noeol.vim to Executable.vim.
"	002	18-Nov-2011	Switched interface of Preserve() to pass
"				pre-/post-write flag instead of filespec.
"	001	18-Nov-2011	file creation

function! PreserveNoEOL#Executable#Preserve( isPostWrite )
    if ! a:isPostWrite
	return ''
    endif

    let l:filespec = expand('<afile>')

    " Using the system() command even though we're not interested in the command
    " output. This is because on Windows GVIM, the system() call does not
    " (briefly) open a Windows shell window, but ':silent !{cmd}' does. system()
    " also does not unintentionally trigger the 'autowrite' feature.
    let l:shell_output = system(g:PreserveNoEOL_Command . ' ' . escapings#shellescape(l:filespec))

    if v:shell_error != 0
	return (empty(l:shell_output) ? v:shell_error : l:shell_output)
    endif

    " Even though the file was changed outside of Vim, this doesn't seem to
    " trigger the |timestamp| "file changed" warning, probably because Vim
    " doesn't regard the change in the final EOL as a change. (The help text
    " says Vim re-reads in to a hidden buffer, so it probably doesn't even see
    " the change.)
    " Therefore, no :checktime / temporary setting of 'autoread' is necessary.
    return ''
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
autoload/PreserveNoEOL/Info.vim	[[[1
24
" PreserveNoEOL/Info.vim: Preserve EOL information for use in statusline etc.
"
" DEPENDENCIES:
"
" Copyright: (C) 2011-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	23-Mar-2012	Rename preservenoeol flag to PreserveNoEOL.
"	001	18-Nov-2011	file creation

function! PreserveNoEOL#Info#IsPreserve()
    if exists('b:PreserveNoEOL')
	return !! b:PreserveNoEOL
    elseif exists('g:PreserveNoEOL')
	return !! g:PreserveNoEOL
    else
	return 0
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
autoload/PreserveNoEOL/Internal.vim	[[[1
84
" PreserveNoEOL/Internal.vim: Internal pure Vimscript implementation of Preserve EOL.
"
" DEPENDENCIES:
"
" Copyright: (C) 2011-2013 Ingo Karkat and the authors of the Vim Tips Wiki page
" "Preserve missing end-of-line at end of text files", which is licensed under
"   Creative Commons Attribution-Share Alike License 3.0 (Unported) (CC-BY-SA)
"   http://creativecommons.org/licenses/by-sa/3.0/
"
" Source: http://vim.wikia.com/wiki/Preserve_missing_end-of-line_at_end_of_text_files

" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
" 1.00.002	26-Apr-2013	Handle any Vim exception that may arise, and
"				return it; PreserveNoEOL#HandleNoEOL will print
"				it.
"	001	18-Nov-2011	file creation

" Preserve noeol (missing trailing eol) when saving file. In order
" to do this we need to temporarily 'set binary' for the duration of
" file writing, and for DOS line endings, add the CRs manually.
" For Mac line endings, also must join everything to one line since it doesn't
" use a LF character anywhere and 'binary' writes everything as if it were Unix.

" This works because 'eol' is set properly no matter what file format is used,
" even if it is only used when 'binary' is set.

fun! s:TempSetBinaryForNoeol()
  let s:save_binary = &binary
  if ! &eol && ! &binary
    let s:save_view = winsaveview()
    setlocal binary
    if &ff == "dos" || &ff == "mac"
      if line('$') > 1
        undojoin | exec "silent 1,$-1normal! A\<C-V>\<C-M>"
      endif
    endif
    if &ff == "mac"
      undojoin | %join!
      " mac format does not use a \n anywhere, so we don't add one when writing
      " in binary (which uses unix format always). However, inside the outer
      " if statement, we already know that 'noeol' is set, so no special logic
      " is needed.
    endif
  endif
endfun

fun! s:TempRestoreBinaryForNoeol()
  if ! &eol && ! s:save_binary
    if &ff == "dos"
      if line('$') > 1
        " Sometimes undojoin gives errors here, even when it shouldn't.
        " Suppress them for now...if you can figure out and fix them instead,
        " please update http://vim.wikia.com/wiki/VimTip1369
        silent! undojoin | silent 1,$-1s/\r$//e
      endif
    elseif &ff == "mac"
      " Sometimes undojoin gives errors here, even when it shouldn't.
      " Suppress them for now...if you can figure out and fix them instead,
      " please update http://vim.wikia.com/wiki/VimTip1369
      silent! undojoin | silent %s/\r/\r/ge
    endif
    setlocal nobinary
    call winrestview(s:save_view)
  endif
endfun

function! PreserveNoEOL#Internal#Preserve( isPostWrite )
  try
    if a:isPostWrite
      call s:TempRestoreBinaryForNoeol()
    else
      call s:TempSetBinaryForNoeol()
    endif
    return ''
  catch /^Vim\%((\a\+)\)\=:E/
    " v:exception contains what is normally in v:errmsg, but with extra
    " exception source info prepended, which we cut away.
    return substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
  endtry
endfunction

" vim: set ts=8 sts=2 sw=2 expandtab ff=unix fdm=syntax :
autoload/PreserveNoEOL/Perl.vim	[[[1
101
" PreserveNoEOL/Perl.vim: Preserve EOL Perl implementation.
"
" DEPENDENCIES:
"   - Vim with built-in Perl support.
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	26-Apr-2013	Return the potential error message;
"				PreserveNoEOL#HandleNoEOL will print it.
"	001	23-Mar-2012	file creation

if ! has('perl')
    finish
endif

if ! exists('s:isPerlInitialized')
    perl << EOF
package PreserveNoEOL;

# XXX: Use of autodie failed with "Can't call method "isa" on an undefined
# value at C:/ProgramData/Perl5.12/perl/lib/autodie/exception.pm line 672."
# instead of throwing an exception. Do explicit "or die()" checks instead.

sub noeol
{
    eval
    {
	my $perms;
	my $file = VIM::Eval('expand("<afile>")');

	if (! -w $file && VIM::Eval('v:cmdbang') == 1) {
	    # Unlike Vim with :write!, Perl cannot open a read-only file for
	    # writing. Being invoked here means that Vim was able to
	    # successfully write the file itself, so we should be able to
	    # temporarily lift the read-only flag, too.
	    my $mode = (stat($file))[2] or die "Can't stat: $!";
	    $perms = sprintf('%04o', $mode & 07777);
	    chmod 0777, $file or die "Can't remove read-only flag: $!";
	}

	open $fh, '+>>', $file or die "Can't open file: $!";
	my $pos = tell $fh;
	$pos > 0 or exit;
	my $len = ($pos >= 2 ? 2 : 1);
	sysseek $fh, $pos - $len, 0 or die "Can't seek to end: $!";
	sysread $fh, $buf, $len or die 'No data to read?';

	if ($buf eq "\r\n") {
	    # print "truncate DOS-style CR-LF\n";
	    truncate $fh, $pos - 2 or die "Can't truncate: $!";
	} elsif(substr($buf, -1) eq "\n") {
	    # print "truncate Unix-style LF\n";
	    truncate $fh, $pos - 1 or die "Can't truncate: $!";
	} elsif(substr($buf, -1) eq "\r") {
	    # print "truncate Mac-style CR\n";
	    truncate $fh, $pos - 1 or die "Can't truncate: $!";
	}
	close $fh or die "Can't close file: $!";

	if ($perms != undef) {
	    chmod $perms, $file or die "Can't restore read-only flag: $!";
	    my $mode2 = (stat($file))[2] or die "Can't stat: $!";
	    my $perms2 = sprintf('%04o', $mode2 & 07777);
	    if ($perms2 ne $perms) {
		# XXX: Somehow, on Strawberry Perl 5.12.3 on Windows Vista
		# and Vim 7.3/x86, the permissions won't change back, even
		# outside Vim. But somehow this can be worked around by
		# invoking another :perl?!
		#VIM::DoCommand("echomsg 'I need the read-only fix'");
		VIM::DoCommand("perl chmod $perms, '$file' or die \"Can't restore read-only flag: \$!\"");
	    }
	}
    };
    $@ =~ s/'/''/g;
    VIM::DoCommand("let perl_errmsg = '$@'");
}
EOF
    let s:isPerlInitialized = 1
endif
function! PreserveNoEOL#Perl#Preserve( isPostWrite )
    if ! a:isPostWrite
	return ''
    endif

    let l:perl_errmsg = ''
    perl PreserveNoEOL::noeol
    return l:perl_errmsg

    " Even though the file was changed outside of Vim, this doesn't seem to
    " trigger the |timestamp| "file changed" warning, probably because Vim
    " doesn't regard the change in the final EOL as a change. (The help text
    " says Vim re-reads in to a hidden buffer, so it probably doesn't even see
    " the change.)
    " Therefore, no :checktime / temporary setting of 'autoread' is necessary.
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
autoload/PreserveNoEOL/Python.vim	[[[1
89
" PreserveNoEOL/Python.vim: Preserve EOL Python implementation.
"
" DEPENDENCIES:
"   - Vim with built-in Python support.
"
" Source:
"   http://stackoverflow.com/a/1663283/813602
"
" Copyright: (C) 2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.01.004	26-Apr-2013	Support traditional Mac (CR) line endings, too.
"   1.00.003	26-Apr-2013	Return the potential error message;
"				PreserveNoEOL#HandleNoEOL will print it.
"	002	06-Jan-2013	Complete implementation.
"	001	05-Jan-2013	file creation

if ! has('python')
    finish
endif

if ! exists('s:isPythonInitialized')
    python << EOF
import os, stat, sys
import vim

def trunc(file, new_len):
    file_mode = os.stat(file)[0]
    is_temp_writable = False
    if (not file_mode & stat.S_IWRITE) and vim.eval("v:cmdbang") == "1":
	# Unlike Vim with :write!, Python cannot open a read-only file for
	# writing. Being invoked here means that Vim was able to
	# successfully write the file itself, so we should be able to
	# temporarily lift the read-only flag, too.
	os.chmod(file, stat.S_IWRITE)
	is_temp_writable = True

    # Open with mode "append" so that we have permission to modify.
    # Cannot open with mode "write" because that clobbers the file!
    f = open(file, "ab")
    f.truncate(new_len)
    f.close()

    if is_temp_writable:
	os.chmod(file, file_mode)

def noeol():
    try:
	file = vim.eval('expand("<afile>")')

	# Must have mode "binary" to allow f.seek() with negative offset.
	f = open(file, "rb")
	f.seek(-2, os.SEEK_END)  # Seek to two bytes before EOF
	end_pos = f.tell()
	last_line = f.read()
	f.close()

	if last_line.endswith("\r\n"):
	    trunc(file, end_pos)
	elif last_line.endswith("\n"):
	    trunc(file, end_pos + 1)
	elif last_line.endswith("\r"):
	    trunc(file, end_pos + 1)
    except Exception as e:
	vim.command("let python_errmsg = '%s'" % str(e).replace("'", "''"))
EOF
    let s:isPythonInitialized = 1
endif
function! PreserveNoEOL#Python#Preserve( isPostWrite )
    if ! a:isPostWrite
	return ''
    endif

    let l:python_errmsg = ''
    python noeol()
    return l:python_errmsg

    " Even though the file was changed outside of Vim, this doesn't seem to
    " trigger the |timestamp| "file changed" warning, probably because Vim
    " doesn't regard the change in the final EOL as a change. (The help text
    " says Vim re-reads in to a hidden buffer, so it probably doesn't even see
    " the change.)
    " Therefore, no :checktime / temporary setting of 'autoread' is necessary.
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
plugin/PreserveNoEOL.vim	[[[1
104
" PreserveNoEOL.vim: Preserve missing EOL at the end of text files.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - PreserveNoEOL.vim autoload script
"   - escapings.vim autoload script
"   - a Preserve implementation like the PreserveNoEOL/Executable.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.009	06-Jan-2013	Add (and prefer) embedded Python implementation.
"	008	25-Mar-2012	Add :SetNoEOL command.
"	007	23-Mar-2012	Add embedded Perl implementation and favor that
"				one if Vim is built with Perl support, since it
"				avoids the shell invocation and doesn't directly
"				mess with Vim's buffer contents.
"	006	23-Mar-2012	Renamed noeol.vim autoload script to
"				Executable.vim.
"	005	02-Mar-2012	FIX: Vim 7.0/1 need preloading of functions
"				referenced in Funcrefs.
"	004	18-Nov-2011	Moved default location of "noeol" executable to
"				any 'runtimepath' directory.
"	003	18-Nov-2011	Switched interface of Preserve() to pass
"				pre-/post-write flag instead of filespec.
"				Add BufWritePre hook to enable pure Vimscript
"				implementation.
"	002	18-Nov-2011	Separated preserve information, (auto)command
"				implementation functions and the strategy for
"				the actual preserve action into dedicated
"				autoload scripts.
"	001	16-Nov-2011	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_PreserveNoEOL') || (v:version < 700)
    finish
endif
let g:loaded_PreserveNoEOL = 1

"- configuration ---------------------------------------------------------------

function! s:DefaultCommand()
    let l:noeolCommandFilespec = get(split(globpath(&runtimepath, 'noeol'), "\n"), 0, '')

    " Fall back to (hopefully) locating this somewhere on $PATH.
    let l:noeolCommandFilespec = (empty(l:noeolCommandFilespec) ? 'noeol' : l:noeolCommandFilespec)

    let l:command = escapings#shellescape(l:noeolCommandFilespec)

    if has('win32') || has('win64')
	" Only Unix shells can directly execute the Perl script through the
	" shebang line; Windows needs an explicit invocation through the Perl
	" interpreter.
	let l:command = 'perl ' . l:command
    endif

    return l:command
endfunction
if ! exists('g:PreserveNoEOL_Command')
    let g:PreserveNoEOL_Command = s:DefaultCommand()
endif
delfunction s:DefaultCommand

if ! exists('g:PreserveNoEOL_Function')
    if v:version < 702
	" Vim 7.0/1 need preloading of functions referenced in Funcrefs.
	runtime autoload/PreserveNoEOL/Executable.vim
	runtime autoload/PreserveNoEOL/Internal.vim
	runtime autoload/PreserveNoEOL/Perl.vim
	runtime autoload/PreserveNoEOL/Python.vim
    endif

    if has('python')
	let g:PreserveNoEOL_Function = function('PreserveNoEOL#Python#Preserve')
    elseif has('perl')
	let g:PreserveNoEOL_Function = function('PreserveNoEOL#Perl#Preserve')
    elseif empty(g:PreserveNoEOL_Command)
	let g:PreserveNoEOL_Command = function('PreserveNoEOL#Internal#Preserve')
    else
	let g:PreserveNoEOL_Function = function('PreserveNoEOL#Executable#Preserve')
    endif
endif



"- autocmds --------------------------------------------------------------------

let s:isNoEOL = 0
augroup PreserveNoEOL
    autocmd!
    autocmd BufWritePre  * let s:isNoEOL = (! &l:eol && ! &l:binary) | if s:isNoEOL | call PreserveNoEOL#HandleNoEOL(0) | endif
    autocmd BufWritePost *                                             if s:isNoEOL | call PreserveNoEOL#HandleNoEOL(1) | endif
augroup END


"- commands --------------------------------------------------------------------

command! -bar PreserveNoEOL call PreserveNoEOL#SetPreserve(0)
command! -bar SetNoEOL      call PreserveNoEOL#SetPreserve(1)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
doc/PreserveNoEOL.txt	[[[1
161
*PreserveNoEOL.txt*     Preserve missing EOL at the end of text files.

		       PRESERVE NOEOL    by Ingo Karkat
							   *PreserveNoEOL.vim*
description			|PreserveNoEOL-description|
usage				|PreserveNoEOL-usage|
installation			|PreserveNoEOL-installation|
configuration			|PreserveNoEOL-configuration|
integration			|PreserveNoEOL-integration|
limitations			|PreserveNoEOL-limitations|
known problems			|PreserveNoEOL-known-problems|
todo				|PreserveNoEOL-todo|
history				|PreserveNoEOL-history|

==============================================================================
DESCRIPTION					   *PreserveNoEOL-description*

This plugin causes Vim to omit the final newline (<EOL>) at the end of a
text file when you save it, if it was missing when the file was read. If the
file was read with <EOL> at the end, it will be saved with one. If it was read
without one, it will be saved without one.

Some (arguably broken) Windows applications (also several text editors) create
files without a final <EOL>, so if you have to interoperate with those, or
want to keep your commits to revision control clean of those changes, this
plugin is for you.

This works for all three line ending styles which Vim recognizes: DOS
(Windows), Unix, and traditional Mac. Multiple strategies are implemented to
handle these cases, so you can choose the one that fits you best.

HOW IT WORKS								     *

Except for the internal Vimscript implementation, all other strategies first
let Vim save the file as usual (with a final <EOL>), and then post-process (on
|BufWritePost|) the file contents, using file-system API functions to truncate
the final <EOL>.

RELATED WORKS								     *

The pure Vimscript implementation is based on the following VimTip:
    http://vim.wikia.com/wiki/Preserve_missing_end-of-line_at_end_of_text_files

==============================================================================
USAGE							 *PreserveNoEOL-usage*
							     *g:PreserveNoEOL*
If you always want to preserve a misssing <EOL> in text files, just put >
    :let g:PreserveNoEOL = 1
into your |vimrc| and you're done. If you need more fine-grained control or
want to just turn this on in particular situations, you can use the following
commands or the buffer-local flag |b:PreserveNoEOL|.

							      *:PreserveNoEOL*
:PreserveNoEOL		For the current buffer, the 'noeol' setting will be
			preserved on writes. (Normally, Vim only does this for
			'binary' files.) This has the same effect as setting
			the marker buffer variable: >
			    let b:PreserveNoEOL = 1
<								   *:SetNoEOL*
:SetNoEOL		When writing the current buffer, do not append an
			<EOL> at the end of the last line, even when there
			used to be one. Same as >
			    setlocal noeol | let b:PreserveNoEOL = 1
<
==============================================================================
INSTALLATION					  *PreserveNoEOL-installation*

This script is packaged as a |vimball|. If you have the "gunzip" decompressor
in your PATH, simply edit the *.vmb.gz package in Vim; otherwise, decompress
the archive first, e.g. using WinZip. Inside Vim, install by sourcing the
vimball or via the |:UseVimball| command. >
    vim PreserveNoEOL*.vmb.gz
    :so %
On Linux / Unix systems, you also have to make the "noeol" script executable: >
    :! chmod +x ~/.vim/noeol
<
To uninstall, use the |:RmVimball| command.

DEPENDENCIES					  *PreserveNoEOL-dependencies*

- Requires Vim 7.0 or higher.
- Vim with the Python (2.x) interface or the Perl interface (optional)
- System Perl interpreter (optional)

==============================================================================
CONFIGURATION					 *PreserveNoEOL-configuration*

For a permanent configuration, put the following commands into your |vimrc|:

						    *g:PreserveNoEOL_Function*
This plugin supports multiple strategies for keeping the <EOL> off of text
files:
When Vim is compiled with |+python| support, a Python function is used to
strip off the trailing newline after writing the buffer. This even works with
'readonly' files. >
    let g:PreserveNoEOL_Function = function('PreserveNoEOL#Python#Preserve')
When Vim is compiled with |+perl| support, a Perl function is used to strip
off the trailing newline after writing the buffer. This even works with
'readonly' files. >
    let g:PreserveNoEOL_Function = function('PreserveNoEOL#Perl#Preserve')
Without Perl support, an similar Perl script is invoked as an external
executable. This still requires an installed Perl interpreter, but no Perl
support built into Vim. >
    let g:PreserveNoEOL_Function = function('PreserveNoEOL#Executable#Preserve')
As a fallback, a pure Vimscript implementation can be used. This temporarily
sets the 'binary' option on each buffer write and messes with the line
endings. >
    let g:PreserveNoEOL_Function = function('PreserveNoEOL#Internal#Preserve')
<
						     *g:PreserveNoEOL_Command*
The processing can be delegated to an external executable named "noeol". It is
located in 'runtimepath' or somewhere on PATH. On Windows, this Perl script is
invoked through the Perl interpreter. You can use a different path or
executable via: >
    let g:PreserveNoEOL_Command = 'path/to/executable'
<
==============================================================================
INTEGRATION					   *PreserveNoEOL-integration*
							     *b:PreserveNoEOL*
You can influence the write behavior via the buffer-local variable
b:PreserveNoEOL. When this evaluates to true, a 'noeol' setting will be
preserved on writes.
You can use this variable in autocmds, filetype plugins or a local vimrc to
change the behavior for certain file types or files in a particular location.

					     *PreserveNoEOL#Info#IsPreserve()*
If you want to indicate (e.g. in your 'statusline') that the current file's
missing EOL will be preserved, you can use the PreserveNoEOL#Info#IsPreserve()
function, which returns 1 if the plugin will preserve it; 0 otherwise.

==============================================================================
LIMITATIONS					   *PreserveNoEOL-limitations*

KNOWN PROBLEMS					*PreserveNoEOL-known-problems*

TODO							  *PreserveNoEOL-todo*

IDEAS							 *PreserveNoEOL-ideas*

==============================================================================
HISTORY						       *PreserveNoEOL-history*

1.01	26-Apr-2013
In the Python strategy, support traditional Mac (CR) line endings, too.

1.00	26-Apr-2013
First published version.

0.01	16-Nov-2011
Started development.

==============================================================================
Copyright: (C) 2011-2013 Ingo Karkat and the authors of the Vim Tips Wiki page
"Preserve missing end-of-line at end of text files", which is licensed under
  Creative Commons Attribution-Share Alike License 3.0 (Unported) (CC-BY-SA)
  http://creativecommons.org/licenses/by-sa/3.0/
The VIM LICENSE applies to this plugin; see |copyright|.

Maintainer:	Ingo Karkat <ingo@karkat.de>
==============================================================================
 vim:tw=78:ts=8:ft=help:norl:
noeol	[[[1
35
#!/usr/bin/env perl
###############################################################################
##
# FILE:		noeol
# PRODUCT:	PreserveNoEOL.vim plugin
# AUTHOR:	Ingo Karkat <ingo@karkat.de>
# DATE CREATED:	16-Nov-2011
#
###############################################################################
#
# COPYRIGHT: (C) 2011-2013 Ingo Karkat
#   The VIM LICENSE applies to this script; see 'vim -c "help copyright"'.
#
# @(#)noeol	1.00.001	(26-Apr-2013)	tools
###############################################################################
use autodie qw(open sysseek sysread truncate);

my $file = shift;
open my $fh, '+>>', $file;
my $pos = tell $fh;
$pos > 0 or exit;
my $len = ($pos >= 2 ? 2 : 1);
sysseek $fh, $pos - $len, 0;
sysread $fh, $buf, $len or die 'No data to read?';

if ($buf eq "\r\n") {
    # print "truncate DOS-style CR-LF\n";
    truncate $fh, $pos - 2;
} elsif(substr($buf, -1) eq "\n") {
    # print "truncate Unix-style LF\n";
    truncate $fh, $pos - 1;
} elsif(substr($buf, -1) eq "\r") {
    # print "truncate Mac-style CR\n";
    truncate $fh, $pos - 1;
}
