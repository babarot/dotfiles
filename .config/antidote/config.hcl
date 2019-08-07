config {
  base = "/Users/b4b4r07/.antidote"

  command {
    path = "/Users/b4b4r07/bin"
  }
}

github "enhancd" {
  owner = "b4b4r07"
  repo  = "enhancd"

  plugin {
    sources = ["init.sh"]

    env = {
      ENHANCD_FILTER = "fzf --height 25% --reverse --ansi"
    }
  }
}

github "neovim" {
  description = "Vim-fork focused on extensibility and usability"

  owner = "neovim"
  repo  = "neovim"

  release {
    name = "nvim"
    tag  = "nightly"
  }

  command {
    link {
      from = "**/bin/nvim"
      to   = "vim"
    }
  }
}

github "jq" {
  description = "Command-line JSON processor"

  owner = "stedolan"
  repo  = "jq"

  release {
    name = "jq"
    tag  = "jq-1.6"
  }
}

gist "misc" {
  owner = "b4b4r07"
  id    = "79ee61f7c140c63d2786"
}

http "incr" {
  description = "http://mimosa-pudica.net/zsh-incremental.html"

  url    = "http://mimosa-pudica.net/src/incr-0.2.zsh"
  output = "incr-0.2.zsh"

  plugin {
    sources = []
  }
}

github "kubectx" {
  description = "Switch faster between clusters and namespaces in kubectl"

  owner = "ahmetb"
  repo  = "kubectx"

  command {
    link {
      from = "kubectx"
    }

    link {
      from = "kubens"
    }

    alias = {
      kctx = "kubectx"
      kns  = "kubens"
    }
  }
}

github "fzy" {
  owner = "jhawthorn"
  repo  = "fzy"

  command {
    build {
      steps = [
        "make",
        "sudo make install",
      ]
    }
  }
}

github "envchain" {
  owner = "sorah"
  repo  = "envchain"

  command {
    build {
      steps = [
        "make",
        "sudo make install",
      ]
    }
  }
}

# github "history" {
#   owner = "b4b4r07"
#   repo  = "history"
#
#   plugin {
#     sources = ["misc/zsh/init.zsh"]
#
#     env = {
#       ZSH_HISTORY_AUTO_SYNC = false
#     }
#   }
# }

github "history-search-multi-word" {
  owner = "zdharma"
  repo  = "history-search-multi-word"

  plugin {
    sources = ["history-search-multi-word.plugin.zsh"]
  }
}

github "fast-syntax-highlighting" {
  // Similar to zsh-users/zsh-syntax-highlighting
  description = "Syntax-highlighting for Zshell"

  owner = "zdharma"
  repo  = "fast-syntax-highlighting"

  plugin {
    sources = ["fast-syntax-highlighting.plugin.zsh"]
  }
}

github "ultimate" {
  // Similar to subnixr/minimal
  description = "Ultimate is a simple theme for minimalistic zsh users"

  owner = "b4b4r07"
  repo  = "ultimate"

  plugin {
    sources = ["*.zsh-theme"]
  }
}

github "gron" {
  description = "Make JSON greppable!"

  owner = "tomnomnom"
  repo  = "gron"

  release {
    name = "gron"
    tag  = "v0.6.0"
  }
}

github "dockfmt" {
  description = "Dockerfile format and parser. Like `gofmt` but for Dockerfiles."

  owner = "jessfraz"
  repo  = "dockfmt"

  release {
    name = "dockfmt"
    tag  = "v0.3.3"
  }
}

github "fzf" {
  description = "A command-line fuzzy finder"

  owner = "junegunn"
  repo  = "fzf-bin"

  release {
    name = "fzf"
    tag  = "0.17.5"
  }
}

github "fillin" {
  description = "fill-in your command and execute"

  owner = "itchyny"
  repo  = "fillin"

  release {
    name = "fillin"
    tag  = "v0.1.1"
  }
}

github "pet" {
  description = "Simple command-line snippet manager"

  owner = "knqyf263"
  repo  = "pet"

  release {
    name = "pet"
    tag  = "v0.3.4"
  }
}

github "prok" {
  description = "easy process grep with ps output"

  owner = "mutantcornholio"
  repo  = "prok"

  command {
    link {
      from = "prok.sh"
      to   = "prok"
    }
  }
}

github "peco" {
  description = "Simplistic interactive filtering tool"

  owner = "peco"
  repo  = "peco"

  release {
    name = "peco"
    tag  = "v0.5.3"
  }
}

github "gkill" {
  description = "Interactice process killer for Linux and macOS"

  owner = "heppu"
  repo  = "gkill"

  release {
    name = "gkill"
    tag  = "v1.0.2"
  }
}

github "kustomize" {
  description = "Customization of kubernetes YAML configurations"

  owner = "kubernetes-sigs"
  repo  = "kustomize"

  release {
    name = "kustomize"
    tag  = "v2.0.3"
  }
}

github "zsh-vimode-visual" {
  description = "Implement the vim-like visual mode to vi-mode of zsh"

  owner = "b4b4r07"
  repo  = "zsh-vimode-visual"

  plugin {
    sources = ["zsh-vimode-visual.zsh"]
  }
}

