local "zsh" {
  directory = "/Users/babarot/.zsh"

  plugin {
    # sources = glob("~/.zsh/[0-9]*.zsh")
    sources = ["[0-9]*.zsh"]
  }
}

local "gcloud-sdk" {
  directory = "/Users/babarot/Downloads/google-cloud-sdk"

  plugin {
    sources = ["*.zsh.inc"]
  }
}
