---
title: 'I.O. プログラムはメモリのシンタックスなのか？'
pubDate: 2026-02-04 00:43
description: '備忘録'
draft: true
tags: ["Java"]
---

## 前書き

とあるYoutubeライブのアーカイブを見ていると，こんな会話が出てきました．

↓これです．面白いです．

https://www.youtube.com/live/lG7YbM2AfU8?si=yJlaw1hwCzoOY49J&t=938

「プログラムはメモリのシンタックスシュガー」

そこで自分はほんまか！？となりました．
ちょうど，若手向け(自分も自称若手ではある)にJavaで良いコードを書くには，ということを考えていました．
そんなこともあり，「確かに，staticとかの扱いってメモリのことを思い浮かべられた方が分かりやすいなぁ」と．
もちろん，それ以外にも色々とあるので，それだけではないでしょう．
ただ，説明するときにこの話をできれば，イミュータブルであることの嬉しさみたいなものも，根拠を明確にして伝えられそうです．


シンタックスシュガー(syntacs sugar)とは

> [Wikipediaより]
> 糖衣構文（とういこうぶん、英: syntactic sugar あるいは syntax sugar）は、プログラミング言語において、読み書きのしやすさのために導入される書き方であり、複雑でわかりにくい書き方と全く同じ意味になるものを、よりシンプルでわかりやすい書き方で書くことができるもののことである。
>
> 構文上の書き換えとして定義できるものであるとも言える。
>
> https://ja.wikipedia.org/wiki/%E7%B3%96%E8%A1%A3%E6%A7%8B%E6%96%87

糖衣はこういうところにもいます．
通常の正露丸はゴムみたいな匂いが強いんですが，セイロガン糖衣Aはかなり匂いが抑えられています．
人間に優しい！

https://www.seirogan.co.jp/seirogan/products/toui_a/

正露丸さん，いつもありがとう．


とはいえ，普段TypescriptやHaskellを書くことが多い自分としては，Javaをあまり詳しくありません．
ので，Javaにおけるメモリの扱いについて見ていこうと思います．

**本題はここで終了**

## Javaファイルの準備

ひとまず，JavaでHello Worldを書きます．

