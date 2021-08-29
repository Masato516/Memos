# 4点
num_of_steps = gets.chomp.to_i

answer_arr = []

if num_of_steps <= 49
  # 必要な横のマス数
  width_required = num_of_steps + 1
  # 必要なマス数は最小の２
  height_required = 2
  # 必要な横のマス数分の配列を作成
  first_row = Array.new(width_required, '.')
  first_row[0] = 'S'
  first_row[num_of_steps] = 'G'
  second_row = Array.new(width_required, '.')
  answer_arr.push(first_row, second_row)
elsif num_of_steps <= 98
  # 必要な横のマス数を最大の50を利用
  width_required = 50
  num_of_vertical_steps = height_required - 49
  height_required = num_of_vertical_steps + 1
  first_row = Array.new(width_required, '.')
  first_row[0] = 'S'
  answer_arr.push(first_row)
  height_required.times do 
    answer_arr << Array.new(50, '.')
  end
  answer_arr[num_of_vertical_steps][0] = 'G'
end

puts [height_required, width_required].join(" ")
answer_arr.each { |column| puts column.join("") }






num_of_column = gets.chomp.to_i

table = []

num_of_column.times do
  column = gets.chomp.chars
  table << column
end

answer = "No"

table.each do |column|
  answer = "Yes" if column.all? { |cell| cell == "o" }
end

table.transpose.each do |row|
  answer = "Yes" if row.all? { |cell| cell == "o" }
end



righe_diagonal_square = []
left_diagonal_square = []

table.each_with_index do |column, index|
  righe_diagonal_square << column[index]
  left_diagonal_square << column.reverse[index]
end


answer = "Yes" if righe_diagonal_square.all? { |cell| cell == "o" }
answer = "Yes" if left_diagonal_square.all? { |cell| cell == "o" }

puts answer




num_of_column = gets.chomp.to_i

table = []

num_of_column.times do
  column = gets.chomp.chars
  table << column
end

answer = "No"

table.each do |column|
  answer = "Yes" if column.all? { |cell| cell == "○" }
end

table.transpose.each do |row|
  p answer = "Yes" if row.all? { |cell| cell == "○" }
end



righe_diagonal_square = []
left_diagonal_square = []

table.each_with_index do |column, index|
  righe_diagonal_square << column[index]
  left_diagonal_square << column.reverse[index]
end

# p righe_diagonal_square
# p left_diagonal_square

answer = "Yes" if righe_diagonal_square.all? { |cell| cell == "○" }
answer = "Yes" if left_diagonal_square.all? { |cell| cell == "○" }

puts answer


price, postage = gets.chomp.split().map( &:to_i )

if price >= 3000
  if postage <= 700
    postage = 0
  elsif postage > 700
    postage -= 700
  end
elsif price < 3000
  if postage <= 700
    postage /= 2
  elsif postage > 700
    postage -= 350
  end
end

puts price + postage


postage > 700 ? (postage -= 700) : (postage = 0)

postage > 700 ? (postage -= 350) : (postage /= 2)



### pixiv コーディングテストで教えてもらった書き方
hoge("GET", "/hello") == ["200 OK", "こんにちは"]
hoge("GET", "/aaa") == ["404 NotFound", "ないです"]

responses = {
  ["GET", "/hello"]: ["200 OK", "こんにちは"]
}

def hoge(method, path)
    responses[[method, path]]
    if method == "GET" && path == "/hello"
        ["200 OK", "こんにちは"]
    elsif method == "GET" && path == "/bye"
        ["200 OK", "さよなら"]
    elsif method == "POST" && path == "/bye"
        ["200 OK", "ばいばい"]
    else
        ["404 NotFound", "ないです"]
    end
end


def hello(method)
    if method == "GET"
      .. 
    end
end

##################################




array = [1,2,2,3]

p array.permutation(4).to_a


# Arrayクラスに入れ替えを行なうメソッドを追加
class Array
  def swap!(a, b)
    self[a], self[b] = self[b], self[a]

    self
  end

  def swap(a, b)
    self.dup.swap!(a, b)
  end
end


input_line = gets.chomp.split(" ").map(&:to_i)
# たて線の数とよこ線の数を取得
side_num, vertical_num = input_line
# よこ線のスタートする線の位置
start_point_arr = gets.chomp.split(" ").map(&:to_i)
# あみだくじの下の番号
target_numbers = gets.chomp.split(" ").map(&:to_i)

## 本来あるべき下の番号を求める
# 上の番号を生成
upper_numbers = (1..side_num).to_a
# たて線の数だけ数値の入れ替えをおこなう
i = 0
while i < vertical_num
  start_point = start_point_arr[i]
  upper_numbers.swap!(i, i+1)
  i += 1
