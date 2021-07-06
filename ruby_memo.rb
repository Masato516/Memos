## エラー
# unterminated string meets end of file：引用符の閉じ忘れ
# parse error：文法間違い。ifやwhileに対するend忘れであることが多い。
# undefined method....：メソッドのスペルミス

## 2つの配列からハッシュを生成
keys = %w(ushi tori)
vals = %w(beef chicken)
hash = Hash[keys.zip vals]

## 順列
# combination(引数)
# combinationの引数は選び出す要素の個数を指定
array = [1,2,3,4]
p array.combination(3).to_a
#=> [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]
# 重複している要素がある場合
array = [1,2,2,3]
p array.permutation(4).to_a
#=> [[1, 2, 2, 3], [1, 2, 3, 2], [1, 2, 2, 3], [1, 2, 3, 2], [1, 3, 2, 2], [1, 3, 2, 2], [2, 1, 2, 3], [2, 1, 3, 2], [2, 2, 1, 3], [2, 2, 3, 1], [2, 3, 1, 2], [2, 3, 2, 1], [2, 1, 2, 3], [2, 1, 3, 2], [2, 2, 1, 3], [2, 2, 3, 1], [2, 3, 1, 2], [2, 3, 2, 1], [3, 1, 2, 2], [3, 1, 2, 2], [3, 2, 1, 2], [3, 2, 2, 1], [3, 2, 1, 2], [3, 2, 2, 1]]

## 組み合わせ
array = [1,2,3]
p array.permutation(3).to_a
#=> [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]

# 要素の重複を許可する場合は repeated_combination や repeated_permutation が利用できる

## 順列(combination)、組み合わせ(permutation)、factorial(階上)の数を数える
# 内部の処理的には配列のパターンを全て列挙しているので、大きな値になってくると時間がかかる
array = (1..20).to_a
p array.permutation(5).to_a.count # n_P_k
p array.combination(5).to_a.count # n_C_k
#=> 1秒ほど掛かる
# Integerクラスをオープンして「combination」「permutation」「factorial」メソッドを定義
class Integer
  def combination(k)
    return 1 if k.zero?

    (self - k + 1..self).inject(:*) / k.factorial
  end

  def permutation(k)
    return 1 if k.zero?

    (self - k + 1..self).inject(:*)
  end

  def factorial
    return 1 if self.zero?

    (1..self).inject(:*)
  end
end
3.factorial => 6
0.factorial => 1
10.factorial => 3628800
4.combination(1) => 4
4.combination(0) => 1
10.combination(5) => 252
3.permutation(2) => 6
20.permutation(5) => 1860480
20.combination(5) => 15504



## コマンドラインの引数
# 配列として取得
ARGV
# １つずつ文字列として取得
ARGV[0]

## キュー (unshiftはprependでも良い: 2.5以上)
# 最初に入れたデータを最初に取り出すデータ構造
# (後ろから並んでいき、先頭から取り出す)
列 = []

# 要素を末尾に追加する
列.push '一人目'
列.push '二人目'
列 #=> ["一人目", "二人目"]

# 先頭の要素を取得して削除する
列.shift #=> "一人目"
列.shift #=> "二人目"
列       #=> []

## スタック (pushはappendでも良い: 2.5以上)
# 最後に入れたデータを最初に取り出すデータ構造
# (後ろから入れていき、後ろから取り出す)
ダイニングテーブル = []

# 要素を末尾に追加する
ダイニングテーブル.push '大きい皿'
ダイニングテーブル.push '小さい皿'
ダイニングテーブル #=> ["大きい皿", "小さい皿"]

# 末尾の要素を取得して削除する
ダイニングテーブル.pop #=> "小さい皿"
ダイニングテーブル.pop #=> "大きい皿"
ダイニングテーブル     #=> []


## Rubyは () を半角スペースで省略できる

# 入力例: 3 5 7
# 入力値を整数の配列に
input_line = gets.chomp.split().map( &:to_i )

## メソッドの引数

# 引数の数が不定な場合(*変数名)を使う
# *変数名に入れられた値は配列になる
def foo(*args)
  args
end
p foo(1)      #=> [1]
p foo([1, 1]) #=> [1, 1]

# キーワード引数
# ハッシュを引数にする
# デフォルトがあってもなくても良い
def volume(x: , y: 1, z: 1)
  [x, y, z]