``` java Main.java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

そして，何年ぶりかの手動コンパイル．

``` shell
$ javac Main.java
```

`Main.class`ができました．
Javaを学んだときに，「Javaはコンパイルするときに，直接実行可能なバイナリファイルを生成するのではなく，中間言語(バイトコード)に変換する」みたいなことがありました．
当時は何言ってんだという感じでしたが，今なら理解できます．

では，`Main.class`の中身を見ていきましょう．

``` shell
$ hexdump -C Main.class
00000000  ca fe ba be 00 00 00 41  00 1d 0a 00 02 00 03 07  |.......A........|
00000010  00 04 0c 00 05 00 06 01  00 10 6a 61 76 61 2f 6c  |..........java/l|
00000020  61 6e 67 2f 4f 62 6a 65  63 74 01 00 06 3c 69 6e  |ang/Object...<in|
00000030  69 74 3e 01 00 03 28 29  56 09 00 08 00 09 07 00  |it>...()V.......|
00000040  0a 0c 00 0b 00 0c 01 00  10 6a 61 76 61 2f 6c 61  |.........java/la|
00000050  6e 67 2f 53 79 73 74 65  6d 01 00 03 6f 75 74 01  |ng/System...out.|
00000060  00 15 4c 6a 61 76 61 2f  69 6f 2f 50 72 69 6e 74  |..Ljava/io/Print|
00000070  53 74 72 65 61 6d 3b 08  00 0e 01 00 0d 48 65 6c  |Stream;......Hel|
00000080  6c 6f 2c 20 57 6f 72 6c  64 21 0a 00 10 00 11 07  |lo, World!......|
00000090  00 12 0c 00 13 00 14 01  00 13 6a 61 76 61 2f 69  |..........java/i|
000000a0  6f 2f 50 72 69 6e 74 53  74 72 65 61 6d 01 00 07  |o/PrintStream...|
000000b0  70 72 69 6e 74 6c 6e 01  00 15 28 4c 6a 61 76 61  |println...(Ljava|
000000c0  2f 6c 61 6e 67 2f 53 74  72 69 6e 67 3b 29 56 07  |/lang/String;)V.|
000000d0  00 16 01 00 04 4d 61 69  6e 01 00 04 43 6f 64 65  |.....Main...Code|
000000e0  01 00 0f 4c 69 6e 65 4e  75 6d 62 65 72 54 61 62  |...LineNumberTab|
000000f0  6c 65 01 00 04 6d 61 69  6e 01 00 16 28 5b 4c 6a  |le...main...([Lj|
00000100  61 76 61 2f 6c 61 6e 67  2f 53 74 72 69 6e 67 3b  |ava/lang/String;|
00000110  29 56 01 00 0a 53 6f 75  72 63 65 46 69 6c 65 01  |)V...SourceFile.|
00000120  00 09 4d 61 69 6e 2e 6a  61 76 61 00 21 00 15 00  |..Main.java.!...|
00000130  02 00 00 00 00 00 02 00  01 00 05 00 06 00 01 00  |................|
00000140  17 00 00 00 1d 00 01 00  01 00 00 00 05 2a b7 00  |.............*..|
00000150  01 b1 00 00 00 01 00 18  00 00 00 06 00 01 00 00  |................|
00000160  00 01 00 09 00 19 00 1a  00 01 00 17 00 00 00 25  |...............%|
00000170  00 02 00 01 00 00 00 09  b2 00 07 12 0d b6 00 0f  |................|
00000180  b1 00 00 00 01 00 18 00  00 00 0a 00 02 00 00 00  |................|
00000190  03 00 08 00 04 00 01 00  1b 00 00 00 02 00 1c     |...............|
0000019f
```

`Hello, World!`さんがいますね．
このバイトコードをJVMが読むことで実行されます．

バイナリを読むことが今回の目的ではないので，ひとまず先に進みます．

もう少し，`Main.class`をよく見ていきます．

``` shell
$ javap -v Main.class
Classfile /home/r38k/playground/iomem/Main.class
  Last modified Feb 3, 2026; size 415 bytes
  SHA-256 checksum cbe01deba3845936685f3acb07834efdd534cb88c497b2df4a902b9f722d3985
  Compiled from "Main.java"
public class Main
  minor version: 0
  major version: 65
  flags: (0x0021) ACC_PUBLIC, ACC_SUPER
  this_class: #21                         // Main
  super_class: #2                         // java/lang/Object
  interfaces: 0, fields: 0, methods: 2, attributes: 1
Constant pool:
   #1 = Methodref          #2.#3          // java/lang/Object."<init>":()V
   #2 = Class              #4             // java/lang/Object
   #3 = NameAndType        #5:#6          // "<init>":()V
   #4 = Utf8               java/lang/Object
   #5 = Utf8               <init>
   #6 = Utf8               ()V
   #7 = Fieldref           #8.#9          // java/lang/System.out:Ljava/io/PrintStream;
   #8 = Class              #10            // java/lang/System
   #9 = NameAndType        #11:#12        // out:Ljava/io/PrintStream;
  #10 = Utf8               java/lang/System
  #11 = Utf8               out
  #12 = Utf8               Ljava/io/PrintStream;
  #13 = String             #14            // Hello, World!
  #14 = Utf8               Hello, World!
  #15 = Methodref          #16.#17        // java/io/PrintStream.println:(Ljava/lang/String;)V
  #16 = Class              #18            // java/io/PrintStream
  #17 = NameAndType        #19:#20        // println:(Ljava/lang/String;)V
  #18 = Utf8               java/io/PrintStream
  #19 = Utf8               println
  #20 = Utf8               (Ljava/lang/String;)V
  #21 = Class              #22            // Main
  #22 = Utf8               Main
  #23 = Utf8               Code
  #24 = Utf8               LineNumberTable
  #25 = Utf8               main
  #26 = Utf8               ([Ljava/lang/String;)V
  #27 = Utf8               SourceFile
  #28 = Utf8               Main.java
{
  public Main();
    descriptor: ()V
    flags: (0x0001) ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 1: 0

  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: (0x0009) ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=1, args_size=1
         0: getstatic     #7                  // Field java/lang/System.out:Ljava/io/PrintStream;
         3: ldc           #13                 // String Hello, World!
         5: invokevirtual #15                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
         8: return
      LineNumberTable:
        line 3: 0
        line 4: 8
}
SourceFile: "Main.java"
```

Hello, World!さんは#14というところにいますね．
このHello Worldが実行されるときの流れを見ていきます．

AIさんと見ていきましたが，正確性が不安なのでこちらを見ながら確認しています．

https://dev.java/learn/

https://docs.oracle.com/javase/specs/jvms/se25/html/jvms-2.html

Javaは実行時に以下のようなデータ領域を作成します．

- The pc Register
- JVM Stacks
- Heap
- Method Area
- Run-Time Constant Pool
- Native Method Stacks

今回はJVM StacksとHeap，Method Area, Run-Time Constant Poolに焦点を当てていきます．

::: warn
冒頭の動画を見ているので，Rustにおけるメモリと混同している部分があるかもしれません．
:::

### JVM Stacks

いわゆるスタックというやつですね．

### Heap

### Method Area

### Run-Time Constant Pool

## Javaファイルが実行される流れ

`javac`コマンドで，Javaファイルをバイトコードにコンパイルしました．
このバイトコードをJVMに見てもらいましょう．

### 実行前

実行前はただバイナリデータがディスクに存在しているだけです．
バイナリデータの中には，Run-Time Constant Poolとは別にConstant Poolがあります．

``` shell
Constant pool:
   #1 = Methodref          #2.#3          // java/lang/Object."<init>":()V
   #2 = Class              #4             // java/lang/Object
   #3 = NameAndType        #5:#6          // "<init>":()V
   #4 = Utf8               java/lang/Object
   #5 = Utf8               <init>
   #6 = Utf8               ()V
   #7 = Fieldref           #8.#9          // java/lang/System.out:Ljava/io/PrintStream;
   #8 = Class              #10            // java/lang/System
   #9 = NameAndType        #11:#12        // out:Ljava/io/PrintStream;
  #10 = Utf8               java/lang/System
  #11 = Utf8               out
  #12 = Utf8               Ljava/io/PrintStream;
  #13 = String             #14            // Hello, World!
  #14 = Utf8               Hello, World!
  #15 = Methodref          #16.#17        // java/io/PrintStream.println:(Ljava/lang/String;)V
  #16 = Class              #18            // java/io/PrintStream
  #17 = NameAndType        #19:#20        // println:(Ljava/lang/String;)V
  #18 = Utf8               java/io/PrintStream
  #19 = Utf8               println
  #20 = Utf8               (Ljava/lang/String;)V
  #21 = Class              #22            // Main
  #22 = Utf8               Main
  #23 = Utf8               Code
  #24 = Utf8               LineNumberTable
  #25 = Utf8               main
  #26 = Utf8               ([Ljava/lang/String;)V
  #27 = Utf8               SourceFile
  #28 = Utf8               Main.java
```

### クラスロード

それでは，Javaファイルを実行していきます．

プログラムが動くには，メモリ上に置かなければいけません．
JVMはバイトコードを元に，クラスの情報をMethod Areaに格納していきます．


### mainメソッド


## データと関数



https://github.com/openjdk/jdk
