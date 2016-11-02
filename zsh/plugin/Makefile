all: pod2man runtests

ZSHFILES = $(wildcard doc/*.zsh)

pod2man:
	# @$(foreach f, $(ZSHFILES), pod2man $(f) > man/man1/`basename $(f)`.1;)
	# util::podgen lib/* man/man1/myfunc.1

runtests:
	urchin tests
