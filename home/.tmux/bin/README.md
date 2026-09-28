# tmux-bin

Utility commands for tmux status bar.
Can be used as external plugins for [tmux-powerkit](https://github.com/fabioluciano/tmux-powerkit).

## Commands

### path

Display the current directory in various styles.

```bash
path --dir <path> --style <style> --depth <n>
```

| Option | Default | Description |
|--------|---------|-------------|
| `--dir` | `$PWD` | Path to display |
| `--style` | `minimal` | Display style (minimal, short, full) |
| `--depth` | `2` | Number of directory levels to display in minimal style |
| `--help` | - | Show help message |

**Styles:**

| Style | Example | Description |
|-------|---------|-------------|
| `minimal` | `bar/baz` | Display only last N levels |
| `short` | `~/s/g/b/dotfiles` | Abbreviate each directory to 1 character |
| `full` | `~/src/github.com/babarot/dotfiles` | Full path (with `~` expansion) |

**Examples:**

```bash
# Display current directory with minimal style (default)
path

# Display specific directory with full path
path --dir ~/src/github.com/babarot/dotfiles --style full

# Display last 3 levels
path --style minimal --depth 3

# Display with short style
path --style short
```

### kube

Display the current Kubernetes context and namespace.
Automatically removes cloud provider prefixes and region information for better readability.

```bash
kube [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `-r`, `--raw` | Display raw context name (no formatting) |
| `-c`, `--context-only` | Display context name only |
| `-n`, `--namespace-only` | Display namespace only |

**Format examples:**

| Original Context Name | Output |
|----------------------|--------|
| `gke_myproject_asia-northeast1-a_prod` | `myproject:prod` |
| `arn:aws:eks:us-west-2:123456:cluster/staging` | `staging` |
| `aks_myproject_eastus_dev` | `myproject:dev` |
| `minikube` | `minikube` |

## Usage as powerkit external plugin

Example configuration in tmux.conf:

```bash
# Add to PATH
set-environment -g PATH "$HOME/.tmux/bin:$PATH"

# Display kube in status-left
set -g @powerkit_plugins_left "external(|$(~/.tmux/bin/kube)|secondary|accent|0)"

# Display path in status-right
set -g @powerkit_plugins_right "external(|$(~/.tmux/bin/path --dir #{pane_current_path} --style minimal --depth 2)|secondary|accent|0)"
```

**external plugin format:**

```
external("icon"|"content"|"accent"|"accent_icon"|"ttl")
```

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| icon | Yes | - | Icon (Nerd Font) |
| content | Yes | - | Command to execute `$(cmd)` |
| accent | No | `secondary` | Background color for content part |
| accent_icon | No | `active` | Background color for icon part |
| ttl | No | `0` | Cache duration in seconds (0 = no cache) |
