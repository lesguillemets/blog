---
layout: post
title:  "Vim の起動時オプションについて"
date:  2014-07-26 12:00:00 UTC+9
categories: vim
---

Vim は起動時にいろんなオプションを渡すことができる．`-O` や `-u` は有名だと思うけど，この度 `vim -` の存在を知ったのでお役立ちっぽいのをまとめてみる．
`vim -` は標準入力をバッファに流しこんで vim を起動させるもの． `ls | vim -` みたいな感じで使えます （勿論 `$ vim -` でハードコアなコーディングも出来るよね！)．

`:h starting.txt` より個人的に使うかもなのを抜粋．

<style>
  table{
    width:80%;
    margin-left: auto;
    margin-right: auto;
    border-collapse: collapse;
    background-color:#f9ffff;
  }
  th,td,tr{
    border:1px solid black;
    padding-left:0.5em;
    padding-right:0.5em;
  }
  table .option { width:20%; text-align:center;}
  th {
    text-align:center;
  }
  tr {
    display:table-row;
  }
</style>

<table>
  <tr>
    <th class="option">option</td>
    <th class="desc">descr</td>
  </tr>
  <tr>
    <td class="option"><code>-</code></td>
    <td class="desc"> 標準入力からバッファに流しこんで起動</td>
  </tr>
  <tr>
    <td class="option"><code>--version</code></td>
    <td class="desc">バージョン情報</td>
  </tr>
  <tr>
    <td class="option"><code>--noplugin</code></td>
    <td class="desc">プラグイン読み込まない (<code>.vimrc</code> は読む)</td>
  </tr>
  <tr>
    <td class="option"><code>--startuptime {fname}</code></td>
    <td class="desc">起動にかかる時間をファイルに記録</td>
  </tr>
  <tr>
    <td class="option"><code>+ [num]</code></td>
    <td class="desc"> n 行目にカーソル置いて起動</td>
  </tr>
  <tr>
    <td class="option"><code>+/</code></td>
    <td class="desc">パターン検索してそこへ</td>
  </tr>
  <tr>
    <td class="option"><code>-c</code></td>
    <td class="desc">コマンド実行．<code>+</code> でもいいらしい．
    コマンドはファイル読み込みの後に実行される．</td>
  </tr>
  <tr>
    <td class="option"><code>--cmd {command}</code></td>
    <td class="desc">こちらはコマンドを vimrc 読み込み前に実行する</td>
  </tr>
  <tr>
    <td class="option"><code>-S {file}</code></td>
    <td class="desc">source script file</td>
  </tr>
  <tr>
    <td class="option"><code>-M</code></td>
    <td class="desc"><code>nomodifiable</code> で書き込みもできなくなる．書き込みのみを禁じる時は <code>m</code> でいいようだ．</td>
  </tr>
  <tr>
    <td class="option"><code>-b</code></td>
    <td class="desc">binary mode.</td>
  </tr>
  <tr>
    <td class="option"><code>-V[n]</code></td>
    <td class="desc"><code>verbose</code> を設定して起動．さらにファイルを指定すると <code>verbosefile</code> も設定できる</td>
  </tr>
  <tr>
    <td class="option"><code>-y</code></td>
    <td class="desc"><a href=”http://togetter.com/li/572461”>vim -y にくるしむみなさん。-- togetter</a></td>
  </tr>
  <tr>
    <td class="option"><code>-o,-O,-p</code></td>
    <td class="desc">略</td>
  </tr>
  <tr>
    <td class="option"><code>-f</code><br /><code>--nofork</code></td>
    <td class="desc">gui で新しいプロセスをつくらない</td>
  </tr>
  <tr>
    <td class="option"><code>-u -U</code></td>
    <td class="desc">略</td>
  </tr>
  <tr>
    <td class="option"><code>-x</code></td>
    <td class="desc">暗号化．読むときは自動で判定してくれるからなくてよい．</td>
  </tr>
  <tr>
    <td class="option"><code>-s {scriptin}</code></td>
    <td class="desc">ファイルを読み込んで，そこに書いてあるのを一文字一文字打ったように挙動．<code>:source! {scriptin}</code>と同じ．</td>
  </tr>
  <tr>
    <td class="option"><code>-w {scriptout}</code></td>
    <td class="desc">打ち込む文字を全部ファイルに吐く．<code>-W</code> で既存ファイルを上書き，こっちは append する．</td>
  </tr>
  <tr>
    <td class="option"><code>-w {number}</code></td>
    <td class="desc"><code>window</code> を n に設定．これがあるから上の <code>scriptout</code> は数字で始まっちゃだめ．</td>
  </tr>
  <tr>
    <td class="option"><code>--remote-*</code></td>
    <td class="desc">Vim をサーバとしてそっちに投げる的なあれ．</td>
  </tr>
</table>

`--remote` とかうまく使うと結構幸せになれそうな気がする．

追記: `-` については例えば `cat` なども同様のを取るらしい．

{% highlight text %}
$ cat - foo.txt > bar.txt
{% endhighlight %}

とやれば，標準入力に打ち込んだ内容と `foo.txt` を concatenate したものが `bar.txt` に書き込まれる．