# github "zsh-interactive-cd" {
#   description = "Fish like interactive tab completion for cd in zsh"
#
#   owner = "changyuheng"
#   repo  = "zsh-interactive-cd"
#
#   plugin {
#     sources = ["zsh-interactive-cd.plugin.zsh"]
#   }
# }

github "exa" {
  description = "A modern version of 'ls'."

  owner = "ogham"
  repo  = "exa"

  release {
    name = "exa"
    tag  = "v0.9.0"
  }
}

github "ghq" {
  description = "Remote repository management made easy"

  owner = "motemen"
  repo  = "ghq"

  release {
    name = "ghq"
    tag  = "v0.12.6"
  }

  command {
    alias = {
      ls = "exa --group-directories-first"
      ll = "ls -al"
    }
  }
}

github "colordiff" {
  description = "Primary development for colordiff"

  owner = "daveewart"
  repo  = "colordiff"

  command {
    link {
      from = "colordiff.pl"
      to   = "colordiff"
    }

    alias = {
      diff = "colordiff -u"
    }
  }
}

github "tpm" {
  description = "Tmux Plugin Manager"

  owner = "tmux-plugins"
  repo  = "tpm"

  path = "${expand("~/.tmux/plugins/tpm")}"
}

github "fx" {
  description = "Command-line tool and terminal JSON viewer"

  owner = "antonmedv"
  repo  = "fx"

  release {
    name = "fx"
    tag  = "14.0.1"
  }

  command {
    link {
      from = "*fx*"
      to   = "fx"
    }
  }
}

github "goreleaser" {
  description = "Deliver Go binaries as fast and easily as possible"

  owner = "goreleaser"
  repo  = "goreleaser"

  release {
    name = "goreleaser"
    tag  = "v0.114.0"
  }
}

github "fd" {
  description = "A simple, fast and user-friendly alternative to 'find'"

  owner = "sharkdp"
  repo  = "fd"

  release {
    name = "fd"
    tag  = "v7.3.0"
  }
}

github "bat" {
  description = "A cat(1) clone with wings."

  owner = "sharkdp"
  repo  = "bat"

  release {
    name = "bat"
    tag  = "v0.11.0"
  }

  command {
    env = {
      BAT_PAGER = "less -RF"
      BAT_THEME = "ansi-dark"
      BAT_STYLE = "numbers,changes"
    }

    alias = {
      bat-theme = "bat --list-themes | fzf --preview='bat --theme={} --color=always ~/.zshrc'"
    }
  }
}

github "ripgrep" {
  description = "ripgrep recursively searches directories for a regex pattern"

  owner = "BurntSushi"
  repo  = "ripgrep"

  release {
    name = "ripgrep"
    tag  = "11.0.2"
  }

  command {
    link {
      from = "**/rg"
    }
  }
}

github "red" {
  description = "Terminal log analysis tools"

  owner = "antonmedv"
  repo  = "red"

  command {
    link {
      from = "red"
    }

    build {
      steps = ["go build -o red"]
    }
  }
}

github "gobump" {
  description = "Bumps up Go program version"

  owner = "motemen"
  repo  = "gobump"

  command {
    link {
      from = "gobump"
      to   = "gobump"
    }

    build {
      steps = ["go build -o gobump cmd/gobump/main.go"]
    }
  }
}

github "docker-compose" {
  description = "Define and run multi-container applications with Docker"

  owner = "docker"
  repo  = "compose"

  release {
    name = "docker-compose"
    tag  = "1.21.1"
  }
}

github "git-open" {
  description = "Type `git open` to open the GitHub page or website for a repository in your browser."

  owner = "paulirish"
  repo  = "git-open"

  command {
    link {
      from = "git-open"
      to   = "git-open"
    }
  }
}

github "dep" {
  description = "A command-line tool that makes git easier to use with GitHub."

  owner = "golang"
  repo  = "dep"

  release {
    name = "dep"
    tag  = "v0.5.4"
  }
}

github "hub" {
  description = "A command-line tool that makes git easier to use with GitHub."

  owner = "github"
  repo  = "hub"

  release {
    name = "hub"
    tag  = "v2.12.3"
  }

  command {
    link {
      from = "**/bin/hub"
    }
  }
}

# https://github.com/karan/joe
# https://github.com/astaxie/bat
# https://github.com/isacikgoz/gitin
# https://github.com/gokcehan/lf
# https://github.com/tidwall/jj
# https://github.com/huydx/hget
# https://github.com/aybabtme/humanlog
# https://github.com/gulyasm/jsonui
# https://github.com/sugyan/ttygif
# https://github.com/distatus/battery
# https://github.com/tigrawap/slit
# https://github.com/radovskyb/watcher
# https://github.com/tianon/gosleep
# https://github.com/minamijoyo/tfschema
# https://github.com/skanehira/gjo
# https://github.com/k1LoW/evry
# https://github.com/mattn/jsonargs
# https://github.com/itchyny/gojo
# https://github.com/jpmens/jo
# https://github.com/dtan4/ghrls
# https://github.com/jesseduffield/lazygit
# https://github.com/bcicen/ctop
# https://github.com/rakyll/hey
# https://github.com/simeji/jid
# https://github.com/cjbassi/gotop
# https://github.com/micha/jsawk

local "zsh" {
  plugin {
    sources = "${glob("~/.zsh/[0-9]*.zsh")}"
  }
}
