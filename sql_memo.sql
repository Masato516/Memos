-------------------SQL----------------------
SQLは宣言型プログラミング
宣言型プログラミングでは対象の定義 =「何（What）を得たいか」を宣言してプログラムを構成し、
逆にそれを得る過程・手続き・アルゴリズム =「どうやって（How）得るか」を記述しない
すなわち、出力を得る方法ではなく、出力の性質・あるべき状態を記述することが「宣言型」である
「どのようなデータが欲しいか」を宣言し、どのテーブルから先に見るかなどといった
「いかにしてデータベースにアクセスするか」という命令・手続きには関与しない

カッコは(　)を使う

## SQLが実行される順番
FROM → ON → JOIN → WHERE → GROUP BY → HAVING 
→ SELECT → DISTINCT → ORDER BY → TOP (LIMIT)

## SQLの構文の並び順
SELECT → FROM → JOIN → ON → WHERE 
→ GROUP BY → HAVING → ORDER BY


## 論理演算子の優先順位
NOT、AND、OR の順で演算される


# データベースの選択
USE DATABASES


## SELECT 文

# 対象のテーブルに格納されてるデータの確認
SELECT * FROM テーブル名;

# カラム(列)を取り出す
SELECT カラム名1, カラム名2 FROM テーブル名;


## INSERT 文 (値を指定したレコード追加)
INSERT INTO の後にテーブル名を記載

--INSERT文の構文（１）
INSERT INTO	テーブル名 (カラム名,カラム名...)
VALUES	             (値,     値     ...)

その後ろの（カッコ）の中には列名をカンマ区切りで指定
レコード追加したい値はVALUESの後ろの（カッコ）の中に、値をカンマ区切りで記載
値が文字列の場合はクォーテーションで囲む

例. EMP表に例にINSERT文を記載すると以下のようになる
INSERT INTO	EMP (EMPNO,NAME, JOB,      MGR, HIREDATE,  SAL, COMM,DEPTNO)
VALUES	        (9999,'SAN','SALESMAN',7698,1981-09-28,1000,500, 10)

# 表の全項目に値を追加する場合は、列名は省略することが可能
INSERT INTO	EMP
VALUES (9999,'SAN','SALESMAN',7698,2004-06-24,1000,500,10)

# 一部の項目に値を設定する場合は、表名の後ろの追加したい値を格納する項目名を記載し、VALUESに追加したい値を記載
INSERT INTO	EMP (EMPNO,ENAME)
VALUES	        (9999,'SAN')

# テーブルへのデータの挿入(登録)
1.テーブルの全てのカラムにデータを追加する場合にはカラム名の指定を省略できる(1レコードずつしか挿入できない)
INSERT INTO テーブル名 VALUES (1, 'Yamada');

2.指定しなかったカラムにはデフォルトの値が格納される
  カラム名の数と値の数は同じにする
INSERT INTO テーブル名 (column_name1, column_name2, ...) VALUES (value1, value2, ...)


## UPDATE 文 (テーブルにあるレコードの更新)
-- UPDATE文の構文（１）
UPDATE テーブル名
SET	   カラム名 = 値, カラム名 = 値...
WHERE	 条件

--UPDATE文の構文（２）
UPDATE EMP
SET	   SAL = SAL * 1.5
WHERE	 EMPNO = 7369


## DELETE 文 (テーブルにあるレコードを削除)
-- DELETE文の構文（１）
DELETE FROM	テーブル名
WHERE	      条件

例. 従業員全員のレコードを削除
DELETE FROM	EMP
例. EMP表のSMITHさん（従業員番号:7369）のレコードを削除
DELETE FROM	EMP
WHERE	EMPNO = 7369


## DROP 文 (テーブルとデータベースの削除)
DROP TABLE テーブル名

# テーブルがある時だけ削除
DROP TABLE IF EXISTS テーブル名;


## SHOW 文

# 文字コードの確認(デフォルトは latin1)
SHOW variables like '%char%';

# データベースの確認
SHOW DATABASES;

# 接続中のデータベースを表示
SHOW PROCESSLIST;

# 選択したテーブルのカラム情報の確認
SHOW COLUMNS FROM テーブル名 FROM データベース名;

## SQL句

# WHERE 句(条件を指定)
SELECT * 
FROM テーブル名 
WHERE score <= 60

-- 集約関数を使う条件文を使用する場合havingを使用する。
-- where句の中では集約関数は使えない。

# ORDER BY 句(並び替え)
SELECT   ENAME, JOB, SAL 
FROM     EMP 
ORDER BY SAL DESC

# LIMIT 句 (件数を指定してカラム(例)を取り出す)
 (MySQL)
