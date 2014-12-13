---
layout: post
title:  "Klipper+Vim(?)で QClipboard::setData: Cannot set X11 selection owner for PRIMARY"
date:  2014-12-13 00:00:00 UTC+9
categories: Qt
---

Ubuntu + KDE + Klipper (+uim/mozc) という環境で，端末上の Vim で visual mode でカーソル動かすと
その場所にこんな表示がでろでろ流れ出てくるようになった：

> QClipboard::setData: Cannot set X11 selection owner for PRIMARY

* `j`とかそのへんにまつわる `vmap` は特にない．
* Klipper を終了すると再現しない．
* Klipper 再起動やOS再起動では解決しない．

同じメッセージで検索かけるといくつか出てくるのだが[^ub][^os], 全体に古いしどうも根っこが違いそうにも見える．

[^ub]: [Bug #479740 “Copy and paste broken after using input method” : Bugs : qt4-x11 package : Ubuntu](https://bugs.launchpad.net/ubuntu/+source/qt4-x11/+bug/479740)
[^os]: [Copy/Paste problem with qt4.5.2 - forums.opensuse.org](https://forums.opensuse.org/showthread.php/417992-Copy-Paste-problem-with-qt4-5-2)

うーん困ったなーと思ってたのですが，Klipper -> Clear clipboard history から Klipper の履歴を削除すると再現しなくなってしまい，僕としてはめでたし．
ただ何だったのかは気になります．
