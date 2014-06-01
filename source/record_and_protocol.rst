=====================================
プロトコル
=====================================

elixirはプロトコルを提供します。この章では主な機能とサンプルを紹介しま
す。defprotocolとdefimplの使い方を学びます。

プロトコルは契約を定義します。それがプロトタイプを実装する限り、任意の
データタイプが利用可能です。実際的な例を挙げてみましょう。


Elixirではfalseとnilだけが偽の値であると考慮されています。それ以外の任
意の値は真と評価されます。アプリケーションに依存しますが、空白を指定す
る事が重要である場合がある事から、データ型に対して空白かどうかをブーリ
アンで返すblank?プロトコルを設計してみます。例えば、空のリストや空のバ
イナリは空白であると考えることができます。

プロトコルは以下のように定義できます。

.. literalinclude:: ../codes/blank.ex
   :linenos:
   :end-before: implstart

Blankプロトコルで、blank?/1関数をサポートする事を要求するものとなります。
これの実装は、

.. literalinclude:: ../codes/blank.ex
   :language: elixir
   :linenos:
   :start-after: implstart

のように行います。使用例は、

.. runblock:: iex
   
   > c("codes/blank.ex")
   > Blank.blank?([])
   > Blank.blank?([1])
   > Blank.blank?(1)  # これはエラー

のようになり、Listについてはblank?が機能していますが、blank?(1)は
怒られました。しかたないのでInteger型についても実装を定義してみます。

.. runblock:: iex

   > defimpl Blank, for: Integer do
   >   def blank?(_), do: true
   > end
   > Blank.blank?(0)
   > Blank.blank?(1)

このように整数についてもblank?/1が機能するようになりました。:forに使え
る型は以下のとおりです。


• Tuple

• Atom

• List

• BitString

• Integer

• Float

• Function

• PID

• Port

• Reference

• Any


デフォルトの実装を与えたい場合は、@fallback_to_anyにtrueをセットしAny型について実装しましょう。

.. literalinclude:: ../codes/protocol_blank_any.lst
   :language: elixir
   :linenos:

