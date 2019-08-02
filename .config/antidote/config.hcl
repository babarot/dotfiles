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
    sources = [
      "init.sh",
    ]

    env = {
      ENHANCD_FILTER            = "fzf --height 25% --reverse --ansi"
      ENHANCD_DOT_SHOW_FULLPATH = 1
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

  command {
    targets = ["jq"]
  }
}

gist "misc" {
  owner = "b4b4r07"
  id    = "79ee61f7c140c63d2786"
}

github "hoge" {
  owner = "ahmetb"
  repo  = "kubectx"

  command {
    targets = ["kubectx", "kubens"]
  }
}

http "incr" {
  description = "http://mimosa-pudica.net/zsh-incremental.html"

  url    = "http://mimosa-pudica.net/src/incr-0.2.zsh"
  output = "incr-0.2.zsh"

  plugin {
    sources = []
  }
}

github "fzy" {
  owner = "jhawthorn"
  repo  = "fzy"

  command {
    targets = ["fzy"]

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
    targets = ["envchain"]

    build {
      steps = [
        "make",
        "sudo make install",
      ]
    }
  }
}

github "zsh-history" {
  owner = "b4b4r07"
  repo  = "history"

  plugin {
    disable = true

    sources = [
      "misc/zsh/init.zsh",
    ]

    env = {
      ZSH_HISTORY_AUTO_SYNC = false
    }
  }
}

github "zsh-history-search" {
  owner = "zdharma"
  repo  = "history-search-multi-word"

  plugin {
    sources = [
      "history-search-multi-word.plugin.zsh",
    ]
  }
}

github "zsh-highlight" {
  owner = "zdharma"
  repo  = "fast-syntax-highlighting"

  plugin {
    sources = [
      "fast-syntax-highlighting.plugin.zsh",
    ]
  }
}

github "zsh-highlight-disable" {
  owner = "zsh-users"
  repo  = "zsh-syntax-highlighting"

  plugin {
    disable = true

    sources = ["zsh-syntax-highlighting.plugin.zsh"]
  }
}

github "zsh-theme-ultimate" {
  owner = "b4b4r07"
  repo  = "ultimate"

  plugin {
    disable = false
    sources = ["ultimate.zsh-theme"]
  }
}

github "minimal" {
  owner = "subnixr"
  repo  = "minimal"

  plugin {
    disable = true
    sources = ["minimal.zsh"]
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

  command {
    targets = ["gron"]
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

  command {
    targets = ["fzf"]
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

  command {
    targets = ["fillin"]
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

  command {
    targets = ["pet"]
  }
}

github "prok" {
  description = "easy process grep with ps output"

  owner = "mutantcornholio"
  repo  = "prok"

  command {
    targets = [
      "prok.sh",
      "hoge",
    ]
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

  command {
    targets = ["peco"]
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

  command {
    targets = ["gkill"]
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

  command {
    targets = ["kustomize"]
  }
}

github "agkozak-zsh-prompt" {
  description = "A fast, asynchronous ZSH prompt with color ASCII indicators of Git, exit, SSH, and vi mode status. Framework-agnostic and customizable."

  owner = "agkozak"
  repo  = "agkozak-zsh-prompt"

  plugin {
    disable = true

    sources = [
      "agkozak-zsh-prompt.plugin.zsh",
    ]
  }
}

github "zsh-vimode-visual" {
  description = "Implement the vim-like visual mode to vi-mode of zsh"

  owner = "b4b4r07"
  repo  = "zsh-vimode-visual"

  plugin {
    sources = [
      "zsh-vimode-visual.zsh",
    ]
  }
}

github "zsh-interactive-cd" {
  description = "Fish like interactive tab completion for cd in zsh "

  owner = "changyuheng"
  repo  = "zsh-interactive-cd"

  plugin {
    disable = true

    sources = [
      "zsh-interactive-cd.plugin.zsh",
    ]
  }
}

github "exa" {
  description = "A modern version of 'ls'."

  owner = "ogham"
  repo  = "exa"

  release {
    name = "exa"
    tag  = "v0.9.0"
  }

  command {
    targets = ["exa"]
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
    targets = ["**/ghq"]
  }
}

github "gobump" {
  description = "Bumps up Go program version"

  owner = "motemen"
  repo  = "gobump"

  command {
    targets = ["**/gobump"]

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

  command {
    targets = ["docker-compose"]
  }
}

github "git-open" {
  description = "Type `git open` to open the GitHub page or website for a repository in your browser."

  owner = "paulirish"
  repo  = "git-open"

  command {
    targets = ["git-open"]
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
    targets = ["**/bin/hub"]
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
    targets = ["**/bin/nvim"]
  }
}

# https://github.com/karan/joe
# https://github.com/astaxie/bat
# https://github.com/isacikgoz/gitin
# https://github.com/gokcehan/lf
# https://github.com/tidwall/jj
# https://github.com/huydx/hget
# https://github.com/jessfraz/dockfmt
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

# local "theme" {
#   plugin {
#     sources = ["/Users/b4b4r07/src/github.com/b4b4r07/ultimate/ultimate.zsh-theme"]
#   }
# }

