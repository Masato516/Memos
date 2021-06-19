def hoge(arg)
  arg
end

p hoge({a: 1, b: 2})
p hoge(a: 1, b: 2)


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