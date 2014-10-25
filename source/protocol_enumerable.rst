=====================================
重要なプロトコル
=====================================

elixirでは標準でいくつかのプロトコルを提供しています。
ここでは、それらのプロトコルの使いかたを説明します。

Enumerable
-------------------------------------

Enumerableとは、「数え上げることができる」という意味で、主にEnum、
StreamモジュールがEnumerableを対象とした操作を行っています。

Enumerableが実装を要求する関数は、count/1, member?/2, reduce/3の3個で、
それらを実装したモジュールはEnumerableになり、Enum, Streamモジュール
の恩恵をうけることができます。

Rangeに習って、フィボナッチ数を生成するモジュールFibを作りながら
Enumerableを学んでいきます。

まず、構造体と初期化子を作ります。これはプロトコルでは要請されて
いません。デフォルトでは無限に生成するようcountは:infinityに
してみます。

.. literalinclude:: ../codes/protocol_fib.exs
   :language: elixir
   :linenos:
   :lines: 1-6

次に、Enumerableを実装していきます。以下の3つの関数の
実装が求められています。

.. code-block:: elixir

   def count(collection) :: {:ok, non_neg_integer} | {:error, module}
   def member?(collection, value) :: {:ok, boolean} | {:error, module}
   def reduce(collection, acc, fun) :: {:done, term} | 
                                       {:halted, term} |
                                       {:suspended, term, continuation}
  
このうち、count/1, member?/2はデフォルトの実装が提供されていて、デフォ
ルトの実装を使う場合、{:error, module}を返します。デフォルトの実装は、
reduce/3を使い、線形時間がかかるので、データ構造上、それよりも高速に求
められることがわかっている場合にのみ、カスタム実装を行います。

例えば、フィボナッチ数列のcountは、:infinityでない場合なら、
構造体のフィールドから直接求めることが可能です。:infinityの
場合はデフォルト実装にお任せします。

.. code-block:: elixir

   def count(%Fib{count: :infinity}), do: {:error, __MODULE__}
   def count(fib), do: {:ok, fib.count}


一方、member?/2は、結局１つひとつ比較するしかないので、デフォルト
実装にお任せします。

.. code-block:: elixir

   def member?(_fib, _value), do: {:error, __MODULE__}

残りはreduce/3ですが、アキュムレータにタグが付けられている
ことに注意します。タグは以下のとおりです。

* :cont - 数え上げを継続します。 {:cont, acc}か{:done, acc}を返します。
* :halt - 直ちに数え上げを停止します。 {:halted, acc}を返します。
* :suspend - 直ちに数え上げをサスペンドします。
            {:suspended, acc, 
              fn(x) -> reduce(enum, x, fun) end}を返します。

.. code-block:: elixir

   def reduce(e, acc, fun) do
     reduce(e.f0, e.f1, e.count, acc, fun)
   end
   def reduce(_f0, _f1, 0, {:cont, acc}, _fun) do
     {:done, acc}
   end
   def reduce(f0, f1, n, {:cont, acc}, fun) do
     reduce(f1, f0 + f1, n-1, fun.(f0, acc), fun)
   end
   def reduce(_, _, _, {:halt, acc}, _fun) do
     {:halted, acc}
   end
   def reduce(f0, f1, n, {:suspend, acc}, fun) do
     {:suspended, acc, &reduce(f0, f1, n, &1, fun)}
   end

このように、reduceではフィボナッチ数を計算しながらカウントが
0になったら`{:done, acc}`を返すことになります。
そしてナイスなことに、この状態でStreamにも対応出来ています。

さて、使ってみましょう。お題として、10から100までのフィボナッチ数列の、
最初の二つを出力するというものにしてみます。範囲はRangeを使います。

.. runblock:: iex

   > import_file ("codes/protocol_fib.exs")
   > Fib.new |> Stream.filter(&Enum.member?(10..100, &1)) |> 
   >   Stream.take(2) |> Enum.to_list 

Fib.newとして、無限数列としているにも拘わらず、きちんと計算されて
いるのは、Streamのお陰です。Enumerableプロトコルを実装するだけで
遅延評価の恩恵を受けられるのは素晴しいことです。

Collectable
-------------------------------------

Collectableプロトコルは、「集めることができる」
という意味のプロトコルで、Enumモジュールで実装され
ています。集めたあと「数え上げることができる」ことは
要求していないので注意してください。

Collectableが実装を要求する関数はinto/1で、
それらを実装したモジュールはCollectableになり、Enumerableも
実装していると、Enumモジュールの恩恵を受けることができます。

発生したイベントをファイルへ書き込むCollectableである
FileAppenderを作ってみましょう。構造体と初期化のための
empty(path)を作ります。

.. code-block:: elixir

    defmodule FileAppender do
      defstruct file: nil

      def empty(file) do
        File.rm(file)
        %FileAppender{file: file}
      end
    end

続いて、唯一の関数であるinto/1を実装します。

.. code-block:: elixir

   defimpl Collectable, for: FileAppender do
     def into(collectable) do
       {collectable,
         fn
           fa, {:cont, term} ->
             File.write(fa.file, "#{inspect term}\n", [:append])
             fa
           fa, :done -> fa
           _, :halt -> :ok
         end}
     end
   end

さて、試してみましょう。

.. runblock:: iex

   > import_file "codes/protocol_collectable.exs"
   > m = FileAppender.empty("test.log")
   > Enum.into([1,2,3], m)
   > File.read("test.log")
   > Enum.to_list(m) ## Enumerableプロトコルは実装していない

このようにCollectableとEnumerableは密接に関係していますが、
別のものとして分離されています。
なお、今回、FileAppenderを作成しましたが、File.stream!/3
により生成されるFile.Streamを利用したほうが便利です。


Access
-------------------------------------

Accessプロトコルは、`[]` によるアクセスを可能にします。
また、`.` によるアクセスも可能にします。
実装すべき関数は get/2 と、 get_and_update/3 です。

取り敢えず、Fibの属性を[]で取り出せるようにしてみます。

.. literalinclude:: ../codes/protocol_access.exs
   :language: elixir
   :linenos:

get/2は単に取得した値を返すので簡単ですが、
get_and_update/3は、{取得した値, 更新後の構造体}を返します。
定義できたので使ってみましょう。

.. runblock:: iex

      > import_file ("codes/protocol_fib.exs")
      > import_file ("codes/protocol_access.exs")
      > r = Fib.new
      > r[:f0]
      > get_and_update_in(r[:f0], &{&1, &1 + 1})

なお、わざわざ[]でのアクセスが出来るように実装しましたが、
構造体の場合、 `.` でも同様のことが出来ます。

.. runblock:: iex

      > import_file ("codes/protocol_fib.exs")
      > r = Fib.new
      > r.f0
      > get_and_update_in(r.f0, &{&1, &1 + 1})

