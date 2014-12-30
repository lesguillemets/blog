---
layout: post
title:  "Haskell で PIL みたいに気軽にお絵かき / mandelbrot"
date:  2014-12-30 00:00:00 UTC+9
categories: haskell
---

## イントロ

最近しばらくごく小さな javascript を除いては基本的に haskell 縛りで生きてみようというようなことを考えついて，
画像についてちょっと調べてみたのですが，どうやらベクタ画像については
[Diagrams](http://projects.haskell.org/diagrams/) というのがかなりいいっぽい．

一方 python でいう PIL みたいにラスタ画像を手軽に扱えるのないのかなーと思ってたのですが，
[JuicyPixels: Picture loading/serialization (in png, jpeg, bitmap, gif, tga, tiff and radiance)](https://hackage.haskell.org/package/JuicyPixels)
というのがわりとそれっぽく使えそうな感じなのでご紹介．
何故か僕の環境には入ってたんだけど，これは自分で入れてたのか，なんかのライブラリの依存元だったのか．

[Codec.Picture (hoogle)](https://hackage.haskell.org/package/JuicyPixels-1.2/docs/Codec-Picture.html)みればだいたい
使い方がわかるのは静的型のありがたいところですね．
どうやら基本的に `Data.Word.Word8` をピクセルや RGB 値として使い，画像はその列として
`Data.Vsctor.Storable.Vector` を基盤にできるっぽい．

Gray scale で横幅10px くらいの png を出力するのはこんな感じ：

{% highlight haskell %}
import qualified Data.Word as W
import qualified Data.Vector.Storable as V
import qualified Codec.Picture as P

main = let dat = V.fromList [255,254,254,254,23,23,24,150,150,250,250] :: V.Vector W.Word8
           img = P.Image { P.imageHeight = 1, P.imageWidth = V.length dat, P.imageData = dat } :: P.Image P.Pixel8
           in
               P.writePng "./out.png" img
{% endhighlight %}

## Mandelbrot!

人がなぜ png 画像を扱いたいかというと，それはひとえにフラクタル画像を描いてみたいからであります．違うか．

Python とか javascript とかで描いてもう飽きた感もあるけど，haskell で! とかんがえるとやる気も出てくるので
`900*600` px で Mandelbrot を描いてみました．結構速い，大きくなった時にどうなるかわからんけど．
ソースファイルは [こちら]({{site.baseurl}}/assets/2014-12/small_mandel.hs)

{% highlight haskell %}
import Data.Complex
import qualified Data.Word as W
import qualified Data.Vector.Storable as V
import qualified Codec.Picture as P

main :: IO ()
main = P.writePng "./out.png" $ mandel ((-2):+(-1)) (1:+1) 900 600

type CPoint = Complex Double

mandel :: CPoint -> CPoint -> Int -> Int -> P.Image P.Pixel8
mandel topLeft bottomRight width height = P.Image {
    P.imageWidth = width,
    P.imageHeight = height,
    P.imageData = V.generate (width*height)
        (\n -> let (y,x) = n `divMod` width in
                    convergence (topLeft + dx* fromIntegral x + dy* fromIntegral y))
} where
    dx = (realPart bottomRight - realPart topLeft) / fromIntegral width :+ 0
    dy = 0 :+ (imagPart bottomRight - imagPart topLeft) / fromIntegral height

convergence :: CPoint -> W.Word8
convergence c = convergence' c 5.0 (0:+0) 200

convergence' :: CPoint -> Double -> CPoint -> Int -> W.Word8
convergence' _ _ _ 0 = 0
convergence' c threshold xn n
    | magnitude xn' > threshold = 255 - fromIntegral n
    | otherwise = convergence' c threshold xn' (n-1)
    where
        xn' =  xn*xn + c
{% endhighlight %}

それでこんな感じ．

![mandel]({{site.baseurl}}/img/2014-12/30-haskell-mandelbrot.png)

手軽にちょっと書きたいときとかにはかなりいいかも知れません．
