all: pod2man runtests

ZSHFILES = $(wildcard *.zsh)

pod2man:
	@$(foreach f,$(ZSHFILES),pod2man $(f) > man/man1/$(f).1;)

runtests:
	urchin tests
