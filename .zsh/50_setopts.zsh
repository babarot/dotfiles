#setopt ignore_eof        # Ignore EOF (Ctrl-D) to prevent shell exit; require `exit` or `logout` instead (shell exits only after 10 consecutive EOF)
#setopt xtrace            # Trace execution: print commands (with arguments) as they are executed (useful for debugging, like Bash `-x`)
setopt always_last_prompt # Ensure completion listings return to the original prompt (without needing a numeric argument)
setopt append_history     # Append session history to the history file (don’t overwrite), allowing multiple shell sessions to contribute
setopt auto_cd            # Automatically `cd` into a directory if a command with that name is not found (treat directory name as `cd` command)
setopt auto_menu          # On the second consecutive completion attempt (e.g. pressing Tab again), activate menu selection of completion choices
setopt auto_param_keys    # If a completed parameter name is followed by a delimiter (like `}` or `:`), remove the auto-inserted space so the delimiter follows immediately
setopt auto_param_slash   # When completing a parameter whose value is a directory, append a trailing slash instead of a space
setopt auto_pushd         # Make `cd` push the previous directory onto the stack (like pushd), creating a directory stack on navigation
setopt auto_remove_slash  # If a completed path ends in `/` and the next character is a separator or terminator, remove the trailing slash
setopt auto_resume        # Treat a single-word command that matches a stopped job’s name as a request to resume that job (rather than a new command)
setopt bang_hist          # Enable `!` history expansion (csh-style), e.g. `!!` for last command, `!^` first arg of last command
setopt brace_ccl          # Allow brace patterns like `{a-z}` to expand to all characters in the range (lexically ordered)
setopt complete_in_word   # Don’t automatically move cursor to end on Tab; allow completion in the middle of a word (completes both before and after cursor)
setopt correct            # Try to auto-correct minor spelling errors in command names (offer suggestions for mistyped commands)
setopt correct_all        # Like `correct` but corrects all words in the command line (not just the first word)
setopt equals             # Enable `=cmd` expansion to full path of cmd (first search result in $PATH)
setopt extended_glob      # Enable extended globbing patterns for advanced filename matching (e.g. `^`, `**`, `~` operators)
setopt extended_history   # Record timestamp (start time and duration) for each command in history (prefixed in history file)
setopt globdots           # Include dotfiles (files beginning with `.`) in filename glob matches without requiring the `.` explicitly
setopt hist_expire_dups_first # When trimming history (upon exceeding $HISTSIZE), remove oldest duplicate entries before removing unique ones
setopt hist_find_no_dups  # During history search, skip duplicate matches of the same command (show each command only once)
setopt hist_ignore_dups   # Don’t record a command in history if it’s identical to the previous command
setopt hist_ignore_space  # Don’t record commands that start with a space in the history (useful for sensitive or transient commands)
setopt hist_no_functions  # Don’t save function definitions in the history list
setopt hist_no_store      # Don’t store the `history` command (fc -l) itself in the history list
setopt hist_reduce_blanks # Remove unnecessary whitespace from commands before saving them to history (squash repeated blanks)
setopt hist_save_nodups   # When writing history to file, omit older duplicate entries (save only the most recent occurrence of each command)
setopt hist_verify        # After history expansion (using `!` syntax), don’t execute immediately – load the expanded command back into the editor for verification
setopt inc_append_history # Immediately append each command to the history file as it’s executed, rather than waiting for shell exit
setopt interactive_comments # Allow comments in an interactive shell (treat lines starting with `#` as comments even in interactive mode)
setopt list_types         # When listing completion matches, show file type indicators (e.g. `/` for directories, `*` for executables)
setopt long_list_jobs     # Use long format when displaying jobs (include PID and full status info by default, like `jobs -l`)
setopt magic_equal_subst  # Treat arguments of form `name=value` as if for expansion: expand `~` or `=$VAR` on the right side even when not a real assignment
setopt mail_warning       # Print a warning message if a mail file (in $MAIL or $MAILPATH) has been modified since the last check (potential new mail)
setopt mark_dirs          # Append a trailing `/` to directory names during completion or globbing, to clearly mark directories
setopt multios            # Allow multiple redirections on a command (e.g. `echo "hi" >a >b` writes to both a and b, like an implicit tee)
setopt no_beep            # Disable audible bell on errors or ambiguous completions (don’t beep in the line editor on errors)
setopt no_case_glob       # Make filename globbing case-insensitive (match files ignoring case unless a pattern specifies otherwise)
setopt no_clobber         # Prevent `>` redirection from overwriting existing files (use `>!` or `>|` to override and allow clobbering)
setopt no_flow_control    # Disable XON/XOFF flow control for the terminal (so Ctrl-S/Ctrl-Q are available for other uses in the editor)
setopt no_global_rcs      # Don’t execute the global zsh startup files (`/etc/zshrc`, etc.) on shell startup
setopt no_hist_beep       # Don’t beep when a history search reaches the end (disable audible bell for history navigation, i.e. HIST_BEEP)
setopt no_list_beep       # Don’t beep on ambiguous completion (suppresses the bell when completion has multiple possibilities)
setopt no_prompt_cr       # Don’t print an extra carriage return before each prompt (by default PROMPT_CR is on to aid multi-line editing)
setopt notify             # Notify immediately when background jobs change status, instead of waiting for the next prompt (instant job status reports)
setopt path_dirs          # Perform $PATH lookup even for commands containing a slash (`/`) in their name (search each PATH directory for the given subpath)
setopt print_eight_bit    # Print 8-bit characters literally in outputs (don’t treat high-bit chars specially in completion lists, etc.)
setopt print_exit_value   # If a pipeline/command has a non-zero exit status, print its exit code (in interactive shells)
setopt pushd_ignore_dups  # Don’t push multiple copies of the same directory onto the stack (ignore if the directory is already in the stack)
setopt pushd_minus        # Swap meaning of `+N` and `-N` in directory stack navigation (make pushd/popd number references treat `-` as the left of stack)
setopt pushd_to_home      # Make `pushd` with no argument behave like `pushd $HOME` (pushes home directory onto the stack)
setopt rc_quotes          # Allow `'''` (two single quotes) inside a single-quoted string to produce one literal single quote character
setopt rm_star_wait       # If prompting for confirmation on `rm *` (or `rm path/*`), wait 10 seconds and ignore input to avoid accidental confirmations
setopt sh_word_split      # Enable word splitting on unquoted parameter expansions (split fields using $IFS, as in sh)
setopt share_history      # Share command history among all concurrent shells: immediately share new history entries and fetch others from the history file
