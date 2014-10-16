---
layout: post
title:  "`CTRL-w` で始まるVim の Window 操作あれこれ"
date:  2014-10-16 00:00:00 UTC+9
categories: Vim
---

`h windows.txt` から，`:new` などのコマンドを用いないものをまとめます．

## Opening and closing a window

### opening

* `<C-w> s` : `:sp` と一緒．
* `<C-w> v` : `:vsp`.
* `<C-w> n` : `:new`.
* `<C-w> ^` : `:split #` と同じで alternate file を開く．

このあたり全体に `<C-w><C-s>` でも良いっぽい．Konsole とかでは `<C-s>`
は出力を suspend するからまあよしなに考えましょう．
また，それぞれカウントも与えられて，この場合は幅指定などになる．

### closing

* `<C-w> q` : `:quit`. これも `<C-w><C-q>` でもよい．
* `<C-w> c` : `:close`. これはほとんど使ったこと無いな．
* `<C-w> <C-c>` : これも `:close` すると思ったでしょ．`<C-c>` はコマンドをキャンセルするのでそうなりません．
* `<C-w> o` : `:only`. current window を screen の中で唯一のものにして，ほかは全部 close する．最近覚えた．

## Moving

### Moving cursor to other windows

* `<C-w> j` あるいは `<C-w><Down>`, `<C-w><C-j>` : `j` 方向に．
* `<C-w>` `k`, `h`, `l` いずれも同じ．
* `<C-w> w` : 右下方向に動かす．端っこまで来たら top-left にうつる．
* `<C-w> W` : 左上方向．
* `<C-w> t` : top-left window に移動．
* `<C-w> b` : bottom-right に．
* `<C-w> p` : 直前にいた window に飛ぶ．
* `<C-w> P` : preview window に．

カウントを与えると大体 `n` 段飛びになる．また visual mode のときは，
2 つの window が同じ buffer を扱ってる[^onbuf]時は継続され（るようにカーソルが動く），
そうでなければ visual mode からは抜けることになる．

### Moving windows around

* `<C-w> r` : 右下方向に rotate.現在の window がある row ないし column だけで働くとかいてある．カーソル位置はそのまま．
* `<C-w> R` : 上左方向．
* `<C-w> x` : 現在の window と [nth] next window を交換．カーソルは交換されたやつに行く．next window がなければ previous と交換，これも同じ row ないし column だけで働く．
* `<C-w> [K/J/H/L]` : 現在の window をそっち方向の端っこに．幅ないし高さも最大化する．
* `<C-w> T` : 現在の window を新しい tab page に．既に今の tab page にひとつしか window がない場合は失敗する．

rotate とかなかなか覚えると良さそうだ．

---

resizing と tag とかは省いてこんな感じ．割と覚えやすいように出来ていますね．ただこの辺を組み合わせて任意の状況から望む並びまで出来るかというとちょっと慣れが必要かもしれません．

[^onbuf]: "on the same buffer"