end
answer_numbers = upper_numbers

swap_point = []
answer_numbers.map.with_index {|number, index|
  swap_point << index if number != target_numbers[index]
}

# # 両隣の数値を入れ替えるだけで済む場合
# if swap_point.length == 2 && (swap_point[1] - swap_point[0]) == 1
#   answer_point = vertical_num + 1, swap_point[0] + 1
# # 
# # elsif 

# # 入れ替えることが出来ない場合
# else
#   answer_point = -1
# end

# puts answer_point


# # Arrayクラスに入れ替えを行なうメソッドを追加
# class Array
#   def swap!(a, b)
#     raise ArgumentError unless a.between?(0, self.count-1) && b.between?(0, self.count-1)

#     self[a], self[b] = self[b], self[a]

#     self
#   end

#   def swap(a, b)
#     self.dup.swap!(a, b)
#   end
# end

# input_line = gets.chomp.split(" ").map(&:to_i)
# # たて線の数とよこ線の数を取得
# side_num, vertical_num = input_line
# # よこ線のスタートする線の位置
# start_point_arr = gets.chomp.split(" ").map(&:to_i)
# # あみだくじの下の番号
# target_numbers = gets.chomp.split(" ").map(&:to_i)

# ## 本来あるべき下の番号を求める
# # 上の番号を生成
# upper_numbers = (1..side_num).to_a
# # たて線の数だけ数値の入れ替えをおこなう
# i = 0
# while i < vertical_num
#   start_point = start_point_arr[i]
#   upper_numbers.swap!(i, i+1)
#   i += 1
# end
# answer_numbers = upper_numbers

# swap_point = []
# answer_numbers.map.with_index {|number, index|
#   swap_point << index if number != target_numbers[index]
# }

# if swap_point.length == 2 && (swap_point[1] - swap_point[0]) == 1
#   answer_point = vertical_num + 1, swap_point[0] + 1
# else
#   answer_point = -1
# end

# puts answer_point




# num_of_people = gets.chomp.to_i

# initial_pair_arry = []
# i = 0
# while i < num_of_people
#   initial_pair = gets.chomp.split(" ").map(&:to_i)
#   initial_pair_arry.push(initial_pair)
#   i += 1
# end

# num_of_match = 0
# i = 0
# # 名前のペアの数、ループ処理を実施
# while i < num_of_people - 1
#   j = 1
#   while j < num_of_people - i
#     if initial_pair_arry[i] == initial_pair_arry[i+j].reverse
#       num_of_match += 1
#       initial_pair_arry.delete_at(i+j)
#       num_of_people -= 1
#       break
#     end
#     j += 1
#   end
  
#   i += 1
# end

# puts num_of_match


# num_of_people
#  = gets.chomp.to_i

# name_arry = []
# i = 0
# while i < num_of_people
#   イニシャル = gets.chomp.split(" ")
#   name_arry.push(イニシャル)
#   i += 1
# end

# match_num = 0
# i = 0
# while i < num_of_people
#   if name_arry[i][0] == name_arry[i+1][1] && name_arry[i][1] == name_arry[i+1][0]
#     match_num += 1
#     num_of_people -= 1
#   end
#   i += 1
# end

# puts match_num

# # 同じ位置だけ見比べる
# arr1.zip(arr2).select{ |a, b| a[0..1] == b[0..1] }.map(&:first)

# # 全部比較する
# hash1 = arr1.group_by{ |arr| arr[0..1] }
# hash2 = arr2.group_by{ |arr| arr[0..1] }
# hash1.values_at(*hash1.keys & hash2.keys).flatten(1)


# class Num2Eng
#   # 数字と英語を結びつける
#   NUM_ENG = {
#       '0' => 'zero',
#       '1' => 'one',
#       '2' => 'two',
#       '3' => 'three',
#       '4' => 'four',
#       '5' => 'five',
#       '6' => 'six',
#       '7' => 'seven',
#       '8' => 'eight',
#       '9' => 'nine',
#       '10' => 'ten',
#       '11' => 'eleven',
#       '12' => 'twelve',
#       '13' => 'thirteen',
#       '14' => 'fourteen',
#       '15' => 'fifteen',
#       '16' => 'sixteen',
#       '17' => 'seventeen',
#       '18' => 'eighteen',
#       '19' => 'nineteen',
#       '20' => 'twenty',
#       '30' => 'thirty',
#       '40' => 'fourty',
#       '50' => 'fifty',
#       '60' => 'sixty',
#       '70' => 'seventy',
#       '80' => 'eighty',
#       '90' => 'ninety'
#   }

