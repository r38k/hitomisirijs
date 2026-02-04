---
title: 'Haskell入門1'
pubDate: 2025-12-27 20:31
description: 'Haskellの勉強'
draft: true
tags: ["Haskell"]
---

こちらを読み進めながら進める．

https://www.lambdanote.com/products/haskell?variant=28860844277844

## 環境構築

wslにhaskell環境を作ります．
この本の中では，Haskell Platformの利用を推奨されていますが，2022年以降非推奨となっています．

[Haskell公式](https://www.haskell.org/get-started/)では`GHCup`を使用してHaskellツールチェーンをインストールおよび管理することが推奨されています．

[GHCup](https://www.haskell.org/ghcup/#)のインストール


wsl用
```sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

インストール時に色々と聞かれますが，全部デフォルトにしました．

::: NOTE
windows用
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { & ([ScriptBlock]::Create((Invoke-WebRequest https://www.haskell.org/ghcup/sh/bootstrap-haskell.ps1 -UseBasicParsing))) -Interactive -DisableCurl } catch { Write-Error $_ }
```
:::

GHCupに必要なパッケージをインストール
```sh
apt install -y build-essential curl libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev pkg-config
```

PATHを通す
```sh
. /home/r38k/.ghcup/env
```

`.zshrc`に追加
```sh
[ -f "/home/r38k/.ghcup/env" ] && . "/home/r38k/.ghcup/env" # ghcup-env
```

GHCupは以下のツールチェーンをインストールします．
- GHC
  - Haskellのコンパイラ
  - Glasgow Haskell Compilerの略
  - `ghci`でREPLが使えます
- HLS
  - HaskellのLanguage Server
  - VSCodeなどのエディタが使うことで補完などが使えるようになります
- Cabal
  - ビルドツール
- Stack
  - Cabalの代替
  - 今はCabalでいいらしい

VSCode用に拡張も入れます．
[Haskell for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=haskell.haskell)

::: NOTE
OpenVSXにもあるので，CursorやWindsurfでも使えます．
:::

## 導入

> Haskellにおける**関数**は，一つ以上の引数を取って一つの結果を返す，変換器です．

入力として定義された型の値の集合を別の集合に写す(マッピング)ときに使用するのが関数という認識．このマッピングを適用するときのことを関数適用ととらえている.

> 関数プログラミングとは何でしょうか？

自分なりの定義を見つけることを目標にしよう．

Haskellの特徴
- 簡潔なプログラム(2,4章)
  - 簡潔？あまりピンと来てないが．
- 強力な型システム(3,8章)
  - 多相性と多重定義．忘れた．
- リスト内包表記(5章)
  - 内包表記ってなんだと思ったけど，条件で書けるやつか．
- 再帰関数(6章)
  - あまり使ったことないな．
- 高階関数(7章)
  - 最近はTSで高階関数を書くことが多い．
- 作用を持つ関数(10,12章)
  - モナドとかだ．全然知らないので気になる．
- 汎用的な関数(12,14章)
  - 関手，アプリカティブ，モナド，Foldable，Traversable，一つも分からん
- 遅延評価(15章)
  - 言っていることは分かるが，恩恵があまりイメージできてない．
- 等式推論(16,17章)
  - 数学的帰納法懐かしい．

1930年代にAlonzo Churchがラムダ計算を考案．
1950年代にJohn McCarthyが最初の関数型言語とされるLispを開発．
1960年代にPeter Landinがラムダ計算に基づいた最初の純粋関数型言語であるISWIMを開発．
1970年代にJohn BackusがFPを開発．
同1970年代にRobin MilnerらがML(Meta-Language)を開発．多相型と型推論が導入された．
1970,1980年代にDavid Turnerがいくつかの遅延関数型言語を開発．その一つがMiranda．
1987年にプログラミング言語の研究者で構成された国際委員会が遅延関数型言語の標準としてHaskellの開発を開始した．名前は論理学者のHaskell Curryから．
1990年代にPhilip Wadlerらが多重定義を実現する型クラスの概念とモナドを利用した作用の扱いを開発．
2003年にHaskell委員会により，言語の安定仕様を定義したHaskell Reportを公開．
2010年に更新修正されたHaskell Reportが公開．

## はじめの一歩

Haskellであらかじめ組み込まれているモジュール群をプレリュードと呼ぶ．
`+`や`*`もプレリュードの一つ．

リスト操作で使うプレリュード関数
head, tail, take, !!, drop, length, sum, product, ++, reverse

GHCiでよく使うコマンド
`:load name` {name}プログラムを読み込む
`:reload` 現在のプログラムを再読み込みする
`:set editor name` エディタを{name}に設定する
`:edit name` {name}プログラムを編集する
`:type expr` {expr}の型を表示する
`:?` すべてのコマンドを表示する
`:quit` GHCiを終了する

命名規則
- 関数は先頭小文字

レイアウト規則
- 同一レベルのコードは同じ列に
- 波かっこも使える
- タブは使わない

コメント
コメントは`--`，`{- -}`

## 型と型クラス

> 型は，互いに関連する値の集合

`v :: T`は，vの型がTであるということ．
評価されていない式には`e :: T`と表記する．

> 型推論で鍵となるのは，「`f`が型`A`を型`B`へ変換する関数であり，`e`が型`A`の式であれば，関数適用`f e`の型は`B`である」

`f :: A -> B`, `e :: A` `f e :: B`

基本型

- Bool
- Char
  - Unicodeのすべての単一文字が値として含まれる
- String
- Int
  - 固定長整数
  - -2^63から2^63-1まで
- Integer
  - 多倍長整数
- Float
- Double

リスト型

[T]

関数型

型`T1`の引数を型`T2`の返り値に変換する関数の型は`T1 -> T2`
引数や返り値の型に制限はない．

関数は全域関数である必要がない．
=> すべての入力に対して結果を返す必要がない．

カリー化された関数

関数の返り値として関数を返すやつ．
関数全体で複数の引数が必要な場合に，一度に一つの引数を受け取る関数をつなげて一つの関数を形作る．
例えば，3つの数の積を計算する関数は3つの引き数が必要になる．
これを1つの引数を取って，その引数を簡約した状態の関数を返す．

``` haskell
mult :: Int -> (Int -> (Int -> Int))
mult x y z = x * y * z

-- x = 2とすると(mult 2)は以下の関数を返す
mult :: Int -> (Int -> Int)
mult y z = 2 * y * z
```

これが部分適用．
という認識．

Hakellでは複数の引数があれば，勝手にカリー化される．

多相型

任意の型に対応するもの．
lengthは任意の型`a`の配列`[a]`の長さを返す多相関数．
`length :: [a] -> Int`

多重定義型

一つ以上の型クラス制約を持つ型のこと．
任意の型`a`に対して，`Num a`のように記述すると任意の型`a`は`Num`(数値型)である必要がある．
整数や浮動小数，その他の数値の型になる．

基本クラス

型クラス(または単にクラス)は，共通のメソッドを提供する型の集合．
メソッドとは，多重定義された操作のこと．

例
- Eq
  - `(==) :: a -> a -> Bool`
  - `(/=) :: a -> a -> Bool`
- Ord
- Show
- Read
- Num
- Integral
- Fractional

## 関数定義

> 関数を定義する一番簡単な方法は，既存の関数を組み合わせること

条件式

``` haskell
abs :: Int -> Int
abs n = if n >= 0 then n else -n

signum :: Int -> Int
signum n = if n < 0 then -1 else if n == 0 then 0 else 1
```

Haskellでは，常に`else`部が必要．

> ぶらさがり`else`問題

ガード付きの等式

``` haskell
abs n | n >= 0    = n
      | otherwise = -n
```

いつ使うの？どう使い分ける？
=> 条件が多くなってきたときに読みやすい

パターンマッチ

``` haskell
(&&) :: Bool -> Bool -> Bool
True && True = True
True && False = False
False && True = False
False && False = False

-- 以下でも可
True && True = True
_ && _ = False
```

`_`はワイルドカードとして使える．
下側の定義では，一つ目の引数がFalseであればその時点で結果を返せる．

タプルパターン

> 要素数が同じで，それぞれの要素が対応するパターンにすべて合致するタプル

``` haskell
fst :: (a,b) -> a
fst (x,_) = x

snd :: (a,b) -> b
snd (_,y) = y
```

これはタプルから一つ目の要素と二つ目の要素を取り出す関数．

リストパターン

``` haskell
test :: [Char] -> Bool
test ['a',_,_] = True
test _         = False
```

リストの先頭の要素が`'a'`であり，要素数が3のリストかを検証する．

> リストは合成されたデータであり，空リスト`[]`に対して演算子`:`を使って要素を一つずつ増やしていくことで生成されます．

`:`はcons演算子(construct)で，既存リストの先頭に新しい要素を追加して新しいリストを生成する．
`[1,2,3]`は`1 : (2 : (3: []))`の略記法にすぎないらしい．

``` haskell
test :: [Char]
test ('a':_) = True
test _       = False
```

cons演算子を使うと，任意の長さのリストに対応した関数を書ける．

関数適用は演算子よりも結合順位が高い．

ラムダ式

引数のパターンと，引数から結果を計算する方法を示した本体からなる．
無名関数

``` haskell
\x -> x + x
```

> カリー化された関数の形式的な意味づけに利用できます

形式的な意味づけ？

``` haskell
add :: Int -> Int -> Int
add x y = x + y

add :: Int -> (Int -> Int)
add = \x -> (\y -> x + y)
```

ラムダ式を使った方が，型定義と実装の形が同じになって分かりやすいらしい．

``` haskell
const :: a -> b -> a
const x _ = x

const :: a -> (b -> a)
const x = \_ -> x
```

関数の定義で，関数を返していることが分かりやすくなるらしい．
まだピンと来てはない．

一度しか参照されない関数の命名をしないようにする．
これは嬉しいか．

セクション

関数名をバッククォートで囲むことで演算子になる．(`div`)
任意の演算子は括弧で囲むことで，前置として使うカリー化された関数になる．
へー．

`(1+)`だと，1を加える関数になる．

任意の演算子`#`と引数`x`と`y`を使って以下のように書ける．

``` haskell
(#) = \x -> (\y -> x # y)
(x #) = \y -> x # y)
(# y) = \x -> x # y)
```

これらを一般にセクションと呼ぶ．
`(#), (x #) (# y)`がセクションか．

独自の演算子を定義したりする場合は，型の宣言にセクションが必要．
二項演算子を関数の引数に渡す場合もセクションが必要．

練習問題を解いているときにhlintがありがたい．
ここまでの練習問題はわりかし問題なく解けているが，どうしても最初に手続き型(命令型)の実装が浮かんでしまう．

## リスト内包表記

内包表記は数学の話か．
既存の集合から新しい集合を生成するときに使う．
`{x² | x ∈ {1..5}}`
Haskellでも同じことができますよと．

``` haskell
> [x^2 | x <- [1..5]]
[1,4,9,16,25]
```

`x <- [1..5]`の部分を生成器と呼ぶ．
複数の生成器を書くこともできる．
複数の生成器を書いた場合は，先に書いた方の生成器が入れ子の浅い側に来る．
なので，後ろに書いた生成器では先の生成器が使う変数を使える．

``` haskell
> [(x,y) | x <- [1..3], y <- [x..3]]
[(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
```

プレリュード関数の`concat`で使われている．

``` haskell
concat :: [[a]] -> [a]
concat xss = [x | xs <- xss, x <- xs]

-- 1. xss :: [[a]]から順にxs :: [a]を取り出す
-- 2. xs :: [a]から順にx :: aを取り出す
```

ガード

前方の生成器で生成された値を間引く．
TSにおけるfilterみたいなものか．

関数zip

なんでこれだけ専用の項が作られてるんだ？
プレリュード関数zip．

二つのリストを引数にとって，各リストの要素を順に組にした新しいリストを生成する．
まだ分からん．

> 関数`zip`をリスト内包表記と一緒に使うと便利なことが多々あります

``` haskell
pairs :: [a] -> [(a,a)]
pairs xs = zip xs (tail xs)
```

`zip`を使用した`pairs`関数が説明に必要らしい．

> 関数`pairs`を使って，要素の型がOrdクラスに属しているリストが整列されているか調べる関数を定義できます

ソートに使えるのか．
ソートに使えるというか，ソートされているかを確認できるだけか．
`pairs`関数で隣り合う値の大小関係を見ればいいのか．

``` haskell
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x,y) <- pairs xs]
```

生成器を回す過程で間違っている組があれば即座に`False`になる．

値がリストのどの位置にあるかを調べて，そのインデックスのリストを返すような`positions`関数も書ける．

``` haskell
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..], x == x']
```

文字列の内包表記

文字列自体も文字のリストなので内包表記が使える．

シーザー暗号

あれか，何文字かずらすやつ．
カイ二乗検定．
実際の登場頻度と期待頻度の差が少ないほど小さくなる．

## 再帰関数

基礎概念

関数の定義にその関数自身を使うこと．

``` haskell
fac :: Int -> Int
fac 0 = 1
fac n = n * fac (n-1)
```

`fac 0 = 1`の部分を基底部．
`fac n = n * fac (n-1)`を再帰部と呼ぶ．

リストに対する再帰

引数を渡す際に，cons演算子を用いて先頭の要素を切り出す形で再帰を使えますよと．

``` haskell
product :: Num a => [a] -> a
product [] = 1
product (n:ns) = n * product ns
```

複数の引数

複数の引数を使用する関数も再帰を使って定義できますと．

``` haskell
zip :: [a] -> [b] -> [(a,b)]
zip [] _ = []
zip _ [] = []
zip (x:xs) (y:ys) = (x,y) : zip xs ys
```

多重再帰

関数が自分自身を複数参照する．
フィボナッチ数列とかが該当する．

相互再帰

二つの関数がお互いを参照しあうこと．

``` haskell
even :: Int -> Bool
even 0 = True
even n = odd (n-1)

odd :: Int -> Bool
odd 0 = False
odd n = even (n-1)
```

再帰の秘訣

1. 型を定義する
2. 場合分けをする
3. 場合分けの簡単な方を定義する
4. 場合分けの複雑な方を定義する
5. 一般化し単純にする

> ［訳注］再帰は表現力が強いため、再帰が使われたプログラムを読む場合は、さまざまな可能性を考えなければならず読みにくさがあります。
> 一方、機能が一つしかない高階関数foldrやmapを使うと、プログラムの意味が明瞭になり読みやすくなります。
> 面白いことに、再帰をよく理解できるようになると、再帰をあまり使わなくなります。

ほう．

## 高階関数

高階関数とは以下のどちらかであること．

1. 引数に関数を取る関数
2. 関数を返す関数

ただ，1はカリー化で呼ばれることが多いので，2を指して高階関数と呼ぶケースがよくあるらしい．

基礎概念に`add`関数が持つ意味について書いてある．

> ``` haskell
> add :: Int -> Int -> Int
> add x y = x + y
> ```
> これは次のような意味です．
> ``` haskell
> add :: Int -> (Int -> Int)
> add = \x -> (\y -> x + y)
> ```

この本を読んでいると，関数や型にどのような意味を持たせるかということをとても考えさせるようになっている．

なぜ高階関数を使うか．

> 高階関数を使うことで、Haskellの力は大きく増幅します。
> なぜなら、より、プログラミングの共通の様式を関数に閉じ込められるからです:
> より一般的に言うと、高階関数は、Haskellで「ドメイン固有言語」（DSL： domain specificlanguage）を作成するのに利用できます。
> ~~~
> ［訳注］他の言語では、データと関数の集合が部品（モジュール）を構成するのに対し、
> Haskellでは関数自体が完全に独立な部品となります。

部分適用でデータと処理を一つの部品として扱うことができるか．

リスト処理

TSでもよく使う`map`が高階関数に当たる．

入れ子になったリストを処理するときは`map`の引数に`map`を渡す．

畳込関数`foldr`

これまでにちょいちょい見ていた`foldr`(fold right)．

``` haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f v [] = v
foldr f v (x:xs) = f x (foldr f v xs)
```

> foldr f vの動作を理解するときは再帰的に、
> 「リストのcons演算子を関数fに置き換え、末尾の空リストを値vに置き換える」
> と考えるほうが実際にはよいでしょう。

あー，分かりやすい．

畳込関数`foldl`

`foldr`と`foldl`(fold left)

右結合の`foldr`でも，左結合の`foldl`でもどちらでも書ける．
が，処理の流れは変わる．
どちらを使うかは，効率やHaskellの評価の仕組みを考えて決める．

今は細かいところは見ない．

関数合成演算子

関数合成の話だ．

`(.)`が二つの関数を合成した関数を返す高階演算子．

``` haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
f . g = \x -> f (g x)
```

`.`はcomposed withと読むらしい．
`.`で合成できるのは引数が一つの関数のみ．
なので，部分適用で引数を一つにしたりする．

合成する際の初期値に恒等関数`id`を使うことがある．
`id`は引数をそのまま返すだけの関数．

何も処理をしないことを明示的に書くことができる．

文字列の二進数変換



## 初耳概念(耳にしたことはあっても説明できないもの)

一旦は大まかな理解で進めて，分からなくなってきたら後からちゃんと調べる．

- 簡約(reduction)
- β簡約
- 正規形
- 関数適用
- WHNF
- 多相性
- 多重定義
- GHC
- 冪乗
  - これべき乗なんだ．．．
- モナド
- アプリカティブ
- 関手
- Foldable
- Traversable
- 等式推論
- プレリュード
    - 全域関数
- 型クラス制約
- 内包公理
