# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Expansion and Globbing
setopt BAD_PATTERN
setopt CASEMATCH                                                                # Whether regex comparison (e.g. =~) will match case
setopt NO_NOMATCH                                                               # pass through '*' if globbing fails
setopt NO_WARN_CREATE_GLOBAL

# Input/Output
setopt ALIASES
setopt CORRECT
setopt NO_FLOW_CONTROL
setopt INTERACTIVE_COMMENTS                                                     # Escape commands so I can use them later
setopt PRINT_EXIT_VALUE                                                         # Alert me if something's failed
setopt RC_QUOTES
setopt SHORT_LOOPS

# Job Control
setopt CHECK_JOBS
setopt NOHUP                                                                    # Don't kill background jobs when I logout
setopt LONG_LIST_JOBS
setopt MONITOR

# Prompting
setopt PROMPT_BANG
setopt PROMPT_CR                                                                # Default on, resulting in a carriage return ^M when enter on the numeric pad is pressed.
setopt PROMPT_PERCENT
setopt PROMPT_SUBST

# Scripts and Functions
setopt C_BASES
setopt NO_ERR_RETURN                                                            # Enable this would break completion!
setopt FUNCTION_ARGZERO
setopt NO_SOURCE_TRACE
setopt NO_XTRACE

# Shell Emulation
setopt NO_CONTINUE_ON_ERROR
# setopt RC_EXPAND_PARAM                                                        # Causing zplug to not use cache file

# General
setopt BRACE_CCL          # Allow brace character class list expansion.
setopt COMBINING_CHARS    # Combine zero-length punctuation characters (accents)
                          # with the base character.
setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt MAIL_WARNING     # Don't print a warning message if a mail file has been accessed.

# Jobs
setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.