end
p volume(x: 1, y:10)  # => [1, 10, 1]
p volume(y: 10)       # => missing keyword: :x (ArgumentError)

# 定義に存在しないキーワード引数を受け取る
def foo(x: 0, y: 0, z: 0, **args)
  [x, y, z, args]
end
p foo             #=> [0, 0, 0, {}]
p foo()           #=> [0, 0, 0, {}]
p foo(i: 2, h: 6) #=> [0, 0, 0, {:i=>2, :h=>6}]

## メソッドの呼び出し時
# 引数に配列を入れる
# 引数で配列を展開(**ar)
def hoge(a, b, c)
  [a, b, c]
end
args1 = [10, 100]
p hoge(1, 2, *args1) #=> wrong number of arguments (given 4, expected 3)
p hoge(1, *args1) #=> [1, 10, 100]

# 引数にハッシュを入れる
# メソッドの引数にハッシュを入れる場合は{ }を省略できる
def hoge(arg)
  arg
end
p hoge({a: 1, b: 2}) #=> {:a=>1, :b=>2}
p hoge(a: 1, b: 2)   #=> {:a=>1, :b=>2}


#配列内に配列を挿入(多次元配列になる)
example1_arry.push(example2_arry)

## 二次元配列の並び替え（ソート:昇順）
二次元配列 = [[1, 3], [1, 2], [2, 4], [2, 2]]
# sort()バージョン
# 値が数値、文字に関わらず有効
p 二次元配列.sort {|前の配列,後の配列| 前の配列[1] <=> 後の配列[1]}
#=> [[1, 2], [2, 2], [1, 3], [2, 4]]
# sort_by()バージョン
# 値が数値、文字に関わらず有効
p 二次元配列.sort_by {|配列| 配列[1]}
#=> [[1, 2], [2, 2], [1, 3], [2, 4]]

## 二次元配列の並び替え（ソート:降順）
二次元配列 = [[1, 3], [1, 2], [2, 4], [2, 2]]
# sort()バージョン１
# 昇順.reverse
# 値が数値、文字に関わらず有効
p 二次元配列.sort {|前の配列,後の配列| 前の配列[1] <=> 後の配列[1]}.reverse
# sort()バージョン２
# b<=>a
# 値が数値、文字に関わらず有効
p 二次元配列.sort {|前の配列,後の配列| 後の配列[1] <=> 前の配列[1]}
# sort_by()バージョン１
# 昇順.reverse
# 値が数値、文字に関わらず有効
p 二次元配列.sort_by {|配列| 配列[1]}.reverse
# sort_by()バージョン２
# -x
# 値が数値のみ有効
p 二次元配列.sort_by {|配列| -配列[1]}


# 二次元配列をベクトル的に行・列を入れ替える
example1_arry = example2_arry.transpose
#具体例　配列として次のような配列を考えてみます。
ary = [[1, 2], [3, 4], [5, 6]]
#この配列は3つの要素を持ち、それぞれが2つの要素を持つ配列となっています。この配列を次のような行列と見なします。
ary =[[1, 2],
      [3, 4],
      [5, 6]]
#「transpose」メソッドを使うと配列を行列と見なした場合の行と列を入れ替えます。
ary =[[1, 3, 5],
      [2, 4, 6]]
#「transpose」メソッドを使う場合には元の配列の各要素が行列として成り立つように要素数などが同じでなければなりません。

#map メソッドの記述方法
#要素がひとつずつ取り出され変数に要素が代入されていき、指定した変数名をブロック内で使用する
example_arry.map { |変数|
  # 実行したい処理
}
#ハッシュにも map を適用することができます。
h = { "apple" => 100, "orange" => 200, "grape" => 300 }
p h.map { |key, value| [key, value * 2] }
# [["apple", 200], ["orange", 400], ["apple", 600]]

h = { "apple" => 100, "orange" => 200, "grape" => 300 }
p h.map { |key, value| [key, value * 2] }
# [["apple", 200], ["orange", 400], ["apple", 600]]
#上の例では、ハッシュのキーが「key」に代入され、値が「value」に代入されていき、ブロック内の処理が繰り返されていきます。
#ハッシュで map を使用する場合でも戻り値は配列であることに注意
#to_h メソッドを利用することで戻り値の配列をハッシュに変換
h = { "apple" => 100, "orange" => 200, "grape" => 300 }
p h.map { |key, value| [key, value * 2] }.to_h
# {"apple"=>200, "orange"=>400, "grape"=>600}
#各要素にメソッドを適用するときは以下のように省略
オブジェクト.map(&:メソッド名)

