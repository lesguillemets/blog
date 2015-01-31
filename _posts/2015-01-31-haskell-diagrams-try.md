---
layout: post
title:  "Haskell でお絵かき: diagrams (1)"
date:  2015-01-31 12:00:00 UTC+9
categories: haskell
---

Haskell でベクタ画像をお絵かきするなら [diagrams](http://projects.haskell.org/diagrams/) が定番らしい．
`svg` がメイン，という感じだが，`png` とかでの出力もできるし，`cairo` backend を使えば
直接 animated gif を出力したりもできるらしい．

チュートリアルは [Diagrams - Diagrams Quick Start Tutorial](http://projects.haskell.org/diagrams/doc/quickstart.html)
が十分親切で，まずはこれを読んでおけばよいとおもう[^old]．ひとつ気をつけるべきは `beside` で，こういうふうに使うけど

{% highlight haskell %}
circleSqV1 = beside (r2 (1,1)) (circle 1) (square 2)
{% endhighlight %}

この `r2 (1,1)` は方向を示すだけで，実際の位置は「その方向で，ふたつの図形が接する場所」ということになる．
横にずらすには `translate` 系を使う．

とりあえずここまでで，円を格子状に並べた連番 png を作ってみた．
最後に animated gif にするつもりなので，Cairo を使って png を出力している．

{% highlight haskell %}
import Diagrams.Prelude as DP
import qualified Diagrams.Backend.Cairo as C
import Data.List (foldl1')

main = mapM_ create [0..99]

create n = C.renderCairo ("./anim" ++ show' n ++ ".png") size $ example d nu
    where d = -0.5 + 0.01* fromIntegral n
size :: SizeSpec2D
size = mkSizeSpec (Just 500) (Just 500)

nu :: Int
nu = 15

show' :: Int -> String
show' n
    | n < 10 = '0' : show n
    | otherwise = show n

example :: Double -> Int -> Diagram C.B R2
example d n = flip atop (square 10 # fc white)  $ circles d n

oncat = foldl1' atop

circles :: Double -> Int -> Diagram C.B R2
circles d n = center . oncat . take n . iterate (translate yr) . oncat . take n $ row
    where
        xr = r2 (d,0)
        yr = r2 (0,d)
        row = iterate (translate xr) $ circle 1 # lw veryThin
{% endhighlight %}

ふむふむ．

---

上から順に見ていく．

最終的な出力は

{% highlight haskell %}
C.renderCairo fileName size shape
{% endhighlight %}

というような形で行われる．
`size` は出力画像のサイズ．`mkSizeSpec` で作った．
これは縦横どちらも指定があるとは限らないから `Maybe Double -> Maybe Double -> SizeSpec2D` という型
…なんだけど， `Maybe Int` じゃなくていいんだろうか．

さておき，連番での出力には `n` 番目の画像を作る `create :: Int -> IO ()` と `mapM_` を使っていて，ファイル名を作るのに `show'` を定義した．
結局 `00..99` にしたいだけなので，本来なら `Text.Printf` を使うところだろう．

`example` はもともとサンプルに書いていたのの名残なので気にしないでほしい．これが本体で， d (円同士の距離）と n （並べる円の個数）
を受け取って画像を返す．`flip atop (square 10 # fc white)` で白い正方形を背後においているが，
これは i) 背景を透過でなくするため と ii) 描画領域を一定にするため で，それぞれ多分他のやり方があると思うのでまた調べたい．

上に載ってるのが `circles` で，「半径 1 の円[^circ]を横にずらしながらたくさん並べたlist」（`row`）の先頭 n 個を繋げたやつ[^onc]，
を縦にずらしながら同じようにn個並べて[^itr]，画面中央に持ってきたやつ[^cent]，ということになっている．

画像の list をくっつけるのには `hcat` が少なくともあるようなのだけれど，これは画像を重ねないっぽくて，望む結果にならない．
上に載せていくのは `atop :: QDiagram b v m -> QDiagram b v m -> QDiagram b v m` を使えばよく，これを `fold` して使うことにした．
これもなんかそれっぽいのが定義されてそうだけど，まずは自分の手でもできる．

これを実行すると anim00.png -- anim99.png ができるので `convert -colors 4 *.png anim.gif` するとこのようになる（ちょっと重いので imgur 上に置いた）．

![result](http://i.imgur.com/wqWOOI2.gif)

よかったですね．

[^old]: [http://www.cis.upenn.edu/~byorgey/diagrams-doc-HEAD/doc/quickstart.html](http://www.cis.upenn.edu/~byorgey/diagrams-doc-HEAD/doc/quickstart.html) はほぼ同様の内容だけど，やや内容が古い．
[^circ]: `circle 1 # lw veryThin`
[^onc]: `oncat . take n $ row`
[^itr]: `oncat . take n . iterate (translate yr)`
[^cent]: `center`
