FILES=$(shell echo .??*)
EXCES=.DS_Store .git

all: help

copy: $(foreach f, $(filter-out $(EXCES), $(FILES)), copy-$(f))

install: $(foreach f, $(filter-out $(EXCES), $(FILES)), link-$(f))

.PHONY: clean
clean: $(foreach f, $(filter-out $(EXCES), $(FILES)), unlink-$(f))

copy-%: %
	@rm -rf $(HOME)/$<
	@cp -f -R $(CURDIR)/$< $(HOME)/$<
	@printf "Create Copy %-15s => %-30s\n" $< $(HOME)/$<

link-%: %
	@ln -snf $(CURDIR)/$< $(HOME)/$<
	@printf "Create Symlink %-15s => %-30s\n" $< $(HOME)/$<

unlink-%: %
	@rm -rf $(HOME)/$<
	@echo "Remove $(HOME)/$<"

#vim: clean
vim:
	@rm -rf $(HOME)/.vimrc
	@cp -f -R $(CURDIR)/.vimrc.ext $(HOME)/.vimrc

work:
	@rm -rf $(HOME)/.vimrc
	@ln -snf $(CURDIR)/.vimrc.ex $(HOME)/.vimrc

help:
	@echo 'make         -> show this help'
	@echo 'make copy    -> create copy files'
	@echo 'make install -> create symlink files'
	@echo 'make clean   -> remove the files'
	@echo 'make vim     -> create vimrc.ex as vimrc'
