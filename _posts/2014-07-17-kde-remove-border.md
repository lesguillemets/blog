---
layout: post
title:  "KDE で border をなくした"
date:  2014-07-17 18:00:00 UTC+9
categories: KDE
---

設定変更のたぐいって blog に綴っとくのに丁度いいと思うんだ．


KDE の感じもいいなーと思いつつ，もっとこうスリッとした感じにも憧れていたりしたのだが
それはともかく window の border をなくすようにした．”Syetem settings” -> “Workspace Appearance” -> “Window Decorations”
-> “Configure decoration” -> “Border Size” : “No border”. Grow が邪魔な感じだったから decoration options -> “Shadows” で幅を狭めた．
terminal とか並べた時にいい感じにいい感じでよい．

![no-border]({{site.baseurl}}/img/2014-07/17_no_border.png)

人はこうやって [tiling window manager](https://www.google.com/search?tbm=isch&q=tiling+window+manager)
を使うようになっていくのかもしれない．

ちなみに何らかのウィンドウから Alt+F3 で出てくるメニューから “No border” にするとタイトルの部分も消えて面白いのだが

![no-titlebar]({{site.baseurl}}/img/2014-07/17_no_titlebar.png)

上の部分を「掴む」のが出来なくてちょっと不便そうだから設定は辞めておいた．
デフォルトの挙動をこうしたい時は上の decoration options -> “Window-Specific overrides” で少なくとも設定できるんだけど，
全体に設定したいような場合ってどうするんだろう．


TODO : 

* もうちょっと theme のあたり弄ってみたいなー
* 黒系の theme もいいんだけどブラウザの色々と衝突したりするのでアレなのをアレする
* 起動時に全 workspace 共通の konsole をデスクトップ上に埋め込むようなことをしたい
