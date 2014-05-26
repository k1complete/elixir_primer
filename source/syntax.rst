=====================================
簡単な構文説明
=====================================

データタイプ
-------------------------------------

基本データタイプ
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

基本データタイプは以下のとおりです。

.. runblock:: iex

   > 1 # 整数
   > 0x10 # 16進数
   > 0b10 # 2進数
   > 1.0  # 実数
   > :atom # アトム
   > {1,2,3} # タプル
   > [1,2,3] # リスト
   > %{key1: 1, key2: 2} # マップ

.. _関数:

関数
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

関数オブジェクト(無名関数)もありますが、変数に格納された関数を呼び出す
ときには、変数と引数をドットで区切ります。無名関数の定義方法は、fn()
-> body endになります。

.. runblock:: iex

   > add = fn(a,b) -> a + b end # 無名関数をaddという名前の変数に束縛
   > add(1, 2) # addという名前の関数は存在しないのでエラー
   > add.(1, 2) # 変数addに束縛されている関数に引数を与えて実行


関数に渡す引数の数をアリティと呼びます。

関数は所属するモジュールやアリティが異なると全く違う関数として認識され
ます。従って関数は、モジュール名.関数名/アリティのような書式で記述する
事で識別します。

タプル
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

タプルとは、項目の集まりを格納するために使う、複合的な型です。タプルは
{}で囲み、個々の要素は任意の値をとることができ、カンマで区切ります。タ
プルは複雑な構造を記述する際の中心となる構造です。タプルの最初の要素を
そのタプルの内容を表すアトムにする方法はよくとられます。

.. runblock:: iex

   > {:item1, :item2}
   > {}
   > a = {:uname, "netbsd", "i386", "smp"}
   > elem a, 1
   > put_elem a, 1, "freebsd"

elem/2により内部の要素を取得できます。また、put_elem/3により一部の要素
を変更した新しいタプルを作成することができます。要素の位置は0始まりです。


リスト
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

