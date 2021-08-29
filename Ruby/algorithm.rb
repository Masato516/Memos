## 最大の利益
n    = gets.to_i  # 与えられる数値の数
minv = gets.to_i  # １つ目の数値を代入
num = gets.to_i  # 2つ目の数値を代入
maxDiff = num - minv  # 2つ目の数値と１つ目の数値の差

minv = num if num < minv  # １つ目の最小値を求める処理をおこなう

(n - 2).times {
  num = gets.to_i
  # 現在の値と前の値の中で最小値を引いて、今までの差でも最も大きい値を代入
  maxDiff = num - minv if (num - minv) > maxDiff
  # 現在まで出てきた値の中で最も小さい値を代入
  minv = num           if num < minv
}

puts maxDiff



## 素数
def isPrime(num)
  if num == 2   # 2 は素数
    return true
  end

  if num < 2 || (num % 2 == 0)  # 2未満 かつ 偶数であれば合成数
    return false
  end
  # 3以上の場合、以下の処理を行なう
  i = 3
  # 合成数は p <= √x を満たす素因数p をもつ という性質を利用
  while i <= Math.sqrt(num)
    # 割り切れたら、合成数
    if num % i == 0
      return false
    end
    # 偶数は合成数なので、奇数のみで割る
    i += 2
  end
  # 3以上で割り切れない数値は素数が確定する
  return true
end




## 最大公約数 (gcdメソッドでも可能)
# GCD: Greatest Common Divisor
# xとyの小さい方をnとし、dがnから 1 までについて、
# xとyの両方を割り切れるかを調べ、割り切れたらdを返すアルゴリズムだと
# 最悪 n 回の割り算を行う必要があるため、大きな数に対しては時間が掛かる！！
# => ユークリッドの互除法を使うのが高速！！！
def gcd(bigger, smaller)
  # 数値の並び替え
  bigger, smaller = smaller, bigger if bigger < smaller
  # 割り切れるまで処理
  while smaller != 0
    bigger, smaller = smaller, bigger % smaller
  end
  puts bigger
end

gcd(147, 105)


## 挿入ソート (sortメソッドでも可能)
# 挿入ソートは、入力のデータの並びが、計算量に大きく影響する興味深いアルゴリズムの１つ
# 計算量が O(N2)になるのは、データが降順に並んでいる場合
# 一方、データが昇順に並んでいる場合は A[j] の移動が必要ないため、
# おおよそ N回の比較ですむ
# 従って、挿入ソートはある程度整列されたデータに対しては高速に動作する特長を持つ

n = gets.chomp.to_i
arry = gets.chomp.split().map(&:to_i)

puts "-----------------------------"

## バージョン１
def insertSort(arry, n)
  (0..(n-1)).each do |i|
    while i >= 1 && arry[i-1] > arry[i]
      arry[i-1], arry[i] = arry[i], arry[i-1]
      i -= 1
    end
    puts arry.join(" ")
  end
end

insertSort(arry, n)

## バージョン２
def insertSort(arry)
  arry.each_index do |i|
    while i >= 1 && arry[i-1] > arry[i]
      arry[i-1], arry[i] = arry[i], arry[i-1]
      i -= 1
    end
    puts arry.join(" ")
  end
end

insertSort(arry)



