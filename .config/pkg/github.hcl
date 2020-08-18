github "enhancd" {
  description = "A next-generation cd command with your interactive filter"

  owner = "b4b4r07"
  repo  = "enhancd"

  plugin {
    sources = [
      "init.sh",
    ]

    env = {
      ENHANCD_FILTER = "fzf --height 25% --reverse --ansi:fzy"
    }
  }
}

# github "fzf-man" {
#   description = ""
#
#   owner = "junegunn"
#   repo  = "fzf"
#
#   command {
#     link {
#       from = "man/man1/fzf.1"
#       to   = "${expand("~/man/man1")}"
#     }
#
#     env = {
#       MANPATH = "$MANPATH:${expand("~/man/man1")}"
#     }
#   }
# }

github "kubectx" {
  description = "Switch faster between clusters and namespaces in kubectl"

  owner = "ahmetb"
  repo  = "kubectx"

  command {
    link {
      from = "kubectx"
      to   = "kubectl-ctx"
    }

    link {
      from = "kubens"
      to   = "kubectl-ns"
    }
  }
}

github "kubetail" {
  description = "Bash script to tail Kubernetes logs from multiple pods at the same time"

  owner = "johanhaleby"
  repo  = "kubetail"

  command {
    link {
      from = "kubetail"
    }
  }
}

github "fzy" {
  description = "A better fuzzy finder"

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

# github "envchain" {
#   description = "Environment variables meet macOS Keychain and gnome-keyring <3"
# 
#   owner = "sorah"
#   repo  = "envchain"
# 
#   command {
#     build {
#       # env = {
#       #   DESTDIR = "${env.HOME}"
#       # }
# 
#       steps = [
#         "make",
#         "make install",
#       ]
#     }
# 
#     # link {
#     #   from = "envchain"
#     # }
#   }
# }

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
  description = "Multi-word, syntax highlighted history searching for Zsh"

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

# github "ultimate" {
#   // Similar to subnixr/minimal
#   description = "Ultimate is a simple theme for minimalistic zsh users"
#
#   owner = "b4b4r07"
#   repo  = "ultimate"
#
#   plugin {
#     sources = ["*.zsh-theme"]
#   }
# }

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

github "diff-so-fancy" {
  description = "Good-lookin' diffs. Actually… nah… The best-lookin' diffs."

  owner = "so-fancy"
  repo  = "diff-so-fancy"

  command {
    link {
      from = "diff-so-fancy"
    }
  }
}

github "tpm" {
  description = "Tmux Plugin Manager"

  owner = "tmux-plugins"
  repo  = "tpm"

  command {
    link {
      from = "."
      to   = "${expand("~/.tmux/plugins/tpm")}"
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

github "kubectl-trace" {
  description = "Schedule bpftrace programs on your kubernetes cluster using the kubectl"

  owner = "iovisor"
  repo  = "kubectl-trace"

  command {
    link {
      from = "kubectl-trace"
      to   = "kubectl-trace"
    }

    build {
      steps = ["go build -o kubectl-trace cmd/kubectl-trace/root.go"]
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

# github "hclfmt" {
#   description = "Format and prettify HCL files"
#
#   owner = "fatih"
#   repo  = "hclfmt"
#
#   command {
#     link {
#       from = "hclfmt"
#       to   = "hclfmt"
#     }
#
#     build {
#       steps = ["go build -o hclfmt"]
#     }
#   }
# }

github "hclfmt" {
  description = "Format and prettify HCL files"

  owner = "hashicorp"
  repo  = "hcl"

  branch = "hcl2"

  command {
    link {
      from = "hclfmt"
      to   = "hclfmt"
    }

    build {
      steps = ["go build -o hclfmt cmd/hclfmt/main.go"]
    }
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

github "distribution" {
  owner       = "philovivero"
  repo        = "distribution"
  description = "New Canonical Project for this is wizzat / distribution"
  branch      = "master"

  command {
    link {
      from = "distribution.py"
      to   = "distribution"
    }
  }
}

github "zsh-prompt-minimal" {
  description = "Super super super minimal prompt for zsh"

  owner = "b4b4r07"
  repo  = "zsh-prompt-minimal"

  plugin {
    sources = ["*.zsh-theme"]

    env = {
      PROMPT_PATH_STYLE   = "minimal"
      PROMPT_USE_VIM_MODE = true
    }
  }
}

# github "fzf-tab" {
#   owner       = "Aloxaf"
#   repo        = "fzf-tab"
#   description = "Replace zsh's default completion selection menu with fzf!"
#   branch      = "master"
#
#   plugin {
#     sources = ["fzf-tab.zsh"]
#   }
# }

github "shlide" {
  owner       = "icyphox"
  repo        = "shlide"
  description = "a slide deck presentation tool written in pure bash"
  branch      = "master"

  command {
    link {
      from = "shlide"
      to   = "shlide"
    }

    env   = null
    alias = null
  }
}

