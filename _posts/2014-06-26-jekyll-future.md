---
layout: post
title:  "github pages + jekyll で予約投稿"
date:   2014-06-26 22:30:00 UTC+9
categories: jekyll
---

Jekyll のオプションに [`future`](http://jekyllrb.com/docs/configuration/#build-command-options) というのがある．
これは bool 値を取るオプションで，ドキュメントによれば単純明快，”Publish posts with a future date.” とのこと．

default では `true` なこのオプションを `false` にすると，未来の日付の post は publish されなくなる．
Github にこれで push した場合に，時刻が来ると publish されるのか，なにかしらのことを（何でもいいから push するとか）しないと反映されないのか，
この post で確かめる．

結果

↓↓↓

反映されなかった．結局 github pages の方で rebuild されるのに push とかが必要らしい．
[stackoverflow](http://stackoverflow.com/questions/24353638/show-only-future-posts-in-jekyll)にも似た話があり，
丁度同じ事を試さはった [blog](http://praglowski.com/2013/03/14/scheduling-a-future-posts-in-jekyll/) もある．

`cron` で `push` って auth どうするんだろう，ssh 作るといけるでみたいな話もあるし，あるいは
[Personal access tokens](https://github.com/settings/applications) とか使えばいいのかな．
