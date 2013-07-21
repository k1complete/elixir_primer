=====================================
レコードとプロトコル
=====================================

elixirはレコードとプロトコルの両方を提供します。この章では主な機能とサ
ンプルを紹介します。defrecord, defprotocolとdefimplの使い方を学びます。

レコード
-------------------------------------

レコード定義
`````````````````````````````````````

レコードは値を保持するシンプルな構造体です。例えば、以下のようにしてファ
イル似ついての情報を保存するためのFileInfoレコードを定義できます。


.. code-block:: elixir
   :linenos:

    defrecord FileInfo, atime: nil, mtime: nil, access: 0

上の行は、FileInfoモジュールを定義し、新しいレコードを作成するnewという
名前の関数やレコードの値をセットしたり読み出したりする関数を含みます。
以下のように使うことができます。

.. code-block:: elixir
   :linenos:

    iex> file_info = FileInfo.new(atime: :erlang.now())
    {FileInfo,0,{1335,14082,453196},nil} 
    iex> file_info.atime  #=> getter
    {1335,14082,453196}
    iex> file_info.atime(:erlang.now()) #=> setter
    {FileInfo,0,{1335,14267,998607},nil}
    iex> 

elixirは一つの引数をとるupdate_#{field}関数も定義しています。update関数
が呼ばれると、フィールドの現在の値を関数に渡します。関数からの戻り値で
フィールドを更新します。

.. code-block:: elixir
   :linenos:

    iex> file_info.access
    20
    iex> file_info = file_info.update_access(fn(x) -> x+10 end)
    {FileInfo,30,{1335,16186,476731},nil}
    iex> file_info.access                                      
    30
    iex>


内部的にはレコードは先頭のフィールドがモジュール名となっているシンプル
なタプルです。Interactive Elixir(bin/iex)でこれをチェックすることができ
ます。

.. literalinclude:: ../codes/record_is_tuple.lst
   :language: elixir
   :linenos:

上の例のように通常は:"Elixir.Module"というタプル名になっていますが、無
理すれば任意のアトムをレコード名にすることができます。


    defrecord RecordName, [attribute: initialvalue], [:do, block]
 
do: その他の任意のブロックを記述可能です。たとえば、各種メソッドを
    定義することができます。第一引数は対象のレコード自身となります。

ブロックを記述する例として、たとえばaccess_incrementという関数を
定義してみます。

.. literalinclude:: ../codes/record_block.lst
   :language: elixir
   :linenos:


レコードアクセス
`````````````````````````````````````

レコードはnewによって生成出来るが、配列的記述により記述することの
ほうが便利です。当然のことながらパターンマッチも可能です。

.. literalinclude:: ../codes/record_access.lst
   :language: elixir
   :linenos:


プロトコル
-------------------------------------

プロトコルは契約を定義します。それがプロトタイプを実装する限り、任意の
データタイプが利用可能です。実際的な例を挙げてみましょう。

Elixirではfalseとnilだけが偽の値であると考慮されています。それ以外の任
意の値は真と評価されます。アプリケーションに依存しますが、空白を指定す
る事が重要である場合がある事から、データ型に対して空白かどうかをブーリ
アンで返すblank?プロトコルを設計してみます。例えば、空のリストや空のバ
イナリは空白であると考えることができます。

プロトコルは以下のように定義できます。

.. literalinclude:: ../codes/protocol_blank.exs
   :language: elixir
   :linenos:
   :lines: 1-3

Blankプロトコルで、blank?/1関数をサポートする事を要求するものとなります。
これの実装は、

.. literalinclude:: ../codes/protocol_blank.exs
   :language: elixir
   :linenos:
   :lines: 4-7

のように行います。使用例は、

.. literalinclude:: ../codes/protocol_blank.lst
   :language: elixir
   :linenos:
   :lines: 18-34


のようになり、Listについてはblank?が機能していますが、blank?(1)は
怒られました。しかたないのでNumber型についても実装を定義してみます。

.. literalinclude:: ../codes/protocol_blank.lst
   :language: elixir
   :linenos: 
   :lines: 36-48


このように数値についてもblank?/1が機能するようになりました。:forに使え
る型は以下のとおりです。

• Record

• Tuple

• Atom

• List

• BitString

• Number

• Function

• PID

• Port

• Reference

• Any

