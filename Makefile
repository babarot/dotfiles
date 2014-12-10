RSYNC_OPTS = --exclude ".git/" --exclude ".DS_Store" --exclude "README.md" --exclude="Makefile" -avh --no-perms
DOTFILES_DIR = $(PWD)
FILES_TO_BE_LINKED = .??* bin
DOTFILES_FILE = $(addprefix $(DOTFILES_DIR)/, $(FILES_TO_BE_LINKED))

all:
	help

help:
	@echo "make list             #=> list the files"
	@echo "make deploy           #=> create symlink"
	@echo "make update           #=> fetch changes"
	@echo "make install          #=> setup environment"
	@echo "make clean            #=> remove the files"

list:
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(val);)

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


update:
	git pull origin master
	git submodule init
	git submodule update
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