#各要素において、x(変数)よりも大きな値の要素の数
 parent_arry.count { |child_arry| child_arry > x }
# 配列の各要素の大きさを調べる

# 2次元配列 大きさ順に並び替え
example_arry.sort!{ |a,b| b[1] <=> a[1] }

# 配列をindexと一緒に出力
# each_with_indexの場合 indexは0から
array = ["Ruby", "PHP", "Python"]
array.each_with_index do |element, index|
  p "#{index}：#{element}"
end
#以下の様に出力
0：Ruby
1：PHP
2：Python

#each.with_indexの場合 indexは1から
array = ["Ruby", "PHP", "Python"]
array.each.with_index(1) do |element, index|
  p "#{index}：#{element}"
end
#以下の様に出力
1：Ruby
2：PHP
3：Python

#beginとrescueの間の処理で問題が起きたら、エラーでストップせずにrescueとend内の処理を行ってくれる。
begin
  1 / 0 #エラー発生→普通なら処理が止まる
rescue
  puts "何か問題が発生しました。" #エスケープできる
end

#aiseは例外を発生してくれるらしい。特に指定しなければRuntimeErrorを発生させるとのこと。
raise "RunTimeError??"
#=> main.rb:1:in `<main>': RunTimeError?? (RuntimeError)

#配列内の要素の順位付け
class Array
  def rank
    # 以下の場合は例外スロー
    # - 自身配列が空
    # - 自身配列に数値以外の値を含む
    raise "Self array is nil!" if self.size == 0
    self.each do |v|
      raise "Items except numerical values exist!" unless v.to_s =~ /[\d\.]+/
    end

    # ランク付け
    self.map { |v| self.count { |a| a > v } + 1 }
  end
end
#出力
a = [9, 3, 2, 7, 1, 6, 8, 5, 10, 4]
p a.rank
[2, 8, 9, 4, 10, 5, 3, 6, 1, 7]

# ヒアドキュメント
ヒアドキュメントとは一言で言うと、「文字列をプログラミングに埋め込むためのもの」
普通の文字列の表現と違い、改行も埋め込むことができるので、より柔軟に文字列を扱える
特にRubyの場合、改行は普通だと文の終了だと見なされるますがヒアドキュメントによって、改行した複数行の文字列をプログラムに使用できる

p <<-EOF
ruby
python
java
EOF
# =>"ruby\npython\njava\n"


# ===演算子(オブジェクトが同じか判定？)
String === "hello" #"hello"はStringクラスのインスタンスなのでtrue
=> true 

String === [] #[]はArrayクラスのインスタンスなのでfalse
=> false 

Array === [] #[]はArrayクラスのインスタンスなのでtrue
=> true 

# 入力例: 3 5 7
# 入力値を整数の配列に
input_line = gets.chomp.split().map( &:to_i )

# 多重代入(可読性が増す)
sister, brother = ["Lily", "Jack"]
# 入力値から直接でもいける
sister, brother = gets.chomp

# Rubyのメソッドでは、最後に評価された値が返る
# 後置ifでは注意が必要
def hoge(is_hoge)
  "fuga"
  "hoge" if is_hoge
end
hoge(true) # "hoge"
hoge(false) # nil
# なんとなくhoge(false)でfugaが帰って来そうですが、最後で評価された値が返るのでnilが返る
# 後置ifでは、ifの右側の値が評価されたあと、trueならば左側が評価されます。
# falseであればnilを返します。

例の場合、hoge(false)でif is_hogeは成立しないので、左側のfugaは評価されず、
"hoge" if is_hogeが最後に評価された値となり、nilを返します。

# コードの効率化
# 処理が遅い(多い)例
(n - k + 1).times do |i|
    i_average = 0
    # 区間k日分足して平均値を求める
    k.times do |j|
        a_list[i + j]
        i_average += a_list[i + j].to_f
    end
    average.append(i_average / k)
end

# はじめのk個の区間の要素の合計を求める
# 効率化した例(各区間で合計値を求めるのに1回四則演算多い)
k = 5 #要素の数
n = 3 #区間の要素数
a_list = [1 2 3 2 1]
k.times do |i|
    tmp += a_list[i]
end
average.push(tmp)

