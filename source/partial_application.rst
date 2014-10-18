=====================================
部分適用と遅延評価
=====================================

部分適用
-------------------------------------

elixirは関数を便利に使うための構文をサポートしています。バイナリのリス
トを持っていて、それぞれのサイズを計算したいとします。そのとき、通常は
以下のように書きます。

.. runblock:: iex

   > list = ["foo", "bar", "baz"]
   > Enum.map list, fn(x) -> byte_size(x) end


このようにも書くことができます。

.. runblock:: iex

   > list = ["foo", "bar", "baz"]
   > Enum.map list, &byte_size(&1)


上の例の&size(&1)はfn(x) -> size(x) endに直接変換されます。演算子もまた
関数呼び出しですので、同じシンタックスを使うことができます。

.. runblock:: iex

   > Enum.reduce [1,2,3], 1, &(&1 * &2)


このケースでは、&(&1 * &2) はその順番の引数として自動生成された関数にマッピ
ングされます。つまりは fn(x1, x2) -> x1 * x2 end と同じです。

この部分適用シンタックスはElixirではSpecialform以外の任意の関数、マクロ、
演算子で使用することができます。



パイプライン
-------------------------------------

パイプライン演算子|>を使ってさらに部分適用を便利に使うことができます。
 リストを平準化(List.flatten)して、各要素を2倍する(Enum.map(&(&1 * 2)))し
 たい場合は以下のように書くことができます。


.. runblock:: iex

   > [1, [2], 3] |> List.flatten |> Enum.map(&(&1 * 2))


左辺 |> 右辺は、コンパイル時に右辺(左辺,右辺の引数の残り)のように変換さ
れます。また左結合性ですので、上記は以下と等価です。


.. runblock:: iex

   > Enum.map(List.flatten([1, [2], 3]), &(&1 * 2))


遅延評価
-------------------------------------

StreamモジュールはEnumerableを引数にしてStream.Lazy遅延評価レコードを返
します。Stream.Lazyレコードに対してEnumerableプロトコルが実装されていま
すので任意のEnumモジュールの関数を使うことができます。Streamと|>演算子
の相性は最高で、unixのパイプ演算子と同じように使うことができます。

Enumモジュールによる|>演算子は所詮は関数の呼出でしたので、内側の関数が
一旦完全なEnumオブジェクトを返してから、それを引数にして外側の関数が呼
ばれていました。

.. literalinclude:: ../codes/enum_map_take_map.lst
   :language: elixir
   :linenos:

.. runblock:: iex

   > Enum.map([1,2,3,4,5], 
   >           fn(x) -> IO.puts("step1 #{x}+1"); x + 1 end) |>
   > Enum.take(3) |>
   > Enum.map fn(x) -> IO.puts("step3 #{x} + 1"); x + 1 end


Enum.mapを使ったパイプラインでは、step1が5回出力されてからstep3が3回出
力されていることから、中間のオブジェクトが作成されていることがわかりま
す。

Streamではアクセスされた場合に計算される関数を登録したStream.Lazyオブジェ
クトが返り、次の関数に渡され、最終的にEnum.to_list/1などでアクセスした
場合に実際の処理が行なわれます。


.. runblock:: iex

   > Stream.map([1,2,3,4,5], 
   >             fn(x) -> IO.puts("step1 #{x}+1"); x + 1 end) |>
   > Stream.take(3) |>
   > Stream.map(fn(x) -> IO.puts("step3 #{x} + 1"); x + 1 end) |> 
   > Enum.to_list



Enum.mapに比べてstep1での余分なリストへの処理がされていないことに
注意してください。
これを一ステップづつ行ってみます。

.. runblock:: iex

   > m = Stream.map([1,2,3,4,5], 
   >                 fn(x) -> IO.puts("step1 #{x}+1"); x + 1 end)
   > m2 = Stream.take(m, 3)
   > m3 = Stream.map(m2, fn(x) -> IO.puts("step3 #{x} + 1"); x + 1 end)
   > m3 |> Enum.to_list

Stream.Lazyレコードがネストしているさまがわかります。最後に
Enum.to_listするまで、IO.putsが呼ばれていないことから、遅延評価されてい
ることもわかります。


