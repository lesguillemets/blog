---
layout: post
title:  "vim を +python3 でビルドしようとして PyUnicodeUSC4_Decode がない云々"
date:  2014-08-19 17:19:57 UTC+9
categories: python vim
---

表題の通りで，今は面倒になったのでやめるが

> if_py_both.h:261: undefined reference to `PyUnicodeUCS4_Decode'

みたいなのが出てアレし， `/src/auto/config.cache` とかをチェックしても大丈夫そうだし何なんだろうと思っていたら，原点に立ち返って

[https://wincent.com/wiki/building_Vim_from_source](https://wincent.com/wiki/building_Vim_from_source)

あたりを眺め `make clean distclean` してから build したら成功した．謎．

* https://docs.python.org/3/c-api/unicode.html
* [Burak Sezer : Compile Vim with Python support](https://coderwall.com/p/ft_1wq)
* [python - where to find PyUnicodeUCS4_Decode? - Stack Overflow](http://stackoverflow.com/questions/8146785/where-to-find-pyunicodeucs4-decode)
* [unicode - How to find out if Python is compiled with UCS-2 or UCS-4? - Stack Overflow](http://stackoverflow.com/questions/1446347/how-to-find-out-if-python-is-compiled-with-ucs-2-or-ucs-4)
* [undefined symbol: PyUnicodeUCS4_FromEncodedObject](https://www.rosettacommons.org/node/1901)


ううむ．
