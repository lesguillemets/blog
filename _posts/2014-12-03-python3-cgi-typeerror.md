---
layout: post
title:  "Python3 + cgi.FieldStorage で typerror"
date: 2014-12-01 12:00:00 UTC+9
categories: python javascript ajax
---

嵌って結局友人に解決してもらったのでここにメモ．

## 概要

### 問題

Python 3 の `cgi` を使って `cgi.FieldStorage()` でデータを取得しようとする．
`curl --data "n=32"` とかだとうまく行くし，`/?n=32` のようにして POST してもうまく行くが，
javascript から POST しようとすると（あろうことか）python が `cgi.FieldStorage` に起因して `cgi.py` のなかで
`TypeError: must be str, not bytes` といって死んでしまう．

### 解決

`Content-type` の設定が必要で，javascript からやると何もしない時に（僕の場合）`text/plain` として送ってしまうけれど，
例えば `n=32` の形式なら `curl` がやっているように `application/x-www-form-urlencoded` とするのが正しい．

## 詳しく

### 構成
Python 3 で簡単な cgi を考えてみる．

こんなディレクトリ構成

{% highlight text %}
.
├── index.html
├── test.js
├── serve.py
└── cgi-bin
    └── cgi_test.py
{% endhighlight %}

大本の `serve.py`

{% highlight python %}
#!/usr/bin/env python3
# serve.py
import http.server

def main():
    server_address = ("", 8000)
    handler_class = http.server.CGIHTTPRequestHandler
    server = http.server.HTTPServer(server_address, handler_class)
    print("access: http://127.0.0.1:8000/")
    server.serve_forever()

if __name__ == "__main__":
    main()
{% endhighlight %}

今から叩く `cgi-bin/cgi_test.py`, `n` の値をそのまま返す．

{% highlight python %}
#!/usr/bin/env python3
# cgi-bin/cgi_test.py
import cgi
import cgitb

def main():
    cgitb.enable()
    print("Content-type: text/plain")
    print("")  # end of the header
    fields = cgi.FieldStorage() # ここで落ちる
    n = fields.getfirst('n', 0)
    print(n)

if __name__ == "__main__":
    main()
{% endhighlight %}

`index.html`. Javascript 経由で `cgi-bin/cgi_test.py` を叩いて結果を表示する．

{% highlight html %}
<!DOCTYPE html>
<!-- index.html -->
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title></title>
  <script src="./test.js"></script>
</head>
<body>
  Hi there!
  <pre id="response"></pre>
</body>
</html>
{% endhighlight %}

上で呼ばれる `test.js`.

{% highlight javascript %}
// test.js
window.addEventListener('load', fetchValue);

function fetchValue(){
  var request = new XMLHttpRequest();
  var params = "n=353";
  
  // although this works
  // request.open("GET", "cgi-bin/cgi_test.py?n=3232", true);
  request.open("POST", "cgi-bin/cgi_test.py", true);
  request.onreadystatechange = function(){
    if (request.readyState == 4 && request.status == 200){
      document.getElementById("response").innerHTML = request.responseText;
    }
  }
  request.send(params);
}
{% endhighlight %}


### 問題

これで `index.html` を見てみると `cgi-bin/cgi_test.py` が死んでいて

{% highlight text %}
Traceback (most recent call last):
  File "./cgi-bin/cgi_test.py", line 13, in main
    fields = cgi.FieldStorage()
  File "/usr/lib/python3.4/cgi.py", line 561, in __init__
    self.read_single()
  File "/usr/lib/python3.4/cgi.py", line 724, in read_single
    self.read_binary()
  File "/usr/lib/python3.4/cgi.py", line 746, in read_binary
    self.file.write(data)
TypeError: must be str, not bytes
{% endhighlight %}

……困った．

curl でうまく行くことを確認してみよう

{% highlight bash %}
$ curl --data "n=423" http://127.0.0.1:8000/cgi-bin/cgi_test.py
# => 423
{% endhighlight %}

問題ない． javascript から GET してみよう．こういう感じで書き換える

{% highlight javascript %}
// test.js
function fetchValue(){
  var request = new XMLHttpRequest();
  request.open("GET", "cgi-bin/cgi_test.py?n=3232", true);
  request.onreadystatechange = function(){
    if (request.readyState == 4 && request.status == 200){
      document.getElementById("response").innerHTML = request.responseText;
    }
  }
  request.send();
}
{% endhighlight %}

これも問題なく `3232` が表示される．さてさて．

### 解決

友人の託宣により `Content-type` を `x-www-form-urlencoded` に設定する

{% highlight javascript  %}
request.open("POST", "cgi-bin/cgi_test.py", true);
// +++
request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
{% endhighlight %}

…で解決する．やった！！やった！！！！考えてみれば `text/plain` だと思ってたのになんか `bytes` が来てるじゃんってのも
符合するし，渡してるのは確かにそういう値でもある．

確認のため，`cgi_test.py` に `cgi.print_environs()` を仕込んで確認してみると，
`curl --data` のときは `content-type` は `x-www-form-urlencoded` に設定されていて，
何も考えない最初の `javascript` では `text/plain` になっていた．


## さらに
ただ，いくらなんでも唐突な `TypeError` はどうかという気がするので，
どこでどう catch するのが適切かというのを考えていきたい．そもそも `cgi.FieldStorage` する前になにかしとくといいのかもしれないなあ…


というわけで，おわり．
