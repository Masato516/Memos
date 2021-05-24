-------------------SQL----------------------
# データベースの選択
USE DATABASES

# テーブルへのデータの挿入(登録)
1.テーブルの全てのカラムにデータを追加する場合にはカラム名の指定を省略できる(1レコードずつしか挿入できない)
INSERT INTO テーブル名 VALUES (1, 'Yamada');

2.指定しなかったカラムにはデフォルトの値が格納される
  カラム名の数と値の数は同じにする
INSERT INTO テーブル名 (column_name1, column_name2, ...) VALUES (value1, value2, ...)


# SELECT 文

# 対象のテーブルに格納されてるデータの確認
SELECT * FROM テーブル名;

# カラム(列)を取り出す
SELECT 列名1, 列名2 FROM テーブル名;


# WHERE 句(条件を指定)
select * FROM テーブル名 WHERE score <= 60

# LIMIT 句(件数を指定してカラム(例)を取り出す)
 (MySQL)
SELECT * FROM テーブル名 ORDER BY id LIMIT 0(先頭の行), 10(最後の行);
 (PostgreSQL)
SELECT * FROM テーブル名 ORDER BY id OFFSET 0(先頭の行) LIMIT 10(最後の行);

# IN 演算子
指定した列のデータの中から()内のいずれかの値と一致するデータだけを取り出す
SELECT user FROM sample_db WHERE height IN (180, 1700) 

# NOT IN 演算子
指定した列のデータの中から()内のいずれとも一致しないデータだけを取り出す
SELECT user FROM sample_db WHERE height NOT IN (180, 1700) 


* データベースの名称
テーブル、カラム、レコード、フィールド

* 検索アルゴリズム
・単純探索
頭から目的のレコードを一つずつ探索する方法

・二分探索
検索範囲の真ん中が目的のレコードのフィールドより大きいか小さいかで
検索範囲を狭めて行くことで目的のレコードを取得する方法

* インデックス
・主キー(primary key: idカラム)
デフォルトではid順に並んでいる
データの重複やNULL値は禁止

・複合インデックス
[所属コード,社員コード]でインデックスを作った場合
所属   社員  名前
1001	 101	テスト太郎D
1003	 101	テスト太郎C
1004	 101	テスト太郎A
1002	 102	テスト太郎B
1005	 102	テスト太郎E

２つ目のインデックスでSQL文を実行すると...
select * from 社員テーブル where 社員コード = 1003 
データの並び順が社員コード順になっていないので、全件検索し該当レコードを探す動きになる


* 制約
・NOT NULL
NULL値を禁止
・CHECK
条件を指定し、条件を満たさないデータを禁止
・UNIQUE
重複したデータを禁止、複数の列に設定可能、NULLを禁止するわけではない
・PRIMARY KEY(主キー制約)
一意を保証、重複とNULLを禁止、1つのテーブルに1つ
・FOREIGN KEY(参照整合性制約、外部キー制約)
他のテーブルの列を参照し、その列にないデータを禁止
・DEFAULT=値
デフォルト値を設定


** サブクエリ

* サブセレクト
SELECT文の中にSELECT文を内包する
例 (Rails Tutorial より)

・サブセレクトを用いない場合
following_idsでフォローしているすべてのユーザーをデータベースに問い合わせし、
さらに、フォローしているユーザーの完全な配列を作るために再度データベースに問い合わせしている
Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)

・サブセレクトを用いた場合
following_ids = "SELECT followed_id FROM relationships
                  WHERE follower_id = :user_id"
