# Links into ~ are made by home-manager (nix/home/dotfiles.nix)

.DEFAULT_GOAL := help

all: brew

brew: ## Install Homebrew (darwin-rebuild installs the apps)
	@sh ./etc/scripts/brew.sh

new-shell: ## Run ghostty with zsh
	ghostty --command=/bin/zsh

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
