# tmux-bin

tmux ステータスバー用のユーティリティコマンド集。
[tmux-powerkit](https://github.com/babarot/tmux-powerkit) の external plugin として使用可能。

## コマンド一覧

### path

カレントディレクトリを様々なスタイルで表示する。

```bash
path [path] [style] [depth]
```

| 引数 | デフォルト | 説明 |
|------|-----------|------|
| path | `$PWD` | 表示するパス |
| style | `minimal` | 表示スタイル |
| depth | `2` | minimal スタイルで表示するディレクトリ階層数 |

**スタイル:**

| スタイル | 例 | 説明 |
|----------|-----|------|
| `minimal` | `bar/baz` | 末尾 N 階層のみ表示 |
| `short` | `~/s/g/b/dotfiles` | 各ディレクトリを1文字に省略 |
| `full` | `~/src/github.com/babarot/dotfiles` | フルパス（`~` 展開あり） |

### kube

現在の Kubernetes コンテキストと namespace を表示する。
クラウドプロバイダのプレフィックス・リージョン情報を自動で除去し、可読性を向上させる。

```bash
kube [OPTIONS]
```

| オプション | 説明 |
|-----------|------|
| `-r`, `--raw` | 生のコンテキスト名を表示（フォーマットなし） |
| `-c`, `--context-only` | コンテキスト名のみ表示 |
| `-n`, `--namespace-only` | namespace のみ表示 |

**フォーマット例:**

| 元のコンテキスト名 | 出力 |
|-------------------|------|
| `gke_myproject_asia-northeast1-a_prod` | `myproject:prod` |
| `arn:aws:eks:us-west-2:123456:cluster/staging` | `staging` |
| `aks_myproject_eastus_dev` | `myproject:dev` |
| `minikube` | `minikube` |

## powerkit external plugin として使用

tmux.conf での設定例:

```bash
# PATH に追加
set-environment -g PATH "$HOME/.tmux/bin:$PATH"

# status-left に kube を表示
set -g @powerkit_plugins_left "external(|$(~/.tmux/bin/kube)|secondary|accent|0)"

# status-right に path を表示
set -g @powerkit_plugins_right "external(|$(~/.tmux/bin/path #{pane_current_path} minimal 2)|secondary|accent|0)"
```

**external plugin フォーマット:**

```
external("icon"|"content"|"accent"|"accent_icon"|"ttl")
```

| パラメータ | 必須 | デフォルト | 説明 |
|-----------|------|-----------|------|
| icon | Yes | - | アイコン（Nerd Font） |
| content | Yes | - | 実行するコマンド `$(cmd)` |
| accent | No | `secondary` | コンテンツ部分の背景色 |
| accent_icon | No | `active` | アイコン部分の背景色 |
| ttl | No | `0` | キャッシュ秒数（0 = キャッシュなし） |
