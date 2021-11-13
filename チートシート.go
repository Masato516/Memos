/* 
  関数の定義

  キャメルケースで命名
  packageの外で利用する関数：   アッパーキャメルケース（先頭大文字から始まる）
  packageの内のみで利用する関数：ローワーキャメルケース（先頭小文字から始まる）
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
  可変長引数（Variadic parameter）
*/

// 引数に型名を指定する時に、「…」を前につけることで関数を宣言
func 関数名(引数名 ...型名) 型名 {
	// 処理コード
}

// 例.
func sum(n ...int) int {
	total := 0
	for _, v := range n {
		total += v
	}
	return total
}
x := sum(1, 2, 3, 4, 5)
fmt.Println(x) //=> 15



/*
  クロージャ（Clousure）
*/

// 例1.
func incrementGenerator() (func() int) {
	i := 0
	return func() int {
		i++
		return i
	}
}

func main() {
	counter := incrementGenerator()
	// i=1
	fmt.Println(counter()) //=> 1
	// i=2
	fmt.Println(counter()) //=> 2
	// i=3
	fmt.Println(counter()) //=> 3
}

// 例2.
func counterGenerator() func() int {
	var i int
	return func() int {
		i++
		return i
	}
}

func main() {
	couter1 := counterGenerator()
	fmt.Println(couter1()) //=> 1
	fmt.Println(couter1()) //=> 2
	fmt.Println(couter1()) //=> 3
	
	counter2 := counterGenerator()
	fmt.Println(counter2()) //=> 1
	fmt.Println(counter2()) //=> 2
	fmt.Println(counter2()) //=> 3
}


// 例3. πの値を変更して、計算できる
func circleArea(pi float64) func(radius float64) float64 {
	return func(radius float64) float64 {
		return pi * radius * radius
	}
}

func main() {
	// π = 3.14 で計算
	c1 := circleArea(3.14)
	// 半径 2 の円の面積を計算
	fmt.Println(c1(2)) //=> 12.56
	// 半径 3 の円の面積を計算
	fmt.Println(c1(3)) //=> 28.2599999...

	// π = 3 で計算
	c2 := circleArea(3)
	// 半径 2 の円の面積を計算
	fmt.Println(c2(2)) //=> 12
	// 半径 3 の円の面積を計算
	fmt.Println(c2(3)) //=> 27
}


/*
  switch
*/
switch(条件){
　　case 値:
　　　 処理
   ・・・
　　default:
　　　 処理
}

// 例1.
a := "2"
switch a {
    case "1":
        fmt.Println("1つめ")
    case "2":
        fmt.Println("2つめ") // 2つめが出力される
    default:
        fmt.Println("3つめ")
}

// 例2.
// 処理を続けて実行する(フォールスルー)
a := "1"
switch a {
    case "1":
        fmt.Println("1つめ")
        fallthrough
    case "2":
        fmt.Println("2つめ") // 2つめが出力される
    default:
        fmt.Println("3つめ")
}

