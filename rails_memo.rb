### Rubocop
## 1. インストール
#  Gemfile
gem 'rubocop', require: false
$ bundle install

## 2. RuboCopの設定ファイルを生成
# 「.rubocop_todo.yml」と「.rubocop.yml」という2つのファイルを生成するだけでなく、
# 現在出ている警告を一時退避させることができる
.rubocop.yml      #「守るべきルール」
.rubocop_todo.yml # 「今後直すべき違反」
$ rubocop --auto-gen-config

# 「.rubocop_todo.yml」内の記述から
# 修正したい警告をコメントアウト
# 例. Gemfile の警告の一時退避を削除
# Bundler/DuplicatedGem:
#   Exclude:
#     - 'Gemfile'

## 3. 修正内容を確認
$ bundle exec rubocop

## 4. コードが修正されたか確認
$ bundle exec rubocop

## 5.「.rubocop_todo.yml」に戻りコメントアウトした警告を削除


## 自動修正
# safeとマークされているCopのみを自動修正
$ rubocop -a
# unsafe(挙動が変わってしまう可能性)のCopも含めた全てのCopを自動修正
$ rubocop -A

## 差異を確認
git diff
## 差異を戻す
git reset

# .: clean file
# c: convention
# w: warning
# e: error
# f: fatal




----------Trix-------------
gem 'trix-rails', require: 'trix'

# application.js
//= require trix
# application.scss
@import "trix";

# formにtrix editorを追加(trix editorにタイプされたものがdetailのtext_areaに反映される)
<div class="form-group">
  <%= f.label :detail, "詳細" %>
  <%= f.text_area :detail, id: :post_detail, required: true, autofocus: true, autocomplete: 'detail', class: 'form-control' %>
</div>
<trix-editor input="post_detail"></trix-editor>

# 表示画面
<%= sanitize @board.detail %>

Photoモデルを作成(image_dataには画像,imageには画像データ？)
rails g scaffold Photo image_data:text
# 書き換え
# 画像を保存できるようにする(photos_controller.rb)
def photo_params
  params.require(:photo).permit(:image)
end

~/model/image_uploader.rbを作成
class ImageUploader < Shrine
end
を記述

gem 'shrine'

# config/initializers/shrine.rbを新規作成して以下をコピペ
#############################################
require "shrine"
require "shrine/storage/file_system"
# ファイルを保存する場所を指定
Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
}
Shrine.plugin :activerecord #loads Active Record integration
Shrine.plugin :cached_attachment_data #enables retaining cached file across form redisplays
# Shrine.plugin :restore_cached_data #extracts metadata for assigned cached files
#######################以下######################

####Trixとは直接関係ない(指定のJSだけ読み込ませる)#########
# config/environments/development.rb と production.rb
config.assets.precompile += ['application.js']
# _form.html.erb
<%= javascript_include_tag 'trix_uploads.js' %>
# config/initializers/assets.rb
Rails.application.config.assets.precompile += %w( fuga.js )
#####################以上####################

--------mysql2----------
エラー
ローカルのRubyバージョンをアップデートしたので、Railsアプリケーションのgemもアップデートした際、mysql2のインストールでエラーが発生

Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
ld: library not found for -lssl
mysqlがlibssl.dylibを見つけられないといって止まる
ldはGNUリンカーと呼ばれるコマンド

-lsslとは、mysql2 gemインストール時にldコマンドに与えられたオプションの一つ

ls /usr/local/Cellar/mysql/8.0.21/lib
実際に覗いてみると、お目当てのlibssl.dylibがない

ライブラリの場所を指定してgemをインストールできればいい
brew info openssl
=> buildオプションの値
  export LDFLAGS="-L/usr/local/opt/openssl/lib"
  export CPPFLAGS="-I/usr/local/opt/openssl/include"

gem install mysql2 -v '0.5.3' --source 'https://rubygems.org/' -- --with-cppflags=-I/usr/local/opt/openssl@1.1/include --with-ldflags=-L/usr/local/opt/openssl@1.1/lib

