RSYNC_OPTS = --exclude ".git/" --exclude ".DS_Store" --exclude "README.md" --exclude="Makefile" -avh --no-perms
DOTFILES_DIR = $(PWD)
FILES_TO_BE_LINKED = .??* bin
DOTFILES_FILE = $(addprefix $(DOTFILES_DIR)/, $(FILES_TO_BE_LINKED))

all:
	help

help:
	@echo "make list             #=> ls -A"
	@echo "make deploy           #=> create symlink"
	@echo "make rsync            #=> copy files by rsync"
	@echo "make mini             #=> copy minimal rc files"
	@echo "make update           #=> git pull origin master"
	@echo "make install          #=> setup environment"
	@echo "make clean            #=> rm -rf all files"

list:
	@ls -A

deploy:
	@echo "Start deploy dotfiles current directory."
	@echo "If this is \"dotdir\", curretly it is ignored and copy your hand."
	@echo ""
	@for f in $(FILES_TO_BE_LINKED) ; do \
		test "$${f}" = .git -o "$${f}" = .git/ && continue ; \
		test "$${f}" = .DS_Store  && continue ; \
		echo "$${f}" | grep -q 'minimal' && continue ; \
		ln -sfnv "$(PWD)/$${f}" "$(HOME)/$${f}" ; \
	done ; true

sync:
	rsync $(RSYNC_OPTS) . ~;

update:
	git pull origin master
	git submodule foreach git pull origin master

install:
	@for x in ./etc/init/*.sh ; do bash $$x 2>/dev/null; done; true
ifeq ($(shell uname),Darwin)
	@for x in ./etc/osx/*.sh ; do bash $$x 2>/dev/null; done; true
endif

clean:
	@echo "rm -rf files..."
	@for f in .??* ; do \
		rm -v -rf ~/"$${f}" ; \
	done ; true
	rm -rf ~/.vim
	rm -rf ~/.vital
	rm -rf $(DOTFILES_DIR)