Micropost.where("user_id IN (#{following_ids})
                  OR user_id = :user_id", user_id: id)
生成されるクエリ
SELECT * FROM microposts
WHERE user_id IN (SELECT followed_id FROM relationships
                  WHERE  follower_id = 1)
                  OR user_id = 1
このサブセレクトは集合のロジックを (Railsではなく) データベース内に保存するので、より効率的にデータを取得することができる
------------mysql-----------
** データ型

* 文字列
・CHAR 
・VARCHAR (ie. VARiable CHARacter)


** SQL文の最後に;をつける

# mysqlを起動
mysql.server start

# rootユーザーでmysqlにログイン
mysql -u root -p

# ログアウト
exit

# データベースの確認
SHOW DATABASES;

# ユーザー、ホストの確認
(DATABASEのmysqlにユーザー情報等が入っている)
SELECT Host, User FROM mysql.user;

# ユーザー、ホスト、プラグインの確認
SELECT Host, User, plugin FROM mysql.user;

# データベースの作成
CREATE DATABASE データベース名;

# テーブルの作成
CREATE TABLE テーブル名(カラム名 データ型,
                      カラム名 データ型, 制約);

# データベースの指定
USE データベース名;

# 現在接続しているデータベースの確認
SELECT database();

# 接続中のデータベースを表示
SHOW PROCESSLIST;

# データベースの削除
DROP DATABASE データベース名;

# テーブル内のデータの全削除
# (DELETEと異なりAUTO_INCREMENTがリセットされる)
TRUNCATE TABLE USER;

作成したデータベースに対する作業ユーザーを作成
新規でユーザーを作るときは、次のコマンドを使

#rootユーザーは、ほぼすべてのファイルにアクセスが可能で、作成や削除などの命令を自由に出すことができる強力な権限を持つ

# ユーザーを作成
CREATE USER ユーザー名 IDENTIFIED BY 'パスワード';

# ユーザー作成(ホスト付き)
CREATE USER ユーザー名@接続元 IDENTIFIED BY 'password-example';

#MySQL8ではGRANT文でユーザが作成できない(crateしてから使用)
# grant all onは「すべての権限を与える」、 .* は、「指定のデータベース下すべてのテーブルに対して」という意味
grant all on データベース名.* to ユーザー名@接続元;

# sampledbデータベースに「dbuser」でログイン
./mysql -u dbuser -p sampledb
※uはuser、p はplaceでログイン先
例.
mysql -h recruit-db.cxqoweigndew.ap-northeast-1.rds.amazonaws.com -u admin -P 3306 -pToRecruit516Subjects

# パスワードの変更
ALTER USER ユーザー名@ホスト名 IDENTIFIED '変更後のパスワード';

# ユーザー削除
DELETE FROM mysql.user WHERE user='ユーザー名';

# すでに入ってあるidを1から始める
USE データベース名;
SET @n:=0;

# ID(連番)の初期化
ALTER TABLE `テーブル名` auto_increment = 1;

選択したテーブルのカラム情報の確認
SHOW COLUMNS FROM テーブル名 FROM データベース名;

---------AWS Mysql-----------
CREATE USER wordpress@"%" IDENTIFIED BY 'WordPressPasswd@516';
@は接続元
"%"は全てのホスト名
-> どこからでも接続できるwordpressというユーザー

# MySQLの状態を確認
systemctl status mysqld.service

#自動起動設定
$ sudo systemctl start mysqld.service
$ sudo systemctl enable mysqld.service
$ systemctl status mysqld.service

ゆるいパスワードでユーザを作成しようとした際に怒られる
# パスワードのvalidationの確認
mysql> show global variables like '%validate%';
+--------------------------------------+--------+
| Variable_name                        | Value  |
+--------------------------------------+--------+
| validate_password.check_user_name    | ON     |
| validate_password.dictionary_file    |        |
| validate_password.length             | 8      |
| validate_password.mixed_case_count   | 1      |
| validate_password.number_count       | 1      |
| validate_password.policy             | MEDIUM |
| validate_password.special_char_count | 1      |
+--------------------------------------+--------+
デフォルトでは
パスワード長 8文字以上
大文字小文字 1文字以上
数字 1文字以上
記号 1文字以上 でないと怒られる
# バリデーションポリシーの変更例(パスワードの長さのみの制約に変更)
mysql> set global validate_password.policy = "LOW";

MySQL5.7までの認証プラグインには mysql_native_password がデフォルトで使用されていましたが、MySQL8.0より新たに追加された caching_sha2_password に変更
caching_sha2_passwordは、SHA-256を使用したより安全なパスワードの暗号化を提供するとともに、キャッシュを使用して同一ユーザの認証処理を高速化しようという、MySQL推奨の認証プラグイン
MySQL接続ライブラリが caching_sha2_password　に未対応のため接続不可
解決策としては認証方式を mysql_native_password に戻す
# 既存ユーザーの認証方式を確認
SELECT user, host, plugin FROM mysql.user;
# 既存ユーザーの認証方式を変更 (対処法1)
ALTER USER 'vagrant'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
# ユーザ作成時に使用する認証プラグインを指定 (新規作成バージョン)
mysql> create user user2@localhost identified with mysql_native_password by 'user2_Password';
ユーザ作成時に「with mysql_native_password」を指定する事で、作成したユーザは mysql_native_password 認証プラグインを使用
# デフォルトの認証プラグインを変更する (対処法2)
# /etc/my.cnf に追記
[mysqld]
default_authentication_plugin=mysql_native_password

エラーの確認
sudo less /var/log/httpd/error_log | tail -20
インストールされているものの確認
yum list installed | grep 検索ワード

dbコンテナ内でbash操作する
docker exec -it recruit_db_container bash