SELECT * FROM テーブル名 ORDER BY id LIMIT 0(先頭の行), 10(最後の行);
 (PostgreSQL)
SELECT * FROM テーブル名 ORDER BY id OFFSET 0(先頭の行) LIMIT 10(最後の行);

# GROUP BY 句 (データをグループ化する)
指定したカラムごとにグループ化し、集合関数の計算結果を取得できる
[GROUP BY カラム名]のように記述

--例. 
SELECT   DEPTNO, AVG(SAL)
FROM     EMP
GROUP BY DEPTNO

--例. WHEREによるレコードの選択
WHERE条件によりレコードが抽出され、
GROUP BYで指定したカラムごとにグループ化され、集合関数で計算結果が求められる
SELECT    JOB,AVG(SAL)
FROM	    EMP
WHERE	    DEPTNO <> 10
GROUP BY	JOB


# HAVING 句 (GROUP BY句に対して抽出条件を設定)
GROUP BY句の後ろに[ HAVING 条件式 ] と記述
WHERE条件が  GROUP BY でグループ化される前のレコード抽出段階の条件
HAVING条件は GROUP BY でグループ化された後のレコード抽出段階の条件

重要！！！
集約関数を使う条件文を使用する場合havingを使用
where句の中では集約関数は使えない
HAVING 句はWHERE 句による検索
⇒GROUP BY によるグループ化
⇒集計関数による集計と、列選択が終わったあとに絞り込みを行う



--例.
SELECT   JOB, MIN(SAL), MAX(SAL), AVG(SAL)
FROM     EMP
GROUP BY JOB
HAVING   MAX(SAL) >= 2000


# DISTINCT 句 (重複行の削除)
DISTINCTキーワードはSELECT句の後ろに記載

-- 抽出したレコードから重複行を削除(JOBとSALが重複するレコードを削除)
SELECT DISTINCT JOB, SAL
FROM	 EMP


## 演算子
# EXISTS 演算子 (限定述語)
（）の中に書いてあるSQLで抽出されるレコードがある場合は真、無い場合は偽を返す
真のときのみ外側のWHERE条件が成立し、レコードが抽出される
-- 例.給料がもっとも高い従業員の抽出
SELECT ENAME,SAL
FROM	 EMP EA
WHERE	 NOT EXISTS(
       SELECT * FROM EMP EB
       WHRE EB.SAL > EA.SAL
       )
内側のクエリで真を返した時のみ
レコードを取り出す！


# IN 演算子
指定した列のデータの中から()内のいずれかの値と一致するデータだけを取り出す
例. sample_dbテーブルからheightが 180 もしくは 170の user を取得
SELECT user 
FROM   sample_db 
WHERE  height IN (180, 170) 


# NOT IN 演算子
指定した列のデータの中から()内のいずれとも一致しないデータだけを取り出す
SELECT user FROM sample_db WHERE height NOT IN (180, 1700)


# BETWEEN 演算子
BETWEEN演算子はWHERE句で使用
[カラム名 BETWEEN 下限値 AND 上限値] と記述(下限値と上限値を逆に記述することはできない)
カラムの値が下限値以上、上限値以下の場合真を返す
例.
SELECT ENAME, SAL
FROM   EMP
WHERE  SAL BETWEEN 1000 AND 2000
以下と同じクエリ！！
SELECT ENAME
FROM	 EMP
WHERE	 1000 <= SAL AND SAL <= 2000


# NOT BETWEEN 演算子
-- 例. BETWEEN演算子を否定
-- [カラム名 NOT BETWEEN 下限値 AND 上限値]と記述
-- 例.
SELECT ENAME, SAL
FROM   EMP
WHERE  SAL NOT BETWEEN 1000 AND 2000
以下と同じクエリ！！
SELECT ENAME, SAL
FROM   EMP
WHERE  SAL <= 1000 OR 2000 <= SAL


# LIKE 演算子(パターンマッチング)
-- WHERE句で使用
-- [カラム名 LIKE 比較文字列] と記述
-- カラム名と比較文字列のパターンマッチングを行なう
-- 例. Aという文字を含む従業員名を検索
SELECT	ENAME
FROM	EMP
WHERE	ENAME LIKE '%A%'

-- 比較文字列に使用可能なワイルドカードは以下の2文字
-- %（パーセント）	0文字以上の任意の文字列
-- _（アンダーバー）	1文字の任意の文字


# ESCAPE(エスケープキーワード)
例.
WHERE ENAME LIKE '%?_%' ESCAPE '?'


# NOT LIKE 演算子
[カラム名 NOT LIKE 比較文字列]のようにLIKE演算子の前にNOTを記述
例.
WHERE ENAME NOT LIKE '%A%'



## 集約関数