#   def get (num)
#     if num.size == 1
#       NUM_ENG[num]
#     elsif num.size == 2
#       get_ten(num)

#     elsif num.size == 3
#       get_hundred(num)
#     elsif num.size == 4
#       get_thousand(num)
#     end
#   end

#   private
#   def get_one (num)
#     NUM_ENG[num]
#   end

#   def get_ten (num)
#     if num.to_i < 20
#       NUM_ENG[num]
#     elsif num.to_i % 10 == 0
#       NUM_ENG[num]
#     else
#       NUM_ENG[num[0] + '0'] + '-' + NUM_ENG[num[1]]
#     end
#   end

#   def get_hundred (num)
#     if num.to_i % 100 == 0
#       NUM_ENG[num[0]] + ' hundred'
#     else
#       NUM_ENG[num[0]] + ' hundred ' + get_ten(num[1..2])
#     end
#   end

#   def get_thousand (num)
#     if num.to_i % 1000 == 0
#       NUM_ENG[num[0]] + ' thousand'
#     elsif num.to_i % 100 == 0
#       get_ten(num[0..1]) + ' hundred'
#     else
#       get_ten(num[0..1]) + ' hundred ' + get_ten(num[2..3])
#     end
#   end

#   def get_million (num)
#     if num.to_i % 10000 == 0
#       NUM_ENG[num[0]] + ' thousand'
#     end
#   end
  

# end

# hoge = Num2Eng.new
# p hoge.get("100")

# rest_num = gets.chomp.to_i

# answer = ""

# billion_num = rest_num / 1000**3
# if billion_num >= 1
#   answer << 
# end
# rest_num = rest_num % 1000**3

# million_num = rest_num / 1000**2
# if million_num >= 1
#   answer << 
# end
# rest_num = rest_num % 1000**2

# thousand_num = est_num % 1000**1
# if thousand_num >= 1
  
#   answer << 
# end
# rest_num = rest_num % 1000*1

# one_num = rest_num % 1
# if one_num >= 1
  
#   answer << 
# end
# rest_num = rest_num % 1




# # CSVライブラリを読み込む
# require 'csv'
# # 入力値を取得
# output_type = ARGV[0]
# file_name   = ARGV[1]
# # 科目数
# subjects_num = 6

# # 落第者のIDを出力する場合
# if output_type == "dropouts"
#   puts "ID" # ヘッダー
#   # CSVデータの各行を出力
#   CSV.foreach(file_name, headers: true) do |csv|
#     # 点数をINTに変換し、scoreに代入
#     scores = csv[1..6].map(&:to_i)
#     # 49点以下の数を取得
#     failure_num = scores.each.count{|n| n <= 49}
#     if failure_num >= 2 #49点以下のテストが２つ以上ある時
#       puts csv["ID"]
#     end
#   end

# # 最高平均点と最低平均点をとった学生のIDを出力
# elsif output_type == "top-vs-bottom"
#   high_score = 0 # 最高点を入れるための変数
#   low_score = 100 # 最低点を入れるための変数
#   mean_scores_table = [] # IDと平均値を入れる配列
#   # CSVデータの各行を出力
#   CSV.foreach(file_name, headers: true) do |csv|
#     id = csv["ID"]
#     # 点数をINTに変換し、各学生のテストの平均値を算出
#     mean_score = csv[1..6].map(&:to_i).sum.fdiv(subjects_num)
#     # 最高点を取得(今までの平均値で最も大きい値を代入)
#     high_score = mean_score if mean_score > high_score
#     # 最低点を取得(今までの平均値で最も小さい値を代入)
#     low_score = mean_score if mean_score < low_score
#     # IDと平均値を配列に追加
#     mean_scores_table.append([id, mean_score])
#   end
#   # 答えを入れるための配列
#   answers = []
#   # idと平均値が入っている二次元配列の中で、最高点と最低点を持つidと点数をanswersに挿入
#   mean_scores_table.each do |arry|
#     id = arry[0]
#     mean_score = arry[1]
#     if mean_score == high_score 
#       answers.append([id, high_score])
#     elsif mean_score == low_score
#       answers.prepend([id, low_score])
#     end
#   end
#   # 答えの標準出力
#   puts "ID,Mean"
#   answers.each do |answer|
#     puts "#{answer[0]},#{sprintf("%2.2f", answer[1])}"
#   end
# end


# n    = gets.to_i  # 与えられる数値の数
# minv = gets.to_i  # １つ目の数値を代入
# num = gets.to_i  # 2つ目の数値を代入
# maxDiff = num - minv  # 2つ目の数値と１つ目の数値の差

# minv = num if num < minv  # １つ目の最小値を求める処理をおこなう

# (n - 2).times {
#   num = gets.to_i
#   # 現在の値と前の値の中で最小値を引いて、今までの差でも最も大きい値を代入
#   maxDiff = num - minv if (num - minv) > maxDiff
#   # 現在まで出てきた値の中で最も小さい値を代入
#   minv = num           if num < minv
# }

# puts maxDiff


# n    = gets.to_i
# minv = gets.to_i
# input_line = gets.to_i
# maxDiff = input_line - minv

# i = 0
# while i < n - 2
#   input_line = gets.to_i
#   # 現在の値と前の値の中で最小値を引いて、今までの差でも最も大きい値を代入
#   maxDiff = input_line - minv if (input_line - minv) > maxDiff
#   # 現在まで出てきた値の中で最も小さい値を代入
#   minv = input_line        if input_line < minv
#   i += 1
# end

# puts maxDiff

# puts maxv - minv

# for j が 1 から n-1 まで
#   for i が 0 から j-1 まで
#     maxv = (maxv と R[j]-R[i] のうち大きい方)


# minv = R[0]
# for j が 1 から n-1 まで
#   maxv = (maxv と R[j]-minv のうち大きい方)
#   minv = (minv と R[j] のうち小さい方)


# def isPrime(num)
#   if num == 2   # 2 は素数
#     return true
#   end

#   if num < 2 || (num % 2 == 0)  # 2未満 かつ 偶数であれば合成数
#     return false
#   end
#   # 3以上の場合、以下の処理を行なう
#   i = 3
#   # 合成数は p <= √x を満たす素因数p をもつ という性質を利用
#   while i <= Math.sqrt(num)
#     # 割り切れたら、合成数
#     if num % i == 0
#       return false
#     end
#     # 偶数は合成数なので、奇数のみで割る
#     i += 2
#   end
#   # 3以上で割り切れない数値は素数が確定する
#   return true
# end

# n = gets.chomp.to_i
# primeNum = 0
# i = 0
# while i < n
#   input_line = gets.chomp.to_i

#   if isPrime(input_line)
#     primeNum += 1
#   end
#   i += 1
# end

# puts primeNum

# insertionSort(A, N) # N個の要素を含む0-オリジンの配列A
#   for  i が 1 から N-1 まで  # 未ソートの部分列の先頭を示すループ変数
#     v = A[i]    # A[i]の値を一時的に保持しておくための変数
#     j = i - 1   # ソート済み部分列からvを挿入するための位置を探すループ変数

#     # i-1 番目に要素があり、かつi-1番目よりi番目の要素が小さいときはループ処理
#     while j >= 0 かつ A[j] > v
#       A[j+1] = A[j]   # 
#       j--
#     A[j+1] = v

# arry = [500, 100, 50, 10, 5, 1]

# arry.map {|コインの単位|
#   コインの枚数 += 入力値 / コインの単位
#   残りの金額 = 入力値 % コインの単位
# }
# # 100で割り切れた数値を入れる


# コインの枚数 = 残りの金額 / 100
# 残りの金額 = 残りの金額 % 100


# # 文字列が数字だけで構成されていれば true を返す
# def number?(str)
#   # 文字列の先頭(\A)から末尾(\z)までが「0」から「9」の文字か
#   nil != (str =~ /\A[0-9]+\z/)
# end

# p input_line = %w(8 3 3 * + 2 + 1 -)
# stack = []

# input_line.map{ |v|
#   # begin
#     if number?(v)
#       p stack.push(v)
#     elsif v == "+"
#       result = stack.pop(2).map( &:to_i ).inject(:+)
#       p stack.push(result)
#     elsif v == "-"
#       result = stack.pop(2).map( &:to_i ).inject(:-)
#       p stack.push(result)
#     elsif v == "*"
#       result = stack.pop(2).map( &:to_i ).inject(:*)
#       p stack.push(result)
#     elsif v == "++"
#       result = stack.pop(1)[0].to_i + 1
#       p stack.push(result)
#     elsif v == "@"
#       result = 0
#       stack.pop(3).map{|n|
#         result = stack.map( &:to_i ).inject(:*)
#       }
#       p stack.push(result)
#     end
    
#   # rescue
#     # puts "invalid"
#   # end
# }



# # 文字列が数字だけで構成されていれば true を返す
# def number?(str)
#   # 文字列の先頭(\A)から末尾(\z)までが「0」から「9」の文字か
#   nil != (str =~ /\A[0-9]+\z/)
# end

# input_line = gets.chomp.split()