# 2番目以降の区間の要素の合計を求める
((n - k + 1) - 1).times do |i|
    tmp = average[i] + a_list[k + i] - a_list[i]
    average.push(tmp)
end

#=> ["Lily", "Jack"]
"私の家族の名前には、#{sister}と#{brother}がいます。"
#=> "私の家族の名前には、LilyとJackがいます。"

# 数値の特定の桁の値を取得
# 文字列の特定の文字数目の値の取得にも使える
a = 195283
a = a.to_s #文字列に変換
p a % 10000 #10000で割った時の値を取得(↓と同じ)
p a[2..5].to_i # 下4桁の数値をintegerにして取得


# 配列の各要素が条件を満たすか調べる
# 配列に1つ以上、条件を満たす要素があるか調べるにはArray#any?を使う。
p [1, 2, 3].any?{|i| i % 2 == 0} #=> true
p [1, 3, 5].any?{|i| i % 2 == 0} #=> false
#配列のすべての要素が、条件を満たしているか調べるにはArray#all?を使う。
p [1, 2, 3].all?{|i| i % 2 == 0} #=> false
p [2, 4, 6].all?{|i| i % 2 == 0} #=> true
# 配列に1つだけ、条件を満たす要素があるか調べるにはArray#one?を使う。
p [1, 2, 3].one?{|i| i % 2 == 0} #=> true
p [2, 4, 6].one?{|i| i % 2 == 0} #=> false
# 配列のすべての要素が、条件を満たしていないことを調べるにはArray#none?を使う。
p [1, 2, 3].none?{|i| i % 2 == 0} #=> false
p [1, 3, 5].none?{|i| i % 2 == 0} #=> true

# 配列の作成
array1 = Array.new(3)
array2 = Array.new
array1 = [nil, nil, nil]

# 同じ要素(オブジェクト)を持った配列の作成
array = Array.new(3, "Red") 全て同じオブジェクト!! 一つ変更すると全て変更される
array1 = ["Red", "Red", "Red"]#同じオブジェクト

# 配列 異なるオブジェクトの要素を持つ配列の作成
array = Array.new(3){"Red"}
array1 = ["Red", "Red", "Red"]#異なるオブジェクト

# 繰り返し処理による入れうtの作成(要素を指定して作成)
array = Array.new(3){|index|
  "#{index}"
}
array = ["0", "1", "2"]

# 多次元配列の作成
# 間違い！！！！！！！
a = Array.new(3, Array.new(3, 0) )
#変更前
p a
#変更前
[[0, 0, 0], [0, 0, 0], [0, 0, 0]]
#第一要素の配列の変更 0 => 5
a[0][0] = 5
p a #=> [[5, 0, 0], [5, 0, 0], [5, 0, 0]]
#変更後
# 最初の初期化で全て同じ配列オブジェクトを参照してしまっているため
# mapメソッドを使って解決
a = Array.new(3).map{Array.new(3,0)}
p a #=> [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
a[0][0] = 5
p a #=> [[5, 0, 0], [0, 0, 0], [0, 0, 0]]

# 多次元配列は操作が面倒なので出来るだけ一次配列で行ったほうが良さそう
#配列内に配列を挿入(多次元配列になる)
example1_arry.push(example2_arry)

# 二次元配列をベクトル的に行・列を入れ替える
example1_arry = example2_arry.transpose
#具体例　配列として次のような配列を考えてみます。
ary = [[1, 2], [3, 4], [5, 6]]
#この配列は3つの要素を持ち、それぞれが2つの要素を持つ配列となっています。この配列を次のような行列と見なします。
ary =[[1, 2],
      [3, 4],
      [5, 6]]
#「transpose」メソッドを使うと配列を行列と見なした場合の行と列を入れ替えます。
ary =[[1, 3, 5],
      [2, 4, 6]]
#「transpose」メソッドを使う場合には元の配列の各要素が行列として成り立つように要素数などが同じでなければなりません。
# 配列同士をベクトル的に計算(要素同士を四則演算)
arry1 = [1, 2, 3]
arry2 = [1, 2, 3]
p [arry1,arry2].transpose.map{ |ele| ele.inject(:*) }
# => [1, 4, 9]

# 1次元配列と2次元配列をかけ合わせる
# pointとnumberの位置の同じ各要素をかけ合わせ
point =[1,2,3,4,5]
number =[[2,4,6,8,10],[1,3,5,7,11]]
number.zip(point).map{|n,p| n*p}
# => [[2, 4, 6, 8, 10], [1, 3, 5, 7, 11, 1, 3, 5, 7, 11]]

