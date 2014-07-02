---
layout: post
title:  "Evernote web clipper で特定サイトからのクリップで特定 tag を付けたい"
date:  2014-07-03 00:00:00 UTC+9
categories: javascript
---

普段使いのブラウザは Firefox, evernote web clipper は大変便利に使っている．
こいつには smart filling といって tag とか notebook を自動で埋めるという機能があるんだが，

![smart filling]({{site.baseurl}}/img/2014-07/03_evernote_clipper0.png)

これの挙動が外から見えなくて若干気持ち悪いのと，学習してもらうんじゃなくて最初から自分である程度 configure したいという需要があった．例えば

* stackoverflow.com から clip するときには stackoverflow タグをつけて欲しい
* タイトルに python とあったらとりあえず python タグつけてくれれば良い
* その他 (regex) で (なんか) してほしい

で，ちょっと前から自分で拡張書く妄想とかしてたんだけど，今冷静に考えてみれば手許で動いている web clipper のコードにちょっと手を加えるのがどう考えても圧倒的に楽．

求めるコードはどこにあるかというと，多分システムにもよるが僕のでは `~/.mozilla/firefox/[profileの名前っぽいなんか].default/extensions/foobar/` あたり．
`foobar` のところはパッと見ではわからない感じになっているので `ag evernote` とかして探すとよいでしょう．

でまあそこから `tag` とか `smart` とか色々で grep しながら眺めたり掘ったりしていくと，
例えば `chrome/content/common/libs/evernote/FF/Popup/FFQuickNoteController.js` に行き着いたりします．
全体の構造はまだ全然つかめてないのでなんとも言えんのですが，こんな感じのコードがあって

{% highlight javascript %}
  if ( smartFillingEnabled == Evernote.Options.SMART_FILLING_ENABLED_OPTIONS.ALL || smartFillingEnabled == Evernote.Options.SMART_FILLING_ENABLED_OPTIONS.TAGS ) {
    if ( data && data.tags && data.tags.list && data.tags.list.length > 0 ) {
      for ( i = 0; i < data.tags.list.length; ++i ) {
        this._tagControl.addTag( data.tags.list[i].name );
        anythingSelectedBySmartFilling = true;
      }
    }
  }
{% endhighlight %}

みたいな感じの処理をしているところがあって，まあおおよそこのあたりでは tag が足されたりしているわけだ．

というわけで，このあたりにちょっとこういうのを足してみる

{% highlight javascript %}
var this_url = this._popup.getTabUrl();
var regex_stackoverflow = /https?:\/\/stackoverflow.com\/.*/;
if (regex_stackoverflow.test(this_url)){
  this._tagControl.addTag("stackoverflow");
}
{% endhighlight %}

ここに入れるのがどのくらい綺麗なのかはともかく，とりあえずこれで stackoverflow から clip するときには自動でタグがつくようになりました．良かったですね．
