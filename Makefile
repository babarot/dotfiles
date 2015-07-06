DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: install

test:
	@#prove $(PROVE_OPT) $(wildcard ./etc/test/*_test.pl)
	@#$(foreach val, $(PWD)/etc/test/sh/*_test.sh, echo $(val);)
	@#bash $(PWD)/etc/test/sh/test.sh
	@DOTPATH=$(PWD) bash $(PWD)/etc/test/test.sh

help:
	@echo "make list           #=> Show file list for deployment"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make deploy         #=> Create symlink to home directory"
	@echo "make init           #=> Setup environment settings"
	@echo "make install        #=> Run make update, deploy, init"
	@echo "make clean          #=> Remove the dotfiles and this repo"

list:
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(val);)

update:
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

deploy:
	@echo 'Copyright (c) 2013-2015 BABAROT All Rights Reserved.'
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

init:
	@#$(foreach val, $(wildcard ./etc/init/*.sh), DOTPATH=$(PWD) bash $(val);)
	@DOTPATH=$(PWD) bash $(PWD)/etc/init/init.sh

install: update deploy init
	@exec $$SHELL

clean:
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES_FILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(PWD)
