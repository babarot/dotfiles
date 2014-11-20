MANPAGES   ?= *.1
PREFIX     ?= /usr/local
MKPATH     ?= mkdir -p
INSTALL    ?= install
INSTALLMAN ?= ${INSTALL} -m 444 -v
RM         := rm -f

all: install

uninstall:
	$(RM) ${PREFIX}/share/man/man1/noc.1

install:
	${MKPATH} ${PREFIX}/share/man/man1
	@for f in $(MANPAGES); do \
		${INSTALLMAN} "$$f" ${PREFIX}/share/man/man1/"$$f"; \
	done; true

.PHONY: all install uninstall
