---
layout: post
title:  "$ git commit だけのお付き合いのための小さな .vimrc"
date:  2014-12-20 12:00:00 UTC+9
categories: vim
---

## 問題

友人に Emacs 使いがいて，彼は一応 Vim の基本操作は習得しているものの，`.vimrc` はない状態にある．
`git commit` した時にエディタが立ち上がるが，そこで Emacs を立ち上げるのもなんだかなあだし，
敢えて `nano` を使うような人間でもなく，微妙な顔をしながら素の Vim を使っているということだ．

世の中に Vim 入門記事は色々あるものの，全体に Vim を普段のエディタとして使うことを想定したものが多い感じで，
`git commit` 程度のお付き合いの人がサクッと幸福度を上げられる記事はあまりない，ような気がする．
というわけで，この目的に絞った minimal な `.vimrc` + α を考えてみました．

## その前に
Vim の基本操作といえば `h`, `j`, `k`, `l` と `d`, `c`, `x`, `r` あたりと，`insert`/`visual`/`normal`
モードの使い分けあたりが入ってくるのではないかと思う．
全般に `:vimtutor` すればよいのだけれど，この辺多少使えるようになったらもうひとつ覚えるとよいのは次のどれか（個人の感想です）．

* text objects
* `w`/`e`/`b` 辺りの単語 (word/WORD) 単位移動
* `f`/`t` とオペレータの組み合わせ

特におすすめは最初の text objects で，個人的には vim の良さのかなりの部分を占めていると思う[^tobj]．たとえば `|` がカーソルとして

{% highlight text %}
"The (quick bro|wn) fox"
{% endhighlight %}

