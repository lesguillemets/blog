---
layout: post
title:  "Python で your Python may not be configured for Tk といわれて tkinter できない"
date:  2014-07-21 22:33:34 UTC+9
categories: python
---

### 問題

最近 python (3) も自分でビルドしてるんだけど， `tkinter` を `import`
しようとしたときに

{% highlight text %}
Python 3.4.1 (default, May 22 2014, 22:07:00) 
[GCC 4.6.3] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import tkinter
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/local/lib/python3.4/tkinter/__init__.py", line 38, in <module>
    import _tkinter # If this fails your Python may not be configured for Tk
ImportError: No module named '_tkinter'
{% endhighlight %}

といわれてしまった．

### Ask stackoverflow

[Tkinter: "Python may not be configured for Tk" - Stack Overflow](http://stackoverflow.com/questions/5459444/tkinter-python-may-not-be-configured-for-tk)

そっか自前だとそのへんも自分でやるんだなー

{% highlight text %}
$ sudo apt-get install tk-dev
{% endhighlight %}

して ソース置いてあるところまで移動の後 `./configure` (は要らないかも),
`make`, `sudo make install`

できたらあとは

{% highlight text %}
import tkinter
tkinter._test()
{% endhighlight %}

めでたし．
