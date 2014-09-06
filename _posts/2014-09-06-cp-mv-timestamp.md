---
layout: post
title:  "cp とか mv の更新日時について"
date:  2014-09-06 12:00:00 UTC+9
categories: bash
---

`cp` には `-a`, `--archive` というオプションがある．

> `-a`, `--archive` : same as `-dR --preserve=all`

`-d` とかそのへんはまあ面倒なので置いとくとして， timestamp とかそのへんを preserve してくれるっぽい．

つまり

{% highlight bash %}
touch a
# ここで1分待つ
cp a b
cp -a a c
cp -a a d
mv d e
ls -l
{% endhighlight %}

とやるとこういう感じになる：

{% highlight text %}
-rw-rw-r--  1 me me    0 Sep  6 16:29 a
-rw-rw-r--  1 me me    0 Sep  6 16:31 b
-rw-rw-r--  1 me me    0 Sep  6 16:29 c
-rw-rw-r--  1 me me    0 Sep  6 16:29 e
{% endhighlight %}

というわけで賢く使っていきましょう．`mv` で変わらないのは（ディレクトリの扱いとかにも出ている通り）`cp` と `mv` では結構やってることが違うから当然だが，
`cp a b; rm a` 相当のことって単純なコマンドでできたりするかな…（あれ，それをしたくことはない？）
