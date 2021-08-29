



# num_of_integer = gets.chomp.to_i
# arr = []
# (1..num_of_integer).each do
#   input_line = gets
#   # プラスの値であれば、配列に挿入
#   if input_line[0] != "-"
#     arr << input_line.chomp.to_i
#   end
# end

# if arr.empty?
#   arr << 2
# end

# # 最大値を探索
# i = 1
# while i <= arr.max
#   break unless arr.include?(i)
#   i += 1
# end
# puts i




# primeNumbers = [
#   2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109,
#   113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239,
#   241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
#   383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521,
#   523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661,
#   673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827,
#   829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991,
#   997, 1009, 1013, 1019, 1021, 1031, 1033, 1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103, 1109,
#   1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259,
#   1277, 1279, 1283, 1289, 1291, 1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423,
#   1427, 1429, 1433, 1439, 1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511,
# ]

# puts primeNumbers.index(53)

# questions = ["f-say61zjv,arlba.wgezpo!by5h9d8an", 
#              "g-say61zjv,arlba.wgezpo!by5h8y3an",
#              "89?uc.83,lx!ctndc-yig,rq0d.7j.6bj4r"]

# string_combis_arry = []

# p num = "weather".length - 1

# questions.map {|q|
#   string_combis = []
#   i = 0
#   while i < q.length - num
#     upper_i = num + i
  
#     extracted_str = q[i..upper_i]
#     string_combis.push(extracted_str)
  
#     i += 1
#   end
  
#   string_combis_arry.push(string_combis)
# }

# # p string_combis_arry[0]
# # p string_combis_arry[1]
# # p string_combis_arry[2]

# string_combis_arry[0].map {|string_combi|
#   # if string_combis_arry[1].include?(string_combi) && string_combis_arry[2].include?(string_combi)
#   #   p string_combi
#   # end
#   puts string_combis_arry[1].include?(string_combi)
# }
# puts ""
# string_combis_arry[0].map {|string_combi|
#   # if string_combis_arry[1].include?(string_combi) && string_combis_arry[2].include?(string_combi)
#   #   p string_combi
#   # end
#   puts string_combis_arry[2].include?(string_combi)
# }



# foo = {"foo": 123}

# puts foo.object_id
# puts foo

# def bar(v)
#     v["foo"] = 12345
# end

# bar(foo)
# # ↓書き換えられないはずだ…
# puts foo.object_id
# puts foo


# foo = 123

# puts foo.object_id
# puts foo

# def bar(v)
#     v = 12345
# end

# bar(foo)
# # ↓書き換えられない
# puts foo.object_id
# puts foo

# foo = 123

# puts foo.object_id
# puts foo

# def bar(v)
#     v = 12345
# end

# bar(foo)
# # ↓書き換えられない
# puts foo.object_id
# puts foo

# foo = 123

# puts foo.object_id
# puts foo

# foo = 12345

# # ↓書き換えられない
# puts foo.object_id
# puts foo


# # 値渡し
# def foo(a, b)     # a, b を「仮引数」という
#   a += 1
#   b += 2          # a と b を変更する
# end

# x = 10
# y = 20

# puts x            #=> 10  # 変更されてない
# puts x.object_id
# puts y            #=> 20  # 変更されてない
# puts y.object_id

# foo(x, y)         # x, y を「実引数」という

# puts x            #=> 10  # 変更されてない
# puts x.object_id
# puts y            #=> 20  # 変更されてない
# puts y.object_id


# numbers = [10, 20, 31]

# def bar(hoge)
#   p hoge.object_id

#   p hoge[0].object_id
#   hoge[0] += 1
#   p hoge[0].object_id
# end

# p numbers
# p numbers.object_id

# bar(numbers)

# p numbers
# p numbers.object_id

# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
# WORKDIR /root/
# COPY app .
# CMD ["./app"]



# FROM golang:1.7.3
# WORKDIR /go/src/github.com/alexellis/href-counter/
# RUN go get -d -v golang.org/x/net/html
# COPY app.go .
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
# WORKDIR /root/
# COPY --from=0 /go/src/github.com/alexellis/href-counter/app .
# CMD ["./app"]