# need colors
# printf "\n${fg_bold[cyan]} ${SHELL} ${fg_bold[red]}${ZSH_VERSION}"
# printf "${fg_bold[cyan]} - DISPLAY on ${fg_bold[red]}${TMUX:+$(tmux -V)}${reset_color}\n\n"

export PATH=$HOME/dotfiles-2024/bin:$PATH
export WORKSPACE_ROOT=$HOME/Code/active_workspaces

export KUBECONFIG=~/.kube/config:$(find ~/.kube/contexts -type f -name '*_config' | tr '\n' ':')

neofetch

# /Users/panda/Code/active_workspace/.vscode