// 例3.
// caseの後に条件を追加する
i := 1
switch {
    case i < 5:
        fmt.Println("1つめ")
    case i < 10:
        fmt.Println("2つめ") // 2つめが出力される
    default:
        fmt.Println("1つめ")
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
  ポインタ
*/
// メモリのアドレス情報のこと

var memory int = 100 //=> 100

// &
// 変数のアドレスを取得することが可能
&memory //=> 0xc0000a0a0

// int*
// ポインタ型: メモリー上のアドレスを記憶する変数の型
// *int で変数にアドレスを代入可能
var address *int = &memory //=> 0xc0000a0a0

// *
// アドレスからメモリ上の値を取得
*address //=> 100



/*
  Structs(構造体)
  他の言語のクラスと似たような役割を持つ

  キャメルケースで命名
  packageの外で利用する関数：   アッパーキャメルケース（先頭大文字から始まる）
  packageの内のみで利用する関数：ローワーキャメルケース（先頭小文字から始まる）
*/

//// 構造体の定義
type Person struct {
    firstName string 
    age       int
 }

//// 構造体の初期化

// 1. 変数定義後にフィールドを設定する方法
type Person struct {
    firstName string 
    age int
}
 
func main(){
    var mike Person
    mike.firstName = "Mike"
    mike.age = 20
    fmt.Println(mike.firstName, mike.age) //=> Mike 20
}

// 2. {} で順番にフィールドの値を渡す方法
type Person struct {
    firstName string 
    age int
 }
 
func main(){
    bob := Person{"Bob", 30}
    fmt.Println(bob.firstName, bob.age) //=>Bob 30
}

// 3. フィールド名を ： で指定する方法
type Person struct {
    firstName string 
    age int
 }
 
func main(){
    sam := Person{age: 15, firstName: "Sam"}
    fmt.Println(sam.firstName, sam.age) //=>Sam 15
}


// 初期化関数を作成することで初期化することも一般的
// 他言語の「クラスを new してコンストラクタを呼び出す」のようなもの

// 例１.
type Person struct {
    firstName string 
    age int
 }
 
func newPerson(firstName string, age int) *Person{
    person := new(Person)
    person.firstName = firstName
    person.age = age
    return person
}
 
func main(){
    var jen *Person = newPerson("Jennifer", 40)
    fmt.Println(jen.firstName, jen.age) //=>Jennifer 40
}


// 例２.
type Profile struct {
    Name string
    Age  int
}

func New(name string, age int) *Profile {
    return &Profile{
        Name: name,
        Age:  age,
    }
}

func (p Profile) Print() {
    println("name:", p.Name, ", age:", p.Age)
}

func main() {
    p := New("Tanaka", 31)
    p.Print()
}




/*
  Maps(連想配列)
*/

// Maps(連想配列)の初期値を指定しない場合、変数は nil (nil マップ) に初期化される
// nil マップ は要素を格納することができず、要素を格納する場合はマップの初期化を行う必要がある


// 1. 組み込み関数make()を利用して宣言
make(map[キーの型]値の型, キャパシティの初期値)
// キャパシティの初期値は、省略も可能
make(map[キーの型]値の型)


// 2. 初期値を指定して宣言
// 組み込み関数 make() を使用せずとも
// 以下の様に初期値を指定して宣言可能
var 変数名 map[key]value = map[key]value{key1: value1, key2: value2, ..., keyN: valueN}
// 例.
var mapEx = map[string]string{"firstName":"Khabib", "lastName": "Nurmagomedov"}
//=> map[lastName:Khabib firstName:Nurmagomedov]


// nilマップ
// Maps(連想配列)の初期値を指定しない場合、変数は nil (nil マップ) に初期化される
// nil マップ は要素を格納することができず、要素を格納する場合はマップの初期化を行う必要がある
var romero map[string]int
romero["age"] = "40" //=> panic: assignment to entry in nil map



/*
  Range
*/

// Slices(スライス) や、Maps(マップ) をひとつずつ反復処理するために利用

// Go では range を使うと簡単に反復処理可能
for i := 0; i < len(slice); i++{
    fmt.Println(i, slice[i])
    //=> 0 Khabib
    //=> 1 Mcgregor
    //=> 2 Poirier
}
// ↑ と同じ
for index, value := range slice(スライス・Maps名) {
    fmt.Println(index, value)
    //=> 0 Khabib
    //=> 1 Mcgregor
    //=> 2 Poirier
}



/*
  break
  for ループを途中で止める
*/


/*
  continue
  continue以降の処理をスキップして次のループに進む
*/

// 
var slice = []string{"Khabib", "Mcgregor", "Poirier"}

for _, fighter := range slice {
    if "Khabib" == fighter {
        fmt.Println("Retire")
        continue
    }
    fmt.Println("active")
    fmt.Println(fighter)
}
//=> Retire
//=> active
//=> Mcgregor
//=> active
//=> Poirier


var slice = []string{"Khabib", "Mcgregor", "Poirier"}

for _, fighter := range slice {
    if "Khabib" == fighter {
        fmt.Println("Retire")
        continue
    }
    fmt.Println("active")
    fmt.Println(fighter)
}



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




/*
  出力
*/

// 要素数と容量（スライスと配列のみ：mapには使えない！）
test := []int{1, 2, 3}
fmt.Printf("len=%d, cap=%d\n", len(test), cap(test))