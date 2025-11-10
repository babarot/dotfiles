## 現在インストールされているプラグイン一覧

### カラースキーム (14個)

- folke/tokyonight.nvim
- daschw/leaf.nvim
- junegunn/seoul256.vim
- marko-cerovac/material.nvim
- projekt0n/github-nvim-theme
- gbprod/nord.nvim
- rebelot/kanagawa.nvim
- EdenEast/nightfox.nvim
- akinsho/horizon.nvim
- olivercederborg/poimandres.nvim
- cocopon/iceberg.vim
- voidekh/kyotonight.vim
- AlessandroYorba/Despacio
- ellisonleao/gruvbox.nvim
- maxmx03/solarized.nvim

### カラースキーム切り替え (1個)

- babarot/ftcolor.nvim - ファイルタイプごとに自動カラースキーム切り替え

### 基盤・LSP (6個)

- nvim-treesitter/nvim-treesitter - シンタックスハイライト・構文解析
- williamboman/mason.nvim - LSPサーバー/ツールインストーラー
- williamboman/mason-lspconfig.nvim - MasonとLSPConfigの橋渡し
- neovim/nvim-lspconfig - LSP設定（gopls, lua_ls）
- nvimdev/lspsaga.nvim - LSP UI強化（hover, peek, outline等）
- saghen/blink.cmp - 補完エンジン（Rust製、高速）

### 補完・スニペット (1個)

- rafamadriz/friendly-snippets - スニペット集（blink.cmpの依存）

### 編集機能 (4個)

- windwp/nvim-autopairs - 括弧自動閉じ
- numToStr/Comment.nvim - コメントアウト（gcc, gc）
- kylechui/nvim-surround - 囲み文字の操作（ys, ds, cs）
- Wansmer/treesj - コードブロックの分割/結合（Tree-sitter使用）

### UI・統合ツール (8個)

- folke/snacks.nvim - 統合UIツールパック（picker, dashboard, explorer, notifier等）
- folke/which-key.nvim - キーバインディングヒント表示
- nvim-lualine/lualine.nvim - ステータスライン（高速、美しい、LSP/Git統合）
- romgrk/barbar.nvim - タブライン（バッファ一覧表示、軽量・高速）
<!-- - akinsho/bufferline.nvim - タブライン（LSP統合、視覚重視、スタイルカスタマイズ豊富）※disabled -->
- folke/trouble.nvim - 診断情報・LSP参照の統合表示
- greggh/claude-code.nvim - Claude Code統合（シンプル・ターミナル）
- coder/claudecode.nvim - Claude Code統合（高度・WebSocket + MCP）
- gelguy/wilder.nvim - コマンドライン強化（履歴フィルタリング・ファジー検索）

### 視覚補助 (8個)

- folke/todo-comments.nvim - TODO/FIXMEコメントのハイライト
- ntpeters/vim-better-whitespace - 末尾空白ハイライトと自動削除
- dstein64/nvim-scrollview - スクロールバー表示
- utilyre/barbecue.nvim - ウィンバーにパンくずリスト表示（LSP統合）
- tummetott/reticle.nvim - カーソル行の自動表示/非表示
- babarot/cursor-x.nvim - カーソル位置の自動ハイライト（一定時間後）
- lukas-reineke/indent-blankline.nvim - インデントガイド表示（Treesitter統合）
- kevinhwang91/nvim-hlslens - 検索結果カウント表示（[1/5]等）
<!-- - shellRaining/hlchunk.nvim - コードブロックハイライト（無効化: indent-blanklineと競合） -->

### Git統合 (2個)

- lewis6991/gitsigns.nvim - Git差分表示、ハンク操作、ブレーム表示
- ruanyl/vim-gh-line - GitHubでファイル/行を開く（:GH, :GHInteractive）

### 言語固有 (3個)

- ray-x/go.nvim - Go開発ツール（goimport、タグ追加、テスト実行等）
- babarot/markdown-preview.nvim - Markdownプレビュー（GitHub API使用）
- MeanderingProgrammer/render-markdown.nvim - Markdownレンダリング（見出し、コードブロック、テーブル等）

### アイコン (2個)

- echasnovski/mini.icons - アイコンサポート（snacks/lspsagaの依存）
- nvim-tree/nvim-web-devicons - アイコンサポート（barbarの依存）

### ファイル操作 (2個)

- babarot/rm.nvim - 安全なファイル削除（:Rm コマンド、gomi対応）
- babarot/backup.nvim - ファイル保存時の自動バックアップ（~/.backup/vim、日付別保存）

### ユーティリティライブラリ (3個)

- nvim-lua/plenary.nvim - Lua関数ライブラリ（todo-commentsの依存）
- SmiteshP/nvim-navic - LSPベースのナビゲーション（barbecueの依存）
- ray-x/guihua.lua - GUI/浮動ウィンドウライブラリ（go.nvimの依存）
