=====================================
メタプログラミング
=====================================


Elixirマクロ入門
-------------------------------------

Elixirのマクロはコンパイルプロセス中において、構文解析後のツリーを入力
として、別のツリーを返すフックとして機能します。そして、そのフックは
Elixir自身を用いて記述することができます。この記述のしやすさと、Elixir
のクロージャサポートによりLispなみの拡張性を持っています。

.. image:: ../illustrations/diagram.png

Elixirプログラムのデータ構造としてのツリー表現
----------------------------------------------

elixirはhomoiconic言語です。つまりプログラムをプログラム中でデータ構造
として扱うことができるという事です。どんなelixirプログラムでもそれ自身
のデータ構造を使用して表現することができます。このセクションは、そのよ
うなデータ構造としてのelixir言語の仕様を記述します。elixirの
homoiconicityの構築ブロックは3要素のタプルです。例えば:

.. code-block:: elixir
   :linenos:

    { :sum, 0, [1, 2, 3] }

上のタプルは1,2,3を引数にして関数sum/3の呼び出しを表現しています。
このタプルの要そは以下のとおりです:

.. code-block:: elixir
   :linenos:

    { Tuple | Atom, List, List | Atom }

* タプルの最初の要素は、アトムあるいは他のタプル表現です。

* タプルの第2の要素は、コンテキスト情報を表すリストです。

* タプルの第3の要素は、関数呼び出しの引数です。第3引数は(nilあるい
  は:quoted)アトムである場合もあります。そして、それが関数呼び出しでは
  なく、変数である事を意味します。

quote do: 式 マクロを用いて任意の式のデータ構造表現を得ることができます:

.. literalinclude:: ../codes/quote_do_sum.lst
   :language: elixir
   :linenos:

elixirでは全ては関数呼び出しで、それは前述のタプルで表現できます。例えば、以下の様な演算子を含む式は以下の様になります。

.. literalinclude:: ../codes/quote_do_plus.lst
   :language: elixir
   :linenos:
   :lines: 1-2

3要素以上のタプルも"{}"関数になります。

.. literalinclude:: ../codes/quote_do_plus.lst
   :language: elixir
   :linenos:
   :lines: 3-6


このルールの例外はたった五つのElixirリテラルだけです。リテラルはquoteさ
れるとそれ自身を返すデータ型で、それらは以下のとおりです:

.. literalinclude:: ../codes/quote_literal.lst
   :language: elixir
   :linenos: 
   :lines: 1-10

また、変数は、Elixirという印がついたアトムのタプルになります。

.. literalinclude:: ../codes/quote_literal.lst
   :language: elixir
   :linenos: 
   :lines: 11-14

doブロックは:__block__関数になります。

.. literalinclude:: ../codes/quote_literal.lst
   :language: elixir
   :linenos: 
   :lines: 15-19

これでユーザ定義のマクロを定義する準備ができました。Doug HoyteはLet
Over Lambdaで「他のすべての言語が単にLispに薄い皮をかぶせたにすぎないと
いうことが分かるだろう」と書いています。その通りなのですが、他の言語と
違い、Elixirはいつでもその薄い皮を剥がすことができるということです。

マクロ定義
----------------------------------------------

ユーザ定義のマクロを定義する
``````````````````````````````````````````````

“defmacro”を使用してマクロを定義することができます。例えば、unlessと
呼ばれるマクロを定義することができます。それはちょっとしたコードでちょ
うどRubyのunlessと同じように働きます。

.. literalinclude:: ../codes/defmacro_unless.exs
   :language: elixir
   :linenos: 
   :lines: 1-7

上の例では、unlessは二つの引数を受けて呼ばれます。
“clause”と”options”です。しかし、unlessはそれらの値を受け取る訳では
なく、式を受け取る点に注意してください。例えば、次の呼び出しでは、

.. literalinclude:: ../codes/defmacro_unless.exs
   :language: elixir
   :linenos: 
   :lines: 9

MyMacro.unlessは以下の物を受け取ることになります。

.. code-block:: elixir
   :linenos:

    MyMacro.unless({:==, [context: Elixir, import: Kernel],
                    [{:+, [context: Elixir, import: Kernel], [2, 2]}, 5]},
                   [do: {{:.,[], [{:__aliases__, [alias: false], [:IO]}, 
                                  :puts]}, [],
                                  ["unless"]}])


MyMacro.unless側では、ifのツリー構造を返す為に"quote"を呼びます。
これは"if"で我々の"unless"をトランスレートしていることを意味します。
しかしながら、開発者が通常"quote"された式の要素を"unquote"し忘れるのは
共通のミスです。"unquote"が何をするかを理解するために取り除いてみましょう。

.. literalinclude:: ../codes/defmacro_unless_fail.exs
   :language: elixir
   :linenos: 
   :lines: 1-7

これをコンパイルして呼び出すとこのようになります。

.. literalinclude:: ../codes/defmacro_unless_fail.lst
   :language: elixir
   :linenos: 
   :lines: 17-22

unquoteが無いバージョンではclauseとoptionsという関数を呼び出すようになっ
ていることに注意してください。
言い替えると、"unquote"は"quote"されたツリーに式を組込むメカニズムで、
メタプログラミングメカニズムの本質です。

