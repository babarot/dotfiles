# find file
ffind() {
    rg --files | fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:70% --query="$1"
}


git_dbranch() {
  if [ -z "$1" ]; then
    echo "Usage: delete_branch <branch_name>"
    return 1
  fi

  local branch="$1"

  # Delete local branch
  if git branch --list | grep -q "$branch"; then
    git branch -d "$branch" || git branch -D "$branch"
    echo "Deleted local branch: $branch"
  else
    echo "Local branch '$branch' does not exist."
  fi

  # Delete remote branch
  if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    git push origin --delete "$branch"
    echo "Deleted remote branch: $branch"
  else
    echo "Remote branch '$branch' does not exist."
  fi
}

_delete_branch_autocomplete() {
  local branches
  branches=($(git for-each-ref --format="%(refname:short)" refs/heads/ refs/remotes/ | sort -u))
  _values "branches" "${branches[@]}"
}

compdef _delete_branch_autocomplete delete_branch

# Find text in a files
tfind() {
    local search_path=$1
    rg --column --line-number --with-filename --no-heading --color=always \
        --case-sensitive --word-regexp \
        --glob '!**/(.git|node_modules)/**' --glob '!**/(yarn\.lock)' \
        "$2" "$search_path" | fzf --ansi \
        --preview 'echo {} | awk -F: '\''{start=$2-10; if(start<0) start=0; end=$2+10; print "--style=numbers --color=always --decorations=always --line-range "start":"end" --highlight-line "$2" "$1}'\'' | xargs bat'
}

# Moved to bin/gcf
# gcf() {
#   # Build the list of refs
#   local refs=$(
#     (
#       git for-each-ref --format='[local] %(refname:short)' refs/heads/
#       git for-each-ref --format='[remote] %(refname:short)' refs/remotes/
#       git stash list --format='[stash] %gd: %gs'
#     ) | fzf --height 40% --reverse --prompt="Select source> " \
#          --preview='
#            ref=$(echo {} | sed "s/^\[[^]]*\] \([^:]*\).*/\1/");
#            if [[ $ref == stash@* ]]; then
#              git ls-tree -r "$ref^1" --name-only
#            else
#              git ls-tree -r "$ref" --name-only
#            fi'
#     )

#   [ -z "$refs" ] && return

#   # Extract the ref name
#   local ref=$(echo "$refs" | sed 's/^\[[^]]*\] \([^:]*\).*/\1/')

#   # Export ref for use in the preview command
#   export FZF_PREVIEW_REF="$ref"

#   # Get the list of files and directories in the ref
#   local file_or_folder=$(git ls-tree -r -t --name-only "$ref" | fzf --height 40% --reverse --prompt="Select file or folder> " \
#       --preview='
#         path="{}"
#         if [[ -d "$path" ]]; then
#           echo "Directory: $path"
#           git ls-tree -r "$FZF_PREVIEW_REF" "$path" --name-only | while read -r file; do
#             status=$(git status --short "$file" | cut -c1-2)
#             echo "$status $file"
#           done
#         else
#           git show "$FZF_PREVIEW_REF:$path" 2>/dev/null | bat --style=numbers --color=always --pager=never || echo "File does not exist in base branch"
#         fi'
#     )

#   [ -z "$file_or_folder" ] && return

#   # Check if the selected file or folder exists in the target ref
#   if git cat-file -e "$ref:$file_or_folder" 2>/dev/null; then
#     # Check out the selected file or folder
#     git checkout "$ref" -- "$file_or_folder"
#   else
#     echo "Error: The file or folder '$file_or_folder' does not exist in '$ref'."
#   fi
# }

# Exec into running containers and try to determine the shell type automatically
dexec() {
  # List running containers and select one
  local container
  container=$(docker ps --format '{{.Names}}' | fzf --height 40% --reverse --border --prompt='Select container: ')
  [ -z "$container" ] && return 1  # Exit if no container selected

  # Attempt to detect the shell in the container
  local shell
  if docker exec "$container" sh -c 'command -v bash' &>/dev/null; then
    shell='bash'
  elif docker exec "$container" sh -c 'command -v sh' &>/dev/null; then
    shell='sh'
  elif docker exec "$container" sh -c 'command -v ash' &>/dev/null; then
    shell='ash'
  else
    echo "No common shell found in container '$container'."
    return 1
  fi

  # Execute the shell in the container
  docker exec -it "$container" "$shell"
}

_dexec_autocomplete() {
  local containers
  containers=($(docker ps --format '{{.Names}}'))
  _values "containers" "${containers[@]}"
}

compdef _dexec_autocomplete dexec

# Search the git log for changes and display preview of changes in bat window
function glog() {
  git log --pretty=format:"%C(auto)%h %s" --no-merges |
  fzf --query="$1" --preview 'echo {} | grep -o "^[a-f0-9]\+" | xargs git show --color=always | bat --style=full --paging=always --color=always'
}

git_search() {
  # Step 1: Build a list of commit logs, added/deleted files, and file contents
  local selection=$( (
    git log --pretty=format:'[LOG] %C(yellow)%h %C(magenta)%ad %C(cyan)%s' --date=short
    git log --diff-filter=A --name-only --pretty=format:'%C(black)%C(bold)' | sed '/^$/d' | sed 's/^/[FILE-ADDED] /'
    git log --diff-filter=D --name-only --pretty=format:'%C(black)%C(bold)' | sed '/^$/d' | sed 's/^/[FILE-DELETED] /'
    git ls-tree -r HEAD --name-only | sed 's/^/[FILE] /'
    git grep -I --name-only '' | sed 's/^/[CONTENT] /'
  ) | fzf --ansi --height 50% --reverse --prompt="Search across logs, files, and content > " \
      --preview='
        type=$(echo {} | awk "{print \$1}");
        value=$(echo {} | awk "{print \$2}");

        if [[ $type == "[LOG]" ]]; then
          git show --name-only "$value";
        elif [[ $type == "[FILE]" || $type == "[CONTENT]" || $type == "[FILE-ADDED]" || $type == "[FILE-DELETED]" ]]; then
          git log -n 1 --pretty=format:"%h %ad" --date=short -- "$value";
        fi' \
      --preview-window=right:70% --header="LOGS | FILES | CONTENT" \
      --color='bg+:#1A1A40,fg+:#C3C3E5,fg:#B4B4C4,bg:#0B0B20,prompt:#FF79C6,hl:#FF6E67,hl+:#FFB86C,info:#8BE9FD,border:#282A36'
  )

  # Step 2: If nothing is selected, exit the function
  [ -z "$selection" ] && return

  # Extract the type (LOG/FILE/CONTENT) and value (commit hash or filename)
  local type=$(echo "$selection" | awk '{print $1}')
  local value=$(echo "$selection" | awk '{print $2}')

  # Step 3: Handle based on the type of selection
  if [[ "$type" == "[LOG]" ]]; then
    echo "$value"  # Return the commit hash for logs
  elif [[ "$type" == "[FILE]" || "$type" == "[CONTENT]" || "$type" == "[FILE-ADDED]" || "$type" == "[FILE-DELETED]" ]]; then
    local commit_hash=$(git log -n 1 --pretty=format:"%h" -- "$value")
    echo "$commit_hash"  # Return the commit hash associated with the file or content
  fi
}
