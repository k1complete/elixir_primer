=====================================
部分適用と遅延評価
=====================================

部分適用
-------------------------------------

elixirは関数を便利に使うための構文をサポートしています。バイナリのリス
トを持っていて、それぞれのサイズを計算したいとします。そのとき、通常は
以下のように書きます。

.. literalinclude:: ../codes/binary_list_calc1.lst
   :language: elixir
   :linenos:

このようにも書くことができます。

.. literalinclude:: ../codes/binary_list_calc2.lst
   :language: elixir
   :linenos:

上の例のsize(&1)はfn(x) -> size(x) endに直接変換されます。演算子もまた
関数呼び出しですので、同じシンタックスを使うことができます。

.. literalinclude:: ../codes/list_resuce_partial_app.lst
   :language: elixir
   :linenos:
   :lines: 1-2


このケースでは、&1 * &2 はその順番の引数として自動生成された関数にマッピ
ングされます。つまりは fn(x1, x2) -> x1 + x2 end と同じです。

.. literalinclude:: ../codes/list_resuce_partial_app.lst
   :language: elixir
   :linenos:
   :lines: 3-4


全く同じことを&()で囲うことでより明示的に記述することができます。

この部分適用シンタックスはElixirではSpecialform以外の任意の関数、マクロ、
演算子で使用することができます。



パイプライン
-------------------------------------

パイプライン演算子|>を使ってさらに部分適用を便利に使うことができます。
 リストを平準化(List.flatten)して、各要素を2倍する(Enum.map(&1 * 2))し
 たい場合は以下のように書くことができます。

.. literalinclude:: ../codes/pipeline_flatten_and_double.lst
   :language: elixir
   :linenos:

左辺 |> 右辺は、コンパイル時に右辺(左辺,右辺の引数の残り)のように変換さ
れます。また左結合性ですので、上記は以下と等価です。

.. literalinclude:: ../codes/pipeline_flatten_and_double2.lst
   :language: elixir
   :linenos:

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

Enum.mapを使ったパイプラインでは、step1が5回出力されてからstep3が3回出
力されていることから、中間のオブジェクトが作成されていることがわかりま
す。

Streamではアクセスされた場合に計算される関数を登録したStream.Lazyオブジェ
クトが返り、次の関数に渡され、最終的にEnum.to_list/1などでアクセスした
場合に実際の処理が行なわれます。

.. literalinclude:: ../codes/stream_map_take_map.lst
   :language: elixir
   :linenos:
   :lines: 1-13

Enum.mapに比べてstep1での余分なリストへの処理がされていないことに
注意してください。
これを一ステップづつ行ってみます。

.. literalinclude:: ../codes/stream_map_take_map.lst
   :language: elixir
   :linenos:
   :lines: 16-43

Stream.Lazyレコードがネストしているさまがわかります。最後に
Enum.to_listするまで、IO.putsが呼ばれていないことから、遅延評価されてい
ることもわかります。


