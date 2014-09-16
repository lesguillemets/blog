---
layout: post
title:  "Numeric Haskell: A Vector Tutorial"
date:  2014-09-16 00:00:00 UTC+9
categories: haskell
---

今回も Haskell Wiki から[^moto]．

[Vector](http://hackage.haskell.org/package/vector) は array を使うためのライブラリ．
[loop fusion](https://en.wikipedia.org/wiki/Loop_fusion) とか使った非常に高いパフォーマンスに重点を置いていて，
インターフェイスもいい感じに整えてある．
メインのデータタイプは boxed なのと unboxed な array で， immutable (pure) なのと mutable なのがある[^mut]．
C とのやりとりに便利な Storable elements を格納できるし，array type と相互変換も可能．Index は非負の `Int` だ．

API は有名な haskell の list と似ていて，名前が同じものも多い．

この tutorial は [NumPy の tutorial](http://www.scipy.org/Tentative_NumPy_Tutorial) をベースにしている．

## Quick tour

### Importing the library
Vector package をインストール[^cabal]：

{% highlight text %}
$ cabal install vector
{% endhighlight %}

boxed array については

{% highlight haskell %}
import qualified Data.Vector as V
{% endhighlight %}

unboxed については

{% highlight haskell %}
import qualified Data.Vector.Unboxed as V
{% endhighlight %}

### Generating Vectors
いろんな作り方がある[^non-qualified]．以下 ghti[^type]

{% highlight haskell %}
Prelude> :m + Data.Vector
-- リストから
Prelude Data.Vector> let a = fromList [10,20,30,40]
a :: Vector Integer
Prelude Data.Vector> a
fromList [10,20,30,40]
it :: Vector Integer

-- or filled from a sequence
Prelude Data.Vector> enumFromStepN 10 10 4
fromList [10,20,30,40]
it :: Vector Integer

-- 隣接する値なら
Prelude Data.Vector> enumFromN 10 4
fromList [10,11,12,13]
it :: Vector Integer
{% endhighlight %}

list みたいな作り方も出来る．

{% highlight haskell %}
-- the empty vector
Prelude Data.Vector> empty
fromList []
it :: Vector a

-- a vector of length one
Prelude Data.Vector> singleton 2
fromList [2]
it :: Vector Integer

-- 値と長さを指定．Prelude の奴と衝突するからフルで指定する
Prelude Data.Vector> Data.Vector.replicate 5 2
fromList [2,2,2,2,2]
it :: Vector Integer
{% endhighlight %}

index と函数から作れるのも便利．

{% highlight haskell %}
Prelude Data.Vector> generate 5 (^2)
fromList [0,1,4,9,16]
it :: Vector Int
{% endhighlight %}

次元は 1 でなくても良い

{% highlight haskell %}
Prelude Data.Vector> let x = generate 4 (\n -> Data.Vector.replicate 5 n)
x :: Vector (Vector Int)
Prelude Data.Vector> x
fromList [fromList [0,0,0,0,0],fromList [1,1,1,1,1],fromList [2,2,2,2,2],fromList [3,3,3,3,3]]
{% endhighlight %}

伸ばしたり縮めたり

{% highlight haskell %}
Prelude Data.Vector> let y = Data.Vector.enumFromTo 0 6
Prelude Data.Vector> y
fromList [0,1,2,3,4,5,6]
it :: Vector Integer
Prelude Data.Vector> Data.Vector.take 3 y
fromList [0,1,2]
Prelude Data.Vector> y Data.Vector.++ y
fromList [0,1,2,3,4,5,6,0,1,2,3,4,5,6]
{% endhighlight %}

[^moto]: 元記事：http://www.haskell.org/haskellwiki/Numeric_Haskell:_A_Vector_Tutorial
[^mut]: mutable なのがあるのはいいですね．
[^cabal]: …標準で入ってると思って（atcoder で使おうと思って）書き始めたのに現実は非情だ……．
[^non-qualified]: 上では `qualified` してるけどここではふつうに `import` してる
[^type]: ghci で `:set +t` とすると常に評価後に type を表示するようになる．`:help` 参照


