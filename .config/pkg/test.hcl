github "test" {
  owner = "b4b4r07"
  repo  = "sandbox"

  plugin {
    sources = ["test-plugin.sh"]
  }

  command {
    link {
      from = "test-command"
      to   = "test-command"
    }
  }
}
