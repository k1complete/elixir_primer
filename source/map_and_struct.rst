=====================================
複雑なデータ構造
=====================================

elixirは情報を纏めるための構造をマップやタプル以外に幾つか提供していま
す。この章では主な機能とサンプルを紹介します。

構造体
--------------------------------------

マップに名前を付けて構造体を定義することができます。構造体は
デフォルト値とコンパイル時の型を保証するマップの拡張です。

.. runblock:: iex

   > person =  %{name: 'curumi', age: 17}
   > defmodule Person do
   >   defstruct name: 'unknown', age: 0
   > end
   > %Person{}
   > p = %Person{name: 'curumi', age: 17}
   > is_map(p)

構造体では、作成時に勝手にキーを追加することはできない
ため、開発作業が捗りますが、無理やりMap.put/3でキーを追加すると
構造体として認識されず__struct__というキーが入ったマップとして
扱われます。

.. runblock:: iex

   > person =  %{name: 'curumi', age: 17}
   > defmodule Person do
   >   defstruct name: 'unknown', age: 0
   > end
   > %Person{}
   > p = %Person{name: 'curumi', age: 17}
   > q = Map.put(p, :sex, :female)      ## 無理やりputするとただのMapになる
   > p = %Person{name: 'curumi', age: 17, sex: :female} ## エラー
   > q = %{:name => 'curumi', :age => 17}
   > Person.__struct__
   > struct(Person, q)   ## 既存のマップから構造体を作成する
   > struct(Person, [name: 'curumi', age: 17])   ## キーワードリストから作成

