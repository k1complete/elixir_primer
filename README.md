elixir_primer
=============

eixirの入門書をsphinxで買いてみています。
もともとはdev.0.5.0から0.7.0頃のgetting startedを翻訳していたのですが、
本家の更新が早過ぎてついていけなくなったのと、OTPとの連携とかを
書き加えているうちに別物になってきました。

当初はlyxというワープロ(笑)で作業していましたがsphinxに乗り換え
ることにして今に至ります。

ビルド方法
----------

elixirが必要ですので事前にインストールしておきます。

また、sphinx-contrib/autorunとk1complete/cittyが依存しています。
autorunはsphinxビルド時にrunblockを任意のプログラムの標準入力として
実行した結果に置き換える拡張で、cittyは標準入力を疑似端末として
任意の対話型プログラムに送り、自動で対話するプログラムです。

% make html