# 2次元配列同士をかけ合わせる
# number1とnumber2の位置の同じ各要素をかけ合わせ
number1 =[[2,4,6,8,10],[1,3,5,7,11]]
number2 =[[2,4,6,8,10],[1,3,5,7,11]]
number1.map.with_index { |element, index|
  number3 = [number2[index], element].transpose.map { |ele| ele.inject(:*) }
}
# => [[4, 16, 36, 64, 100], [1, 9, 25, 49, 121]]

# 1次配列の要素の合計
[1,2,3,4,5].sum
[1,2,3,4,5].inject(:+)
#=> 15

# n回のループ処理(繰り返し処理)をおこなう
# 回数分のループ処理をおこなう
n.times do
  query = gets.chomp
  # それぞれ取得した変数へ実行したい処理
end

#map メソッドの記述方法
#要素がひとつずつ取り出され変数に要素が代入されていき、指定した変数名をブロック内で使用する
example_arry.map { |変数|
  # 実行したい処理
}
# 何でもeachでやるのは非効率
# 具体的な処理をループの中に記述するという意味では実はeachはforと本質的に変わりません。何でもeachでループ処理する癖を直さないと、forでやるのと同じく、C言語的な手続き型の発想に囚われたままになってしまう

# 以下は配列[1, 2, 3, 4, 5]の各要素を倍にしたものを返すコード
# わざわざループの外でdouble = []という配列を用意して、さらにループの中でdouble << i * 2とdoubleに追加するところまで書くのは、他の言語ならともかく、Ruby的には非常にイケてない冗長な書き方
list = (1..5).to_a.freeze

double = []        # 空のdoubleをわざわざ用意している☹️
list.each do |i|
  double << i * 2  # doubleの組み立てまでやっている☹️
end
# 上下同じ処理
list = (1..5).to_a.freeze

mapped = list.map do |i|
  i * 2                  # やりたいことはこれだけ😄
end
# 変数を用意する必要がない
puts "2倍したリスト: #{mapped}"


#ハッシュにも map を適用することができます。
h = { "apple" => 100, "orange" => 200, "grape" => 300 }
p h.map { |key, value| [key, value * 2] }
# [["apple", 200], ["orange", 400], ["apple", 600]]

h = { "apple" => 100, "orange" => 200, "grape" => 300 }
p h.map { |key, value| [key, value * 2] }
# [["apple", 200], ["orange", 400], ["apple", 600]]
#上の例では、ハッシュのキーが「key」に代入され、値が「value」に代入されていき、ブロック内の処理が繰り返されていきます。ハッシュで map を使用する場合でも戻り値は配列であることに注意
#to_h メソッドを利用することで戻り値の配列をハッシュに変換
h = { "apple" => 100, "orange" => 200, "grape" => 300 }
p h.map { |key, value| [key, value * 2] }.to_h
# {"apple"=>200, "orange"=>400, "grape"=>600}
#各要素にメソッドを適用するときは以下のように省略
オブジェクト.map(&:メソッド名)
# ハッシュではmap!が使えないので変数を用意してあげる必要がある↑

#各要素において、x(変数)よりも大きな値の要素の数
parent_arry.count { |child_arry| child_arry > x }
# 配列の各要素の大きさを調べる

# 2次元配列 大きさ順に並び替え
example_arry.sort!{ |a,b| b[1] <=> a[1] }

# 配列に格納されている各要素を逆の順場に並び替える方法
ary = [1, 2, 3, 4, 5]
newary = ary.reverse
# =>[5, 4, 3, 2, 1]
ary = [1, 2, 3, 4, 5]
ary.reverse!
# =>[5, 4, 3, 2, 1]

# 配列をindexと一緒に出力
array = ["Ruby", "PHP", "Python"]
array.map.with_index { |element, index|
  p "#{index}：#{element}"
 }
 #以下の様に出力
 0：Ruby
 1：PHP
 2：Python

 array.each_index{|index|
   puts index
 }
 0
 1
 2

# 配列をindexと一緒に出力
# each_with_indexの場合 indexは0から
array.each_with_index do |element, index|
  p "#{index}：#{element}"
end
#以下の様に出力
0：Ruby
1：PHP
2：Python

#each.with_indexの場合 indexは1から
array.each.with_index(1) do |element, index|
  p "#{index}：#{element}"
