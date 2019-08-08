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
# http "wget" {
#   description = ""
#
#   url    = "http://ftp.gnu.org/gnu/wget/wget-1.20.tar.gz"
#   output = ""
#
#   command {
#     build {
#       working_dir = "wget-1.20"
#
#       steps = [
#         "./configure",
#         "make",
#       ]
#     }
#
#     link {
#       from = "wget"
#     }
#   }
# }