elixiではリストをunquoteして、もとの式のリスト中に差し込むことを一度にする
unquote_splicing/1も提供しています。

.. literalinclude:: ../codes/unquote_splicing.lst
   :language: elixir
   :linenos: 

elixirで提供されているビルトインマクロのオーバーライドを含めて、欲しい
と思う任意のマクロを定義することができます。elixirスペシャルフォームの
オーバーライドができないと言う事だけが例外です。Elixir::SpecialFormにそ
の例外となるスペシャルフォームがリストされています。

健全なマクロ
``````````````````````````````````````````````

elixirマクロはScheme協定に従っていて、健全(hygienic)です。これはマクロ
の内側で定義された変数はマクロが使われたコンテキストで定義された変数と
衝突しないという事を意味します。例えば

.. literalinclude:: ../codes/hygiene.lst
   :language: elixir
   :linenos:
   :lines: 1-16


このように、testmacroの内部でaに1を束縛しても、それは外部に影響を及ぼし
ません。マクロでコンテキストに影響を与えたい場合は、 var!()を使うことが
できます:

.. literalinclude:: ../codes/hygiene.lst
   :language: elixir
   :linenos:
   :lines: 17-32


var!()によってマクロが展開された場所のコンテキストで変数が
評価されることが分ります。

マクロの展開過程を確認するために、Macro.expand/2, Macro.expand_once/2が
あります。Macro.expand/2はマクロを全て展開してしまうため却って分かり難く
なります。これらがASTを返しますが、これらをelixirのシンタックスに
文字列として変換する、Macro.to_string/1もあります。

.. literalinclude:: ../codes/defmacro_unless.lst
   :language: elixir
   :linenos:
   :lines: 18-52

これまでquoteを使ってきましたが、直接ASTを構成するタプルを返して
マクロを作ることもできます。たとえば、引数を2倍するマクロを作ってみます。
:"+" 関数に引数を渡すplus/1マクロを書いてみます。

.. literalinclude:: ../codes/defmacro_plus.lst
   :language: elixir
   :linenos:

一見上手く動いているように見えますが、微妙なバグがあります。


quoteを使っていないので、unquoteも使う必要はありません。このような単純
な場合にはquoteを使うほうが遥かに楽ですが、複雑な式の変換を行う際には
直接ASTをハンドルする必要が出て来ます。



プライベートマクロ
``````````````````````````````````````````````
あるモジュールで定義されたマクロはそのモジュールの中では呼び出すことは
出来ません。defmacropで定義されたプライベートマクロは逆でモジュール
内でのみ呼び出しが可能です。プライベートマクロはガード式など
関数呼びだしが許されない場所で良く使われます。

.. literalinclude:: ../codes/private_macro.exs
   :language: elixir
   :linenos: 
   :lines: 1-10

プライベートマクロは前方参照を許していませんので、定義するまえに使うと
エラーとなります。

.. literalinclude:: ../codes/private_macro.lst
   :language: elixir
   :linenos: 
   :lines: 18-44

マクロの実際
-------------------------------------

マクロ delegate [{name, arity}|t], do: target を考えてみます。これは、
あるモジュールの関数群を他のモジュールに委譲したい場合に使う事を目的と
しています。例えば、MyListという独自リストモジュールを定義していて
reverse/1とmember/2を:listsモジュールをそのまま使いたい場合です。

.. code-block:: elixir
   :linenos:

    defmodule MyList do
      delegate [reverse: 1, member: 2], to: :lists
    end

これをこんなふうに展開されたいわけです。

.. code-block:: elixir
   :linenos:

    defmodule MyList do
      ## delegate [reverse: 1, member: 2], to: :lists
      def reverse(arg1) do
        apply :lists, reverse, [arg1]
      end
      def member(arg1, arg2) do
        apply :lists, member, [arg1, arg2]
      end
    end

ではdelegateマクロを実装していきましょう。
コアはこんな感じです。


.. code-block:: elixir
   :linenos:

    defmodule MyMacro do
      defmacro delegate1([{fname, arity}| t], to: module) do
        args = makeargs(arity)
        quote do
          def unquote(fname).(unquote_splicing(args)) do
            apply unquote(module), unquote(fname), [unquote_splicing(args)]
          end
        end
      end
    end

makeargs/1は指定された数だけの仮引数として使用できるアトムリストを返す
関数であり、このように作ることができます。

.. literalinclude:: ../codes/delegate.exs
   :language: elixir
   :linenos: 
   :lines: 2-8

delegate1は渡された最初の{fname, arity}のみ処理しているので、残りの部分
を処理するよう書き換えます。

.. literalinclude:: ../codes/delegate.exs
   :language: elixir
   :linenos: 
   :lines: 9-23

このようにマクロのなかから関数を呼ぶことが出来ますが、マクロが自分自身
を呼び出すことは出来ません。
末尾再帰の形をEnum.map/2で書き直すと以下のようになり、幾分すっきりします。

.. literalinclude:: ../codes/delegate.exs
   :language: elixir
   :linenos: 
   :lines: 24-34

実行結果は以下のとおりです。

.. literalinclude:: ../codes/delegate.lst
   :language: elixir
   :linenos: 
   :lines: 42-55
