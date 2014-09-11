RSYNC_OPTS = --exclude ".git/" --exclude ".DS_Store" --exclude "README.md" --exclude="Makefile" -avh --no-perms
DOTFILES   = $(PWD)

all: help

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
	@for f in .??* ; do \
		test "$${f}" = .git -o "$${f}" = .git/ && continue ; \
		test "$${f}" = .DS_Store  && continue ; \
		echo "$${f}" | grep -q 'minimal' && continue ; \
		ln -sfnv "$(PWD)/$${f}" "$(HOME)/$${f}" ; \
	done ; true

sync:
	rsync $(RSYNC_OPTS) . ~;

mini:
	@for x in .*.minimal; do \
		rm -rf  ~/"$${x%.*}"; \
		cp -v -f "$(PWD)/$$x" ~/"$${x%.*}"; \
	done ; true

update:
	#git fetch && git merge origin/master
	git pull origin master

install:
	#@for x in init/*.sh ; do sh $$x; done
ifeq ($(shell uname),Darwin)
	@for x in {osx,init}/*.sh ; do sh $$x; done
endif

clean:
	@echo "rm -rf files..."
	@for f in .??* ; do \
		rm -v -rf ~/"$${f}" ; \
	done ; true
	rm -rf ~/.vim
	rm -rf ~/.vital
	rm -rf $(DOTFILES)
