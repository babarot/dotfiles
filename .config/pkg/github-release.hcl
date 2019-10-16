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

github "stein" {
  description = ""

  owner = "b4b4r07"
  repo  = "stein"

  release {
    name = "stein"
    tag  = "v0.2.4"
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

github "godu" {
  description = "Simple golang utility helping to discover large files/folders."

  owner = "viktomas"
  repo  = "godu"

  release {
    name = "godu"
    tag  = "v1.1"
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

github "exa" {
  description = "A modern version of 'ls'."

  owner = "ogham"
  repo  = "exa"

  release {
    name = "exa"
    tag  = "v0.9.0"
  }

  command {
    alias = {
      ls = "exa --group-directories-first"
      ll = "exa --group-directories-first -la --header --git"
    }
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

github "dry" {
  description = "A Docker manager for the terminal"

  owner = "moncho"
  repo  = "dry"

  release {
    name = "dry"
    tag  = "v0.9-beta.10"
  }
}

github "ktop" {
  description = "top for k8s"

  owner = "ynqa"
  repo  = "ktop"

  release {
    name = "ktop"
    tag  = "v0.1.1"
  }
}

github "ctop" {
  description = "Top-like interface for container metrics"

  owner = "bcicen"
  repo  = "ctop"

  release {
    name = "ctop"
    tag  = "v0.7.2"
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

github "gotestsum" {
  description = "`go test` runner with output optimized for humans, JUnit XML for CI integration, and a summary of the test run results."

  owner = "gotestyourself"
  repo  = "gotestsum"

  release {
    name = "gotestsum"
    tag  = "v0.3.5"
  }

  command {
    alias = {
      gotest = "gotestsum --format short-verbose"
    }
  }
}

github "grex" {
  description = "A command-line tool for generating regular expressions from user-provided input strings"

  owner = "pemistahl"
  repo  = "grex"

  release {
    name = "grex"
    tag  = "v0.1.0"
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

github "sd" {
  description = "Intuitive find & replace CLI (sed alternative)"

  owner = "chmln"
  repo  = "sd"

  release {
    name = "sd"
    tag  = "0.6.5"
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

github "xsv" {
  description = "A fast CSV command line toolkit written in Rust."

  owner = "BurntSushi"
  repo  = "xsv"

  release {
    name = "xsv"
    tag  = "0.13.0"
  }

  command {
    link {
      from = "xsv"
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

github "docker-compose" {
  description = "Define and run multi-container applications with Docker"

  owner = "docker"
  repo  = "compose"

  release {
    name = "docker-compose"
    tag  = "1.21.1"
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

github "httpstat" {
  description = "It's like curl -v, with colours."

  owner = "davecheney"
  repo  = "httpstat"

  release {
    name = "httpstat"
    tag  = "v1.0.0"
  }
}

github "stern" {
  description = "Multi pod and container log tailing for Kubernetes"

  owner = "wercker"
  repo  = "stern"

  release {
    name = "stern"
    tag  = "1.11.0"
  }
}

github "bow" {
  description = "Exec a command on multiple pods for Kubernetes"

  owner = "ueokande"
  repo  = "bow"

  release {
    name = "bow"
    tag  = "v0.0.1"
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

github "delta" {
  description = "A syntax-highlighting pager for git"

  owner = "dandavison"
  repo  = "delta"

  release {
    name = "delta"
    tag  = "0.0.10"
  }
}
