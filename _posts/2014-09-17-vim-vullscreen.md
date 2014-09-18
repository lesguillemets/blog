---
layout: post
title:  "gVim をいい感じに最大化してくれる vullscreen が便利"
date:  2014-09-17 12:00:00 UTC+9
categories: vim
---

GVim でふつうにウィンドウを最大化するとこういうことになりがちだ[^cit]．

![normal-maximize]({{site.baseurl}}/img/2014-09/17-vullscreen-00.png)

もちろんこれはこれで正しく最大化，なのだが，例えばブラウザを，例えばターミナルを最大化した時みたいに
画面全体を GVim が覆う感じになってほしい．あまり GVim は使わないからまあ別にいっかって感じで
そのまま解決策を探してはいなかったのだが，最近ちょうどこれをターゲットにしたプラグインが登場した．
その名は **[VullScreen](https://github.com/KabbAmine/vullScreen.vim)**.
多くのディストリビューションでレポジトリに入ってる wmctrl に依存している．必要なら `sudo apt-get install wmctrl`[^apt] してから

{% highlight Vim %}
Neobundle 'KabbAmine/vullScreen.vim'
{% endhighlight %}

で `:VullScreen`. このようになる．

![vullscreen-maximize]({{site.baseurl}}/img/2014-09/17-vullscreen-01.png)

適宜 `map` するとよく，デフォルトでは `<F11>` になっているようだが，こっちがたまに効かない気がする（？）．
他に KDE だと `:tabe` する時などに崩れることがあって，再現条件とかを絞り込んだら issue たてましょうね．

[^cit]: 要出典，というか，普段全然 GVim つかわないから本当にこうなりがちなのかはわからない．
[^apt]: そういえば最近のバージョンでは [apt コマンドが新しくなった](http://gihyo.jp/admin/serial/01/ubuntu-recipe/0327) んですね．`apt-get`/`apt-cache` に慣れちゃってるから使ってないが，また見とこう．