# stack = []

# begin
#   input_line.map{ |v|
#       if number?(v)
#         stack.push(v)
#       elsif v == "+"
#         result = stack.pop(2).map( &:to_i ).inject(:+)
#         stack.push(result)
#       elsif v == "-"
#         result = stack.pop(2).map( &:to_i ).inject(:-)
#         stack.push(result)
#       elsif v == "*"
#         result = stack.pop(2).map( &:to_i ).inject(:*)
#         stack.push(result)
#       elsif v == "++"
#         result = stack.pop(1)[0].to_i + 1
#         stack.push(result)
#       elsif v == "@"
#         result = 0
#         stack.pop(3).map{|n|
#           result = stack.map( &:to_i ).inject(:*)
#         }
#         stack.push(result)
#       end
#   }
#   puts stack.pop
# rescue
#   puts "invalid"
# end

arry = [1, -2, 3]

result = 0
arry.map do |n|
  arry.unshift(1)
  result += n * arry.inject(:+)
end

p result

# p [1].inject(:+1)

# def hoge(arg)
#   arg
# end

# p hoge({a: 1, b: 2})
# p hoge(a: 1, b: 2)


# def hoge(a, b, c)
#   [a, b, c]
# end
# args1 = [10, 100]
# p hoge(1, *args1)

# def foo(x: 0, y: 0, z: 0, **args)
#   [x, y, z, args]
# end
# p foo             #=> [0, 0, 0, {}]
# p foo()           #=> [0, 0, 0, {}]
# p foo(i: 2, h: 6) #=> [0, 0, 0, {:i=>2, :h=>6}]


# def volume(x: , y: 1, z: 1)
#   [x, y, z]
# end
# p volume(x: 1, y:10)  # => [1, 10, 1]
# p volume(y: 10)       # => missing keyword: :x (ArgumentError)


# def foo(*args)
#   args
# end

# p foo(1)      #=> [1]
# p foo([1, 1]) #=> [1, 1]

# 元のリスト = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
#             "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
#             "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", 
#             "u", "v", "w", "x", "y", "z", ".", ",", "-", "!",
#             "?"]

# # 表として利用する配列の作成
# カタログ = []
# h = 0
# while h < 20
#   カタログ += 元のリスト
#   h += 1
# end

# p カタログ[23]

# # 与えられた文字からインデックスを取得
# 問題の文字配列 = %w[c g 0 x m k 4 . ! x]

# 問題のインデックス配列 = 問題の文字配列.map! do |文字|
#   element = 問題のインデックス配列 = 元のリスト.index(文字)
# end

# p 問題のインデックス配列

# # 与えられた文字をインデックスに変換
# カタログのインデックス = 0
# 問題の文字のインデックス = 0
# 問題の文字のインデックス配列 = []
# # 文字
# カタログ.each_with_index do |カタログの文字, カタログのインデックス|
#   # 問題の文字とカタログの文字を比較
#   # 一致した場合は問題の文字を１つ先にすすめる
#   if 問題の文字配列[問題の文字のインデックス] == カタログの文字
#     問題の文字のインデックス += 1
#     問題の文字のインデックス配列 << カタログのインデックス
#   end
#   # 全ての問題の文字を評価し終えた場合は終了
#   if 問題の文字のインデックス == 問題の文字配列.size - 1
#     break
#   end
# end
# p 問題の文字のインデックス配列

# def main(lines)
#   # このコードは標準入力と標準出力を用いたサンプルコードです。
#   # このコードは好きなように編集・削除してもらって構いません。

#   lines.each_with_index do |line,i|
#     puts "line[#{i}]: #{line}"

#     # SとGの場所を探索
#     grids = line.chars() # 1文字ずつ配列に変換
    


#   end
# end

# main(readlines)






























# def is_1st_caps?
#     hoge = "Bにちわ"

#     if /^[A-Z]/ =~ hoge
#         puts true
#     else
#         puts false
#     end
# end

# is_1st_caps?

# # 問題1
# i = 0
# while i < 2020
#     if i % 400 == 0 # 400で割り切れる時
#         puts i
#     elsif i % 100 != 0 # 100で割り切れない時
#         puts i
#     end

#     i += 4
# end

# # 問題2
# i = 2
# while i <= 1000
#     if 
        
#     end
    

#     i += 1
# end

# # 問題3
# num = 0
# i = 0
# while i <= 9999
#     # 数値を文字列にして配列に入れる
#     num_arry = i.chars

#     # 7があった場合
#     num_arry.map{ |e|
#         if e == "7"
#             num += 1
#         end
#     }
#     i += 1
# end

# puts num