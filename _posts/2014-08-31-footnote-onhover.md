---
layout: post
title:  "Jekyll で脚注でマウスホバーでアレ"
date:  2014-08-31 12:00:00 UTC+9
categories: jekyll,javascript
---

とりあえずこの数字の上にマウスホバー[^a]

…とこのように脚注の上にマウスホバーして中身が見られるようにしてみました．とりあえずやってみただけなので色々雑で，javascript で `title` attribute を足してるだけです．
だからブラウザによって挙動が違う．ちゃんと自前で用意したほうがいいんだろうけど，楽さを優先してみた．

{% highlight javascript %}
function setFootnoteTitles(){
  footTags = document.getElementsByClassName("footnote");
  for (var i=0; i<footTags.length; i++){
    var footTag = footTags[i];
    var footNote = document.getElementById(
          (footTag.getAttribute("href")).slice(1)
        );
    var text = footNote.getElementsByTagName("p")[0];
    footTag.setAttribute('title',text['textContent']);
  }
}
{% endhighlight %}

こんな感じで実現．対応する脚注の中身取るのにどうしていいかわからなくて `href` から `#` を除いたやつが id になってるのでそれを取ってきて，そのなかの `p` タグをとってます．

良かったですね．

[^a]: なんか見えるはず
