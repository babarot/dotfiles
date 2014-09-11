# [B4B4R07](https://twitter.com/b4b4r07)の dotfiles

このリポジトリが目的とすることは、新しく環境構築することを容易にするためです。このリポジトリをクローンすると、いつも使っている環境を簡単に再現できます（以下の参考写真参照）。そのためにあなたがするべきことは、以下のことだけです。この README ファイルでは長々と説明を書き連ねているので、最速で環境再構築するのに必要な情報は[これ](#oneliner)だけです。

![dotfiles](http://cl.ly/image/3A3e0i1L0v0J/environment.png "vim-on-tmux")

## アウトライン

* `sh <(curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)`
* `cd ~/.dotfiles && make install`

## #1; 環境構築

このリポジトリのクローンと、dotfiles のインストール（各設定ファイルを `$HOME` しかるべき所にデプロイすることなど）は以下を実行することで一括で行われます。


	sh <(curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh)

または

	sh -c "`curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh`"

記述はさまざまありますが、以上２つのどちらかがお勧めです。
	
他の方法:

	curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh
	
もありますが、あまり推奨されません。この方法では、`bootstrap.sh` スクリプトが行うはずであった3番目の項目の「bash の再起動」が行われないからです。しかし、逆を返すと、再起動したくない場合にこの方法はお勧めです。

ダウンローダに `curl` でなく、`wget` を使用する場合は、`curl -L {URL}` を `wget -q -O - {URL}` に書き換えてください。

このリポジトリのクローンが昔に行われ、変更を取得しアップデートする際は、

	make update

でいいです。

### `bootstrap.sh` がする処理について

1. `git clone b4b4r07/dotfiles.git`
2. `make deploy`
3. `source ~/.bash_profile`

推奨された方法で `curl` などのダウンローダを通して、`bootstrap.sh` の実行を行うと、dotfiles リポジトリがクローンされ(1)、各設定ファイルが所定の箇所にデプロイされ(2)、bash が再起動(3)されます。

## #2; `make deploy` のあとにやるべきこと

\#1; が終わり、あなたがその環境を恒久的に使用する場合はこの項を読み、実行するべきです。

	cd ~/.dotfiles && make install

`make install` は環境設定をします。具体的な処理内容としては、`init/` ディレクトリ以下にあるスクリプトファイルの実行です。以下に列挙します。

- vim のインストール。多くの場合、デフォルトでインストールされている vim は便利な機能が欠如していることが多いです。それのリインストールです。
- ホームディレクトリの英語化
- OSX の場合、homebrew の初期化
- OSX の場合、`defauls` コマンド群の実行
- パッケージのインストール(`wget` など)

## #3; 好みの設定
* エディタの設定

	エディタは vim です。環境構築が終わりたての vim はプラグインなどもないまっさらな Vim です。初回起動時は引数に `-c "NeoBundleInit"` を指定して起動するといいです。たちまちに多くのプラグインがインストールされます。ただし、vim の種類は ノーマルかそれ[以上](http://www.drchip.org/astronaut/vim/vimfeat.html)であることが必須です。また、当然ながら `git` を必須とします。

* Git の設定

	個人用の設定ファイルを作成するといいでしょう。
	個人用設定ファイル `~/.bashrc.local` は以下のようにするといいでしょう:

		GIT_AUTHOR_NAME="B4B4R07"
		GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
		git config --global user.name "$GIT_AUTHOR_NAME"
		GIT_AUTHOR_EMAIL="b4b4r07@gmail.com"
		GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
		git config --global user.email "$GIT_AUTHOR_EMAIL"

環境構築と設定は以上で終了です。

=========================================================================================

<a name="oneliner">ONELINER:</a>

	curl -L https://raw.github.com/b4b4r07/dotfiles/master/bootstrap.sh | sh && read -n 1 -p 'Install? ' && if [ "$REPLY" == "y" ]; then make install; fi && echo -e "\n\033[31mFINISH\033[m" && /bin/bash

## Credits

* Dotfiles' `README` layout based on [@Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
* File Hierarchy based on [@Pritzker's dotfiles](https://github.com/skwp/dotfiles)
* `Makefile` based on [@Tetsuji's dotfiles](https://github.com/xtetsuji/dotfiles)
* `bootstrap.sh` based on [@Rocha's dotfiles](https://github.com/zenorocha/old-dotfiles)

## Author

| [![twitter/b4b4r07](http://www.gravatar.com/avatar/8238c3c0be55b887aa9d6d59bfefa504.png)](http://twitter.com/b4b4r07 "Follow @b4b4r07 on Twitter") |
|:---:|
| [b4b4r07's Qiita](http://qiita.com/b4b4r07/ "b4b4r07 on Qiita") |

## Licence

> The MIT License (MIT)
> 
> Copyright (c) 2014 B4B4R07
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
