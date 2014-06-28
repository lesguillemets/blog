---
layout: post
title:  "Javascript の comma operator，そして言語ごとのコンマのちょっとした比較"
date:   2014-06-28 18:00:00 UTC+9
categories: javascript
---

コンマの扱いは意外なほど言語によって異なって，しかし案外意識されないので，気を付けないとハマる．

Python の場合は例えばだいたい `tuple` を作ってるつもりでいると良くて，同数の時は unpack してくれる．

{% highlight python %}
3,4
# => (3, 4)
a,b = 3,4
# => a==3, b==4
a,b = 4,5,6
# => ValueError: too many values to unpack (expected 2)
a,b,c = 3,4
# => ValueError: need more than 2 values to unpack
mylist = [0,1,2]
mylist[0,1]
# => TypeError: list indices must be integers, not tuple
{% endhighlight %}

ちょっと変わった所では

{% highlight python %}
a = 1
b = a, c = (4,5)
# a == 4, c == 5, b == (4,5)
{% endhighlight %}

という感じ．知らない間に馴染んでしまって「なんとなくそういう気分」なことが多かったのだが，
一方 Javascript では…

最初に気付いたのがこの案件．

{% highlight javascript %}
var a = [0,1,2];
console.log(a[0,1]);  // => 1
console.log(a[1,0]);  // => 0
console.log(a[-2,0,231,1]);  // => 1
console.log(a["there",1]);  // => 1
{% endhighlight %}

なんやこの(python に慣れてると)直感に反する挙動．僕としては Error 吐くか `undefined` かなんか返して欲しかった．

そういえば `node` で
{% highlight text %}
> a = 3,4
4
> a
3 // あれ?
{% endhighlight %}
とか
{% highlight text %}
> x,y = 4,3
ReferenceError: a is not defined
{% endhighlight %}
とかになったこともあった．

これらの正体は [comma operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_Operator) というもの．
平たく言えば expression たちを並べて返り値は最後の評価値となる，というもの．
そして結合順位がけっこう低くて，`a = 3,4;` は実は
{% highlight javascript %}
(a = 3), 4
{% endhighlight %}
で，返り値は最後の `4`, `a` に入るのは `3` ということになるらしい． `x,y = 4,3` のほうは
{% highlight javascript %}
x, (y=4), 3
{% endhighlight %}
ということで，最初に `x` を評価しようとすると Error が吐かれるという事情らしい．
なお `var a,b;` みたいなときのコンマは expression の中にあるわけじゃないから似て非なるものとかいうことだ．

ついでに ruby では
{% highlight ruby %}
a = 3,4
# => [3,4]
a,b = 3,4
# => [3,4] , a==3, b==4
a,b,c = 6,2
# => [6,2], a==6, b==2, c==nil
a,b = 9,3,1
# => [9,3,1], a==3, b==4
{% endhighlight %}
と，なんかあげぽよな感じ．

Haskell? これでかんべんしてください
{% highlight text %}
Prelude> :i (,)
data (,) a b = (,) a b  -- Defined in `GHC.Tuple'
instance (Bounded a, Bounded b) => Bounded (a, b)
  -- Defined in `GHC.Enum'
instance (Eq a, Eq b) => Eq (a, b) -- Defined in `GHC.Classes'
instance (Ord a, Ord b) => Ord (a, b) -- Defined in `GHC.Classes'
instance (Read a, Read b) => Read (a, b) -- Defined in `GHC.Read'
instance (Show a, Show b) => Show (a, b) -- Defined in `GHC.Show'
{% endhighlight %}


まあ，っちゅうわけで案外意識してない所でめっちゃハマった，という話．
個人的には最初に触ったので Python のが一番気持ちいいです．
