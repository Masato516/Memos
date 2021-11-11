/* 
  関数の定義 
*/

func 関数名 (引数 型)　{
    // do something
}

// 関数の後ろに戻り値の型を定義することで、
// 値を返却できる様になる
func 関数名 (引数 型) 値の型 {
    // do something
    return 値
}
// 例.
func addOne(i int) int {
    return i + 1
}


// 複数の値を返すパターン
func 関数名 (引数 型) (値の型, 値の型) {
    // do something
    return 値, 値
}
// 例.
func add (a int) (int, int) {
    return a + 1, a - 1
}


// 複数の引数を受け取る(パターン１)
func 関数名 (引数1 型1, 引数2 型2) {
    // do something
}
// 例.
func add (a int, b int) int {
    return a + b
}


// 複数の引数を受け取る(パターン２)
func 関数名 (引数1, 引数2 型) {
    // do something
}
// 例.
func add (a, b int) int {
    return a + b
}


// 返り値を指定する
func 関数名 (引数 型) (返り値 型) {
    返り値 = 引数
    return
}
func add(a int) (result int) {
    result = a + 1
    return
}


/*
  配列の定義
*/
// Goの Arrays(配列) は固定長の的な配列で
// 最初に宣言した配列のサイズを変えられない

// バージョン1
// var 変数名 [長さ]型
var arr [2]string
    arr[0] = "Golange"
    arr[1] = "Java"
fmt.Println(arr[0], arr[1]) //=> Golange Java
fmt.Println(arr)            //=> [Golange Java]

arr[2] = "Ruby"             //=> エラー invalid array index 2 (out of bounds for 2-element array)


// バージョン2
// var 変数名 [長さ]型 = [大きさ]型{初期値1, 初期値n} 
var arr[2] string = [2]string {"Golang", "Java"} //=> [Golange Java]
fmt.Println(arr[0], arr[1]) //=> Golange Java

// バージョン3
// 変数名 := [...]型{初期値１, 初期値n}
arr := [...] string{"Golang", "Java"} //=> [Golange Java]
fmt.Println(arr[0], arr[1]) //=> Golange Java


/*
  Slices(スライス)
*/
// 配列の宣言と異なり、[ ]の中に大きさを指定しない
// スライスは参照型
// => スライスを代入して作成した新しいスライスなどでappendなどを使う場合、
//    元の値が上書きされるを考慮する必要あり


//// スライスの宣言

// ① var 変数名 []型
var slice []string //=> []

// ② var 変数名 []型 = []型{初期値1, ..., 初期値n}
slice := [] string{"Golang", "Java"} //=> [Golange Java]

// ③ 変数名 := 配列[start:end] 
//配列(またはスライス)のstartから(end - 1)を取り出す事でスライスを作成する。 
arr := [...] string{"Golang", "Java"}
slice := arr[0:2] //=> [Golange Java]


// 組み込み関数 make() でスライスを作成
make([]T, len, cap)
// 第 1 引数 []T が型
// 第 2 引数 (len) が 長さ
// 第 3 引数 (cap) が 容量(確保するメモリサイズ)
// capは指定しなければ、lenと同じ

// 例.
a := make([]int, 5, 5) //=> [0 0 0 0 0] len: 5 cap: 5
a := make([]int, 5)    //=> [0 0 0 0 0] len: 5 cap: 5


// スライス操作
// 負の数値は扱えない！！
操作	           意味
Slice[start:end]  start から end - 1 まで
Slice[start:]	  start から最後尾まで
Slice[:end]	      先頭から end - 1 まで
Slice[:]	      先頭から最後尾まで


// 簡易スライス式
// [1:]や[1:2]などの書き方をするスライス式

// ※ スライス式の左が0もしくは記述しない場合、capは変わらない
// 例.
test  := []int{1, 2, 3, 4, 5, 6}
test2 := test[:2]
// [1, 2] len=2, cap=6  ※capは変わらない

// 完全スライス式
// スライス時に使う容量を指定する場合に使う
// [0:2:2]のような書き方をするスライス式
Slice[start:end:capの最大値]
// 例.
test  := []int{1, 2, 3, 4, 5, 6}
test2 := test[:2:2] //=> [1 2] len=2, cap=2

test  := []int{1, 2, 3, 4, 5, 6}
test2 := test[:2:3] //=> [1 2] len=2, cap=3


/*
  標準入力
*/

// fmt.Scan で軽快に読み込む
// 速度を気にしなくてもよいのなら fmt.Scan を使う方法が一番簡単
import "fmt"

var hoge int
fmt.Scan(&hoge)


// bufio の Scanner を使う (1) 一行づつ読み込む
// 文字列が改行区切りで与えられている場合
// 例.
// hoge1
// hoge2
// hoge3
import (
    "bufio"
    "fmt"
    "os"
)

var sc = bufio.NewScanner(os.Stdin)

func main() {
    var s, t string
    if sc.Scan() {
        s = sc.Text()
    }
    if sc.Scan() {
        t = sc.Text()
    }
    fmt.Println(s)
    fmt.Println(t)
}

// bufio の Scanner を使う (1) 一行づつ読み込む
// sc.Scan, sc.Textをメソッドでまとめる

import (
    "bufio"
    "fmt"
    "os"
)

var sc = bufio.NewScanner(os.Stdin)

func nextLine() string {
    sc.Scan()
    return sc.Text()
}

func main() {
    s, t := nextLine(), nextLine()
    fmt.Println(s)
    fmt.Println(t)
}


// 文字列の1行入力
import (
    "fmt"
    "os"
    "bufio"
    "strings"
)

//// 文字列を1行入力

func StrStdin() (stringInput string) { // string型を返す
    // バッファからテキストを取得
    scanner := bufio.NewScanner(os.Stdin)
    // テキストがバッファリングされるまで待機
    scanner.Scan()
    // バッファにテキストが入ったら文字列を取得
    stringInput = scanner.Text()
    // 前後の余白と末尾の改行を取り除く
    stringInput = strings.TrimSpace(stringInput)
    return
}

func main() {
    p := StrStdin()
    fmt.Println(p)
}



//// 整数値1つ取得

import (
    "fmt"
    "strings"
    "os"
    "bufio"
    "strconv"
)

// 文字列を1行取得
func StrStdin() (stringReturned string) {
    // ... 省略 ...
}


func IntStdin() (int, error) {
    stringInput := StrStdin()
    return strconv.Atoi(strings.TrimSpace(stringInput))
}

func main() {
    i, err := IntStdin()
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Println(i)
    }
}