---
layout: post
title:  "matplotlib で AttributeError: max must be larger than min in range parameter"
date:  2014-07-30 12:00:00 UTC+9
categories: python matplotlib
---

### 問題

matplotlib.pyplot をつかってヒストグラムを書いてみよう．

{% highlight python %}
#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
filename = "myfile.tsv"
data = np.genfromtxt(filename, delimiter='\t')
plt.hist(data[:,5])
plt.show()
{% endhighlight %}

すると

{% highlight text %}
AttributeError: max must be larger than min in range parameter.
{% endhighlight %}

とエラーが出てしまう． `max` や `min` を指定した覚えはないのにどうしたことだろうか．

### 解決
`.tsv` からの読み込みのときに入る(可能性のある) `Nan` が問題を引き起こしている．

`np.genfromtxt` はなかなかいい感じにいい感じで，欠損してる値に対しては `np.nan` を入れてくれる．
この `np.nan` がちょっとした性質を持っていて，これが（[`plt.hist`](http://docs.scipy.org/doc/numpy/reference/generated/numpy.histogram.html) が設定する）
`max` や `min` について問題を引き起こすわけだ．

{% highlight text %}
a = np.nan
>>> a > 100
False
>>> a < 100
False
>>> a > -100000
False
>>> a > -np.inf
False
>>> a < np.inf
False
>>> a < a
False
>>> a == a
False
>>> a <= a
False
>>> a is a
True
{% endhighlight %}

で，[`np.isnan`](http://docs.scipy.org/doc/numpy/reference/generated/numpy.isnan.html) あたりを使いつつ適宜
[フィルタすれば](http://stackoverflow.com/questions/11620914/removing-nan-values-from-an-array)うまく行くっぽい．

ありがとうございました．