# MAX関数
例.
SELECT MAX(SAL), MIN(SAL)
FROM   EMP
WHERE  JOB = 'SALESMAN'

# COUNT関数
・レコード数を求める時
COUNT(*)で取得

・データの数を求める時
COUNT(NAME)で取得(NULLは除外)

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


** 制約
* NOT NULL
NULL値を禁止

* CHECK
条件を指定し、条件を満たさないデータを禁止
例. CHECK(AGE BETWEEN 18 AND 60)

* UNIQUE
重複したデータを禁止、複数の列に設定可能、NULLを禁止するわけではない

* PRIMARY KEY(主キー制約)
一意を保証、重複とNULLを禁止、1つのテーブルに1つ
使用例. 
CREATE TABLE customers(
             id INT UNSIGNED NOT NULL AUTO_INCREMENT,
             name VARCHAR(100) NOT NULL,
             created_at DATETIME NOT NULL,
             updated_at DATETIME NOT NULL,
             PRIMARY KEY(id)  -- カラム名を指定(複数指定可能)
             );

CREATE TABLE customers(
             -- カラムに直接指定
             id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
             name VARCHAR(100) NOT NULL,
             created_at DATETIME NOT NULL,
             updated_at DATETIME NOT NULL
             );

* FOREIGN KEY(参照整合性制約、外部キー制約)
他のテーブルの列を参照し、その列にないデータを禁止
--親テーブル
CREATE TABLE 親テーブル名(親カラム名 データ型 PRIMARY KEY);
--子テーブル
CREATE TABLE 子テーブル名
       (子カラム名 データ型,
       INDEX インデックス名(子カラム名), 
       FOREIGN KEY (外部キーとする子カラム名) 
       REFERENCES 親テーブル名(親カラム名)
       );

・親テーブルおよび子テーブルでは FOREIGN KEY 制約の対象となるカラムに対して
  インデックスが必要(作成されない場合は自動で作成される)
・親テーブルと子テーブルは同じストレージエンジンを使用する必要がある
・MySQLで FOREIGN KEY を使用できるストレージエンジンは InnoDB と NDB
・子テーブルの対象カラムと親テーブルの対象カラムは同じデータ型である必要がある
  文字列型の場合、長さは同じである必要がないが、
  非バイナリ型の場合は文字セットと照合順序は同じである必要がある

例. FOREIGN KEY(CODE) REFERENCE BUSHO
・DEFAULT=値
デフォルト値を設定


** オプション

* AUTO_INCREMENT
指定したカラムに対してMySQLが自動的に一意のシーケンス番号を生成する機能



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


## 結合
# 内部結合(1対多の時に使うイメージ: user.prefecture みたいな？)

# 複数テーブルからの問い合わせを行う場合は、FROMの後ろに表名を「,」で区切って記述
# 「表明.項目名」という記述は、テーブルを連結して両方のテーブルに同じカラム名があった場合、どちらの項目を表示するかを指定するため
-- EMP表とDEPT表の内部結合 (WHERE文バージョン)
SELECT EMP.ENAME, DEPT.DNAME
FROM   EMP, DEPT
WHERE  EMP.DEPTNO = DEPT.DEPTNO

-- EMP表とDEPT表の内部結合 (INNER JOIN句バージョン)
SELECT     EMP.ENAME, DEPT.DNAME
FROM       EMP
INNER JOIN DEPT
ON         EMP.DEPTNO = DEPT.DEPTNO
WHERE      EMP.DEPTNO = 2  -- INNER JOINの後に記述！！

# エイリアス
SELECT E.ENAME, D.DNAME
FROM   EMP E, DEPT D -- 表にエイリアス（別名）を付けて記述を簡便化
WHERE  E.DEPTNO = D.DEPTNO



------------mysql-----------
コメントアウト(3種類)
#       から始まって行末までのコメント
--      から始まって行末までのコメント(--の後は半角スペース必須)
/*から*/ までのコメント(改行を許容)


** データ型

* 文字列
・CHAR(最大格納文字数)
文字列がテーブル作成時に指定された文字数よりも短かった場合，
文字列の右側の末尾にスペースで補完
・VARCHAR(最大格納文字数) (ie. VARiable CHARacter)
指定された文字列よりも短かった場合に，データに合わせた文字列として可変長で保存される


* 整数型
・SMALLINT (-32768 ~ 32767)
・INT (-2147483648 ~ 2147483647)
・BIGINT (-9223372036854775808 ~ 9223372036854775807)

UNSIGNED 属性 (例. INT UNSIGNED)
-> 負の数値がなくなる分、扱える数値が増える(0 ~ 65535)


** SQL文の最後に;をつける

# mysqlを起動
mysql.server start

# rootユーザーでmysqlにログイン
mysql -u root -p

# ログアウト
exit

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