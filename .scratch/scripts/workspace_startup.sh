#!/bin/bash

# # Check if the workspace root directory exists
# if [ ! -d "$WORKSPACE_ROOT" ]; then
#     echo "The workspace root path '$WORKSPACE_ROOT' does not exist."
#     exit 1
# fi

# echo "Tree of Git repositories in the workspace:"

# # Function to create a tree view
# print_tree() {
#     local prefix="$1"
#     local path="$2"
#     local is_last="$3"
#     local spacer

#     # Check if this is the last element in the directory
#     if [[ "$is_last" == "1" ]]; then
#         spacer="└── "
#     else
#         spacer="├── "
#     fi

#     # Print the current path
#     echo "$prefix$spacer$(basename "$path")"

#     # New prefix for child directories
#     if [[ "$is_last" == "1" ]]; then
#         new_prefix="$prefix    "
#     else
#         new_prefix="$prefix│   "
#     fi

#     # List all subdirectories except the .git directory
#     local subdirs=($(find "$path" -maxdepth 1 -type d ! -name ".git" ! -path "$path"))
#     local count=${#subdirs[@]}
#     local i=0

#     for subdir in "${subdirs[@]}"; do
#         if [[ "$((++i))" -eq "$count" ]]; then
#             print_tree "$new_prefix" "$subdir" 1
#         else
#             print_tree "$new_prefix" "$subdir" 0
#         fi
#     done
# }

# # Find all Git repositories and print them in a tree structure
# git_repos=($(find "$WORKSPACE_ROOT" -type d -name ".git" | awk -F'/.git' '{print $1}'))

# # Initial prefix and "last element" status
# print_tree "" "$WORKSPACE_ROOT" 1