ここで `viw` で `brown`, `va(` で `(quick brown)`, `vi"` で `The (quick brown) fox` が選択できるようなもの．
`v` の代わりに `d` なら削除，etc.
commit するだけならまあそんなに vim の操作に熟達することも必要ないだろうが，
[Vim Advent Calendar 2013 97日目:モモンガでもわかるテキストオブジェクトとオペレータ](http://d.hatena.ne.jp/osyo-manga/20140307/1394204974)
あたりがよくまとまっている．基本的に `i` は in, `a` は(不定冠詞の) a のつもりでいると良い．

`f` `t` とかも，例えばここから `)` の直前まで削除なら `dt)` と，単に動くだけじゃなくて色々使いでがある．

## .vimrc

ここから

![without]({{site.baseurl}}/img/2014-12/20-gitcommit_empty.png)

まずこれを目指します．

![with_vimrc]({{site.baseurl}}/img/2014-12/20-gitcommit_minimum.png)

commit message だけなので特段自動インデントとか索周りとかそういうのも要らんだろうということで．

{% highlight vim linenos %}
scriptencoding utf-8 " encoding used in this script
filetype plugin indent on  " ファイルタイプ毎の諸々
syntax on
set smarttab " indent/tab 周りを色々
set spelllang=en_gb,cjk " languages for spell checking
set timeout timeoutlen=1000 ttimeoutlen=100
set lazyredraw " don't redraw screen while executing macros etc.

set cursorline " highlight current line
set laststatus=2 " show statusline even when there's only one window
set list " \t, 行末などを可視化
set listchars=tab:>-,eol:$ " 可視化する文字の設定．お好みで
set number " show line number
set showmode  " tells us which mode we're in
set showcmd " show what command is being typed
set ruler " show current position

set t_Co=256 " for terminals that support 256 colours
set background=dark
colorscheme jellybeans

augroup GitCmd
  autocmd!
  autocmd filetype gitcommit setlocal spell " enable spell check for git commits
augroup END
{% endhighlight %}


ファイルは[ここ]({{site.baseurl}}/assets/2014-12/vimrc_for_git_commit.vim)に置きました．
これを `$MYVIMRC` (linux 系では `$HOME/.vimrc`) に保存すればよい．
(全部 utf-8 で揃っていて比較的平和な linux 環境でためしているので， window とかだとエンコーディング周りで問題が発生するかもしれないが，不明）．

幾つか解説を入れると

* `set spelllang=en_gb,cjk` : `cjk` を入れると日本語を無視してくれる．
* `set nocompatible` は `.vimrc` があれば自動的に設定される．書いてると様々なオプションがリセットされるので，書かないほうがむしろよろしい[^noc]．
* `timeout` のあたり : ちょっと複雑な話になるのだが，`timeoutlen` が map の待ち時間，`ttimeoutlen` は key code の待ち時間．
前者は例えば `jk` という打鍵をマップした時に2つの間に置ける待ち時間，後者は例えば矢印が `<Esc>OA` とかそういうの．僕も完全に理解しているわけではないが，
短めに設定しておくと `<Esc>` で待ちが入らないとか色々良いことが多いように思う．自身は `ttimeoutlen=10` にしているが，100位を挙げる例が多いので
それに従った．
* `set lazyredraw` : マクロを使うようになると嬉しさが判るはず．
* `showmode` : いま insert なら insert と表示してくれる．
* `showcmd` : こちらは例えば `diw` と打ってる途中で何が打たれてるのかを表示してくれる．
* `augroup` : `autocmd` は「** のときに ** してね」というような話．この例で言えば filetype が gitcommit の時に，スペルチェックをオンにする．
これをグループごとに区切るのが `augroup`. `autocmd!` は登録された `autocmd` を消す命令で，これがないと例えば
`:source $MYVIMRC` した時に二重に登録されることになる．

`augroup` とかの事情については[vimrcアンチパターン - rbtnn雑記](http://rbtnn.hateblo.jp/entry/2014/11/30/174749)が詳しい．

ここで color scheme はデフォルトのではないから，インストールしていただかなくてはならない．
個人的なおすすめは色々あるのだが，ひとつずつ挙げるなら黒背景の [jellybeans](https://github.com/nanotech/jellybeans.vim),
白背景なら [pencil](https://github.com/reedes/vim-colors-pencil) がおすすめ．
例えば `colors/jellybeans.vim` を `$HOME/.vim/colors/` に保存などでインストールできる．
白背景の時にはこう書く

{% highlight vim %}
set background=light
colorscheme pencil
{% endhighlight %}

デフォルトで入ってる色の中では desert, morning あたりが評価が高いように思うが，まあ好きなのをつかうのがよい．

## Plugin をつかう

上のは `.vimrc` だけでやるものだが，git commit に関してはすごくおすすめの plugin があるので，
制約がないならそれの使用もおすすめしたい．

その名は [committia.vim](https://github.com/rhysd/committia.vim)[^committia]．これを併用すると，こうなる．

![with_committia]({{site.baseurl}}/img/2014-12/20-gitcommit_committia.png)

右側に diff, 左上に編集枠，下に commit 状況を示した区画．めっちゃ使いやすい．

インストールは i) 何らかのプラグインマネージャを使う ii) 手動でやる のいずれか．
プラグインマネージャは大仰ではあるものの，使わないとすぐ収集がつかなくなるのも事実で，
git commit だけの人にどちらを奨めるかは悩ましいところがある．

### plugin について
plugin 関連のファイルは基本的に `$HOME/.vim` に置く．構造はこういう感じ

{% highlight bash %}
.vim
├── autoload/  # 必要に応じて遅延読込されるファイル/ライブラリなど
├── colors/    # colorscheme. jellybeans.vim とかをここに入れる
├── doc/       # help ファイル．
├── ftdetect/  # 拡張子が .md なら markdown にしてよとかそんな話
├── plugin/    # plugin の本体．
└── syntax/    # シンタックスファイル
{% endhighlight %}

必要に応じて他のディレクトリも作られる．ほとんどのプラグインはこのディレクトリ構成を保って作られているので，
`project/autoload` の中身を `$HOME/.vim/autoload` へ，といった形で展開すればインストールできる．

### plugin managers
プラグインマネージャは，vim じたいにそういった機構が無いこともあって，様々なものがある．中でも圧倒的に有名なのは

* [tpope/vim-pathogen](https://github.com/tpope/vim-pathogen)
* [gmarik/Vundle.vim](https://github.com/gmarik/Vundle.vim)
* [Shougo/neobundle.vim](https://github.com/Shougo/neobundle.vim)

の3つ．Pathogen は git に依存しない．Neobundle は Vundle から派生して魔改造が次々と施されているものだ．
他にも Kana神による[Ruby 製のもの](https://github.com/kana/vim-flavor)[^flavor]や[Haskell 製のもの](https://github.com/itchyny/miv)もある．
使ったことはないけれどどちらも丁寧な設計がされている模様で，乗り換えの検討もアリ．

今回はこのうち neobundle を使った例を紹介してみる．理由は特に無く，ただ日本語で一番情報が豊富なため，といった程度である．
好きなのを使ってみて欲しい．

### というわけで Committia 導入

[Readme](https://github.com/Shougo/neobundle.vim#quick-start) に従って neobundle 導入後，`.vimrc` に

こうじゃ

{% highlight vim %}
filetype off

if has('vim_starting')
    set runtimepath+=expand('$HOME/.vim/bundle/neobundle.vim')
endif
call neobundle#begin(expand('$HOME/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'rhysd/committia.vim'
call neobundle#end()
{% endhighlight %}

Vim を再起動するか `:source $MYVIMRC` して， `:NeoBundleInstall` でインストールされる．
あるいは上述の通り，`~/.vim/` 以下に直接ダウンロードしてきても良い．

### Committia の設定

{% highlight vim %}
let g:committia_min_window_width = 100  " これ以下の幅では左右分割しない
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(e)
    setlocal spell
endfunction
{% endhighlight %}

`g:committia_hooks` という global variable （本体は dict）を用意してそれを読んでもらう．
`edit_open` を登録し，commit message 編集域についてだけ spell check を行うという形に．
この場合，最初に提示した `augroup` の中身は不要．

ともかくこれで上記のスクリーンショットの状態になる．
この状態の .vimrc は [こちら]({{site.baseurl}}/assets/2014-12/vimrc_for_git_commit_with_committia.vim)


## FAQ

### auto-closing な parenthesis がほしい
これについては，僕が全く使わないのでなんとも言えない．閉じ括弧の処理を考えず，括弧が自動で閉じるだけなら

{% highlight vim %}
inoremap ( ()<Left>
inoremap { {}<Left>
{% endhighlight %}

といった感じでやれば良い．閉じ括弧のところで Insert mode を抜けたくない場合には，
個人的に[頑張る方法もある](http://vim.wikia.com/wiki/Automatically_append_closing_characters)
けれど，プラグインに頼るのもよいだろうとおもう．
今なら多分 [cohama/lexima.vim](https://github.com/cohama/lexima.vim)[^lexima] がアツい．

### もうちょっと色々設定してみたいが，参考になる資料はないか．

基本的には他人の `.vimrc` を漁るのがよく，[Vimrc 読書会](http://vim-jp.org/reading-vimrc/) への参加は勧められる．
他には [ぼくのかんがえたさいしょうのvimrc - derisの日記](http://deris.hatenablog.jp/entry/2014/05/20/235807)，
少し硬派に [vimrc基礎文法最速マスター - 永遠に未完成](http://d.hatena.ne.jp/thinca/20100205/1265307642)などを読むのもいいかもしれない．
また，[Cohama さんの .vimrc](https://github.com/cohama/.vim/blob/master/.vimrc) は丁寧に作られていて，初心者のころかなりお世話になった．

### tab の幅とかが気になる
[vim-jp » Hack #137: タブとインデントの設定を理解する](http://vim-jp.org/vim-users-jp/2010/04/06/Hack-137.html) をどうぞ．

### カーソルキーを使ってしまう．矯正したい

{% highlight vim %}
noremap  <Up>    <Nop>
noremap  <Left>  <Nop>
noremap  <Right> <Nop>
noremap  <Down>  <Nop>
noremap! <Up>    <Nop>
noremap! <Left>  <Nop>
noremap! <Right> <Nop>
noremap! <Down>  <Nop>
{% endhighlight %}

### 手ぬるいぞ！

{% highlight vim %}
noremap <Up> :<C-u>echoerr "Don't use that key!"<CR>
{% endhighlight %}

### もっとだ！

{% highlight vim %}
noremap <Up> :<C-u>!sl<CR>
{% endhighlight %}

### まだまだ

{% highlight vim %}
noremap <Up> :<C-u>!rm -r . " <CR>
{% endhighlight %}

所謂[危険シェル芸](http://togetter.com/li/709172)何でもどうぞ．


----

というわけで，どうぞよしなに．

なお，git と vim といえば [Agit.vim](https://github.com/cohama/agit.vim) も超おすすめです．

[^tobj]: これは vi にはない機能で，readline とかの "vi keybind" ってやつには無く，結構不自由してしまう．
[^noc]: 逆に `set nocompatible` 一本で戦う手もあるのかもしれない（？）
[^committia]: [作者による紹介記事](http://rhysd.hatenablog.com/entry/2014/12/08/082825)
[^flavor]: [作者による紹介記事](http://labs.timedia.co.jp/2012/04/vim-flavor-a-tool-to-manage-your-favorite-vim-plugins.html)
[^lexima]: [作者による VimConf での発表資料](http://www.slideshare.net/cohama/auto-closing-parenthesis-vim-conf2014-41290298)