end
#以下の様に出力
1：Ruby
2：PHP
3：Python

# 多次元配列での要素のインデックスの検索
arr = [[1,2],[3,4],[5,6]]
arr.each_with_index {|c,i|
    arr[i].each_with_index{|c,j|
        p i,j if (6 == arr[i][j]) # => 2 1
    }
}

# 途中でループを抜ける(中断する)
[1,2,3,4].each do |num|
  break if num ==3
  p num
end
# -> 1 2

# ループ処理内でのnext以降の処理を一回分飛ばす
[1,2,3,4].each do |num|
  next if num ==3
  p num
end
# -> 1 2 4

# 繰り返し処理を中断して、最初からやり直します。
[1,2,3,4].each do |num|
  redo if num ==3
  p num
end
# -> 1 2 4 1 2 4 1 2 4 ....


#beginとrescueの間の処理で問題が起きたら、エラーでストップせずにrescueとend内の処理を行ってくれる。
begin
  1 / 0 #エラー発生→普通なら処理が止まる
rescue
  puts "何か問題が発生しました。" #エスケープできる
end

#aiseは例外を発生してくれるらしい。特に指定しなければRuntimeErrorを発生させるとのこと。
raise "RunTimeError??"
#=> main.rb:1:in `<main>': RunTimeError?? (RuntimeError)

#配列内の要素の順位付け
class Array
  def rank
    # 以下の場合は例外スロー
    # - 自身配列が空
    # - 自身配列に数値以外の値を含む
    raise "Self array is nil!" if self.size == 0
    self.each do |v|
      raise "Items except numerical values exist!" unless v.to_s =~ /[\d\.]+/
    end

    # ランク付け
    self.map { |v| self.count { |a| a > v } + 1 }
  end
end
#出力
a = [9, 3, 2, 7, 1, 6, 8, 5, 10, 4]
p a.rank
[2, 8, 9, 4, 10, 5, 3, 6, 1, 7]

# 日付・日時の操作
# 日付を扱うためのオブジェクト
# 組み込みクラスでないのでrequireが必要
require "date" #DateとDateTimeを扱えるように
# 日付操作
puts Date.new(2007, 5 ,30)
# =>2007-05-30
puts Date.today
# =>2020-02-19
d = Date.today # today or new でオブジェクト作成?
puts d.strftime("%フォーマット")
# %の後の1文字でフォーマット指定
# 例
str = d.strftime("%Y年 %m月 %d日")
# 現在日時を「xxxx年 xx月 xx日」と言うフォーマットで文字列として取得出来ます。


puts DateTime.new(2007, 5 ,30, 16, 20, 45, 0.375)
# =>2007-05-30T16:20:45+09:00
d = DateTime.now # now or new でオブジェクト作成?
puts d.strftime("%フォーマット")
# %の後の1文字でフォーマット指定
# 例
str = d.strftime("%Y年 %m月 %d日 %H時 %M分 %S秒")
# 上記の場合は現在日時を「xxxx年 xx月 xx日 xx時 xx分 xx秒」と言うフォーマットで文字列として取得出来ます。

# 2次元配列を配列ごとに出力
array_2 = [["p","l","e","a","s","e"],["h","e","l","p"],["m","e"]]

array_2.each {|x|
  puts x.join(" ")
}
# 配列をある要素数づつに分ける
(1..10).each_slice(3) {|a| p a}
    # => [1, 2, 3]
    #    [4, 5, 6]
    #    [7, 8, 9]
    #    [10]
# 配列を1行にすべての要素を出力
array_1 = ["p","l","e","a","s","e"]
puts array1.join(" ")

# 四捨五入
# 切り捨て
1.4.floor # 1
1.5.floor # 1
-1.4.floor # -2
-1.5.floor # -2
# レシーバのオブジェクトがマイナスの時は注意が必要です。より小さい方の整数へと丸める。よって-1.4は-2となる
num3 = -1.2.truncate #=> -1
# truncateメソッドはより０に近い整数へと丸めますから、-1となるのです。to_i メソッドと同じ
# 小数点以下 N 桁の切り捨て
# Float クラスの floor メソッドでは、小数点以下の桁数は指定できません。そのため、数値を一度 BigDecimal に変換したのち、floor メソッドを指定します。floor メソッドの引数には小数点以下の桁数を指定します。
require 'bigdecimal'
BigDecimal(1.23456.to_s).floor(2).to_f # 1.24
BigDecimal(1.23456.to_s).floor(3).to_f # 1.234

