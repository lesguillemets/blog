---
layout: post
title:  "ECMAScript 5 の新しい array methods"
date:  2014-10-02 12:00:00 UTC+9
categories: javascript
---

[5 Array Methods That You Should Be Using Now | colintoh.com](http://colintoh.com/blog/5-array-methods-that-you-should-use-today)
という記事に `Array.indexOf()`, `Array.filter()`, `Array.forEach()`, `Array.map()`, `Array.reduce()`(!) が紹介されていて，
そこで参照されていた [ECMAScript 5 compatibility table](http://kangax.github.io/compat-table/es5/) を見ると，
一般的なブラウザで案外いろんな array の method がサポートされてるのに気付いたのでメモ．
ECMAScript 5 の機能は IE9+ を始め殆どのブラウザで実装されているようで[^ecma5]，この感じだと状況によってはガンガン使えるのではないでしょうか．


### [`Array.prototype.indexOf()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf)
`arr.indexOf(searchElement [, fromIndex = 0])`. `fromIndex` が `arr.length` より大きければ常に `-1` が返り，
`fromIndex` に負の値を与えると array の最後からの offset として解釈される．

{% highlight javascript %}
var a = ["Tofu", "Penguin", "Hummingbird"];
a.indexOf("Penguin")
// => 1
a.indexOf("Dragon")
// => -1
{% endhighlight %}


### [`Array.prototype.lastIndexOf()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/lastIndexOf)
`indexOf` と同様に `fromIndex (= arr.length)` を指定できる．最後のを探すんじゃなくて逆から走査するつもりでいいと思う．

{% highlight javascript %}
var a = [5,3,1,2,1];
a.lastIndexOf(1)
// => 4
a.lastIndexOf(5)
// => 0
a.lastIndexOf('foo')
// => -1
{% endhighlight %}

### [`Array.prototype.every()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every)

{% highlight javascript %}
var a = [1,3,5];
a.every( function(e){ return e%2 === 1; } )
// => true
var b = [1,4,5];
b.every( function(e){ return e%2 === 1; } )
// => false
{% endhighlight %}

callback function は `currentValue`, `index`, `array` の3つの引数を受け取る．また `every` に optional で `thisArg` を渡せて，
これは callback を実行するときにこれが `this` になるよ，という値．<del>これだからjsは</del>

### [`Array.prototype.some()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some)

{% highlight javascript %}
var a = [1,3,5];
a.some( function(e){ return e%2 === 0; } )
// => false
var b = [1,4,5];
b.some( function(e){ return e%2 === 0; } )
// => true
{% endhighlight %}

だいたい `every` と同じ．

### [`Array.prototype.forEach()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach)
これの callback も element, index, array being traversed を受け取れる．

{% highlight javascript %}
var a = [2,5,3];
a.forEach(function(e,i,a){ console.log(e,i,a); return e*i;})
// 2 0 [ 2, 5, 3 ]
// 5 1 [ 2, 5, 3 ]
// 3 2 [ 2, 5, 3 ]
// => undefined (or [ 0, 5, 6 ])
{% endhighlight %}

developer.mozilla.org の docs には「常に `undefined` を返す」と書いてあり，firefox もそのとおりの動作をする．
<del>node.js の v0.10.30 で試すと `[0,5,6]` が返ってきた．</del>
-> `map` と `forEach` を打ち間違えてたっぽい，すみません．

`thisArg` もある．

### [`Array.prototype.map()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)
わーーーい

{% highlight javascript %}
var a = [1,2,3];
a.map(function(e){ return e*2; })
// => [2,4,6];
{% endhighlight %}

callback が受け取れるものや `thisArg` についてはこれまでと同様．もう省略するね．

### [`Array.prototype.filter()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)

{% highlight javascript %}
var a = [1,2,3,4,5];
a.filter(function(e){ return e%2 === 0; })
// => [2,4]
{% endhighlight %}

### [`Array.prototype.reduce()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)

どんどん函数型っぽくなってくるね，よい．

{% highlight javascript %}
var a = [1,2,3,4,5];
a.reduce(function(acc,e) { return acc*e; })
// => 120
a.reduce(function(acc,e) { return acc*e; }, 3) // specify initial value
// => 360
{% endhighlight %}

この場合函数は `previousValue`, `currentValue`, `index`, `array` を受け取る．`thisArg` の指定はない．mozilla のドキュメントの解説が
親切なので慣れない場合は読んでみると良い．

### [`Array.prototype.reduceRight()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduceRight)

`foldr` ですね．正格評価だしどっちにしろという感じもあるが，使いたい時もあろう．例は省略．

&nbsp;

というわけでこんなもんだ．javascript もだんだん使いやすくなっていく（…のか，prototype が複雑化していって死ぬのかはわからないけれど）ということだろうか．
Javascript の ruby 化というのも面白い気がするね．個人的には [haste-compiler](https://github.com/valderman/haste-compiler) 推しだけれども．

[^ecma5]: [ECMAScript 6](http://kangax.github.io/compat-table/es6/) になるとまだサポートしてないブラウザもちょくちょくある（主にIE）っぽい．
