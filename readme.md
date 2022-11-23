# Name
- メモ

# Overview
- RubyのWebフレームワークである「sinatra」でできているシンプルなメモアプリです。

# Description
- 機能としてはメモの作成／閲覧／編集／削除があります。
※一度削除すると復帰できません。  

# Demo
- デモは下記です。
https://www.loom.com/share/13d3a713009644bf89a34ee67e874cae  

# Requirement
- 下記のパッケージをインストールする必要があります。
require 'sinatra' # sinatraのパッケージです  
require 'sinatra/reloader' # sinatraを再起動することなくファイル修正ができます  
require 'pg'　# PostgreSQLの接続に必要です。
※PostgreSQLの事前インストールが必要です。

# Usage
- 使い方は下記コマンドを入れます。
% git clone https://github.com/shimonhayashi/memo  
% cd memo  
% bundle install  
% ruby app.rb  
`http://localhost:4567`にアクセス  

# Lisence
- ライセンスは特にありません。