require 'bigdecimal'
BigDecimal(1.23456.to_s).floor(2).to_f # 1.24
BigDecimal(1.23456.to_s).floor(3).to_f # 1.234
# BigDecimal のオブジェクトを生成するときは、引数に String を指定しなければならないので、to_s で Float を String に変換しています。さらに最後に to_f で Float に戻しています。

#切り上げ
#浮動小数点数の切り上げを行う場合は、Float クラスの ceil メソッドを使用します。
1.4.ceil  # 2
1.5.ceil  # 2
-1.4.ceil # -1
-1.5.ceil # -1
#浮動小数点数が負数の場合は、絶対値が小さい方に丸められます。

#小数点以下 N 桁の切り上げ
#小数点以下 N 桁の切り上げを行うときは、切り捨てのときと同様に BigDecimal を使用します。
require 'bigdecimal'
BigDecimal((1.23456).to_s).ceil(2).to_f # 1.24
BigDecimal((1.23456).to_s).ceil(3).to_f # 1.235

# 四捨五入
# 数値を四捨五入する場合は、 round メソッドを使用します。
1.4.round # 1
1.5.round # 2
-1.4.round # -1
-1.5.round # -2
# 小数点以下 N 桁の四捨五入
# round メソッドは引数に桁数を指定することができます。また、整数部の四捨五入を行いたい場合は、引数に負数を指定します。
1.23456.round(2) # 1.23
1.23456.round(3) # 1.235
123456.round(-2) # 123500
123456.round(-3) # 123000

# module
# Mix-inで機能を提供する、名前空間（メソッドやクラス、定数の名前を管理する単位）を
# 提供するといった目的で使用 (処理をまとめたパーツ)

eval
#与えられた文字列をそのままRubyのコードとして解釈して実行する
eval(評価する式 [,Bindingオブジェクト, ファイル名, 行番号])
#このうち、第１引数以外は省略可能
#第２引数のBindingオブジェクトとは、そのメソッドや変数が属する「文脈（スコープ）」が保存されているオブジェクト
def sample
  a = 1
  binding ##fooの　Binding オブジェクトを生成して返す
end
eval("p a")
#=> undefined local variable or method `a'
eval("p a", sample)
#=> 1
#トップレベルから eval メソッドで sample メソッドのローカル変数 a を参照しようとしても、 undefined エラーとなります。ですが、sample メソッドの Binding オブジェクトを第二引数で指定することで、変数 a を参照することができます。

&.
レシーバーがnilの時にNoMethodErrorではなくnilを返す！

# ブロック付きメソッド
def myloop
  while true
      yield
  end
end

num = 1

myloop do
  puts "num is #{num}"
  break if num > 10
  num *= 2
end
# => myloopでブロックを定義(myloop do で以下の処理が行われる？？)
def myloop
  while true
    puts "num is #{num}"
    break if num > 10
    num *= 2
  end
end


# 値渡し(call by value: 変数の値をコピーする渡し方)

# 値渡しでは、変数の値が引数にコピーされるため、次のような性質がある
# 引数 a と b を変更しても、それが変数 x と y には反映されない
def foo(a, b)     # a, b を「仮引数」という(x, yの値がコピーされるだけ: メモリ番地(参照)は渡されない！)
  a += 1
  b += 2          # a と b を変更する
end

x = 10
y = 20
foo(x, y)         # x, y を「実引数」という
puts x            #=> 10  # 変更されてない
puts y            #=> 20  # 変更されてない


# 参照の値渡し(call by reference: 変数のメモリ番地を渡す渡し方)
# 参照渡しではない！
# 共有渡し (call by sharing) とも言われる
# あたかも変数が共有されたような状態になる

def bar(arr)       # 変数 numbers の値(参照:メモリ番地)が引数 arr へコピーされている
  arr[0] += 1      # そのため、変数 numbers と引数 arr は同じオブジェクトを共有している 状態
end

numbers = [10, 20]
bar(numbers)      # 配列の 10 の値が変更される
puts numbers      #=> [11, 20]   # 中身が変更されている!

## 変数 numbers が指す配列オブジェクトを変更する
## (変数 numbers の値は変わらない)
numbers[0] = 11

## 変数 numbers の値を、新しい配列オブジェクトの
## メモリ番地に変更する
numbers = [11, 12]


