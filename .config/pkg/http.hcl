# http "incr" {
#   description = "http://mimosa-pudica.net/zsh-incremental.html"
#
#   url    = "http://mimosa-pudica.net/src/incr-0.2.zsh"
#   output = ""
#
#   plugin {
#     sources = ["incr-0.2.zsh"]
#   }
# }

http "gcping" {
  // https://github.com/GoogleCloudPlatform/gcping
  description = "Like gcping.com but a command line tool"

  url    = "https://storage.googleapis.com/gcping-release/gcping_darwin_amd64_0.0.3"
  output = ""

  command {
    link {
      from = "gcping*"
      to   = "gcping"
    }
  }
}