rails g devise:installでエラー
`autodetect': Could not find a Java
Script runtime. See https://github.com/rails/execjs for a list of available runtimes. (ExecJS::RuntimeUnavailable)
brew install nodejsで解決

Mysql2::Error::ConnectionError: Access denied for user 'root'@'172.19.0.4' (using password: YES)
dbサービスにportsを設定していると発生
mysqlにログインする際に3306を通るため、
ホストがlocalhostではなくなってしまうためアクセスできなくなる！！
->ports: を削除することで対応
->たぶんIPアドレス(=172.19.0.4)がホストのユーザーを作成しても対応できると思う

database.ymlのsocket
同じコンピューター(同一ネットワーク)内で接続する(ドメインソケット)際の設定
→ローカル接続の設定
ネットワーク間で用いるtcp/ip接続よりも高速？

AWSのEC2でMySQL8.0を入れてデータベースを作成する時に発生
→temporary passwordが発行されていた
Couldn't create 'recruit_web_production' database. Please check your configuration.
rails aborted!
Mysql2::Error::ConnectionError: Access denied for user 'root'@'localhost' (using password: NO)
rootユーザーで cat /var/log/mysqld.log | grep password
を叩くとパスワードを確認できる
---------unicorn------------
pidの確認
ps -ef | grep unicorn | grep -v grep
# 出力結果
masa     25078     1 19 14:45 ?        00:00:00 unicorn_rails master -c /var/www/rails/recruit_web/config/unicorn.conf.rb -D -E production
masa     25080 25078  0 14:45 ?        00:00:00 unicorn_rails worker[0] -c /var/www/rails/recruit_web/config/unicorn.conf.rb -D -E production
masa     25081 25078  0 14:45 ?        00:00:00 unicorn_rails worker[1] -c /var/www/rails/recruit_web/config/unicorn.conf.rb -D -E production
-> masterの行の数(25078をkillすれば停止される)

unicornの停止
kill 25078

unicornの起動
bundle exec unicorn_rails -c /var/www/rails/recruit_web/config/unicorn.conf.rb -D -E production
unicornのバージョンによってはbundle execをつける必要ある？

nginxを再起動
sudo nginx -s reload

PID(OSが現在実行されているプロセスを識別する為の、プロセスごとに一意な識別子。 「45364」といった形の番号形式)
---------rbenv-----------
Bundlerとは
プロジェクト内で使うGemのパッケージ管理ツール
Gemをプロジェクト単位で管理できる
rbenv(rubyのバージョンをプロジェクト単位で管理するツール)のGem版
bundle installコマンドを叩くと、GemfileのGemをインストール

rbenvのインストール一覧
rbenv install --list

rbenvにどんなバージョンがインストールされているか確認
rbenv versions

環境全体のRubyバージョンを指定したい場合
rbenv global 2.6.3

特定のプロジェクトだけで指定したい場合
以下のコマンドを適用したいプロジェクトで実行
rbenv local 2.6.3

Rubyのバージョンごとにgemをインストールしないといけない
gem install bundler

プロジェクトのGemfile
bundle install --path=vendor/bundle

問題になっているGemの確認
bundle doctor

bundle execをつけないと、PCにグローバルインストールされているgemが動く

bundle execをつけると、そのプロジェクトで管理しているgemが動く
---------scss(rails)---------
@extendはcssを継承し、なおかつ上書きできる
.icon {
  color: white;
  height: 50px;
  width: 50px;
  border-radius: 10%;
}
.i-blue {
  @extend .icon;
  background-color:gray;
  width: 60px;
}
i-blueは.iconを継承しwidthを60pxに上書きし background-color:grayセレクタを追加

#@mixinは引数を設定して呼び出すことができる
@mixin box_sizing {
  -moz-box-sizing:    border-box;
  -webkit-box-sizing: border-box;
  box-sizing:         border-box;
}
/* miscellaneous */
.debug_dump {
  clear: both;
  float: right;
  width: 100%;
  margin-top: 45px;
  @include box-sizing;
}

content_forメソッドを使用することで、コンテンツを名前付きのyieldブロックとしてレイアウトに挿入できる
たとえば、以下のビューのレンダリング結果は上で紹介したレイアウト内に挿入されます。

# simple_page.html.erb (application.html.erbに渡す)
<% content_for :head do %>
  <title>A simple page</title>
<% end %>

# application.html.erb (simple_page.html.erb から受け取る)
<%= yield :head %>

# HTMLの最終的な表示
<title>A simple page</title>

# html.erbファイル毎にscssを適用
# new.html.erb
<% content_for :css do %>
  <%= stylesheet_link_tag 'users' %>
<% end %>

# application.html.erb
<%= yield :head %>

# application.html.erb の最終的な描画
<%= stylesheet_link_tag 'users' %>
----------Bootstrap---------
Bootstrap2~3用
rails用のbootstrapパッケージを入れる
gem "bootstrap-sass", "~>3.3.6"
gem "jquery-rails"
gem "jquery-ui-rails"
入れたcssとjavascriptを使う事を明記
application.cssをscssに
@import "bootstrap-sprockets";
@import "bootstrap";
->scss内でbootstrapを使用可能に

application.jsにて
//= require jquery
//= require bootstrap-sprockets
->jqueryとbootstrapのjsを入れている

gem "sass-rails", "~>5.0"
->version5代で最新を入れてあげる
->bootstrapを入れるためのsass-rails


Bootstrap4用
gem 'bootstrap', '~> 4.1.1'
gem 'jquery-rails'
# application.css
application.scssにリネーム
@import "bootstrap";
- Sassファイルでは*= require_self、*= require_treeを削除
- Sassファイルではインポートに@importを利用する
- Sassファイルで*= requireを利用すると他のスタイルシートではBootstrapのmixinや変数を利用できなくなる
# application.js
//= require jquery3
//= require popper
//= require bootstrap-sprockets
- Bootstrapのtooltipsやpopoverはpopper.jsに依存している
- bootstrapの依存gemにpopper_jsが指定されているため新たにインストールは不要
- コンパイルを高速化したい場合はbootstrap-sprocketsの代わりにbootstrapを指定する

レスポンシブ対応のためのmetaタグ
<meta name="viewport" content="width=device-width,initial-scale=1">
------------devise-------------
deviseのエラーメッセージではalert-alertやalert-noticeクラス(flashのcssが適用されない)があるので、flashのcssを適用できるようにしてあげる。

gem 'devise'
依存するファイル群も一緒に作成できます。
rails g devise:install

以下コマンドでuserモデルを作成。
emailとpasswordは、自動でカラム生成を行ってくれる為、その他に追加したいものがあれば、別途マイグレーションファイルに記述し、マイグレーションを実行します。
rails g devise user

以下コマンドで、対応するview画面を一気に作成
rails g devise:views users
->rails g devise:i18n:views user
->rails g
の方が良さそう？

最後に以下コマンドで、対応するcontrollerを作成
rails g devise:controllers users

日本語訳を変更
日本語訳を変更したい場合は，次のコマンドでconfig/locales/devise.views.ja.ymlを作成し，編集すればOK
$ rails g devise:i18n:locale ja
例えばアカウント登録を新規登録に変更したい場合は，devise.views.ja.ymlの該当文字を置換すればOK

ログイン画面などの変更
まず，次のコマンドでビューファイルを作成
$ rails g devise:i18n:views
$ rails g devise:views:bootstrap_templates -f
->作成したviewsにbootstrapを適用(上書き)するためのコマンド
それぞれのコマンドの最後に例えばuserをつけることで，usersディレクトリ内にファイルを作成することもできますが，その場合は，次の3つの作業を行わないと反映されない
devise.views.ja.yml30行目のdeviseをusersに変更
config/initializers/devise.rbにあるconfig.scoped_views = falseをtrueに変更
サーバーを再起動

Bootstrapが自動的にある程度反映される
gem 'devise-bootstrap-views'
rails g devise:views userで作成した
view自体にはform-controlなどがないため、
controllerを介すると反映されなくなる

# Controller(registrations)の上書きの反映
devise_for :users, :controllers => {:registrations => "users/registrations"}

# admin画面などでのルーティングを組みたい場合
routes.rb
  devise_for :users,
    path: :admin,
    :controllers => {
      :registrations => 'organizers/registrations',
      :sessions => 'organizers/sessions',
      :passwords => 'organizers/passwords'
    }
----------URI------------
データURIスキーム（data URI scheme）とは、
外部データを直接ウェブページに埋め込む手法です
この技術を利用することで、通常は別のデータに分かれている画像やスタイルシートなどの要素を、1つのHTTPリクエストによって読み込むことが可能になる
ただし、IEとEdgeでは、一部の機能が実装されていない

----------JavaScript(Rails)---------
RailsでJavaScriptファイルを読み込ませたいときは、railsプロジェクトのフォルダの配下にある対象のjsファイルを置くことで、自動で読み込めます
app/assets/javascript/
これは、Railsの標準機能の一つであるAsset Pipeline（複数のJavaScriptやCSSのファイルを一つのファイルに統合・圧縮し読み込みを高速に行えるようにする機能）がデフォルトで有効になっているためです。
結果として、Railsは１つのファイルをすべてのページに適用するという形をとっているため、特定のJavaScriptだけ読み込ませるという動作を行いたいときは邪魔になります。
自動読み込みを無効にするためには、app/assets/javascript/ の配下にあるapplication.jsを編集
application.jsはapp/assets/javascript/配下においてあるjsファイルを管理するファイルであり、自動読み込みの対象を設定できるjsになります。

自動読み込みを無効にするには、application.jsの中に記載してある下記の一文を削除することで、自動読み込みを停止できる
//= require_tree .
app/assets/javascripts以下の全JSファイルを読み込む

production環境で特定のJavaScriptファイルのみ読み込む
Asset Pipelineでの自動読み込みを無効にした場合は、手動でのプリコンパイルが必要
これは、読み込みの設定を行うためにconfig/initializers/配下にある assets.rbを編集
以下の一文を追加することでプリコンパイル対象を指定可能
Rails.application.config.assets.precompile += %w( *.js )
サービスを再起動することで、指定した.js拡張子のファイルをプリコンパイルできる

個別ページでの読み込み
個別ページで特定のjsファイルを読み込むためにはjavascript_include_tagを使用します。
対象のviewファイルのheadなどに下記のように記述することで、任意のファイルを読み込むことが可能です。
<%= javascript_include_tag "hoge_fuga.js" %>

全てのviewで読み込んでほしいjsを手動でコンパイルの設定をする
hoge.jsを追加したい場合は以下の通り。
# config/environments/production.rb
config.assets.precompile += ['hoge.js']

# jsをディレクトリで分けて、特定のディレクトリ（hogehoge）だけ追加する場合は以下の通り。
config/environments/production.rb
config.assets.precompile += ['hogehoge/*.js']
上記では本番用環境（production）のみを記載したが、開発環境でも同様のことを行う場合はdevelopment.rbも同様に追記


「img.onload」を使うことで、意図的に読み込みが完了した時の処理を書くことが出来るわけです。
先ほどの「img.width」による幅サイズの取得は、次のように書けば上手く実行されます。
var img = new Image();
img.onload = function() {
    // 画像の幅サイズを出力
    console.log(img.width);
};
img.src = 'image/sample.jpg';
document.body.appendChild(img);
----------非同期通信-----------
RailsアプリケーションでPOSTリクエストを送る場合、多くの場合はform_withなどのヘルパーを利用すると思いますが、JavaScriptのみでPOSTリクエストを送らなければならないケースに遭遇する。
本記事はこの際に発生した「401 Unauthorized」エラー対応のTIPSです。
xhr.setRequestHeader('X-CSRF-Token', token);
"X-CSRF-Token"を追加する必要がある

responseTextは、XMLHttpRequestのプロパティです。レスポンスの内容を文字列で返す

文字列を JSON として解析し、文字列によって記述されている JavaScript の値やオブジェクトを構築
JSON.parse(xhr.responseText)
----------jbuilder-----------
基本の基本
json.hogeで一番上の階層が作れる
json.total_pages @events.total_pages
↓
{
  "total_pages": 10
}
階層を下げるには？
doを使ってブロックを作り、その中に値を書いてあげる
json.events do
  json.id 123
end
↓
"events": {
  "id": 123
}
gem jbuilderの便利なメソッド
extract!で簡単出力
showの時に使うことが多いかな。対象オブジェクトが1件の場合はextract!を使って出力したいカラムをシンボルで渡してあげれば勝手にjson形式データを作っちゃうよ。 第一引数がオブジェクト、第二引数以降に出力したいカラム名をシンボルで。
json.extract! @item, :id, :title, :description, :created_at, :updated_at
↓
{
    "id": 1,
    "title": "テスト",
    "description": "てすと",
    "created_at": "2019-12-25T09:22:25.186Z",
    "updated_at": "2019-12-25T09:22:25.186Z"
}

ルーティングのprefixが使える
ページのURLを渡したい時はルーティングのprefixが使えちゃう。queryも付与できるからクソ便利だし、hoge_urlにしておけばrequest_urlからドメインも勝手に判断してくれる！
json.url event_url(public_id: @event.eventer.public_id, event_id: @event.id, utm_source: :test)
↓
// 勝手にlocalhost:3000を生成してくれる
"url": "http://localhost:3000/events/1185?utm_source=test",
-----------shrine--------
bin/rails g migration add_image_to_articles image_data:string
bin/rails db:migrate
# Shrineでは、CarrierWaveとは異なり、アップローダー用のクラスを作成するコマンドは提供されていないので、アップローダークラスを以下のように新規追加
# app/uploaders/image_uploader.rb
class ImageUploader < Shrine
end
# 作成したアップローダーをArticleモデルとして使えるようにする設定を入れるため、以下のようにArticleモデルに追記します。
# app/models/article.rb
class Article < ApplicationRecord
  include ImageUploader[:image]
end
# アップローダークラスをインクルードするだけで、モデルから画像を扱えるようになります。
# 注意すべきは、アップローダークラスのキーである「:image」が、先ほどマイグレーションで追加したカラム名の「image_data」のprefixと一致している必要がある点です。
# 例えばマイグレーションで追加したカラム名を「profile_data」とすると、追加するキー名は「:profile」とする必要があります。
------------deloy---------------

# githubからEC2に変更分をpull
git fetch origin
git merge origin master

cd /var/www/rails/recruit_web/
bundle install
unicorn_rails -c /var/www/rails/recruit_web/config/unicorn.conf.rb -D -E production
bundle exec unicorn_rails -c /var/www/rails/recruit_web/config/unicorn.conf.rb -D -E production
cat log/unicorn.log
kill 7186
sudo nginx -s reload
ps -ef | grep unicorn | grep -v grep

--------------controller--------------
Railsでは、インスタンス変数をコントローラ内で宣言するだけでビューで使えるようになる
基本的に名前の最後の部分に「複数形」を使う
ただしこれは絶対的に守らなければならないというものではない
(実際 ApplicationControllerはApplicationが単数になっています)
しかし、この規則には従った方がよい
理由は、resourcesなどのデフォルトのルーティングジェネレータがそのまま利用できるのと、
名前付きルーティングヘルパーの用法がアプリケーション全体で一貫ため。
コントローラ名の最後が複数形になっていないと、
たとえばresourcesで簡単に一括ルーティングできず、:pathや:controllerをいちいち指定しなければなりません。

private
コントローラの内部でのみ実行され、Web経由で外部ユーザーにさらされる必要はないメソッド
=> Rubyのprivateキーワードを使って外部から使用できないようにする
字下げしておく方が良い！

--------------route---------------
* resources(複数形リソース)
Railsの基本となるコントローラの7つのアクション名に対してのルーティングを自動で生成
resources :users で生成されるルーティング
#     users GET    /users(.:format)                        users#index
#           POST   /users(.:format)                        users#create
#  new_user GET    /users/new(.:format)                    users#new
# edit_user GET    /users/:id/edit(.:format)               users#edit
#      user GET    /users/:id(.:format)                    users#show
#           PATCH  /users/:id(.:format)                    users#update
#           PUT    /users/:id(.:format)                    users#update
#           DELETE /users/:id(.:format)                    users#destroy

* resource(単数形リソース)
コントローラの７つのアクションに対して、indexとid付きのパスが生成されない
resource :user で生成されるルーティング
# new_user  GET    /user/new(.:format)                     users#new
# edit_user GET    /user/edit(.:format)                    users#edit
#      user GET    /user(.:format)                         users#show
#           PATCH  /user(.:format)                         users#update
#           PUT    /user(.:format)                         users#update
#           DELETE /user(.:format)                         users#destroy
#           POST   /user(.:format)                         users#create

* namespace
コントローラを名前空間によってグループ化
namespace :admin do
  resources :users
end
# admin_user_index GET    /admin/user(.:format)          admin/user#index
#                  POST   /admin/user(.:format)          admin/user#create
#   new_admin_user GET    /admin/user/new(.:format)      admin/user#new
#  edit_admin_user GET    /admin/user/:id/edit(.:format) admin/user#edit
#       admin_user GET    /admin/user/:id(.:format)      admin/user#show
#                  PUT    /admin/user/:id(.:format)      admin/user#update
#                  DELETE /admin/user/:id(.:format)      admin/user#destroy
controllers/admin以下にコントローラを作成するコマンド
rails g controller admin/users

* scope
URLは/usersだけど、Admin::UsersController
(adminディレクトリ以下にコントローラを作成するとこういうクラス名になる）にルーティングする
scope module: 'admin' do
  resources :tweets
end  
#ブロックを使わない書き方
resources :users, module: 'admin'
#     users GET    /users(.:format)                        admin/users#index
#           POST   /users(.:format)                        admin/users#create
#  new_user GET    /users/new(.:format)                    admin/users#new
# edit_user GET    /users/:id/edit(.:format)               admin/users#edit
#      user GET    /users/:id(.:format)                    admin/users#show
#           PATCH  /users/:id(.:format)                    admin/users#update
#           PUT    /users/:id(.:format)                    admin/users#update
#           DELETE /users/:id(.:format)                    admin/users#destroy

* concern
他のリソースやルーティング内で使いまわせる共通のルーティングを宣言
# 使いまわしたいルーティングを定義
concern :postable do
  resources :posts
end
# concernで定義したルーティングを使い回す
resources :messages, concerns: :commentable

# 以下のコードと同様のルーティングを生成
resources :messages do
  resources :comments
end

#    user_posts GET    /users/:user_id/posts(.:format)          posts#index
#               POST   /users/:user_id/posts(.:format)          posts#create
# new_user_post GET    /users/:user_id/posts/new(.:format)      posts#new
#edit_user_post GET    /users/:user_id/posts/:id/edit(.:format) posts#edit
#     user_post GET    /users/:user_id/posts/:id(.:format)      posts#show
#               PATCH  /users/:user_id/posts/:id(.:format)      posts#update
#               PUT    /users/:user_id/posts/:id(.:format)      posts#update
#               DELETE /users/:user_id/posts/:id(.:format)      posts#destroy
#         users GET    /users(.:format)                         users#index
#               POST   /users(.:format)                         users#create
#      new_user GET    /users/new(.:format)                     users#new
#     edit_user GET    /users/:id/edit(.:format)                users#edit
#          user GET    /users/:id(.:format)                     users#show
#               PATCH  /users/:id(.:format)                     users#update
#               PUT    /users/:id(.:format)                     users#update
#               DELETE /users/:id(.:format)                     users#destroy

* member
memberはメンバールーティング（users/:id/followingのようにidを伴うパス）を追加するときに使う
resources :users do
  member do
    get :following, :followers
  end
end

#追加したいメンバルーティングが1つならonオプションを使うと1行でいける
resources :users do
  get :followers, on: :member
end

* collection
ルーティングにコレクション（/users/searchのようにidを伴わないパス）を追加するときに使う

resources :users do
  collection do
    get :search
  end
end

# こちらもonオプションで1行に
resources :users do
  get :search, on: :collection
end


* shallow
ネストが深くなったときに、生成するルーティングをいい感じにしてくれる
Group が has_many :users で、 User が belongs_to :group

# 以下のようにネストすると、新規に User を作る時の URL が /groups/:group_id/users/new となり、自然な形で group_id を渡せる
# しかし、このように routes を定義すると、
# いざ User が生成された後にその User を show するには /groups/:group_id/users/:id などとしなければならない
resources :group do
  resources :user
end

# shallow を用いるとuser_id を指定しない action である index, new, create の3つは group_id を必要とし、
# それ以外の action では user_id のみを指定すればよくなる
resources :group, shallow: true do
  resources :users
end

#  group_user_index GET    /group/:group_id/user(.:format)          user#index
#                   POST   /group/:group_id/user(.:format)          user#create
#    new_group_user GET    /group/:group_id/user/new(.:format)      user#new
#         edit_user GET    /user/:id/edit(.:format)                 user#edit
#              user GET    /user/:id(.:format)                      user#show   # 注目(groupがつかない！)
#                   PUT    /user/:id(.:format)                      user#update   # 注目(groupがつかない！)
#                   DELETE /user/:id(.:format)                      user#destroy   # 注目(groupがつかない！)
#       group_index GET    /group(.:format)                         group#index
#                   POST   /group(.:format)                         group#create
#         new_group GET    /group/new(.:format)                     group#new
#        edit_group GET    /group/:id/edit(.:format)                group#edit
#             group GET    /group/:id(.:format)                     group#show
#                   PUT    /group/:id(.:format)                     group#update
#                   DELETE /group/:id(.:format)                     group#destroy

* asオプション
:asオプションを使うと、ルーティングに名前を指定できる
get 'exit', to: 'session#destroy', as: :logout

-------------------Ajax-------------------
* ブラウザ側でJavaScriptが無効 (Ajaxリクエストが送れない場合) でもうまく動かす
respond_to do |format|
  format.html { redirect_to @user } <- Ajaxが使えない時用
  format.js
end

require File.expand_path('../boot', __FILE__)
・・・
module SampleApp
  class Application < Rails::Application
    ・・・
    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end

・JavaScript用の埋め込みRuby (.js.erb) ファイル (create.js.erbやdestroy.js.erbなど)
Ajaxリクエストを受信した場合は、Railsが自動的にアクションと同じ名前のファイルが呼び出される


* ステータスフィード


--------------いいね機能----------------
0. JSが無効になっていたときのための設定
config/application.rb
# 認証トークンをremoteフォームに埋め込む
config.action_view.embed_authenticity_token_in_remote_forms = true

いいねを押した時(削除するときは逆をやればいい)
1. Userモデルでブログをいいねしているか確認のためのメソッド定義
def favoring?(blog_id)
  favorites.where(blog_id: blog_id).exists?
end

2. HTML から favorites_controller に POST
<% if current_user.favoring?(post.id) == false %> # 明示的にfalseを付けてる
  <%= link_to create_like_path(@blog.company_id, @blog.id), method: :post, remote: true do %>
    <i class="far fa-heart options-icon blog-options-icon"></i>
  <% end %>
<% end %>

3. favorites_controller で いいねの関係性(user_id と blog_id のレコード)を登録
def create
  favorite = Favorite.new(user_id: current_user.id, blog_id: params[:blog_id])
  favorite.save
end

4. create.js.erb が呼ばれて、HTML(パーシャルの部分)を書き換える
/views/favorites/create.js.erb
document.getElementById("blog_<%= @blog.id %>").innerHTML = '<%= escape_javascript(render "companies/blogs/favorite") %>'

/views/companies/blogs/_favorite.html.erb
render で書き換える要素
<% if current_user.favoring?(post.id) %>
  <%= link_to create_favorite_path(@blog.company_id, @blog.id), method: :post, remote: true do %>
    <i class="far fa-heart options-icon blog-options-icon"></i>
  <% end %>
<else>
  <%= link_to create_favorite_path(@blog.company_id, @blog.id), method: :post, remote: true do %>
    <i class="far fa-heart options-icon blog-options-icon"></i>
  <% end %>
<% end %>

<%= @blog.favorites.size %> # 数値(renderされることで更新される)

/views/companies/blogs/show.html.erb
<p id="blog_<%= @blog.id %>">
  <%= render "companies/blogs/favorite" %>
</p>

---------------------fixture----------------------
helpersディレクトリにはビューヘルパーのテスト、
mailersディレクトリにはメイラーのテスト、
modelsディレクトリにはモデル用のテストをそれぞれ保存します。
controllersディレクトリはコントローラ/ルーティング/ビューをまとめたテストの置き場所
integrationディレクトリはコントローラ同士のやりとりのテストを置く場所

システムテストのディレクトリ（system）にはシステムテストを保存
システムテストは、ユーザーエクスペリエンスに沿ったアプリケーションのテストを行うためのもので、
JavaScriptのテストにも有用
システムテストはCapybaraから継承した機能で、アプリケーションのブラウザテストを実行します。
Capybara is a library written in the Ruby programming language which makes it easy to simulate how a user interacts with your application.

フィクスチャはテストデータを編成する方法の1つであり、fixturesフォルダに置かれる
Railsでは、テストデータの定義とカスタマイズはフィクスチャで行うことができます。
4.2.1 フィクスチャとは何か
フィクスチャ (fixture)とは、いわゆるサンプルデータを言い換えたもの
フィクスチャを使うことで、事前に定義したデータを"テスト実行直前"にtestデータベースに
導入することができる
フィクスチャはYAMLで記述され、特定のデータベースに依存しない
1つのモデルにつき1つのフィクスチャファイルが作成される

By default, test_helper.rb will load all of your fixtures into your test database, so this test will succeed.
The testing environment will automatically load all the fixtures into the database before each test. To ensure consistent data, the environment deletes the fixtures before running the load.
つまり,テストのためだけのデータ
なぜかデフォルトでidが入ってない？？(テキトーなidが振られてしまう)
→idを追加する必要あり！！

rails db:fixtures:load
test/fixtures/のデータをrails testのときと同じやり方でdevelopment用のDBに投入する
rails db:seed のデータが使われないっぽい？？

--------------------seed-----------------
マスタデータを初期登録したりするのに使います。
たとえば、部署一覧（部署マスタ）、郵便番号一覧、勘定科目一覧、カテゴリ一覧とか
rails db:seed
を実行すると読み込まれる
# テスト環境でseedする
rails db:seed RAILS_ENV=test
# テスト環境でRails consoleを使う
rails console -e test
  or
RAILS_ENV=test bundle exec rails c
--------------モデル----------------------
# モデルの作成コマンド
rails g model モデル名 カラム名:型
rails g model User name:string age:integer

・dependent: :destroy
このオプションを使うと、ユーザーが削除されたときに、
そのユーザーに紐付いた投稿も一緒に削除される
これは、管理者がシステムからユーザーを削除したとき、
持ち主の存在しない投稿がデータベースに取り残されてしまう問題を防ぐ

# 中間テーブル
Facebookのような友好関係 (Friendships) では本質的に左右対称のデータモデルが成り立ちますが、
Twitterのようなフォロー関係では左右非対称の性質がある
すなわち、AさんはPさんをフォローしていても、
PさんはAさんをフォローしていないといった関係性が成り立つ
このような左右非対称な関係性を見分けるために、
能動的関係(Aさん→Pさん:フォローしている) (Active Relationship)と
受動的関係(Pさん→Aさん:フォローされている) (Passive Relationship)と呼ぶことにする

Relationshipテーブル作成コマンド
rails g model Relationship follower_id:integer followed_id:integer

能動的関係も受動的関係も、最終的にはデータベースの同じテーブル(relationship)を使う
relationshipテーブルをactive_relationshipsテーブル(フォロワー→フォローしているユーザー)と見立てる
(ユーザーがフォローしているアカウントを結びつけるための中間テーブル)


・能動的関係に対して1対多 (has_many) の関連付けを実装
class User < ApplicationRecord
  ・・・
  has_many :active_relationships, class_name:  "Relationship", # class_name で正しいテーブル名(Relationship)を伝える
                      foreign_key: "follower_id",
                      dependent:   :destroy #ユーザーが削除されるとそのユーザーに関連するレコードも削除
end


・リレーションシップ/フォロワーに対してbelongs_toの関連付けを追加
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" # class_name で正しいテーブル名(User)を伝える
  belongs_to :followed, class_name: "User" # class_name で正しいテーブル名(User)を伝える
end

# 複合キーインデックス
add_index :relationships, [:follower_id, :followed_id], unique: true
follower_idとfollowed_idの組み合わせが必ずユニークであることを保証する仕組み
これにより、あるユーザーが同じユーザーを2回以上フォローすることを防ぐ

# フォローしている(followed)ユーザー
has_many :followeds, through: :active_relationships
デフォルトのhas_many throughという関連付けでは、
Railsはモデル名 (単数形) に対応する外部キーを探す
↓に変更！
has_many :following, through: :active_relationships, source: :followed
:sourceパラメーターで「following配列の元はfollowed idの集合である」ということを明示的にRailsに伝える
User.following でユーザーのフォロワーを取得できるようになる

「followeds」というシンボル名を見て、これを「followed」という単数形に変え、
relationshipsテーブルのfollowed_idを使って対象のユーザーを取得

Userモデルにfollowingの関連付けを追加
class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  # user.active_relationships で外部キー(foreign key)をuser_idではなくfollower_idで参照できるようになる
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed <- #追加
  ・・・
end
関連付けにより、フォローしているユーザーを配列の様に扱えるようになる
=> user2.following << user  #user2のフォロワーにuserを追加

# フォロワー
class User < ApplicationRecord
  ・・・
  # user.passive_relationships で外部キー(foreign key)をuser_idではなくfollowed_idで参照できるようになる
  has_many :passive_relationships, class_name:  "Relationship", <- #追加
                       foreign_key: "followed_id", # データベースの2つのテーブルを繋ぐ(Relationshipテーブルのfollowed_idから対応するuserを探す)
                       dependent:   :destroy
  ・・・
  has_many :followers, through: :passive_relationships, source: :follower <- #追加
  ・・・
end

## フォロー・フォロー解除
form_forを使ってRelationshipモデルオブジェクトを操作

# フォローのフォーム (新しいリレーションシップを作成)
POSTリクエストを Relationshipsコントローラに送信してリレーションシップをcreate(作成)
<%= form_for(current_user.active_relationships.build) do |f| %>
  <div><%= hidden_field_tag :followed_id, @user.id %></div>
  <%= f.submit "Follow", class: "btn btn-primary" %>
<% end %>

# フォロー解除のフォーム (既存のリレーションシップを見つけ出す)
DELETEリクエストを送信してリレーションシップをdestroy(削除)
<%= form_for(current_user.active_relationships.find_by(followed_id: @user.id),
       html: { method: :delete }) do |f| %>
  <%= f.submit "Unfollow", class: "btn" %>
<% end %>


------------フォームオブジェクト------------
「非ActiveRecordモデル」のインスタンス

データベースと無関係なフォームやデータベーステープルと
1対 1 に結び付いていないフォームをform_withメソッドで生成できる

include Active Model::Model
-> form_withのmodelオプションに指定できるようになる

attr_accessorで定義している属性は、 フォームのフィールド名となる
-> インスタンス変数の中身を参照・変更できるようにする

# formオブジェクト内に必要な記述
・formオブジェクトを使用するモデルに設定していたバリデーションの移行
・コントローラでformオブジェクトを使えるようにする記述
・モデルを介すための記述

-------------accepts_nested_attributes_for-----------------
モデルで記述したaccepts_nested_attributes_forにより
paramsに_attributes: []を一緒に追加して送ることができる

ストロングパラメーターは
_attributes: []などの配列を一番後ろに書かないといけない！！

Order.new.order_details_attributes= 関数で
Orderの関連であるOrderDetailモデルを編集できるようになる

allow_destroy: true と宣言することにより、関連の削除が可能になる
allow_destroy 指定で order_detailsのモデルに _destroy という変数が追加される(controllerで削除するため)
この変数に true を入れることにより、 モデル保存時に関連である order_details が削除される

# 1. 記述例(JobとInterview版).
# accepts_nested_attributes_for :interviews, allow_destroy: true
# -> Jobの関連であるInterviewモデルを編集できる
# 2. パラメーター例
# job"=>{"public_status"=>"false",
#     ・
#     ・
#   "interviews_attributes"=>{"0"=>{"employee_name"=>"名無し社員0", "question1"=>"会社しんどい？", ・・・},
#                             "1"=>{"employee_name"=>"名無し社員1", "question1"=>"会社やめたい？", ・・・}

## accepts_nested_attributes_for の記述とパラメータ
1. 記述例(OrderとOrderDetail版)
accepts_nested_attributes_for :order_details, allow_destroy: true
-> Orderの関連であるOrderDetailモデルを編集できるようになる
2. 生成されるパラメーター例
app/controller/orders_controller.rb#update で受け取るparamsのサンプル
"form_order"=>
 {"name"=>"A機械製造1031注文",
  "corporation_id"=>"1",
  "order_details_attributes"=>
     {"0"=>{"id"=>"1", "product_id"=>"1", "unit_price"=>"2000", "quantity"=>"3", "_destroy"=>"false"},
      "1"=>{"id"=>"2", "product_id"=>"4", "unit_price"=>"10000", "quantity"=>"4", "_destroy"=>"false"}
     }
 }

# 上記パラメータをOrderモデル(親)に引き渡すことで、注文、注文明細を更新することが可能
controller にて
# 注文、注文明細を新規作成
@order = Form::Order.new(params[:form_order])

# 注文、注文明細を更新
@order.update_attributes(params[:form_order])

注文明細(子モデル)削除の際は、単に領域を削除してはいけない
指定した受注明細を消すために、
_destroyとid のペアを パラメータとしてコントローラに渡してあげる必要がある

------------------fields_for----------------------
## 同じフォームで別のモデルオブジェクトも編集できる

## 利用条件
・fields_for の第一引数に渡した変数名の変数にアクセスできること
  (親モデルに has_many を記述)
・指定した変数が xxx_attributes= (xxx は変数名)という形式で更新できること
  (accepts_nested_attributes_for 関数を利用)

----------------ActiveModel------------
## ActiveModel::Model
ActiveModel::Modelをincludeするだけで、
オブジェクトをコントローラやビューのメソッドで利用できる
また、ActiveRecordのようにオブジェクトを属性のハッシュで
初期化したり、バリデーションを設定して実行できる

### ActiveModel::Attributes
型を持つ属性の定義を容易にするモジュール
例.
class Person
  include ActiveModel::Attributes

  attributes :name, :string
  attributes :age,  :integer
end

person = Person.new
person.name = "Nate"
#=> "Nate"
person.name
#=> "Nate"
person.age = "40"
#=> "40"
person.age
#=> 40

# 属性にデフォルト値を設定する場合
attribute :name, :string, default: "名無しユーザー"


### ActiveModel::Callbacks
コールバック機能の実装を容易にしてくれるモジュール
例.
class Person
  extend ActiveModel::Callbacks 

  attr_accessor :created_at, :updated_at

  define_model_callbacks :save # コールバックの対象となるメソッド名を選択
  before_save :record_timestamps

  def save
    # コールバックの対象となるメソッドの中身をrun_callbacksメソッドのブロックで囲う必要あり
    run_callbacks :save do
      true #saveメソッドの中身をここに記述
    end
  end

  private

  def record_timestamps
    current_time = Time.current

    self.created_at ||= current_time
    self.updated_at ||= current_time
  end
end

irb(main):001:0> person = Person.new
#<Person:0x00007f80fa223058>
irb(main):002:0> [person.created_at, person.updated_at]
[nil, nil]
irb(main):003:0> person.save
true
irb(main):004:0> [person.created_at, person.updated_at]
9 Mar 2020 08:01:32 UTC +00:00, Sun, 29 Mar 2020 08:01:32 UTC


### ActiveModel::Validations
属性のバリデーション機能の実装を容易にしてくれるモジュール
validates_uniqueness_ofのようなデータベースのレコードを参照するヘルパーを除いて、
ActiveRecordと同じバリデーションヘルパーを提供します(リスト12.7)

リスト12.7
ActiveModel::Validationsの利用例
  class Person
  include ActiveModel::Validations
  attr_accessor :name, :age
  validates :name, presence: true, length: ( maximum: 100 ]
  validates_numericality of :age, greater_than_or_equal_to;
end
person = Person.new
=> #<Person:0x@0007ff8e153a6d8>
person.name
=> "David"
person.valid?
=> false
person.errors.messages
=> (:age=>["is not a number"]]
person.errors.full_messages
=> ["Age is not a number"]

ActiveModel::validationsをincludeするだけで、
ActiveRecordのようにバリデーションを設定して実行できる
なお、このモジュールをincludeしただけでは、before.validation、
after_validationコールバックは利用できない！！
これらを利用するには、さらにActiveModel::Validations::Callbacksをincludeする(リスト12.8)

リスト12.8
ActiveModel::Validations::Callbacksの利用例
class Person
  include ActiveModel: :Validations
  include ActiveModel : :Validations: :Callbacks

  attr_accessor :name
  before_validation :normalize_name, if: -> ( name.present? )

  private

  def normalize_name
    self.name = name.downcase.titleize
  end
end

person = Person.new
=> #<Person:0x00007f86d7bafcd8>
person.name = "david"
=> "daVid"
person.valid?
=> true
person.name
=> "David"

ActiveModel::Validationsにあらかじめ組み込まれているバリデーションヘルバー
各ヘルバーの詳細については、「2-2モデルを扱う」またはRailsガイドを参照
ㆍabsence
ㆍacceptance
ㆍconfirmation
・exclusion
・format
・inclusion
ㆍlength
・numericality
ㆍpresence

これらのヘルパーは、validates_absence_ofのようなメソッドを呼び出すか、
validatesメソッドの呼び出し時のオプションに指定することで利用できる
また、これらのエラーメッセージを英語以外の言語に翻訳したい場合には、
rails-il8n gemを導入したうでリスト12.9のようなロケールファイルを用意する
版ルする例
-----------Active Record-------------
「RubyとSQLの翻訳機」
Rubyで直感的に書ける
どのDBを使用してもRubyで統一できる

基本的にDBにはDB言語としてSQLが使われています。
SQLでないとDBの操作ができません。
しかし、RailsにはModelにActiveRecordが適用されているおかげで、
Rubyを用いてDBからデータを探したり、持ってきたりすることができます。
(厳密にはModelにApplicationRecordを介してActiveRecordが適用されているため)
ORMマッピング(非互換的なデータを変換するプログラミング技法)を実装したもの
→命名規則など
ActiveRecord::Baseが提供する基底クラスを継承しているクラスをモデルクラスorモデルと呼ぶ
そのインスタンスをモデルオブジェクトと呼ぶ

### countとlengthとsizeの違い
ActiveRecordでのレコード数のカウント方法
メソッド	内容	                          キャッシュ
count	  SQLのCOUNTを使ってカウントします	  使わない
length	SQLの実行結果の行数をカウントします	 あれば使う
size	  SQLのCOUNTを使ってカウントします	  あれば使う

## Eager loadingとは (preload, eager_load, includesなど)
予めメモリ上にActive Recordで情報を保持する方法
これによって、素早いレンダリングが可能になる
しかし、アソシエーションしているテーブルにある情報が膨大な場合、
大量のメモリを消費する

## Lazy loadingとは (joinsなど)
Railsに限らず、Lazy loadingは遅延読み込みなどと言われたりしている
これは、JOINしたテーブルの情報が必要になった時に SQLを発行する
メモリを確保する量は少なくて済むが、
JOINするテーブルを参照するたびSQLを発行するため
Webサイト表示パフォーマンスを悪くする場合がある（N+1問題）


### joins
## ユースケース
# メモリの使用量を必要最低限に抑えたい場合
# JOINした先のデータを参照せず、絞り込み結果だけが必要な場合
# 逆に言うと、引用先のデータを参照しない場合、使用しないほうが良い

# mergeを使うと結合先のモデルのscopeを使うことができる

## joins（selectなし）
# actressesのカラムしか持ってこない
# 結合先の情報が不要な場合はこれで良い
Model.joins(:sub_models)   # 子モデルは複数形でないといけない
SubModel.joins(:model)

## joins（selectあり）
# 結合先（この場合はmovies）のカラムも取得できる
# 子モデルは複数形でないといけない joins(:sub_models)
Model.joins(:sub_models).select("models.*, sub_models.*")  # selectメソッド内はテーブル名を指定するので複数形！！！
SubModel.joins(:model).select("sub_models.*, models.*")

## 複数個selectしてcountをするとSQLが壊れる・・・。注意！
Model.joins(:sub_models).select("models.*, sub_models.*").count
#=> SELECT COUNT(jobs.*, access_reports.*) FROM ...    #=> エラー発生

## sizeやlengthを使うと良い
# size
Model.joins(:sub_models).select("models.*, sub_models.*").size
#=> SELECT jobs.*, access_reports.* FROM ...    #=> SQLの実行結果の行数をカウントする (COUNT関数を使わない！)
# length
Model.joins(:sub_models).select("models.*, sub_models.*").length
#=> SELECT COUNT(models.*, sub_models.*) FROM ...

・メリット
「テーブルを結合して絞り込める」
そのため、一般的にjoinsメソッドはwhereメソッドと組み合わせて使うことが多い
デメリットで説明したように、関連性を保持しないため、余計なメモリを消費せず、
関連するテーブルの数が多くなればとても効果的に働く

・デメリット
N+1問題が起きる
原因は、joinsメソッドが関連性を保持せず、ただ抽出するだけだから
抽出した結果を持っているだけですので、表示するためのデータを取得するために、データベースへアクセスする必要がある


### includes
関連するオブジェクトを一度に取得
@event.tickets.includes(:user)
includes(:user)を使わないと@ticketsの要素の数だけSQLクエリが発行される(N+1問題)
必要に応じて生成したテーブルを保持しますので、
eager_loadメソッドとpreloadメソッドを
アソシエーション先のデータ参照（WHEREなどを）しているかどうかで使い分けている


### preload
eager_loadとほぼ同じように、データベースへのアクセス回数を減らせる
1回のアクセスで済むeager_loadメソッドよりは速度の面で劣りますが、
生成したテーブルを保持しませんので、メモリ消費は抑えられる
そのため、巨大なテーブルを扱うときに適している
ただし、テーブルを保持していないため、絞り込みや並べ替えなどができない
例.
def index
  @items = Item.preload(:saler)
end
生成されるクエリ
Item Load (1.0ms)  SELECT "items".* FROM "items"
Saler Load (0.0ms)  SELECT "salers".* FROM "salers" WHERE "salers"."id" IN (?, ?, ?, ?, ?)  [["id", 1], ["id", 2], ["id", 3], ["id", 4], ["id", 5]]

# ユースケース
N対Nのアソシエーションの場合はpreload (1対Nでもpreloadが基本線？byマネフォブログ)
データ量が増えるほど、eager_loadよりも、preloadの方がSQLを分割して取得するため、
レスポンスタイムは早くなるので、preloadをオススメします。
できないこと ： アソシエーション先のデータ参照（Whereによる絞り込みなど）
注意 ： データ量が大きいと、IN句が大きくなりがちで、メモリを圧迫する可能性がある


### eager_load
データベースへのアクセスが1回だけ
（むしろ遅く感じる場合もあります）かもしれませんが、この処理回数の違いは、
データの数が大きくなると大きな違いになってくる
また、関連テーブルも結合して生成したテーブルを保持していますので、
絞り込みなども高速に行うことができる
しかし、その分メモリを多く消費しますので、データ量やアクセスするユーザーの数が増えると、
システムへの負担が大きくなる
例.
def index
  @items = Item.eager_load(:saler)
end
生成されるクエリ
SQL (0.0ms)  SELECT "items"."id" AS t0_r0, "items"."saler_id" AS t0_r1, "items"."title" AS t0_r2, "items"."price" AS t0_r3, "items"."created_at" AS t0_r4, "items"."updated_at" AS t0_r5, "salers"."id" AS t1_r0, "salers"."name" AS t1_r1, "salers"."created_at" AS t1_r2, "salers"."updated_at" AS t1_r3 FROM "items" LEFT OUTER JOIN "salers" ON "salers"."id" = "items"."saler_id"

・何もない時
Board Load (1.2ms)  SELECT  `boards`.* FROM `boards` LIMIT 10 OFFSET 0
CampusName Load (1.3ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1
User Load (1.8ms)  SELECT  `users`.* FROM `users` WHERE `users`.`deleted_at` = '0000-01-01 00:00:00' AND `users`.`id` = 23 ORDER BY `users`.`id` ASC LIMIT 1
CACHE CampusName Load (0.0ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.1ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.0ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.1ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.0ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.0ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (5.9ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.1ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]
CACHE CampusName Load (0.0ms)  SELECT  `campus_names`.* FROM `campus_names` WHERE `campus_names`.`id` = 1 LIMIT 1  [["id", 1], ["LIMIT", 1]]

# ユースケース
1対1あるいはN対1のアソシエーションをJOINする場合（belongs_to, has_one アソシエーション）
JOINした先のテーブルの情報を参照したい場合（Whereによる絞り込みなど）
--------------生の SQL を利用--------------
## find_by_sql
# Modelインスタンスの一覧を配列として返す
(Modelにある属性値しか返さない)
Model.find_by_sql('SQL文')



------------バリデーション(ActiveRecord)-------------
Active Recordを使って、モデルがデータベースに書き込まれる前にモデルの状態をバリデーション（検証: validation）できる。
Active Recordにはモデルチェック用のさまざまなメソッドが用意されている。

The before_save occurs slightly before the before_create. 
To the best of my knowledge, nothing happens between them; 
but before_save will also fire on Update operations, 
while before_create will only fire on Creates.

boolean型のバリデーション
validates :public_status, inclusion: { in: [true, false] }
validates :public_status, exclusion: { in: [nil] }
-------------マイグレーション(ActiveRecord)----------------
Active Recordの機能の1つであり、データベーススキーマを長期にわたって
安定して発展・増築し続けることができるようにするための仕組み
マイグレーション機能のおかげで、Rubyで作成されたマイグレーション用のDSL (ドメイン固有言語) を用いて、
テーブルの変更を簡単に記述できます。スキーマを変更するためにSQLを直に書いて実行する必要がありません。
-------マイグレーションの作成-------
マイグレーション状況の確認コマンド
rails db:migrate:status

どこまでmigrateが実行されているかの確認コマンド
rails db:version

migrateされていないファイルの確認コマンド
rails db:abort_if_pending_migrations

テーブル名の変更コマンド
rename_table :テーブル名(昔,複数形), :テーブル名(新,複数形)

テーブルの削除コマンド(不可逆)
rails g migration Dropテーブル名
rails g migration DropUser
drop_table :users を明記する必要あり

カラム追加コマンド
rails g migration add_カラム名_to_テーブル名 カラム:型
(スネークケース)
rails g migration add_email_to_users mail:string
*スネーク・キャメルケースどちらでも良い

カラム複数追加コマンド
rails g migration AddDetailToUsers mail:string age:integer

カラム名の変更コマンド
rails g migration rename_カラム名(前)_to_カラム名(後)_テーブル名
rails g migration rename_name_to_user_id_wantlists

カラム"情報"の変更コマンド(不可逆)
rails g migration ChangeColumnToテーブル名
change_column :テーブル名, :カラム名, :型, null: true
def up
  change_column :users, :name, :string
end
def down
  change_column :users, :name, :text
end

カラム"削除"の場合
def up
  remove_column :users, :name
end

def down
  add_column :users, :name, :string
end


マイグレーションの実行コマンド
1. マイグレーションファイルから schema.rb を作成
2. schema.rb からテーブルを作成
rails db:migrate

1. schema.rb からテーブルを作成
db:schema:load	

特定のマイグレーションをupまたはdown方向に実行する必要がある場合は、db:migrate:upまたはdb:migrate:downタスクを使います。
以下に示したように、適切なバージョン番号を指定するだけで、該当するマイグレーションに含まれるchange、up、downメソッドのいずれかが呼び出されます。

VERSION指定してマイグレートするコマンド
rails db:migrate:up VERSION=20080906120000
バージョン番号が20080906120000のマイグレーションに含まれるchangeメソッド (またはupメソッド) が実行されます。このコマンドは、最初にそのマイグレーションが実行済みであるかどうかをチェックし、Active Recordによって実行済みであると認定された場合は何も行いません

VERSION指定してロールバックするコマンド
rails db:migrate:down VERSION=20181019135434
そのバージョンのマイグレーションのみがdown
drop_tableやchange_columnをしてしまうとchangeメソッドでは
rollbackできない

直前のマイグレーションにロールバックするコマンド
rails db:rollback
change_column, drop_table等はロールバックできない
(型も変更させるため)

マイグレーションを複数ロールバックする時は、STEPパラメータを指定
最後に行った3つ目のマイグレーションまでロールバックするコマンド
rails db:rollback STEP=3

あるカラムを削除・変更するような不可逆なマイグレーションの場合は、changeメソッドの代わりに、upとdownのメソッドを別々に定義する必要がある

カラム削除コマンド
rails g migration remove_カラム名_to_テーブル名 カラム:型
(キャメルケース)
rails g migration RemoveEmailFromUsers email:string
※ スネークケース・キャメルケースどちらでもよい

マイグレーションファイルはdownしてから削除する！！
upした状態で削除してしまった場合は同じバージョンのダミーファイルを作成して、downしてからファイルを削除！！

マイグレーションファイルの削除
rails destroy migration AddColumnTitles

全てのテーブルを dropし"db/migrate/"以下の全ての migration を実行してテーブルを再作成を行う
マイグレーションファイルを直接利用する。つまり、変更が反映される
マイグレーションに関わらず全てのデータを削除してから、マイグレート＆シードが反映される
rails db:migrate:reset

全てのテーブルを dropし、"db/schema.rb"を元にテーブルの再作成を行う
マイグレーションファイルを編集しても、その内容は反映されない。スキーマファイル ( db/schema.rb =既存のデータスキーム) を利用
rails db:reset

全てのテーブルを dropする(db:seed は実行されない)
rails db:migrate:reset

# エラー
Migrations are pending. To resolve this issue, run: bin/rails db:migrate RAILS_ENV=development
->マイグレーションファイルを削除する！

Can't DROP 'blog_id'; check that column/key exists
->おそらく外部キーを参照しているデータが残っている？
->rails db:resetした後にmigrateすると解決
-------マイグレーションの自作-------
up, downメソッド(changeの代わり)は
drop_tableやchange_columnに必要！
=>書き換えること！！
-----リレーション-----
1対多の関係
# memo.rb
belongs_to :category
すべてのメモはカテゴリーに所属

# category.rb
has_many :memos
カテゴリーテーブルは複数のメモを所有

CRUD処理
Create処理(データの追加)
  User.create(name:"A", age:21)
  user = User.new(name:"A", age:21)
  user.save
Read処理(データの読み込み)
  User.all
  User.find(2)
  User.find_by(name:"A")
  #条件にあったレコード全てを取得します。
  User.where(age:29)
  # AND検索
  User.where(name: "hoge").where(id: 1)
  # AND検索:
  users = Board.where(name:"nick", name:"nate")
  # OR検索:
  users = Board.where(name:"nick").or(Board.where(name:"nate"))
Update処理(データの更新)
  user = User.find(1) -> user.age = 22 -> user.save

  self.update_attribute(:activated, true)
  self.update_attribute(:activated_at, Time.zone.now)
  # 書き換え
  update_columns(activated: true, activated_at: Time.zone.now)

#destroyは配列を処理できない
Delete処理(データの削除)
  user = User.find(1) -> user.destroy
  OR検索:該当データが複数ある場合はorを使う Rails5の場合
  users = Board.where(name:"nick").or(Board.where(name:"nate"))
  users.destroy_all
  Post.destroy_by(name: 'David') Rails6の機能
  # 全てのデータを削除
  User.destroy_all

Memo.all

# select_boxの保存
Board.create(
  deadline: join_Date("deadline"),
)
def join_Date(select)
  Date.new(params["#{select}(1i)"].to_i,params["#{select}(2i)"].to_i,params["#{select}(3i)"].to_i)
end

-------------テスト------------------------
"rails test" の引数にテストファイルを与えると、
そのテストファイルだけを実行することができる
seed等で入れているデータがない状態で
全てのfixtureのデータが入れられる！！
↑つまづいた

rails test test/integration/users_login_test.rb
=> users_login_test.rb のテストだけ実行
rails test
=> 全テストを実行

assert メソッドは、第1引数がtrue である場合に、テストが成功したものとみなす。

viewが
assert_template

# postによってアカウントが一つ増えたかどうかのチェック
# 'User.count'はevalみたいな感じ？
assert_difference 'User.count', 1 do
  post users_path,params: { user: { name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
end

create/update/deleteの実行前後でデータのcountが正しく変化しているか
countが1つ減っていることを確認したい場合を例に取ります。

assert_difference('Hoge.count', -1) do
  delete :destroy, id: @hoge
end
countが変化していないことを確認したい場合はassert_no_differenceが使えます

assert_select "input[name=email][type=hidden][value=?]", user.email
inputタグに正しい名前、type="hidden"、メールアドレスがあるかどうかを確認します。
<input id="email" name="email" type="hidden" value="michael@example.com" />
-----------view(template)----------------

---------------メソッド-----------------
Methodオブジェクトのsource_locationを使えば、
メソッドが定義されている場所と行数が得られる
pry(main)> @photo.method(:image).source_location
# => ["/usr/local/bundle/gems/shrine-3.3.0/lib/shrine/plugins/entity.rb", 39]

**クラスメソッド (記法は２通りある！)
クラスメソッドは１つのインスタンス固有のメソッド
特定のインスタンスに特別な性質を持たせたい場面に使用
1. def self.method_name (特異メソッド形式)
=> 定義するクラス自身の中に書く場合はこのように self. と書くことが多い
=> クラスの外の時は def オブジェクト名.メソッド名
↓例 #特異メソッドによるクラスメソッドの定義例
hoge = "Ruby"
class << hoge
  def hello
    "Hello, #{self}"
  end
end
p hoge.hello
#=> "Hello, Ruby"

2. class << self (特異クラス形式)
=> 特異メソッド方式では複数のクラスメソッドをまとめて定義したい場合に
都度の self. を書くのが面倒なため、
そのようなときは(特異クラス方式)がとられることが多い
↓例 #特異クラスによるクラスメソッドの定義例
class Foo
  class << self     
    def a_class_method
      # self.a_class_methodとしても書けるが二度手間！
    end

    def another_class_method
      # 二つ定義しても self つけなくていいから便利！
    end
  end
end

*includeメソッド
クラスにモジュールを取り込む時に使用
インスタンスメソッドとして取り込む
(クラスメソッドとしては使えない！！)
module Behave
  def eat
      puts "もぐもぐ"
  end
end

class Human
  include Behave
end

Human.new.eat #=> "もぐもぐ"
Human.eat # エラー！(undefined method)

*extendメソッド
モジュールで定義された全てのメソッドを特異メソッドとして
オブジェクトに追加する機能がある
クラス内で取り込まれた場合は、モジュールのメソッドは
そのクラスのクラスメソッドとして機能する
module Behave
  def eat
      puts "もぐもぐ"
  end
end

class Human
  extend Behave
end

Human.eat #=> "もぐもぐ"
Human.new.eat # エラー！(undefined method)

---------------Class-クラス------------------
クラス変数一覧の取得
クラス変数はクラスオブジェクトから取得
[6] pry(main)> Sample.class_variables
=> [:@@val2]
[7] pry(main)> sample.class.class_variables
=> [:@@val2]

クラス定数 ::演算子
・クラスの持っている定数は「::」を使ってクラス名を経由すればクラスの外部からも参照可能
・クラスやモジュールのネスト

MyClass::CONST_VALUE (MyClass: クラス名 CONST_VALUE: 定数名)
class Router
  LOCALHOST_IP = "127.0.0.1"
end
p Router::LOCALHOST_IP  #=> "127.0.0.1"

モジュール内で定義した定数は、モジュール名を経由して呼び出すことが可能
module Mod
  Version = "2.3.0"
end
Mod::Version #=> "2.3.0"

名前空間の提供(クラスをモジュールのスコープ内に入れること？)
ruby gemなどでは、クラス名やメソッド名の重複による使用者からの
モンキーパッチを防ぐためにgemの中身を全て1つのモジュールで梱包することが多い
module Name
  class Hoge
    def self.hello
      puts 'hello'
    end
  end
end

Name::Hoge.hello #=> "hello"
**特異クラス

attr_reader :name #-> @nameが参照できる
def name # nameメソッドを等価
  @name
end
# p user.name で参照可能

attr_writer :name #-> @nameを変更できる
def name=(name)
  @name = name
end
# user.name = "Mr.Hoge" # @nameが変更可能

attr_accessor :name # 参照・変更が可能
# user.name = "Mr.Hoge"
# p user.name
#=> "Mr.Hoge"

# User.new("Sample", "sample@example.com") でインスタンス作成
class User
  def initialize(name, email)
    self.name = name  # @name = name と同じ
    self.email = email  # @email = email と同じ
  end
end

**self変数

selfはクラス内部で書かれる場合、そのクラスのインスタンス変数の参照に利用される

Photo.ancestors
クラスの祖先クラスを出力
---------------Instance-インスタンス-------------
インスタンスメソッド一覧を取得
メソッドの情報は、インスタンスオブジェクトではなく、クラスオブジェクトが情報を持っているので、
こちらから呼び出す。
[9] pry(main)> User.instance_methods(false)
=> [:show]

-------------require--------
require 使いたいライブラリのファイル名
使いたいライブラリのファイル名の.rbは省略可能
予め決められたディレクトリを基準にしてライブラリを探す

----------------helper------------------
Viewをよりシンプルに書くためのもの
ある動作を処理する場合にメソッド化して扱えるように
Railsにあらかじめ組み込まれた機能
app/helpers内に各モジュールが存在し、
処理を追加できる
moduleなのでincludeして使う必要があるが、
rails5のデフォルトは、全てincludeする

----------------form_for------------
モデルがある時に使用する!!

form_for(@user)
-> フォームのactionは/usersというURLへのPOST

form_for(:session, url:login_path)
->セッションの場合はリソースの名前とそれに対応するURLを具体的に指定する必要がある
paramsハッシュでは、sessionキーの下にemailなどが自動的に入る
{ session: { password: "foobar", email: "user@example.com" } }
----------------form_tag-------------
関連するモデルがない時に使用する!!
form_tag('/users, method: :post')
->-> フォームのactionは/usersというURLへのPOST

form_tag(sessions_path, method: "POST")
<%= text_field_tag 'session[email]' %>
-> form_forと異なり、paramsハッシュにおいてsessionキーの下にemailを入れる必要がある！！
----------------form_with------------

関連するモデルがない場合の form_with
<%= form_with url: users_path do |f| %>
  <%= f.text_field :email %>
  <%= f.submit %>
<% end %>
->スコープはparams[:email]になる

関連するモデルがある場合の form_with
<%= form_with model: @user do |f| %>
  <%= f.text_field :email %>
  <%= f.submit %>
<% end %>
->スコープはparams[:user][:email]になる

# モデルから選択させるセレクトボックス
<div class="form-group">
  <%= f.label :faculty_id, "Faculty" %>
  <%= f.select :faculty_id, Faculty.all.map { |faculty| [faculty.name, faculty.id] }, selected: @user.faculty_id %>
</div>

#URLとinputフィールド名にスコープをプレフィックスとして追加する場合する場合
# scope: :postでcontroller内にてparams[:post]で取り出せるようになる
# modelに基づいかないログインなどで利用する際など？
# form_withのデフォルトはremote: true
# ⇒ajax通信をおこなうため、renderで画面遷移しなくなる(local: tureにする！)
<%= form_with scope: :post,local: true,  url: posts_path do |form| %>
  <%= form.text_field :title %>
<% end %>

<%# ↓生成されるタグ %>
<form action="/posts" method="post" data-remote="true">
  <input type="text" name="post[title]">
</form>

# 例
<% # scope: :sessionでcontroller内にてparams[:session]で取り出せるようになる %>
<%= form_with scope: :session, local: true do |f| %>
<div class="form-group">
  <%= f.label :email, "E-mail" %>
  <%= f.email_field :email, class:"form-control" %>
</div>

<div class="form-group">
  <%= f.label :password, "Password" %>
  <%= link_to "(forgot password)", new_password_rest_path %>
  <%= f.password_field :password, class:"form-control" %>
</div>

<%= f.submit "ログイン", class:"btn btn-primary" %>

<p>New user?<%= link_to "新規登録", new_user_path %></p>
<% end %>

form_withで渡すインスタンスがある場合(もしくはそれらのヘルパーを使っている場合)は、f.hidden_fieldを使う。 1個だけパラメータを単体で渡したい時は、hidden_field_tagを使う
hidden_field_tag :email, @user.email
f.hidden_field :email, @user.email
前者 (hidden_field_tag) ではメールアドレスがparams[:email]に保存されますが、後者(hidden_field)ではparams[:user][:email] に保存されてしまう

# パス(URLでもOK),methodオプション,属性を指定
<%= link_to “削除”, member_path(params[:id]), method: :delete %>
# 第2引数で指定したパスが現在のぺージだったら、リンクの代わりにテキストだけ表示する
# TOPページ(root_path)にいるとすれば、「TOP」というリンクはクリックできないようにする
<%= link_to_unless_current “TOP”, root_path %>


# 部分テンプレート
* エラー
render の後のファイルパスはダブルクウォンテーションで囲まないとエラーが発生??
コメントアウトする場合は <% #hoge %> で イコール を付けない

1. シンプルなURLの時
①ファイル名を_から始める。
②共通する部分のみを記述。
* _form.html.erb
<%= form_with model: blog do |form| %>
  <%= form.text_field :content %>
  <%= form.submit %>
<% end %>

form_withが自動的にcreateアクションかupdateアクションへ振り分ける
* new.html.erb と edit.html.erb
(どれでも挙動同じ)
<%= render partial: "form", locals: { blog: @blog } %>
<%= render "form", blog: @blog %>
<%= render "form" %>

2. ネストされたresourcesの時
* _form.html.erb
<%= form_with model: model do |form| %>
  <%= form.text_field :content %>
  <%= form.submit %>
<% end %>

* new.html.erb と edit.html.erb
<%= render "form", locals: { model: [@company, @blog] } %>
参考URL
https://stackoverflow.com/questions/55596186/use-a-single-form-with-to-create-and-edit-nested-resources-in-rails

相対パスの基準はpartialのディレクトリではなく、呼出元の render があるディレクトリに依存する
=> view/からの相対パスで書くのが安全

# newとeditのフォームを統一化した時
<% # newとedit画面でsubmitボタンの表示を切り替える(path_infoでURLによって条件分岐で切り替える) %>
<% if request.path_info == new_company_blog_path %>
  <%= f.submit "作成", class: 'signup-submit' %>
<% else %>
  <%= f.submit "更新", class: 'signup-submit' %>
<% end %>


------------管理者権限----------
admin?
管理者権限があるか判定


----------------ログイン--------------
ユーザーは、編集フォームからPATCHリクエストをupdateアクションに対して送信し、情報を更新する
Strong Parametersを使うことで、安全にWeb上から更新させることができる
beforeフィルターを使うと、特定のアクションが実行される直前にメソッドを呼び出すことができる
beforeフィルターを使って、認可 (アクセス制御) を実現した
認可に対するテストでは、特定のHTTPリクエストを直接送信する低級なテストと、ブラウザの操作をシミュレーションする高級なテスト (統合テスト) の2つを利用した


**フレンドリーフォワーディング:
ログイン成功時に元々行きたかったページに転送させる機能 (ログアウト時は基本リダイレクトしない？)
転送先のURLを保存する仕組みは、ユーザーをログインさせたときと同じで、session変数を使う
requestオブジェクトも使用 (request.original_urlでリクエスト先を取得)

app/helpers/sessions_helper.rb (Railsチュートリアルでの例)
module SessionsHelper
...
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  # アクセスしようとしたURLを覚えておく
  # リクエストが送られたURLをsession変数の:forwarding_urlキーに格納
  # (ただし、GETリクエストが送られたときだけ格納)
  # ->ログインしていないユーザーがフォームを使って送信した場合(cookieの手動削除など)、
  # 転送先のURLを保存させないようにできる
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end

ユーザー一覧ページでは、すべてのユーザーをページ毎に分割して表示する
rails db:seedコマンドは、db/seeds.rbにあるサンプルデータをデータベースに流し込む
render @usersを実行すると、自動的に_user.html.erbパーシャルを参照し、各ユーザーをコレクションとして表示する
boolean型のadmin属性をUserモデルに追加すると、admin?という論理オブジェクトを返すメソッドが自動的に追加される
管理者が削除リンクをクリックすると、DELETEリクエストがdestroyアクションに向けて送信され、該当するユーザーが削除される
fixtureファイル内で埋め込みRubyを使うと、多量のテストユーザーを作成することができる

----------------セッション-----------
Sessionsコントローラの生成
$ rails g controller Sessions new

ユーザーログインの必要なWebアプリケーションでは、セッション (Session) と
呼ばれる半永続的な接続をコンピュータ間 (ユーザーのパソコンのWebブラウザとRailsサーバーなど) に
別途設定します。
Railsでセッションを実装する方法として最も一般的なのは、
cookiesを使う方法です。
cookiesとは、ユーザーのブラウザに保存される小さなテキストデータです。
cookiesは、あるページから別のページに移動した時にも破棄されないので、
ここにユーザーIDなどの情報を保存できます。アプリケーションはcookies内のデータを使って、
例えばログイン中のユーザーが所有する情報をデータベースから取り出すことができます。
本節および8.2では、その名もsessionというRailsのメソッドを使って一時セッションを作成します。
この一時セッションは、ブラウザを閉じると自動的に終了します

ログインページではnewで新しいセッションを出力し、
そのページでログインするとcreateでセッションを実際に作成して保存し、
ログアウトするとdestroyでセッションを破棄する、といった具合です。
ただしUsersリソースと異なるのは、UsersリソースではバックエンドでUserモデルを介して
データベース上の永続的データにアクセスするのに対し、
Sessionリソースでは代わりにcookiesを保存場所として使う点です。

Sessionsコントローラを生成する
$ rails g controller Sessions new

リソースを追加して標準的なRESTfulアクションをgetできるようにする
config/routes.rb
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

ログインフォーム
  # ~/views/sessions/new.html.erbにて
  <%= form_with scope: :session, local: true do |f| %>

    <div class="form-group">
      <%= f.label :email, "E-mail" %>
      <%= f.email_field :email, class: "form-control" %>
    </div>

    <div class="form-group">
      <%= f.label :password, "Password" %>
      <%= f.password_field :password, class:"form-control" %>
    </div>

    <%= f.submit "ログイン", class:"btn btn-primary" %>

    <p>New user? <%= link_to "新規登録", new_user_path %></p>

  <% end %>

ログインフォームによって送られるparamsハッシュ
  session:
    email: 'user@example.com'
    password: 'foobar'
    commit: Log in
    action: create
    controller: sessions


# ~/app/controllers/sessions_controller.rbにて
class SessionsController < ApplicationController

  def new
  end

  def create #ログインするためのメソッド
    # 送られてきたparams[:session][:email]を小文字にしてUserモデルからユーザーを検索・代入
    user = User.find_by(email: params[:session][:email].downcase)
    # ユーザーが存在してハッシュ化されたパスワードと適合しなかった時
    # authenticateはUserクラスにhas_secure_passwordメソッドを加えると使用できる
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      # エラーメッセージを作成する
      # そもそもユーザー名が異なっていた時など
      # flash.nowのメッセージはその後リクエストが発生したときに消滅
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end

end

セッションを実装するには、様々なコントローラやビューで
おびただしい数のメソッドを定義する必要があるが、
Sessionsコントローラ (8.1.1) を生成した時点で既に
セッション用ヘルパーモジュールも (密かに) 自動生成されています。
さらに、Railsのセッション用ヘルパーはビューにも自動的に
読み込まれる。
Railsの全コントローラの親クラスであるApplicationコントローラに
このモジュールを読み込ませれば、どのコントローラでも
使えるようになります。

---------rails g コマンド 一覧---------
rails generate scaffold
モデル名を指定することによりRails のMVC モデルに則った各種ファイルを生成
rails g scaffold user name:string age:integer
*生成されるもの
・マイグレーションファイル
db/migrate/20160310025746_create_users.rb
・Userモデルのファイル
app/models/user.rb
・Userコントローラー(アクションも)
app/controllers/users_controller.rb
index,show,new,edit,create,update,destroyの7つのアクションが自動的に定義
ルーティングの設定ファイルも自動変更される
・ルーティング
config/routes.rb内に
resources :usersが記述される
・ビュー
コントローラーで定義されたアクションに対応するビューファイルが全て作成

rails g scaffold_controller
scaffoldの実行で出力されるコントローラとビューと、それらに関わる部分を切り出した感じで生成
モデルやアセットは作られません。モデルだけ先に作った場合、地味に便利です。

rails g controller
コントローラを生成
scaffold_controller との違いは
RESTful な設計を特に考えない土台を作っているというところ
ビューに関してはディレクトリは作成されます

rails g helper
ヘルパーを生成します。合わせてテストも生成します。こちらも複数形にはなりません。

rails g integration_test
インテグレーションテスト（総合テスト）のファイルを生成します。このファイルは他のgenerate コマンドでは作られません。

rails g mailer
メーラーを生成します。こちらもintegration_test と同じで、このgenerate コマンドでしか作られません。

-------credential-------
gitなどに挙げられない情報を入れるファイル
viを利用してcredentials.yml.encを編集する場合は、
環境変数：EDITORにviを指定してrails credentials:editコマンドを実行
EDITOR="vi" bin/rails credentials:edit
credentials.yml.encに設定した情報を取り出すにはRails.application.credentials.xxxを指定
#credentials.yml.enc
aws:
  access_key_id: 123
=>Rails.application.credentials.aws[:access_key_id]で設定

credentials.yml.encはmaster keyを利用して暗号化・復号されるため、
masterのみGithubに上げなければ良い！！

# コンテナ内では、EDITOR="vim"の部分は環境変数の指定なので-eオプションを使用
docker-compose run -e EDITOR="vi" web rails credentials:edit

config/master.key
cee513823adb2cda09b6c08b2b5508..
/config/master.keyが共有できない環境ではmaster keyを環境変数：RAILS_MASTER_KEYで指定
本番環境ではmaster keyの指定漏れを防ぐためにconfig/environments/production.rbで
config.require_master_key = trueを有効化することが推奨されてる

secret.yml、secret.yml.enc、ENV[‘SECRET_KEY_BASE’]の3つのファイルを一元化
本番環境のみで使用する想定なので、環境毎に値を設定する必要がない
---------vi-----------
# 終了キー
：q	セーブせずに終了
：q!	変更した行もセーブせずに終了
：w	セーブするが終了しない。
：wq	セーブして終了

# 編集モードへ移るためのキー
i	現在のカーソル位置から挿入。
R	現在のカーソル位置から置換。
A	現在行の末尾に追加
O	現在行の前に行挿入
o	現在行の次に行挿入

----------------url------------
** redirect_to と render の違い
redirect_to…ルーティングを通り、新たにviewページを呼び出す。
render…ルーティングを通らず、viewページに直接飛ぶ
なので失敗時のviewの読み込み（以下の部分）をredirect_toにすると、
新しいビューページが呼ばれてしまうため、
error_messagesテンプレートに書いたif文が反応しない

* _path
・相対パス
・redirect_to以外で使用する。
・link_toでよく使用されるイメージ

* _url
・絶対パス
・redirect_toの時にセットで使用する(HTTPの仕様上、リダイレクトのときに完全なURLが求められる)

* link_to
*=> link_to 'リンクをつける文字列', 'URL', (option, methodなど)

# ブロック使う場合(リンクを設置する文字列を置くとエラー:そもそもブロック内で設定しているので必要ない)
<%= link_to edit_company_blog_path(blog.company_id, blog.id) do %>
  <i class="fas fa-edit"></i>
  <span style="display:none">編集</span>
<% end %>

# パスを指定しないとそのページのパスが作成される！
例.
<%= link_to %>
<a href="/companies/50/blogs><a>


# 複数のidを渡す(resources をネストしている場合)
resources :companies do
  resources :blogs, controller: 'companies/blogs'
end
#=> /companies/:company_id/blogs/:id/edit

<%= link_to edit_company_blog_path(blog.company_id, blog.id) %>
#=> URIパターンに登場するものを左から（親のidから）順に書き

redirect_to @user
以下と挙動が一緒っぽい
redirect_to "http://localhost:3000/users/#{@user.id}" # 条件付き(後述)
redirect_to user_url(id: @user.to_param)
redirect_to user_url(id: @user.id)


flashメッセージはアクションが実行された時、
次のアクションが実行されるまで保存され表示される
そして次にアクションが実行される時に削除される仕組みになっている

render時
flash.nowを使う

redirect時
flashを使う


urlの指定方法
url: "pw_update"と指定すると
直前のurlにpw_updateを足したurlが生成
url: "/pw_update"と指定すると
http://localhost:3000/pw_updateが生成

redirect_toの引数メモ
# URLへリダイレクト(アクションはconfig/routes.rbを参照)
redirect_to URL
# indexアクションへリダイレクト
redirect_to action: 'index'
# usersコントローラのindexアクションへリダイレクト
redirect_to controller: 'users', action: 'index'
# usersコントローラーのshowアクションのid=8へリダイレクト
redirect_to controller: 'users', action: 'show', id: 8
# 前ページへリダイレクト
redirect_to :back
# indexアクションへstatusコード404でリダイレクト
redirect_to action: 'index', status: 404
# indexアクションへstatusコード200でリダイレクト(シンボル使用)
redirect_to action: 'index', status: :ok
# indexアクションへオプション(エラーメッセージ)付きでリダイレクト
redirect_to action: 'index', alert: 'ERROR!!'
# indexアクションへオプション(通知用メッセージ)付きでリダイレクト
redirect_to ({:action => 'index'}), :notice => 'message'
# indexアクションへオプション(一時的なメッセージ)付きでリダイレクト
redirect_to action: 'index', flash: {success: 'Yes!! Success'}

# サイト内で使う？(相対パス)
root_path => '/' ※ルート以下の文字列を返す
help_path => '/help'
# メールでurlを送る時などで使う(絶対パス)
root_url  => 'http://www.example.com/'　※完全なURLの文字列を返す
help_url  => 'http://www.example.com/help'

# URLにトークンとメールアドレスを組み込んでいる
edit_account_activation_url(@user.activation_token, email: @user.email)
↓
# 名前付きルートでクエリパラメータを定義すると、Railsが特殊な文字を自動的にエスケープしてくれます(@->%40)。コントローラでparams[:email]からメールアドレスを取り出すときには、自動的にエスケープを解除してくれる
account_activations/q5lt38hQDc_959PVoo6b7A/edit?email=foo%40example.com

# アクションを実行した結果、インスタンス変数に代入されたオブジェクトを取得
assigns(:user)
# その属性を反転する(true -> false)
toggle!(:activated)

------Mailer----------
rails g mailer UserMailer account_activation password_reset
今回必要となるaccount_activationメソッドと、第12章で必要となるpassword_resetメソッドが生成
生成したメイラーごとに、ビューのテンプレートが2つずつ生成
1つはテキストメール用、1つはHTMLメール用のテンプレートです。
edit_account_activation_url(@user.activation_token, ...)
http://www.example.com/account_activations/q5lt38hQDc_959PVoo6b7A/edit
URLにメールアドレスもうまく組み込みましょう。
クエリパラメータとは、URLの末尾で疑問符「?」に続けてキーと値のペアを記述したもの

account_activations/q5lt38hQDc_959PVoo6b7A/edit?email=foo%40example.com
このとき、メールアドレスの「@」記号がURLでは「%40」となっている
これは「エスケープ」と呼ばれる手法で、通常URLでは扱えない文字を扱えるようにするために変換されている
Railsでクエリパラメータを設定するには、名前付きルートに対して次のようなハッシュを追加します。

edit_account_activation_url(@user.activation_token, email: @user.email)
名前付きルートでクエリパラメータを定義すると、Railsが特殊な文字を自動的にエスケープする。
コントローラでparams[:email]からメールアドレスを取り出すときには、自動的にエスケープを除く。

deliver_nowとdeliver_laterの２種類のメール送信メソッドがある
deliver_nowは、今すぐに送信したい場合に使用
deliver_laterは、非同期で送信したい場合に使用

-----アカウントの有効化-------
Mailer
メイラーはUsersコントローラのcreateアクションで有効化リンクをメール送信するために使う。
メイラーの構成はコントローラのアクションとよく似ており、メールのテンプレートをビューと同じ要領で定義できる。
このテンプレートの中に有効化トークンとメールアドレス (= 有効にするアカウントのアドレス) のリンクを含め使う。

有効化の手順
ユーザーの初期状態は「有効化されていない」(unactivated) にしておく。
ユーザー登録が行われたときに、有効化トークンと、それに対応する有効化ダイジェストを生成する。
有効化ダイジェストはデータベースに保存しておき、有効化トークンはメールアドレスと一緒に、ユーザーに送信する有効化用メールのリンクに仕込んでおく3 。
ユーザーがメールのリンクをクリックしたら、アプリケーションはメールアドレスをキーにしてユーザーを探し、データベース内に保存しておいた有効化ダイジェストと比較することでトークンを認証する。
ユーザーを認証できたら、ユーザーのステータスを「有効化されていない」から「有効化済み」(activated) に変更する。

まとめ
アカウント有効化は Active Recordオブジェクトではないが、セッションの場合と同様に、リソースでモデル化できる
Railsは、メール送信で扱うAction Mailerのアクションとビューを生成することができる
Action MailerではテキストメールとHTMLメールの両方を利用できる
メイラーアクションで定義したインスタンス変数は、他のアクションやビューと同様、メイラーのビューから参照できる
アカウントを有効化させるために、生成したトークンを使って一意のURLを作る
より安全なアカウント有効化のために、ハッシュ化したトークン (ダイジェスト) を使う
メイラーのテストと統合テストは、どちらもUserメイラーの振舞いを確認するのに有用
SendGridを使うと、production環境からメールを送信できる

必要なモデルカラム
activation_deigest:string(メールで送信した有効化トークンのダイジェストした値)
activated:boolean(有効化の有無)
activated_at:datetime(有効化された日時)

メイラーの作成
rails g mailer UserMailer account_activation password_reset
account_activationメソッドと、第12章で必要となるpassword_resetメソッドを生成
生成したメイラーごとに、ビューのテンプレートが2つずつ生成
1つはテキストメール用のテンプレート、1つはHTMLメール用のテンプレート

# アカウント有効化リンクをメール送信する
# app/mailers/user_mailer.rb
def account_activation(user)
  @user = user
  mail to: user.email, subject: "Account activation"
end

edit_account_activation_url(@user.activation_token, email: @user.email)
account_activations/q5lt38hQDc_959PVoo6b7A/edit?email=foo%40example.com
メールアドレスの「@」記号がURLでは「%40」となっている。これは「エスケープ」と呼ばれる手法で、通常URLでは扱えない文字を扱えるようにするために変換される
名前付きルートでクエリパラメータを定義するとRailsが特殊な文字を自動的にエスケープする。コントローラでparams[:email]からメールアドレスを取り出すときには、自動的にエスケープを解除する。

#定義したテンプレートの実際の表示を簡単に確認するために、メールプレビューという裏技を使ってみましょう。Railsでは、特殊なURLにアクセスするとメールのメッセージをその場でプレビューすることができます。メールを実際に送信しなくてもよいので大変便利です。これを利用するには、アプリケーションのdevelopment環境の設定に手を加える必要があります
#development環境のメール設定
#config/environments/development.rb
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :test
host = 'example.com' # ここをコピペすると失敗します。自分の環境に合わせてください。
config.action_mailer.default_url_options = { host: host, protocol: 'https' }
ローカル環境で開発している場合は、次のようになります。
host='localhost:3000'# ローカル環境
config.action_mailer.default_url_options = { host: host, protocol: 'http' }


-------パスワード再設定-------
PasswordResetsリソースを作成して、再設定用のトークンとそれに対応するダイジェストを保存するのが今回の目的
1.ユーザーがパスワードの再設定をリクエストすると、ユーザーが送信したメールアドレスをキーにしてデータベースからユーザーを見つける
2.該当のメールアドレスがデータベースにある場合は、再設定用トークンとそれに対応する再設定ダイジェストを生成
3.再設定用ダイジェストはデータベースに保存しておき、再設定用トークンはメールアドレスと一緒に、ユーザーに送信する有効化用メールのリンクに仕込む
4.ユーザーがメールのリンクをクリックしたら、メールアドレスをキーとしてユーザーを探し、データベース内に保存しておいた再設定用ダイジェストと比較 (トークンを認証)
5.認証に成功したら、パスワード変更用のフォームをユーザーに表示

パスワードを再設定するフォームが必要なので、ビューを描画するためのnewアクションとeditアクションが必要になります。また、それぞれのアクションに対応する作成用/更新用のアクションも最終的なRESTfulなルーティングには必要になります

今回はビューも扱うので、newアクションとeditアクションも一緒に生成している
rails g controller PasswordResets new edit --no-test-framework

トークン用の仮想的な属性とそれに対応するダイジェストを用意
トークンをハッシュ化せずに (つまり平文で) データベースに保存してしまうとすると、攻撃者によってデータベースからトークンを読み出されたとき、セキュリティ上の問題が生じます
パスワードの再設定では必ずダイジェストを使うように
セキュリティ上の注意点はもう１つ
再設定用のリンクはなるべく短時間 (数時間以内) で期限切れになるようにしなければなりません。そのために、再設定メールの送信時刻も記録する必要がある
以上の背景に基づいて、reset_digest属性とreset_sent_at属性をUserモデルに追加
reset_digest :string
reset_sent_at :datetime

ユーザーにパスワードリセットメールを送ってから、新しいパスワードを送るフォームにおいてメールアドレスが必要！
メールアドレスをキーとしてユーザーを検索するためには、editアクション(パスワード変更画面)とupdateアクション(パスワード変更のための)の両方でメールアドレスが必要になる

Railsチュートリアル 12章まとめ
パスワードの再設定は Active Recfordオブジェクトではないが、セッションやアカウント有効化の場合と同様に、リソースでモデル化できる
Railsは、メール送信で扱うAction Mailerのアクションとビューを生成することができる
Action MailerではテキストメールとHTMLメールの両方を利用できる
メイラーアクションで定義したインスタンス変数は、他のアクションやビューと同様、メイラーのビューから参照できる
パスワードを再設定させるために、生成したトークンを使って一意のURLを作る
より安全なパスワード再設定のために、ハッシュ化したトークン (ダイジェスト) を使う
メイラーのテストと統合テストは、どちらもUserメイラーの振舞いを確認するのに有用
SendGridを使うとproduction環境からメールを送信できる

HTTPリクエスト	URL	Action	名前付きルート
GET	/password_resets/new	new	new_password_reset_path
POST	/password_resets	create	password_resets_path
GET	/password_resets/<token>/edit	edit	edit_password_reset_url(token)
例：
=>http://localhost:3000/password_resets/7Y3BsYqpvNW-FES-Qhv6bA/edit?emai=admin_example%40rails.org

PATCH	/password_resets/<token>	update	password_reset_url(token)

--------------テスト--------------
モデルのテスト
検証やデータの制御、 複雑なロジックの挙動などを個別のテストケースとして記述
小さい粒度のテストが書けるため、 システムテストなどでは行いにくい、
さまざまな条件下でのわずかな挙動の違いの確認に向いている。
モデルのテストはプロダクトコードよりもテストを
先に書くTDD(テスト駆動開発)に特に適している。

結合テスト
モデルのテストとシステムテストの間を埋めるテスト
UIから確認するほどではなく、モデルや単体テストでは確認しにくいものをテストする。
APIのテストに利用されることが多い。

ルーティング,メーラー,ジョブのテスト
モデルほど頻度は高くないが、複雑なルーティングやほかのテストで置き換えづらい
メーラーやジョプのテストは利用したい場面がある。

その他のテスト(利用する機会少ない)
・ビュー
変化しやすいため、ビューのテストが多いとメンテナンスが大変になりやすい懸念がある
・ヘルパー
よほど凝った処理をヘルパーで書いていなければ使用する場面はあまり多くない

---------------rspec-----------------
動く仕様書(Spec)として要求仕様をドキュメントに記述するような感覚で
記述できるテスティングフレームワーク
Feature Specに代わってSystem Spec(Rails5.1以降に追加)を使う主なメリット
・テスト終了時にDBが自動でロールバックされる
→database_cleaneやdatabase_rewinderといったgemが不要
・テスト失敗時にスクリーンショットを撮影し、ターミナルに表示してくれる
(FeatureSpecではcapybara­ screenshotというgemを利用して
スクリーンショットの撮影をすることができたが、 このgemを別途入れる必要がなくなる)
・driven_byを使って、spec ごとにプラウザを簡単に切り替えられる

# サンプルコード
RSpec.describe User do
  describe '#greet' do
    let(:user) { User.new(params) } 
    let(:params) { { name: 'たろう', age: age } }
     #=> let(:user) { User.new(name: 'たろう', age: age) }にまとめられる
    context '12歳以下の場合' do
      let(:age) { 12 }
      it 'ひらがなで答えること' do
        expect(user.greet).to eq 'ぼくはたろうだよ。'
      end
    end
    context '13歳以上の場合' do
      let(:age) { 13 }
      it '漢字で答えること' do
        expect(user.greet).to eq '僕はたろうです。'
      end
    end
  end
end

こんな順番で呼び出される
1.expect(user.greet).to が呼ばれる => user って何だ？
2.let(:user) { User.new(params) } が呼ばれる => params って何だ？
3.let(:params) { { name: 'たろう', age: age } } が呼ばれる => age って何だ？
4.let(:age) { 12 } （または13） が呼ばれる

結果として expect(User.new(name: 'たろう', age: 12).greet).to を呼んだことになる
これを「before + インスタンス変数」で実現しようとすると結構面倒なことになる
というか、僕はその書き方がぱっと思いつきません。

そんなわけで、 let の遅延評価されるという特徴をうまく活かすと、効率の良いテストコードを書くことができます。

describe [使用を記述する対象(テスト対象)], type: [Specの種類] do

  context [ある状況・状態] do
    before do
      [事前準備]
    end

    it [使用の内容(期待の概要)] do
      [期待する動作]
    end
  end
end

##コード例
describe '~機能 ' , type , , system do
  
  describe '登録' do
  
    context ' 00の場合 ' do
      befoce do
        # (context 内を確認するのに必要な) 事前準備
      end
  
      it '△△する' do
        # 期待する動作
      end
    end

  context 'xxの場合 ' do 
    before do
      # (context 内を確認するのに必要な)事前準備
    end
    
    it '〇〇する' do
      # 期待する動作
    end
  end
end
  
  describe '削除' do
    #略
  eod
end

・describe
通常、一番外側のdescribeには、そのSpecファイル全体の主題を記述する
内部にdescribeをネストすることもよくあり、
階層の深いdescribeにはより細かいテーマを記述
重複・並列可能

・context
テストの内容を「状況・状態」のパリエーションごとに分類
System Specでは、ユーザーの入力内容が正しいか正しくないか、
ログインしているかいないか、ユーザーが管理者か一般ユーザーかといった
各種の条件を記述
重複・並列可能

・before
領域全体の「前提条件」を実現するためのコードを記述する場所
内部のitに書くこともできるが前提条件であればbeforeに書く方が読みやすい
また、同じ条件下で複数のテストケースを実行したい場合には、
beforeに書くことでDRYにする効果がある
beforeの処理は、itが実行されるたびに新たに実行される
次のitが実行されるまでにデータベースの状態は元に戻されるため、
あるテストケースのせいで別のテストケースが影響を受けるということは基本的には起きない

・it
期待する動作を文章と、プロック内のコードで記述
letはitのスコープ内では使えない

Feature Specではdescribeのかわりにfeature、
itの代わりにscenarioと記述することができ、広く利用されている
System Specでも、feature/scenarioを使って記述することもできる

letは「before処理でテストケーススコープの変数に値を代入する」のに近いイメージで利用できる機能
let(:user_a) { FactocyBot.create(:user, name: 'ユーザーA' ,email: 'a@example.com') }
->let(:login_user) { user_a } のようにユーザーAでログインするcontextでは
　letでlogin_userにユーザーAを入れられる


## マッチャ
# eq
(RSpec で等値のエクスペクテーションを書くときは == ではなく eq を使う)

# be_valid

# include

# be_empty

# be_late
RSpec に定義されているマッチャではない
RSpec は賢いので、モデル に late または late? という名前の属性やメソッドが存在し、
それが真偽値を返すようになっていれば
be_late はメソッドや属性の戻り値が true になっていることを 検証してくれる


### controllerテスト(soft deprecated)
# responce
ブラウザに返すべきアプリケーションの全データを保持しているオブジェクト
# be_success
レスポンスステータスが成功(200)かそれ以外(ex. 500)であるかをチェック

describe "GET /index" do
  it "responds successfully" do
    get :index
    expect(response).to be_success 
  end    
end

## 認証が必要なcontroller spec
# コントローラスペックで Devise のテストヘルパーを使用する
(rspec/ails_helper.rb)
config.include Devise::Test::ControllerHelpers, type: :controller

before do
  @user = FactoryBot.create(:user)
end

it "responds successfully" do
  sign_in @user
  get :index
  expect(response).to be_success 
end

# マッチャ
expect(response).to have_http_status "302"

expect(response).to redirect_to "/users/sign_in"

ActiveRecordに値を渡す時は、{ }ブロックで渡すこと
expect {
  get :edit, params: { id: @board.id }
}.to raise_error(ActiveRecord::RecordNotFound)


それが真偽値を返すようになっていれば be_late はメソッドや属性の戻り値が true になっていることを 検証してくれる

## コマンド
$ bin/rails g rspec:controller コントローラー名
------------let--------------
## letが呼び出されるバージョン
let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }

before do  # ログアウト時は使用されないのでlogin_user is undefinedを返してしまう！！
  FactocyBot.create(:task, name: '最初のタスク', user: user_a)  # user_aが作成される(必須！)
  visit login_path
  ----共通化される処理-----
  fill_in 'メールアドレス', with, login_user.email
  fill_in 'バスワード', with, login_user.password
  click_button 'ログインする'

  itブロックでは使用できない
  describeやcontext内でのみ使用可能
  ----------------------
end

** visit は before や it 等の実行するところでしか使用できない

context 'ユーザーAがログインしているとき' do
  let(:login_user) { user_a } # login_userを定義
end

## letが呼び出されれないバージョン
let(:login_user) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') )
before do
  # let(,login_user)の定義を一度も呼び出さずにログインする
  visit login_path
  fill_in 'メールアドレス', with: 'a@example.com'
  fill_in 'パスワード', with: 'password'
  click_button 'ログインする' #=> ユーザーAが作られていないためにログイン失敗する
end

------------let!-------------
# beforeが実行される前にユーザーAを作る
let!(:login_user) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
before do
  visit login_path
  fill_in ' メールアドレス ' , with, 'a@example.com'
  fill_in 'パスワード', with, 'password'
  click_button ' ログインする ' #=> ログインに成功する
end
** 参照しないのであれば let!にせずにbeforeに記述しても良いという考え方もあるが
   let!を使うほうが読みやすくなる場合がある
**「呼び出されるケースと呼び出されないケースがあるが、データは常に作りたい」といった場合にも使える

---------shared_examples---------
itを共通化する方法

↓重複するitを共通化
shared_examples_for 'ユーザーAが作成したタスクが表示される' do
  it {expect(page).to have_content '最初のタスク' }
end
以下のように置き換えられるようになる
it behaves_like 'ユーザーAが作成したタスクが表示される'

---------shared_context----------
contextを共通化する方法

↓重複するcontext(ある状況・状態)を共通化
let(:user) { User.new(name: 'たろう', age: age) }
shared_context '12歳の場合' do
  let(:age) { 12 }
end

------------Capybara----------
操作をシミュレーションできるほか、実際のプラウザと組み合わせてJavaScriptの動作まで含めたテストを行える
人が手作業で確認していたようなプラウザ操作をCapybaraのDSLを使い、 直感的に記述できる
実際のプラウザやHeadlessブラウザを操作することができる

require 'capybaca/rspec' (rails_helper.rbに追加) 
→RSpecでCapyba「aを扱うために必要な機能を読み込む

config.befoce(aeach, type, ,system) do
  driven_by :selenium_chcome_headless
end
→System Specを実行するドライバの設定
 ドライバとは、Capybaraを使ったテスト/Specにおいて、ブラウザ相当の機能を利用するために必要なプログラム

**findメソッド
・find by attributes (find by name)
find('input[type="checkbox"]').click
find('a[href="/dashboard"]').click
find('[name="user_form[age]"]')

・find by name
find('a', name: 'click here').click

・find by element and class
<div class='my-class'>hello</div>
find('div.my-class').text

<div id='book-body'>
  <div class='book-contents vertical'>にほんご</div>
</div>
find('#book-body > book-contents.vertical').text

・find invisible element
find('p.message', visible: false).text
画面に表示されている要素しか検索しないので、 visible: false オプションを付ける

・find the parent of the node
# just one parent node
find('#target_node').find(:xpath, '..')

# recursively parent
el.find(:xpath, '../../../dt')
el.find(:xpath, 'ancestor::dl')

**attachメソッド
<label for='data-file'>Data File</label>
<input type="file" name="files" id="attach_files">

attach_file('data-file', 'path/to/file.csv')
find('form input[type="file"]').set('path/to/file.csv')

-----------FactoryBot-----------
テスト用データの作成をサポートするgem
Railsが標準で用意しているFixture (フィクスチャ)の代替
FixtureはYAML形式でテーブルレコードに対応するデータ内容を定義し、
データペースに直接的に反映する仕組み
シンプルでデータベースの構造に忠実な反面、登録に関する複雑な制御が苦手
→似て非なるデータを大量に定義する必要が生じやすかったり、
 データ間の関係性を適切に作り込むのが大変になりやすい面がある
これに対して FactoryBotでは、DSLを使って似たデータを効率よく定義できる 
Fixtureがテスト時の"データベースの断面"を記述するような感覚であるのに対して、
FactoryBotは"モデルオプジェクトの作り方"を宣言的に記述する感じ

Rails はフィクスチャのデータをデータベースに読み込む際に Active Record を使わない
#=> モデルのバリデーションの ような重要な機能が無視される
#=> もし同じデータを Web フォームやコン ソールから作ろうとすると、失敗することもあるわけです。


Factory Bot は他のモデル と関連を持つモデルを扱うのにとても便利


Factory Bot では シーケンス を使ってこのようなユニークバリデーションを持つフィールドを扱うことができる
シーケンスはファクトリから新しいオブジェクトを作成するたびに、
カウンタの値を1つずつ 増やしながら、ユニークにならなければいけない属性に値を設定する

例.
factory :user do
  family_name      { "八木" }
  given_name       { "雅斗" }
  family_name_kana { "ヤギ" }
  given_name_kana  { "マサト" }
  faculty_id       { 1 }
  email            { |n| "sample#{n}@example.ritsumei.ac.jp" }
  password         { "password1" }
end

### 副作用(関連するモデルが勝手に作成される)

例.
# spec/factories/notes.rb
FactoryBot.define do
  factory :note do
    message "My important note."
    association :project
    association :user
  end 
end

# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" } description "A test project."
    due_on          1.week.from_now
    association     :owner
  end 
end

# spec/factories/users.rb
FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name "Aaron"
    last_name "Sumner"
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "dottle-nouveau-pavilion-tights-furze"
  end 
end

# ファクトリで関連するデータを生成する
it "generates associated data from a factory" do
  note = FactoryBot.create(:note)
  puts "This note's project is #{note.project.inspect}"  # User(プロジェクトに関連する owner)が作成される
  puts "This note's user is #{note.user.inspect}"        # User(メモに関連するユーザー)が作成される
end
#=> Factory Bot を1回しか呼んでいないにもかかわらず、テストの実行結果を見ると必要なデータが全部作成されている

## 以下のように変更するとデフォルトでユーザーが１人しか作成されなくなる
# spec/factories/notes.rb
FactoryBot.define do
  factory :note do
    message "My important note." association :project
    user { project.owner }
  end 
end

## エイリアス
# 同じカウンター(n)のデータを共有できる
Sequences can also have aliases. 
The sequence aliases share the same counter

使うときは、ユーザーファクトリに対して owner という名前で参照される場合 があると伝える必要あり
belongs_to :owner, class_name: User, foreign_key: :user_id



### 重複をなくす

# 継承＆traitなしバージョン
factory :board do
  sequence(:title)          { |n| "Title #{n}" }
  abstract                  { "要約" }
  laboratory                { "○○研究室" }
  start_day                 { "2021-08-23" }
  finish_day                { "2021-08-28" }
  sequence(:place)          { |n| "インテグ#{n}階" }
  reward_present            { true }
  reward_content            { "３０００円" }
  required_number           { 10 }
  sequence(:contact_detail) { |n| "sample#{n}@example.ritsumei.ac.jp" }
  due_on                    { "2021-10-01" }
  campus_name_id            { 1 }
  user                      { create :owner }
end

factory :board_due_today, class: Board do
  sequence(:title)          { |n| "Title #{n}" }
  abstract                  { "要約" }
  laboratory                { "○○研究室" }
  start_day                 { Date.tomorrow }
  finish_day                { Date.tomorrow }
  due_on                    { Date.today }
  sequence(:place)          { |n| "インテグ#{n}階" }
  reward_present            { true }
  reward_content            { "３０００円" }
  required_number           { 10 }
  sequence(:contact_detail) { |n| "sample#{n}@example.ritsumei.ac.jp" }
  campus_name_id            { 1 }
  user                      { create :owner }
end

## 継承バージョン
factory :board do
  sequence(:title)          { |n| "Title #{n}" }
  abstract                  { "要約" }
  laboratory                { "○○研究室" }
  start_day                 { "2021-08-23" }
  finish_day                { "2021-08-28" }
  sequence(:place)          { |n| "インテグ#{n}階" }
  reward_present            { true }
  reward_content            { "３０００円" }
  required_number           { 10 }
  sequence(:contact_detail) { |n| "sample#{n}@example.ritsumei.ac.jp" }
  due_on                    { "2021-10-01" }
  campus_name_id            { 1 }
  user                      { create :owner }

  factory :board_due_today do
    due_on                    { Date.today }
  end
end

board = FactoryBot.create(:board_due_yesterday) # 利用方法


## traitバージョン
factory :board do
  sequence(:title)          { |n| "Title #{n}" }
  abstract                  { "要約" }
  laboratory                { "○○研究室" }
  start_day                 { "2021-08-23" }
  finish_day                { "2021-08-28" }
  sequence(:place)          { |n| "インテグ#{n}階" }
  reward_present            { true }
  reward_content            { "３０００円" }
  required_number           { 10 }
  sequence(:contact_detail) { |n| "sample#{n}@example.ritsumei.ac.jp" }
  due_on                    { "2021-10-01" }
  campus_name_id            { 1 }
  user                      { create :owner }

  trait :today do
    due_on                    { Date.today }
  end
end

board = FactoryBot.create(:board, :today) # 利用方法


# Boardファクトリからテスト用の属性値をハッシュとして作成
FactoryBot.attributes_for(:board)

### コールバック
ファクトリがオブジェクトをcreate、build、stub する前後に
何かしら追加のアクションを実行できる
一方でコールバックは遅いテストや無駄に複雑なテストの原因になることもある

# create_listメソッド



ファクトリを使うとテスト中に予期しないデータが作成されたり、
無駄にテストが遅くなったりする原因になる
上記のような問題がテストで発生した場合はまず、
ファクトリが必要なことだけを行い、それ以上のことをやっていないことを確認！！

コールバックを使って関連するデータを作成する必要があるなら、
ファクトリを使うたびに呼び出されないよう、
トレイトの中でセットアップするようにする

可能な限り FactoryBot.create よりも
FactoryBot.build を使った方が
テストデータベースにデータを追加する回数が減るので、
パフォーマンス面のコストを削減できる

最初の頃は ここでファクトリを使う必要はあるだろうか? と自問するのも良い
もしモデルの new メソッドや create メソッドでテストデータをセットアップできるなら、
ファクトリをまったく使わずに済ませることもできる

PORO で作ったデータとファクトリで作ったデータをテスト内に混在させることもできる
このように、テストの読みやすさと速さを保つためにはいろんな方法が使える


# モデルのファクトリの作成コマンド
bin/rails g factory_bot:model モデル名
-------------Selenium-------------
Webブラウザの操作を自動化し、テストするためのフレームワーク
ブラウザ操作からテストスクリプトを作成でき、Webベース管理タスクの自動化も行える

Seleniumでブラウザ操作するには以下をインストールする
・Web ブラウザ (Chrome, Firefox, IE, Opera など)
・WebDriver (ブラウザを操作するための API を公開するモジュール)
・Selenium (WebDriverと通信しプログラムからブラウザを操作するライブラリ)

ChromeDriver: 
-> SeleniumからChromeを(特異的に？)操作するためのWebDriver
-> Chromeであればchromedriver(Chromeのドライバを同梱)のように、ブラウザ毎にDriverをインストールする必要がある

RSpec -> Capybara -> Selenium-WebDriver (Selenium & WebDriver) -> Chrome
Selenium WebDriverはプログラミングを介してブラウザ操作するライブラリ

Selenium WebDriver: 
-> Webブラウザをプログラムから自動的に操作するためのツール(SeleniumとWebDriverの統合ツール)
-> 様々なブラウザで共通して利用できる？

we need to register a new driver with Capybara that is configured to use the Selenium Grid container 
when a HUB_URL environment variable is present:

selenium/standalone-chrome(Dockerイメージ):
→selenium-standaloneサーバーを上げて（イメージ名のstandaloneってのはそういう意味）、
 そこからChromeにつなぎに行き、ChromeはXvfb上で動くようになっている
プログラム -> selenium-standalone -> ChromeDriver -> Chrome

Selenium::WebDriver には Selenium::WebDriver::Remote::Driver なるものがあり、
url: オプションで別ホストのブラウザのURLを渡すことにより、
Webアプリケーションの動くコンテナ以外のところでブラウザを動かすことができる

All the browser drivers implemented the WebDriver interface 
(actually the RemoteWebDriver class implements WebDriver Interface and the Browser Drivers extends RemoteWebDriver).

# Register new Driver for Capybara
Capybara.register_driver :remote_chrome do |app|
  # Specification of the desired and/or actual capabilities of the browser that the server is being asked to create.
  chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions" => {
      "args" => [
        "no-sandbox",
        "headless",
        "disable-gpu",
        "window-size=1680,1050"
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_REMOTE_URL'], desired_capabilities: chrome_capabilities)
end

RSpec.configure do |config|
  
  # js: trueを入れるとsystem testでjs: trueの時にremote_chrome(ドライバ)が使用される
  # system testにjs: trueがないとremote_chromeを使用しないため
  # -> Selenium::WebDriver::Error::WebDriverError: Unable to find chromedriver. を返す
  config.before(:each, type: :system) do
    driven_by :remote_chrome # driverを指定する(ローカルで行う場合はrack_test??)
    # Returns The IP address bound by default server
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    # Returns the value of attribute server_port
    Capybara.server_port = 3000
    # The default host to use when giving a relative URL to visit, must be a valid URL
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

end



Railsアプリケーションに何らかの機能を実装していて困ったときは、
RailsガイドやRails APIをチェックしてみてください。
いずれも1,000ページを超える大型ドキュメントなので、
今自分がやろうとしていることに関連するトピックがあるかもしれません。
できるだけ念入りにGoogleで検索し、
自分が調べようとしているトピックに言及している
ブログやチュートリアルがないかどうか、よく探すことです。
Webアプリケーションの開発には常に困難がつきまといます。
他人の経験と失敗から学ぶことも重要です。

返信機能
Twitterには、マイクロポスト入力中に@記号に続けてユーザーのログイン名を入力するとそのユーザーに返信できる機能があります。
このポストは、宛先のユーザーのフィードと、自分をフォローしているユーザーにのみ表示されます。
この返信機能の簡単なバージョンを実装してみましょう。
具体的には、@replyは受信者のフィードと送信者のフィードにのみ表示されるようにします。
これを実装するには、micropostsテーブルのin_reply_toカラムと、追加のincluding_repliesスコープをMicropostモデルに追加する必要があると思います。
スコープの詳細については、RailsガイドのActive Record クエリインターフェイスを参照してください。

このサンプルアプリケーションではユーザー名が重なり得るので、
ユーザー名を一意に表す方法も考えなければならないでしょう。
1つの方法は、idと名前を組み合わせて@1-michael-hartlのようにすることです。
もう1つの方法は、ユーザー登録の項目に一意のユーザー名を追加し、@replyで使えるようにすることです。

メッセージ機能
Twitterでは、ダイレクトメッセージを行える機能がサポートされています。
この機能をサンプルアプリケーションに実装してみましょう 
(ヒント: Messageモデルと、新規マイクロポストにマッチする正規表現が必要になるでしょう)。

フォロワーの通知
ユーザーに新しくフォロワーが増えたときにメールで通知する機能を実装してみましょう。
続いて、メールでの通知機能をオプションとして選択可能にし、不要な場合は通知をオフにできるようにしてみましょう。
メール周りで分からないことがあったら、RailsガイドのAction Mailerの基礎にヒントがないか調べてみましょう。

RSSフィード
ユーザーごとのマイクロポストをRSSフィードする機能を実装してください。
次にステータスフィードをRSSフィードする機能も実装し、余裕があればフィードに認証スキームも追加してアクセスを制限してみてください。

REST API
多くのWebサイトはAPI (Application Programmer Interface) を公開しており、
第三者のアプリケーションからリソースのget/post/put/deleteが行えるようになっています。
サンプルアプリケーションにもこのようなREST APIを実装してください。
解決のヒントは、respond_toブロックをコントローラーの多くのアクションに追加することです。
このブロックはXMLをリクエストされたときに応答します。セキュリティには十分注意してください。
認可されたユーザーにのみAPIアクセスを許可する必要があります。

検索機能
現在のサンプルアプリケーションには、ユーザーの一覧ページを端から探す、もしくは他のユーザーのフィードを表示する以外に他のユーザーを検索する手段がありません。
この点を強化するために、検索機能を実装してください。
続いて、マイクロポストを検索する機能も追加してください
 (ヒント: まずは自分自身で検索機能に関する情報を探してみましょう。難しければ、@budougumi0617 さんの簡単な検索フォームの実装例を参考にしてください)。

他の拡張機能
上記の他にも、「いいね機能」「シェア機能」「minitestの代わりにRSpecで書き直す」「erbの代わりにHamlで書き直す」「エラーメッセージをI18nで日本語化する」
「オートコンプリート機能」といったアイデアがありそうです。
「こんな拡張を実装してみた」といった例がありましたら @RailsTutorialJP までご連絡ください。


## 日付・時刻の書式変更
Railsの組み込みメソッドで設定
DateやTimeで独自の:stampフォーマットを作成

config/initializers/time_formats.rb
Date::DATE_FORMATS[:stamp] = "%Y%m%d"       # YYYYMMDD
Time::DATE_FORMATS[:stamp] = "%Y%m%d%H%M%S" # YYYYMMDDHHMMSS

ビューで以下のように書く
<%= @user.last_signed_in_at.to_s(:stamp) %>

-------------Ransack---------------
# search_form_forメソッド
例.
<%= search_form_for @q, url: search_users_path do |f| %>

# @q
検索結果(Ransack::Searchクラス)

# resultメソッド
ransackメソッドで取得したデータをActiveRecord_Relationのオブジェクトに変換するメソッド

# @results
最終的な検索結果(ActiveRecord_Relationクラス)

# _contメソッド
ransackで用意されている検索したワードが含まれているレコードを取得するためのメソッド
入力されたワードで あいまい検索 される
例.
<%= f.label :name_cont, 'ユーザー名' %>
<%= f.search_field :name_cont %>

# _eqメソッド
完全に一致する検索結果を表示する
<%= f.label :name_eq, 'ユーザー名' %>
<%= f.search_field :name_eq %>

# params[:q]
検索のフォームから送られてくるパラメーター

# カラム名_or_カラム名_or_カラム名_メソッド
1つの入力フォームで複数のカラムを検索する(_or_でカラム名を繋ぐ)

## 他のテーブルを検索する場合

# 関連するモデルが、対多（has_many: blogs など）の場合
company: 親テーブル
blog: 子テーブル

search_form_for(@q, url: blog_path) do |f|
  f.text_field :company_name(親テーブル)_or_title(子テーブル)_cont


---------------エラーメッセージ-------------
## エラーメッセージのテンプレート作成
# 1:エラーメッセージのview作成
htmlのif文をmodel.errors.any? にしておくことで
どのモデルのバリデーションにも対応させることができる
(deviseを入れていたら自動的に作成されている？？)
* layouts/_error_messages.html.erb
<% if model.errors.any? %>
  <div class = "error">
     <ul>
        <% model.errors.full_messages.each do |message| %>
           <li><%= message %></li>
	    <% end %>
     </ul>
  </div>
<% end %>

# 2:エラーメッセージのレイアウト作成
* layouts/error_messages.scss
alert {
  color:#262626; 
  background:#FFEBE8;
  text-align: center;
  border:2px solid #990000 ;
  padding:12px; font-weight:850;
}

# 3:エラーメッセージの表示
* products/new.html.erb
<%= render 'layouts/error_messages', model: f.object %>

## エラーメッセージ
errors.full_messages（または同等のerrors.to_a）メソッドは、
エラーメッセージをユーザーが読みやすい形式で返す
以下のように、メッセージごとに頭が大文字の属性名を冒頭に追加する



----------------webpacker-------------------

# エラー
Webpacker::Manifest::MissingEntryError
-> javascriptのパスが誤っていた

-----------------js---------------
<%= javascript_pack_tag 'company/blog/form' %>
-> app/javascript/packs/company/blog/form.js を個別に読み込む


---------------実装-----------------
新規作成・編集画面(new, edit)での画像表示
<img src="<%= @blog.main_image.to_s if @blog.main_image? %>" id="img-prev">


<%= image_tag(@blog.main_image.to_s, id: "img-prev") if @blog.main_image? %>

carriewaveの画像表示
<%= image_tag blog.main_image.to_s %>