リストもタプルと同様に項目の集まりを格納するために使う、複合的な型です。
リストは[]で囲み、個々の要素は任意の値をとることができ、カンマで区切り
ます。タプルとは処理のされ方が違います。0要素のリストは[]で表すことがで
きます。 [#nil_is_not_nul_list]_ 要素の数に意味がある時はタプルで、要素の
数が決められない場合にはリストを使います。タプルとリストを組み合わせる
事で任意のデータ構造を記述できます。

キーワードリスト
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

キーワードリストとはタプルのリストの一種で基本の型ではありませんが、
極めてよく登場します。タプルは2要素で最初の要素はアトムでなくては
なりません。

.. runblock:: iex

   > a = [{:a, 1}, {:b, 2}]
   > a[:a]
   > Keyword.put(a, :b, 3)


マップ
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

マップは他の言語ではハッシュと呼ばれることが多い型で、V0.13から導入され
た新しい型です。 [#map_since_erlang_r17]_ マップの値の取り出しはブラケッ
ト[]またはドット.で行い、値の設定はMap.put/3で行いますが、既存のキーに
対する更新については%{変数 | キー => 値}という記法も使えます。

現在のところはキーは任意の型が使えますが、%{}記法ではキーに変数を
使うことができません。キーに変数を使う場合にはMap.put/3を使います。

.. runblock:: iex

   > a = %{:key1 => 1, :key2 => 2}
   > b = Map.put(a, :key3, 3)
   > %{a | :key2 => 5} # 既存のキーに対してカジュアルな変更が出来る
   > %{a | :key3 => 3} # 存在しないキーはエラーになる
   > a[:key1]          # 取り出しは[]で可能
   > a.key1          # キーがアトムなら取り出しは.キーでも可能
   > c = "key4"        
   > a = %{:key1 => 1, "key4" => 0}
   > %{a | c => 4}       # 変数のキーはエラーになる
   > Map.put(a, c, 4)    # Map.put/3を使えば変数のキーも大丈夫



二種類の文字列
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

二重引用符はUTF-8の文字列 [#erlang_binary]_ になります。単一引用符の文字列
はunicode文字(ucs2)のリスト [#erlang_string]_ になり、両者は全く違います。
:binary.bin_to_list/1 により文字列をリストに変換するとUTF-8のバイトのリストとな
るため、違いが明らかになります。UTF-8のバイナリをunicode文字のリストに
変換するためには、List.from_char_data/1を使います。

.. runblock:: iex

   > list='abc'
   > bin="abc"
   > [h|t]=list
   > t
   > h
   > list==bin
   > list2='あいうえお'
   > bin2="あいうえお"
   > :binary.bin_to_list(bin2)
   > List.from_char_data(bin2)


これらのバイナリやリストの文字列を他の文字列に埋め込む事もできます。ど
ちらのタイプかはis_binary/1やis_list/1を使用して調べることができます。

.. runblock:: iex

   > bin="abc"
   > list='abc'
   > "embedd #{bin}"
   > 'embedd #{list}'
   > 'embedd binary into list #{bin}'
   > "embedd list into binary #{list}"
   > is_binary(bin)
   > is_binary(list)
   > is_list(bin)
   > is_list(list)

既に登場していますが、trueとfalseも存在します。is_boolean/1で判定できま
す。


演算子
-------------------------------------

数値への演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

数値に関しては、通常の四則演算子が利用できます。


.. runblock:: iex

   > 1+2
   > 1-2
   > 1.0+1.0
   > 2*3
   > 12/4
   > 12/5
   > div(11,5)
   > rem(11,5)


リスト演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

リストに対して、++と--が用意されていて、リストの結合と差分をとることができます。[#erlang_list_operation]_

.. runblock:: iex

   > [1,2,3] ++ [4,5,6]
   > [1,2,3] -- [2,3]
   > [1,2,3] -- [4]
   > [1,2,3] -- [3,1]


バイナリ(文字列)演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

単一引用符の文字列はリストなので、結合と差分をとることができますが、二重引用符の文字列(バイナリ)ではそんなことは出来ません。そのかわり'<>
 'という結合演算子が使えます。

.. runblock:: iex

   > "binary" ++ "bin"  # '++'は使えない
   > "binary" <> "bin"

.. _論理演算子:

論理演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

論理演算子の or と and も提供しています。当然ですが、boolean型について
のみ利用できます。その他の型についての論理演算子の使用はエラーになりま
す。

.. literalinclude:: ../codes/bool_operations.lst
   :language: elixir
   :linenos:

.. runblock:: iex

   > true or false
   > false and is_binary("abc")
   > 1 and 2      # 整数型にはandは使えないのでエラー
   > 1 and false  # andはショートカット演算子なのでこれもエラーとなる

or や and はショートカット演算子ですので、全体を評価しなくても値が決ま
る場合には、評価されないことがあります。[#erlang_andalso_orelse]_

.. runblock:: iex

   > true or error("This error will never be raised")
   > false and error("This error will never be raised")


比較演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

通常の比較演算子==, !=, ===, !===, <=, >=, <, >も用意されています。==と
===は整数と浮動小数点数をより厳密に区別することが異なります。


.. runblock:: iex

   > 1.0 == 1  # => true
   > 1.0 === 1 # => false


比較に関しては、異なる型でも順序関係が定義されています。

.. runblock:: iex

   > 1 < :a < fn() -> :a end < {1,2} < 'abc' < "abc"


リファレンス(一意のシンボル)やポート(elixirと外部プログラムのインタフェー
ス)、pid(elixirプロセスの識別子)を含めてすべての型の順序は以下のとおり
です。

.. code-block:: elixir
   :linenos:

    number < atom < reference < functions < port < pid < tuple < list < bit string


もう一つの論理演算子(|| , &&, !) 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`論理演算子` で説明した or, and, not は引数がbool型である必要があ
りました。その制限を外して任意の型の引数が使用できる同様の論理演算子
|| , &&, ! を用意しています。それらの演算子は falseとnil以外のすべての
値をtrueに評価します。

.. runblock:: iex

   > 0 || 1
   > nil || 1
   > false || 1
   > 0 && 1
   > 2 && 1
   > 2 && nil
   > 2 && false


cons演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cons("|")は二つの値からリストを作成する(constructor)演算子です。通常は

.. runblock:: iex

   > newlist = [:a | [:b, :c]] 

のように使います。

in演算子
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ある値がリストに含まれているかどうかを検査するための演算子がinです。同
じ事は Enum.any?/2 などを使用すれば記述できますが、こちらの方がすっき
りと記述することができます。

.. runblock:: iex

   > y = 3
   > y in [1,2,3]
   > Enum.any?([1,2,3], fn(x) -> x == y end)


関数呼び出し
-------------------------------------

関数は引数の数(アリティ)で区別されています。アリティの異なる関数はまっ
たく別の関数として扱われます。関数を呼び出すための括弧は省略できます。

elixirでは入出力や基本的なデータタイプを操作するための小さな標準ライブ
ラリを用意しています。これはつまり、複雑なアプリケーションを開発するた
めにはErlangのライブラリも必要になることを意味しています。

ErlangはOTP(Open Telecom Platform)と呼ばれるライブラリ群とともに公開さ
れています。OTPは監視ツリーや分散アプリケーションや耐障害性といった機能
を提供しています。elixirからErlangの関数を呼び出すのは簡単です。erlang
モジュール名はアトムとしてelixirでは扱っているので、例えばErlangの
listsモジュールの関数reverse/1を呼び出すためには以下のようにします。

.. runblock:: iex

   > :lists.reverse([1,2,3])


パターンマッチ
-------------------------------------

関数型言語ではおなじみのパターンマッチも使えます。

.. runblock:: iex

   > [h | t] = [1,2,3]
   > h
   > t

elixirでは=は代入ではなく、パターンマッチ演算子になります。パターンに変
数がある場合には、できる限りマッチさせるように変数に値が束縛されます。
どうやっても無理の場合には、エラーになります。

.. runblock:: iex

   > [x, x] = [1,2]

束縛された変数は、再度束縛することができます。[#reassign]_

.. runblock:: iex

   > t = [2,3]
   > t
   > [1 | t] = [1,2,3,4]
   > t


変数の値を固定したままでパターンマッチをしたい場合も多々あります。そう
いうときには、^演算子を使って変数の束縛を固定します。

.. runblock:: iex

   > t = [2,3,4]
   > [1|^t]=[1,2,3,4,5]
   > [1|^t]=[1,2,3,4]

elixirではアンダースコア変数(_)を代入しても使用しない変数として使います。
[#under_score_variable]_ アンダースコア変数は必ずマッチしますが、参照す
ることはできません。

.. runblock:: iex

   > [1,_,3|_]=[1,2,3,4]
   > _

キーワードリスト
-------------------------------------

シンタックスシュガーとして、頻繁に使うアトムをキートしたタプルのリスト
である[{:key1, value1}, {:key2, value2}]は[key1: value1, key2: value2]
と書けます。これらへはKeywordモジュールでアクセスできます。

.. runblock:: iex

   > x = [a: 1, b: 2]
   > Keyword.get x, :a
   > Keyword.get x, :b
   > Keyword.get x, :c


キーワード引数と括弧の省略
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

例えば、よく知られたif式は以下のように書きます。

.. runblock:: iex
   
   > if(true, [do: 1+1])
   > if(false, [do: 1+1])

すなわち、do:キーリストを引数とした2変数関数で、第一引数がtrueの場合に、
do:キーの値を評価して返すということになります。そして、関数呼び出しは括
弧を省略できます。

.. runblock:: iex
   
   > if true, [do: 1+2]


さらに、最後の引数がキーワードリストの場合、カギ括弧も省略できます。

.. runblock:: iex
   
   > if true, do: 1+2


if関数は第一引数がfalseの場合はelse:キーがあれば、それを評価します。

.. runblock:: iex

   > if( true, [do: 1, else: 2 ] )
   > if( false, [do: 1, else: 2 ] )  

do:やelse:の中が複数行とする場合、ブロック記法が使えます。

.. runblock:: iex

   > if true do
   > 1
   > else
   > 2
   > end

実は、ifはプリミティブではなく、マクロでelixirのKernelモジュールで実装
されています。

制御構造
-------------------------------------

elixirには制御構造は分岐のみが存在します。繰り返しは再帰呼び出しによっ
て行います。

節とガード式
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

節とは
`````````````````````````````````````
節とは

.. code-block:: elixir

    match_pattern -> expression

の形のものです。match_patternはマッチパターンを書くことができ、さらにガー
ド式を書くことができます。match_patternがマッチするとexpressionが実行さ
れる仕組みです。この仕組みはcase式やcond式、fnなど様々なところで現れま
す。複数の節を書くことができますが、実行時システムは上からパターンを操
作して最初にマッチした節を実行しますので、順序は大事です。

ガード式とは
`````````````````````````````````````

ガード式はmatch_patternを修飾する物で、whenキーワードによって記述します。
match_patternにマッチしてかつ、when句がtrueの場合にマッチしたことになり
ます。パターンに対して複数のwhen句を記述した場合には、いずれかのwhen句
がtrueとなればマッチしたことになります。ガードつきの節は


1) 単一のガードの場合

.. code-block:: elixir

    match_pattern when bool_expression -> expression

2) 複数のガードの場合

.. code-block:: elixir

    match_pattern when bool_expression1
                  when bool_expression2
                  ...
                  when bool_expressionn -> expression

の形をしています。ガード式はブール式でありtrueかfalseを返す必要がありま
す。また、ガード式に記述できる演算子や関数は副作用が無い一部の関数に限
られており、副作用がない関数ならどれでも使用可能と言う訳ではありません。
また、自作の関数を呼ぶ事も出来ません。

比較演算子 
    ==, !=, ===, !==, >, <, <=, >=

ブール演算子 
    and, or, not [#amp_amp_not_allowed]_

算術演算子
     +, -, *, /

リストとバイナリ演算子 
     <>, ++ ただし、左辺値(演算結果)がリテラルとなる場合のみ

内包演算子 
    in 

検査関数(型を検査する以下の関数)
    * is_atom/1
    * is_binary/1
    * is_bitstring/1
    * is_boolean/1
    * is_float/1
    * is_function/1
    * is_function/2
    * is_integer/1
    * is_list/1
    * is_map/1
    * is_number/1
    * is_pid/1
    * is_port/1
    * is_reference/1
    * is_tuple/1

その他の関数 基本的な物を中心に利用可能な関数がいくつかあります。

    * abs(number)
    * bit_size(bitstring)
    * byte_size(bitstring)
    * div(integer, integer)
    * elem(tuple, n)
    * hd(list)
    * length(list)
    * map_size(map)
    * node()
    * node(pid|ref|port)
    * rem(integer, integer)
    * round(number)
    * self()
    * size(tuple|bitstring)
    * tl(list)
    * trunc(number)
    * tuple_size(tuple)

ガード式を複数記述することが出来ますがその場合は、いずれかのガード式が
trueだった場合にマッチパターンを評価します。

if
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ifは最大2分岐の時に使用します。doブロックとキーワードリストの書き方があります。いわゆるelsifはありません。


.. runblock:: iex
   
   > x = 1
   > if x == 1, do: :one, else: :not_one
   > if x == 1 do
   >   :one
   > else 
   >   :not_one
   > end
   > x = 2
   > if x == 1, do: :one, else: :not_one
   > if x == 1 do
   >   :one
   > else 
   >   :not_one
   > end

case 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

パターンマッチ演算子=を導入しましたが、いくつかのパターンにマッチさせた
い場合にはcaseを使います。変数がパターン中に現れると、マッチさせるよう
に値を調整可能な場合には、その値に束縛され直します。ここは=と同様ですが、
関数型言語の多くが単一代入であることと異なっています。

.. runblock:: iex

   > x = 1
   > case [1,2,3] do
   >   [1,2,x] -> x
   >   x -> x
   >    _ -> 0
   > end
   > case [1,2,3] do
   >   x -> x
   >   [1,x,3] -> x
   >   _ -> 0
   > end

再束縛をしてほしくない場合には、=の時と同様に^演算子を用います。

.. runblock:: iex

   > x = 4
   > case [1,2,3] do
   > [1,x,3] ->
   >   x
   > x ->
   >   x
   > _ ->
   >   x
   > end
   > x
   > x = 4          
   > case [1,2,3] do
   > [1,^x,3] ->
   >   x              
   > x ->
   >   x
   > _ ->
   >   0
   > end

パターンにはガード式を使う事もできます。

.. runblock:: iex

   > case [1,2,3] do           
   > [1,x,3] when x > 0 ->
   >   x
   > x ->
   >   x
   > end

ガード式は、型チェックや論理演算子など、組み込み演算子と関数のみが使え
ます。 [#erlang_guard]_ 

cond
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

condは記述された順序で複数の式の検査を行い、最初にtrueと評価された節が
実行されます。

.. runblock:: iex

   > x = 4
   > cond do
   > 2 + x == 5 ->
   >   "x is 3"
   > 2 * x == 8 ->
   >   "x is 4"
   > 1 * x == x ->
   >   "x == any"
   > end

例外
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

例外については後で書く。

例外はモジュールである。



無名関数の定義
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

関数は第一級のオブジェクトです。elixirでは関数の定義も複数の節で定義で
きます。

:ref:`関数` で説明したように、定義はfn()->...endで行い、 =などで変数へ束
縛するか、直接.演算子で使用することができます。

.. runblock:: iex

   > (fn(x) -> x * 2 end).(3)


複雑な関数は改行を入れてもかまいません。

.. runblock:: iex

   > (fn(x) ->
   >   x * 2
   > end).(3)

また、&構文を使って定義することもできます。&()がfn...endのかわりで、
&nが仮引数になります。


.. runblock:: iex

   > (&(&1 * 2)).(3)

関数内で使用される自由変数に対する変更はシャドウされます。

.. runblock:: iex

   > x = 1
   > (fn()->
   > x = 2  
   > [x,x=3]
   > end).()
   > x


receive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

アクターメカニズムのエッセンスについて議論します。Elixirではプログラム
は互いに分離されたプロセスの中で動作し、それらの間でメッセージを交換し
ます。それらのプロセスはオペレーティングシステムのプロセスではありませ
んが(非常に軽量です)、お互いに状態を全く共有しません。

.. figure:: ../illustrations/actor_model.png
   
アクターモデル

メッセージを交換するためにそれぞれのプロセスは受信したメッセージを保存
するmailboxを持っています。receiveはこのmailboxからパターンにマッチする
メッセージを検索します。カレントプロセスにメッセージを送信するために
send/2を使用し、receiveを使ってmailboxからメッセージを取得する例を示し
ます。


.. runblock:: iex

   > current_pid = self # 現在のプロセスのpidを取得
   > spawn fn ->        # プロセスを起動して、メッセージを送信する
   >   send current_pid, { :hello, self }
   >   :ok
   > end 
   > receive do          # メッセージを受信する
   > { :hello, pid } ->
   >   IO.puts "Hello from #{inspect(pid)}"
   > end

モジュール
-------------------------------------

elixirで新しいモジュールを作成するためには、”defmodule”マクロに内容を渡すことで行います。

.. code-block:: elixir
   :linenos:

    defmodule Math do
      def sum(a,b) do
        a + b
      end
    end

iexから対話的に実行するとこうなります。

.. runblock:: iex

   > defmodule Math do
   >   def sum(a,b) do
   >     a + b
   >   end
   > end
   > Math.sum(1,2)

モジュールの中では以下の定義が可能です。

def 
    公開関数の定義

defp
    プライベート関数の定義

defmacro 
    マクロの定義

defmacrop
    プライベートマクロの定義

defstruct 
    構造体の定義

defprotocol 
    プロトコルの定義

defimpl 
    プロトコルの実装の定義

これらの定義については以下に詳細が記述されます。

ディレクティブ
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ソフトウェア再利用をサポートする為に、elixirは4つのディレクティブをサポー
トします。

import
`````````````````````````````````````

修飾された名前を使用する事なく他モジュールから簡単に関数にアクセスした
いときにはいつでも、”import”を使わなければなりません。

たとえば、あなたのモジュールで何回か”Orddict”モジュールの”values”関
数を”Orddict.values”とタイプする事なく使いたいとき、単にそれをインポー
トする事ができます。

.. code-block:: elixir
   :linenos:

    defmodule Math do
      import Orddict, only:[values: 1]
      def some_function do
        # call values(orddict)
      end
    end

この場合、”Orddict”から(アリティ1の)関数”values”だけをインポートし
ています。”only”はオプションですが、このオプションの仕様は推奨されて
います。”except”オプションも使うことができます。このメカニズムはマク
ロをインポートすることは出来ません。関数だけです。

alias
`````````````````````````````````````

aliasは与えられたモジュールを参照する為の別名をセットアップします。
例えば、以下をすることができます:

.. code-block:: elixir
   :linenos:

    defmodule Math do
      alias MyOrddict, as: Orddict 
    end

これで任意の”Orddict”への参照が自動的に”MyOrddict”に置き換わります。
オリジナルの”Orddict”への参照をするにモジュールの前Elixir.をつけま
す:

.. code-block:: elixir
   :linenos:

    Orddict.values #=> uses Elixir.MyOrddixt.values
    Elixir.Orddict.values #=> uses Elixir.Orddict.values

(実際はelixirの全てのモジュールはElixirというモジュールのサブモジュール
になっています)

aliasはレキシカルスコープですので特定の関数の内側でだけaliasをセットアップ
することができます。

.. runblock:: iex

   > defmodule Group do
   >   def direct_product(a, b) do
   >     alias :lists, as: MyList
   >     for x <- MyList.seq(1, a),
   >         y <- MyList.seq(1, b) do
   >         {x, y}
   >     end
   >   end
   >   def product(a, b) do            # MyListはここではaliasから外れている
   >     for x <- MyList.seq(1, a),
   >         y <- MyList.seq(1, b) do
   >         {x, y}
   >     end
   >   end
   > end
   > Group.direct_product(3, 4)
   > Group.product(3, 4)                # エラーとなる

require
`````````````````````````````````````

"require”はカレントモジュールに所定のモジュールマクロを有効にする事で
す。例えば、”MyMacro”もジュルの中に独自の”if”実装を作成したとします。
それを呼び出したいときには最初に明示的に”MyMacro”を”require”する必
要があります:

.. code-block:: elixir
   :linenos:

     defmodule Math do
       require MyMacro
       MyMacro.if do_something, it_works
     end

ロードされていないマクロを呼び出す試みはエラーを起こします。”require”
が唯一のレキシカルなディレクティブであることは重要です。これは特定の関
数の内部で特定のマクロを必要とする事を可能にするという事を意味します:

.. code-block:: elixir
   :linenos:

    defmodule Math do
      def some_function do
        require MyMacro, import: true
        if do_something, it_works
      end
    end

上記の例では、”MyMacro”からマクロを”require”して”import”し、
some_functionの内部での、”if”の実装をオリジナルから独自のものに取り
替えました。そのモジュールの他のすべての関数は、オリジナルを使うことが
できます。

最後に、”require”もimportするマクロを選択する為に”only”と”except”
オプションを受け入れます。

連続的な“require”により前の定義オーバーライドします。

.. code-block:: elixir
   :linenos:

    defmodule MyIo
      # import bit-or and bit-and from Bitwise
      require Bitwise, only: [bor: 2, band: 2]
      def some_func(x, y, z), do: x bor y band z
      
      # import all, except bxor, overriding previous
      require Bitwise, except: [bxor: 2]
    end


use
`````````````````````````````````````

“use”は単に拡張の為の共通API3つのうちで最も単純なメカニズムです。例え
ば、”ExUnit”テスト・フレームワークを使う為には、モジュール中
で”ExUnit::Case”を”use”すればいいです:

.. code-block:: elixir
   :linenos:

    defmodule AssertionTest do
      use ExUnit::Case
      
      def test_always_pass do
        true = true
      end
    end

“use”を呼ぶ事により、”ExUnit::Case”中の”__using__”と呼ばれるフッ
クが起動され、それから元々のセットアップが実行されます。言い換える
と、”use”は単に以下のように翻訳されます:

.. code-block:: elixir
   :linenos:

    defmodule AssertionTest do
      require ExUnit::Case
      ExUnit::Case.__using__(:"::AssertionTest")
      
      def test_always_pass do
        true = true
      end
    end

.. rubric:: 脚注
.. [#map_since_erlang_r17] Erlang/OTP R17で導入され、Elixirでも利用
                              できるようになりました。
.. [#nil_is_not_nul_list] Lispと異なり、nilと[]は異なります
.. [#erlang_binary] Erlangのバイナリ
.. [#erlang_string] Erlangの文字列
.. [#erlang_list_operation] この辺はErlangと全く同じです。
.. [#erlang_andalso_orelse] この振る舞いは、Erlangのandalsoとorelseにマッ
                            プされると考えると良いです。
.. [#reassign] ここはErlangと違うところですが、javaやRuby使いはほっとす
               るところでしょう。
.. [#under_score_variable] ここもErlangと同じです。
.. [#amp_amp_not_allowed] ||, &&は許可されていません
.. [#erlang_guard] Erlangのガード式と同様です。
