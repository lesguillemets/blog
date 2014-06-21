---
layout: post
title:  "Three.js でカメラの回転"
date:   2014-06-21 13:45:41 UTC+9
categories: javascript three.js
---

[Three.js](http://threejs.org/) でカメラの回転について．こういうのはイメージで覚えとくのがいいと思うのでやってみる．

### 三次元での回転

いうまでもないことだが，三次元での回転はまあ，色々とちょっとだけややこしい．
記述の方法にも色々あって，それぞれ three.js でもサポートされているが，
ここでは単純に書きやすい [Euler 角](https://en.wikipedia.org/wiki/Euler_angles) で描いてみよう．
Camera object を回すことを考える．

### `Object3D.rotation`

[Document is here](http://threejs.org/docs/#Reference/Core/Object3D).

Euler 角で表記するときに必要なのは x,y,z それぞれの方向の角と，
どの順番で回転をするか．Three.js では順番は文字列で指定する (default: "XYZ")．
雰囲気はこんなかんじだ．

{% highlight javascript %}
camera.rotation
// Object { _x: -3, _y: 1, _z: 0, _order: "XYZ", onChangeCallback: THREE.Object3D/<.rotation.value<() }
{% endhighlight %}

というわけで，(`camera.rotation.set` とかでもできるわけだけど）

{% highlight javascript %}
camera.rotation.order = "XYZ"
camera.rotation.x = 0.3;
{% endhighlight %}

みたいなことをすればよい．

ふらふら迷いこむときに気をつけるべきは

* 回転が適用される順番は値を与える順番にはよらない
* 回転の軸は世の中の座標軸じゃなくて本人の座標軸
* ちなみにだけど `camera.eulerOrder` ってのがあるけど deprecated.

というあたりだろうか．

### やってみる

まず最初にこのようなシーンを用意します．

![scene.png]({{site.baseurl}}/img/2014-06-21/scene.png)

`z` 軸が上で，カメラは `(220,0,80)` のところにいて原点を見ています．
我々の方には `x` 軸が突き刺さってきています．

カメラを動かすときには気分的にまず z軸方向に回したい（左右を見回したい）のでそのようにしてもらいましょう

{% highlight javascript %}
camera.rotation.order = "ZYX";
{% endhighlight %}

すると (`camera.rotation.x` などは保持されたままなので) このようになります:

![eulerOrderSet.png]({{site.baseurl}}/img/2014-06-21/eulerOrderSet.png)

もういちど原点のほうを向いてもらいましょう (`O = new THREE.Vector3(0,0,0);`):

{% highlight javascript %}
camera.lookAt(O);
{% endhighlight %}

![lookAtOrigin.png]({{site.baseurl}}/img/2014-06-21/lookAtOrigin.png)

ここで `camera.rotation.z` は &pi;/2, `camera.rotation.y` は 0 になっています．
`rotation.z` を増やしてみると

{% highlight javascript %}
camera.rotation.z += 0.2;
{% endhighlight %}

![rotZAdded.png]({{site.baseurl}}/img/2014-06-21/rotZAdded.png)

ちょっと左を向けます．

こんどはもうちょっと足元をみたい．

{% highlight javascript %}
camera.rotation.x -= 0.2;
{% endhighlight %}

![watchYourStep.png]({{site.baseurl}}/img/2014-06-21/watchYourStep.png)

原点を見なおして首をかしげる

{% highlight javascript %}
camera.lookAt(O);
camera.rotation.y += 0.2;
{% endhighlight %}
![uh-huh.png]({{site.baseurl}}/img/2014-06-21/uh-huh.png)

ということで次から迷わない．
