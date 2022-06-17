# # is_login_shell returns true if current shell is first shell
# is_login_shell() {
#     [[ $SHLVL == 1 ]]
# }
# 
# 
# # is_screen_running returns true if GNU screen is running
# is_screen_running() {
#     [[ -n $STY ]]
# }
# 
# # is_tmux_runnning returns true if tmux is running
# is_tmux_runnning() {
#     [[ -n $TMUX ]]
# }
# 
# # is_screen_or_tmux_running returns true if GNU screen or tmux is running
# is_screen_or_tmux_running() {
#     is_screen_running || is_tmux_runnning
# }
# 
# # shell_has_started_interactively returns true if the current shell is
# # running from command line
# shell_has_started_interactively() {
#     [[ -n $PS1 ]]
# }
# 
# # is_ssh_running returns true if the ssh deamon is available
# is_ssh_running() {
#     [[ -n $SSH_CLIENT ]]
# }
