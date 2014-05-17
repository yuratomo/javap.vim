javap.vim
=========

Description
-----------
javap用のvimプラグインです。
jarに含まれるクラスの一覧表示と、その一覧から指定したクラスの定義を調べることが可能です。

Requirements
------------
必要なのものは次のとおり。

* jar
* javap

Setting
-------
# 読み込むjarの設定
次のように必要なjarを.vimrcに定義する

    let g:javap_defines = [
      \ { 'jar' : $JAVA_HOME . '/jre/lib/rt.jar', 'javadoc' : 'http://docs.oracle.com/javase/jp/6/api/%s.html' },
      \ ]

# jarとjavapのパス指定
jarとjavapにパスを通す

Usage
-----
* 起動

次のコマンドで起動するとクラス一覧が表示される

(初回起動後は遅いですが、キャッシュするので次回以降は早いはず)

    :Javap

* クラス一覧

クラス名の上でReturnキーを押すとクラス定義が表示されます。

* クラス定義

クラス名の上でReturnキーを押すとクラス定義が追加表示されます。
Backspaceでクラス一覧に戻ります。
クラス以外の上でReturnキーを押すと関数の定義がヤンクされます。

* キャッシュのクリア

一度ロードしたクラス一覧は~/.vim_javap にキャッシュします。
これをクリアする場合は、次のコマンドを実行してください。

    :JavapClearCache

ScreenShots
-----------

* Javap クラス一覧


HISTORY
-------
*v1.0 2014.03.06 yuratomo

Initial version


