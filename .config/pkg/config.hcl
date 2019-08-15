config {
  base = "${expand("~/.pkg")}"

  command {
    path = "${expand("~/bin")}"
  }
}
