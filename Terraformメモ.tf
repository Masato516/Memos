公式ドキュメント: https://registry.terraform.io/


## tfenv
terraform のバージョン管理ツール


## tfファイル
カレントディレクトリの直下のファイルしか読み込まれない！！！
全ての直下のファイルが読み込まれるため、
ファイル名は何でも良い！！！


## resource
リソース（インフラ）を作るための文


## data
リソースを取得するための文
すでに作成済みのリソースの情報を取得する


## tfstateファイル
terraformで管理しているインフラリソースを
全て記載したjsonファイル

* S3などで管理する例
バケットを作成し、以下のファイルを作成・反映
/backend.tf--------------------------------------------------
terraform {
  required_version = "1.0.5"
  backend "s3" {
    profile = "sh0162vi_terraform"
    bucket = "terraform-masa-test-tfstate" # バケット名
    key    = "terraform.tfstate"           # バケット内のキーのパス
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1" # リージョン名
}
-------------------------------------------------------------



## 設定ファイルと認証情報ファイルの設定

AWS CLI コマンドに適用できる設定と認証情報の集まり
コマンドを実行するプロファイルを指定すると、
設定と認証情報を使用してそのコマンドが実行される。
プロファイルが明示的に参照されない場合に使用される、
default プロファイルを 1 つ指定できる

$ aws configure で簡単に設定できる 
(~/.aws/credentials と ~/.aws/configure に保存される)

例--------------------------------------------
~/.aws/credentials
[プロファイル名]
aws_access_key_id = ~~~~~~~~~~~~~~~~~
aws_secret_access_key = ~~~~~~~~~~~~~~~~~~~~~

~/.aws/config
[profile プロファイル名]
region = ap-northeast-1
output = json
----------------------------------------------



## terraform init
ワークスペースを初期化するコマンド。
Terraform を実行するためには、1番初めに terraform init でワークスペースを初期化することが必須



## terraform apply
.tf ファイルに記載された情報を元にリソースを作成するコマンド。
リソースが作成されると terraform.state というファイルに、
作成されたリソースに関連する情報が保存される
また、2度目以降の実行後には、1世代前のものが terraform.tfstate.backup に保存される形となる
Terraform において、この状態を管理する terraform.state ファイルが非常に重要になってくる。

使用例
AWS_PROFILE=プロファイル名 terraform apply


## terraform validate
terraformの構文チェック
あんまり使わない（planで大体わかる！）


## terraform plan (dry-run)
Terraform による実行計画を参照するコマンド
.tf ファイルに記載された情報を元に、
どのようなリソースが 作成/修正/削除 されるかを参照することが可能

使用例
AWS_PROFILE=プロファイル名 terraform plan



## terraform show
terraform.state ファイルを元に現在のリソースの状態を参照するコマンド



## terraform destroy
.tf ファイルに記載された情報を元にリソースを削除するコマンド
なお、実行すると terraform.tfstate のリソース情報がスカスカになり、
削除直前のものは terraform.tfstate.backup に保存される形となる

使用例
# 全てのリソースを削除
AWS_PROFILE=プロファイル名 terraform destroy
# 特定のリソースを削除
AWS_PROFILE=プロファイル名 terraform destroy -target=aws_subnet.recruit_web_1c



## アウトプット
EC2 インスタンスに紐付けた Elastic IP ( 固定 IP ) の値など
インフラ構築完了後に各種リソースに割り当てられた属性値を知りたい場合がある
テンプレートに output ブロックを記述することで 
terraform コマンド実行時に指定した値がコンソール上に出力されるようになる

・構文
output "<アウトプットしたい属性の説明>" {
  value = "<アウトプットする属性値>" 
}

例
output "elastic_ip_of_web" {
  value = "${aws_eip.web.public_ip}"
}




## ルートテーブル

ルートテーブルを作成する際は下記の作成が必要

・ルートテーブル: aws_route_table
vpc_idを指定するだけ
名前をつけたければtagsでNameを指定

・ルートテーブルとサブネットの関連付け: aws_route_table_association
route_table_idとsubnet_idを指定して
ルートテーブルとサブネットを関連付け

・IGWへのルーティング(サブネットからインターネットへの接続): aws_route
destination_cidr_blockで送信先を指定
またdepends_onで依存を作成することができる
→ aws_route_tableが存在しない場合は
  aws_routeは存在し得ないので、aws_routeを指定する



## Security Group



## Route53

AWS上でのDNS（ちなみに53とは、DNSの使うポート番号）


# ゾーン情報の追加: aws_route53_zone

ゾーン:
1台の権威DNSサーバが管理する範囲

ゾーン情報:
ゾーンのDNS（名前解決）のための情報

権威DNSサーバー:
IPアドレスとドメイン名の紐付けに関して、自分の管理する範囲内のIPアドレスとドメイン名の対応表を持つ
問い合わせに対してはその対応表を元に返事をするDNSサーバ



# レコードの追加: aws_route53_record



その他の設定事項(コンソールにて)
Alias: エイリアス機能を使うかどうか
TTL: キャッシュの接続時間
Value: 割り当てる値（Elastic IPアドレス）
RoutingPolicy: Valueに複数のIPアドレスを記入して、冗長構成や負荷分散するときの振り分け方を決める項目
               １つしかしていない時は意味がない。



## CloudFront




## output

EC2インスタンスのパブリックIPなど、
環境を構築した結果リソースに割り当てられた属性値を知りたい場合がある
その時に役立つのがoutput


# 書式
output "<アウトプットする属性の説明>" {
  value = "<アウトプットする属性値>"
}

output "public ip of cm-test" {
  value = "${aws_instance.cm-test.public_ip}"
}



## workspace
本番環境やステージング環境などに分けられる
(https://www.terraform.io/docs/language/state/workspaces.html)

$ terraform workspace list
workspace（作業空間）の一覧を出力
* default <- 現在のworkspace


$ terraform workspace new <workspace名>
workspaceを作成

例.
terraform workspace new production



#### モジュールなどのリソースの再利用
## module
プログラミング言語でいうクラスのようなもの


## Input variable (入力変数)
関数の引数のようなもの


## Output variabel (出力変数)
moduleの戻り値のようなもの
(関数の戻り値のようなもの)


## local variable (ローカル変数)
関数の一時的なローカル変数のようなもの


使用例.
(~/modules/vpc_subnet.tf: モジュールを定義する側)-----------

resource "aws_vpc" "recruit_web" {
  cidr_block = var.vpc_cidr_block  # 入力変数(input variable)を受け取る

  tags = {
    Name = "vpc_for_recruit_web"
  }
}

resource "aws_subnet" "recruit_web_1c" {
  vpc_id            = aws_vpc.recruit_web.id
  cidr_block        = var.subnet_1c_cidr_block
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public_subnet_for_recruit_web"
  }
}
-------------------------------------------------

(~/modules/terraform.tfvars: 入力変数を宣言)-------

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_1c_cidr_block" {
  type = string
}

-------------------------------------------------

(~/vpc.tf: モジュールを生成する側)-------------------

module "vpc_subnet_1" {
  # ~/modules/vpc_subnet.tf のリソースを作成
  source = "./modules/vpc_subnet"
  # 入力変数に値を代入
  var.vpc_cidr_block       = "10.0.0.0/16"
  var.subnet_1c_cidr_block = "10.0.0.0/24"
}

# 2つめのVPCとサブネットのリソースを作成
module "vpc_subnet_2" {

  source = "./modules/vpc_subnet"

  var.vpc_cidr_block       = "10.1.0.0/16"
  var.subnet_1c_cidr_block = "10.1.0.0/24"
}

# 3つめのVPCとサブネットのリソースを作成
module "vpc_subnet_3" {

  source = "./modules/vpc_subnet"

  var.vpc_cidr_block       = "10.2.0.0/16"
  var.subnet_1c_cidr_block = "10.2.0.0/24"
}
-------------------------------------------------

# 参考資料
https://youtu.be/h1MDCp7blmg?t=4549