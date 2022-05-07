/*
	Go言語の仕様書
	https://go.dev/ref/spec
*/

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
    Interface(インターフェース)
    メソッドの型だけを定義した型
    オブジェクト指向言語でいうところのポリモーフィズムと同様の機能を実現する
*/

type Human interface {
	// メソッド名のみを指定
	say() // say()というメソッドを持っていないとエラーになる
}

// Personというstructを定義
type Person struct {
	name string
}

// Personに対してsay()を実装
// Personにsay()が実装されていいないと以下のエラーを出す
//=> cannot use Person{...} (type Person) as type Human in assignment:
//=> Person does not implement Human (missing say method)
func (p Person) say() {
	fmt.Println(p.name)
}

func main() {
	// HumanというインターフェースにPersonのstructを入れる
	//=> say()というメソッドを持っていないとエラーになる
	var mike Human = Person{"Mike"}
	mike.say()
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
    defer
    関数の最後に実行される
*/

func hoge() {
	defer fmt.Println("遅延実行されている")
	fmt.Println("Hello World")
}

func main() {
	hoge()
}

// 例.
func main() {
	fmt.Println("run")
	defer fmt.Println("1st")
	defer fmt.Println("2nd")
	defer fmt.Println("3rd")
}
//=> run
//=> 3rd
//=> 2nd
//=> 1st



/*
    logging
    ログ出力
    Go言語は最低限のログ出力を行う部分しか提供していない
    =>サードパーティのロギングツールを使用することで、ログ出力を拡張できる
*/
// 例.
import "log"

func main() {
    log.Println("ログ出力")
    //=> 2021/11/14 00:49:15 ログ出力
    log.Printf("%T %v", "ログ出力", "ログ出力")
    //=> 2021/11/14 00:49:15 ログ出力
    log.Fatalln("ログ出力")
    //=> 2021/11/14 00:50:44 ログ出力
    //=> exit status 1  処理が終了する！
}

// 実用例.
// ログファイルを指定して出力する
func LoggingSettings(logFile string) {
	// ログファイルを作成
	logfile, _ := os.OpenFile(logFile, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	// ログファイルを標準出力に結びつける
	// os.Stdout と logfile から新しい io.Writer を生成
	multiLogFile := io.MultiWriter(os.Stdout, logfile)
	// ログのフラグを設定
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
	//=> 2021/11/14 21:20:39 go_paractice.go:26:
	// ログの出力先を設定
	log.SetOutput(multiLogFile)
}

func main() {
	// ログファイル名を指定
	LoggingSettings("log.txt")
	// 存在しないファイルを指定した場合はエラーになる
	_, err := os.Open("no-file.txt")
	if err != nil {
		// エラーが発生した場合はログに出力して終了
		log.Fatalln("Error:", err)
	}
	fmt.Println("ファイルの読み込み成功")
}



/*
    エラーハンドリング
*/

func main() {
	// ファイルを開く
	file, err := os.Open("./go_paractice.go")
	if err != nil {
		log.Fatalln("Error!")
	}
	// 処理の最後にファイルを閉じる
	defer file.Close()

	data := make([]byte, 100)
	// os.Openでファイルのオープンで取得したos.Fileオブジェクトの
	// Readメソッドを使用して読み込みを行
	count, err := file.Read(data)
	if err != nil {
		log.Fatalln("Error!")
	}
	fmt.Println(count, string(data))
	// 返り値が１つの場合は、エラーハンドリングを１行で書くことがある
	if err = os.Chdir("/usr/local"); err != nil {
		log.Fatalln("Error!")
	}
}


/*
    byte型（バイト）
*/

func main() {
	//バイト型の配列を宣言
	b := []byte{72, 73}
	fmt.Println(b)
	// 配列の値をASCIIコードとして文字列に変換
	fmt.Println(string(b))
	//=> HI
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


// capはlenと同様に増加せず、前に確保していた分ずつ確保されていく
n := make([]int, 3, 5)
fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
//=> len=3 cap=5 value=[0 0 0]

n = append(n, 1, 2)
fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
//=> len=3 cap=5 value=[0 0 0]

n = append(n, 3, 4, 5)
fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
//=> len=8 cap=10 value=[0 0 0 1 2 3 4 5]

n = append(n, 6, 7, 8)
fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n
//=> len=11 cap=20 value=[0 0 0 1 2 3 4 5 6 7 8]


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

    type [型(構造体)の名前] struct {
        [フィールド名] [型名]
        [フィールド名] [型名]
        [フィールド名] [型名]
    }

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

/* 様々な構造体の宣言方法 */
v := Vertex{X: 1, Y: 2}
fmt.Println(v)
fmt.Println(v.X, v.Y)

v.X = 100
fmt.Println(v.X, v.Y)

v2 := Vertex{X: 1}
fmt.Println(v2)

v3 := Vertex{1, 2, "test"}
fmt.Println(v3)

v4 := Vertex{}
fmt.Printf("%T %v\n", v4, v4)

var v5 Vertex
fmt.Printf("%T %v\n", v5, v5)

v6 := new(Vertex)
fmt.Printf("%T %v\n", v6, v6)

v7 := &Vertex{}
fmt.Printf("%T %v\n", v7, v7)
// fieldはあってもなくてもOK
v7 := &Vertex{X: 1, Y: 2}

/*
    structの参照・値渡し
*/
type Vertex struct {
	X, Y int
	S    string
}

func changeVertexVal(v Vertex) {
	v.X *= 1000
}

func changeVertexRef(v *Vertex) {
	// structの場合、(*v).Xと記述する必要はない
	v.X *= 1000
	//=> (*v).X *= 1000 と同じ挙動
}

func main() {
	v1 := Vertex{X: 1, Y: 2, S: "値渡し"}
	changeVertexVal(v1)
	fmt.Println(v1)

	v2 := &Vertex{X: 1, Y: 2, S: "参照渡し"}
	changeVertexRef(v2)
	fmt.Println(v2)
}


/*
	タイプアサーション
*/

func do(i interface{}) {
	x := i.(int) // type assertion
	x *= 2
	fmt.Println(x)
}

func main() {
	do(10)
}


/*
	switch type文
*/

func do(i interface{}) {
	switch i.(type) {
	case int:
		fmt.Println(2)
	case string:
		fmt.Println("!")
	default:
		fmt.Println("I don't know")
	}
}

func main() {
	do(10)
	do("Mike")
	do(true)
}

/*
	Stringer

	Stringer インタフェースは、
	stringとして表現することができる型
	fmt パッケージ(と、多くのパッケージ)では、
	変数を文字列で出力するためにこのインタフェースがあることを確認します。
*/

func main() {
	mike := Person{"Mike", 22}
	fmt.Println(mike) // My name is Mike.
	fmt.Print(mike) // My name is Mike.
	log.Println(mike) // 2022/03/01 23:58:31 My name is Mike.
}


/*
	カスタムエラー
	
	参考：https://cs.opensource.google/go/go/+/refs/tags/go1.17.7:src/io/fs/fs.go;l=249;drc=refs%2Ftags%2Fgo1.17.7
*/

// エラー出力するためのstruct
type UserNotFound struct {
	Username string
}

// エラー内容
func (e *UserNotFound) Error() string {
	return fmt.Sprintf("User not found: %v", e.Username)
}

// エラーを起こす関数
func errFunc() error {
	ok := false
	if !ok {
		// errorを返す場合は、ポインタで返す！（ポインタでなくとも動作するが...）
		return &UserNotFound{Username: "Mcgregor"}
	}
	return nil
}

func main() {
	if err := errFunc(); err != nil {
		fmt.Println(err)
	}
}


/*
    メソッド
		
		対象の型を引数に取る関数の場合は，他の関数と名前衝突を防ぐため，
		あるいは処理の内容がわかるような名前をつける必要があるため，どうしても長い名前になる
		=>型と紐付けられる関数はメソッドにした方がよい
*/

// 関数とは異なる
type Vertex struct {
	X, Y int
}

// メソッド: Vertex構造体と結びつきがある
// 構造体（型）に紐づく処理の塊
func (v Vertex) Area() int {
	return v.X * v.Y
}

// 関数
// funcで始まる処理の塊の中で構造体（型）に紐づけられていないもの
func Area(v Vertex) int {
	return v.X * v.Y
}

func main() {
	v := Vertex{3, 4}
	fmt.Println(Area(v))  // 関数
	fmt.Println(v.Area()) // メソッド
}


/*
    ポイントレシーバー
		
		ポインタレシーバ：ポインタとして引数で渡すので、関数内でオブジェクトの値を変更できる
		値レシーバ：元の値とは別のコピーした値が関数に渡されるので元の値は変更はできない
*/

// 値レシーバー
func (v Vertex) Area() int {
	return v.X * v.Y
}

// ポインタレシーバー: structの中身を書き換える
func (v *Vertex) Scale(i int) { // *がなければ、v.Area()は12になる！！
	v.X = v.X * i
	v.Y = v.Y * i
}

func main() {
	v := Vertex{3, 4}
	v.Scale(10) // vのX,Yフィールドを10倍にする
	fmt.Println(v.Area())
}


/*
	コンストラクタ（デザインパターン）

	Rubyでいうinitializeメソッドみたいなもの
*/

type Vertex struct {
	x, y int
}

func New(x, y int) *Vertex {
	return &Vertex{x, y}
}

func (v *Vertex) Area() int {
	return v.x * v.y
}

func main() {
	v := New(3, 4) // コンストラクタ
	fmt.Println(v.Area())
}


/*
	Embedded
	
	クラスの継承のような役割を行う
*/

type Vertex struct {
	x, y int
}

func (v *Vertex) Scale(i int) {
	v.x *= i
	v.y *= i
}

func (v *Vertex) Area() int {
	return v.x * v.y
}

type Vertex3D struct {
	Vertex
	z int
}

func (v *Vertex3D) Scale3D(i int) {
	v.x *= i
	v.y *= i
	v.z *= i
}

func (v *Vertex3D) Area3D() int {
	return v.x * v.y * v.z
}

func New(x, y, z int) *Vertex3D {
	return &Vertex3D{Vertex{x, y}, z}
}

func main() {
	v := New(1, 2, 3)
	v.Scale3D(10)
	fmt.Println(v.Area3D())
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


// 例.
m := map[string]int{"apple": 100, "banana": 140}
fmt.Println(m["apple"])
//=> 100
fmt.Println(m["strawberry"])
//=> 0

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
//=> len=3, cap=3
fmt.Println(test)




/*
    ファイルの開閉
    ファイル読み書きの際のファイルの開き方にいくつか方法がある
*/

/* ・os.OpenFile */
// 基本的に何も考えずファイルを開いて書き込むと中身を全部上書きして書き込まれる
// 第二引数に、用途に合わせてフラグを渡す必要がある

// ファイルに追記する時
// 第二引数に os.O_WRONLY 及び os.O_APPEND をつける
file, err := os.OpenFile("test.txt", os.O_WRONLY|os.O_APPEND, 0666)

// ファイルが存在しなかった場合、新規作成
// 第二引数に os.O_CREATE をつける
file, err := os.OpenFile("test.txt", os.O_WRONLY|os.O_CREATE, 0666)

// ファイルに追記する、存在しなかったら新規作成
//os.O_RDWRを渡しているので、同時に読み込みも可能
file, err := os.OpenFile("test.txt", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)

// 引数
// os.O_RDONLY //読み込む時
// os.O_WRONLY //書き込む時
// os.O_RDWR //読み書き両方する時


/* os.Create */
// ファイルへ何かを書き出す
// 指定したファイルが存在してもエラーを返さず作成し、元のファイルの内容は削除される

/* os.NewFile */
// ファイルを作成

/* ・os.Open */
// ファイルを開く時に使う(読み込み専用:編集不可)



/* テンプレート */
// テキスト出力を生成するためのデータ駆動型テンプレートを実装している

// Go 言語には、組込みのテンプレート・パッケージとして、
// text/template と html/template パッケージが搭載されている 
// Web ページの構築に使用する場合は、
// パラメータを HTML エスケープ処理してくれる 
// html/template パッケージの方を利用する

// // Template オブジェクトの生成
// テンプレート機能を使用するには、
// まずは Template オブジェクトを生成します。 
// テンプレートファイルを使用する場合は template.ParseFiles 関数、
// 文字列データをテンプレートとして使用する場合は template.Parse 関数を使用

t, err := template.ParseFiles("./template.html")
if err != nil {
	log.Fatal(err)
}


// テンプレートファイルのパース処理が成功することが分かっている場合は、
// 次のように template.Must 関数を組み合わせて使用することで、
// エラー処理の記述を省略することができます（エラーになった場合は panic が発生します）。

t := template.Must(template.ParseFiles("./template.html"))


// // テンプレートへの値の埋め込み
// テンプレートへの値の埋め込みは、
// Template オブジェクトの Execute メソッドによって行います。 
// 第一引数には出力先、第二引数には埋め込むデータを渡します。

data := "Hello World"
if err := t.Execute(os.Stdout, data); err != nil {
	log.Fatal(err)
}

// template.ParseFilesで読み込んだファイルが

// ・1つのみの場合
// ExecuteもしくはExecuteTemplateを使う

// ・複数の場合
// ExecuteTemplateを使う


// 渡されたデータは、テンプレートファイル内の、{{ . }} という部分に展開されます。 
// 下記はシンプルなテンプレートファイルの例です。

// template.html
<h1>{{ . }}</h1>
// 出力結果
<h1>Hello World</h1>


/*
	静的ファイル（CSS,JS）にアクセスできるようにする
	↑がないと、<!DOCTYPE>で、Uncaught SyntaxError: Unexpected token 'を吐く
*/

// 例.
http.HandleFunc("/", viewIndexHandler)
// 以下１行を追加する必要あり
http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
return http.ListenAndServe(fmt.Sprintf("%s:%d", config.Config.Address, config.Config.Port), nil)


//// 詳細
http.FileServer(http.Dir("path"))
// pathにあるディレクトリをhandlerとして返す
http.StripPrefix("path", handler)	
// "path"より前を取り除いたpathを作成しhandlerに渡す
http.Handle("path", handler)
// pathという要求がきたらhandlerを返す


/*
    goroutine と sync.WaitoGroup
*/

import (
	"fmt"
	"sync"
)

func goroutine(s string, wg *sync.WaitGroup) {
	defer wg.Done() // 関数の処理が終われば、スレッドを終了
	for i := 0; i < 5; i++ {
		// time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
}

func normal(s string) {
	for i := 0; i < 5; i++ {
		fmt.Println(s)
	}
}

func main() {
	var wg sync.WaitGroup
	wg.Add(1)
	go goroutine("world", &wg)
	normal("hello")
	wg.Wait()
}


/*
    channel
*/

func goroutine1(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum
}

func goroutine2(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum
}

func main() {
	s1 := []int{1, 2, 3, 4, 5}
	s2 := []int{6, 7, 8, 9, 10}
	c := make(chan int)
	go goroutine1(s1, c)
	go goroutine2(s2, c)
	x := <-c
	fmt.Println(x)
	y := <-c
	fmt.Println(y)
}

/*
    channelとselect
*/

func goroutine1(ch chan string) {
	for {
		ch <- "packet from c1"
		time.Sleep(1 * time.Second)
	}
}

func goroutine2(ch chan string) {
	for {
		ch <- "packet from c2"
		time.Sleep(1 * time.Second)
	}
}

func main() {
	c1 := make(chan string)
	c2 := make(chan string)

	go goroutine1(c1)
	go goroutine2(c2)
	
	for {
		select {
		case msg1 := <-c1:
			fmt.Println(msg1)
		case msg2 := <-c2:
			fmt.Println(msg2)
		}
	}
}


/*
    Buffered channel
*/

func main() {
	ch := make(chan int, 2)
	ch <- 100
	fmt.Println(len(ch))

	ch <- 200
	fmt.Println(len(ch))

	close(ch) // closeしないとfor文でエラーが発生
	for c := range ch {
		fmt.Println(c)
	}
}


/*
	Default Selection と for break
*/

// Default Selectionについて
func main() {
	tick := time.Tick(100 * time.Millisecond)
	boom := time.After(500 * time.Millisecond)
	for {
		select {
		case t := <-tick:
			fmt.Println("tick.", t)
		case <-boom:
			fmt.Println("BOOM!")
			return
		default: // チャネルに何も送信されなければ実行
			fmt.Println("    .")
			time.Sleep(50 * time.Millisecond)
		}
	}
}


/*
	Goto文
	指定したラベルにジャンプする
	
	Go言語にはtry catch raise のような例外処理構文はサポートされていないので、goto文を使う
	複数のループ処理から抜き出したい場合、goto文を利用
*/

func main() {
	tick := time.Tick(100 * time.Millisecond)
	boom := time.After(500 * time.Millisecond)
OuterLoop: // break OuterLoopとすることで、途中で抜けられるようになる
	for {
		select {
		case <-tick:
			fmt.Println("tick.")
		case <-boom:
			fmt.Println("BOOM!")
			break OuterLoop
		default:
			fmt.Println("    .")
			time.Sleep(50 * time.Millisecond)
		}
	}
	fmt.Println("######################")
}

/*
    context
		デッドライン、キャンセルシグナル、その他のリクエストに対応した値を
		APIの境界やプロセス間で伝達する
		
		例.
    goroutineにタイムアウトを付け加えることができる
*/

func longProcess(ctx context.Context, ch chan string) {
	fmt.Println("run")
	time.Sleep(3 * time.Second)
	fmt.Println("finish")
	ch <- "result"
}

func main() {
	ch := make(chan string)
	ctx := context.Background()
	ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()
	go longProcess(ctx, ch)

	for {
		select {
		case <-ctx.Done(): // タイムアウトした際に実行される
			fmt.Println(ctx.Err())
			return
		case <-ch: // 正常にchannnelから値が来れば実行される
			fmt.Println("success")
			return
		}
	}
}



func longProcess(ctx context.Context, ch chan string) {
	fmt.Println("run")
	time.Sleep(3 * time.Second)
	fmt.Println("finish")
	ch <- "result"
}

func main() {
	ch := make(chan string)
	ctx := context.Background()
	ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()
	go longProcess(ctx, ch)

CTXLOOP:
	for {
		select {
		case <-ctx.Done():
			fmt.Println(ctx.Err())
			break CTXLOOP
		case <-ch:
			fmt.Println("success")
			break CTXLOOP
		}
	}
	fmt.Println("##################")
}

/*
	semaphore
	セマフォとは、コンピュータで並列処理を行う際、
	同時に実行されているプログラム間で資源（リソース）の排他制御や同期を行う仕組みの一つ
	当該資源のうち現在利用可能な数を表す値のこと
*/

/* セマフォの値が正でなければブロッキング（待機させる） */
// 同時に走らせることができるgoroutineの数を指定
var s *semaphore.Weighted = semaphore.NewWeighted(1)

func longProcess(ctx context.Context) {
	fmt.Println("関数自体は実行されている"
	// セマフォを一つ減らす（専有）
	if err := s.Acquire(ctx, 1); err != nil {
		fmt.Println(err)
		return
	}
	// 専有していたセマフォを一つ戻す（開放）
	defer s.Release(1)
	fmt.Println("Wait...")
	time.Sleep(1 * time.Second)
	fmt.Println("Done")
}

func main() {
	ctx := context.TODO()
	go longProcess(ctx)
	go longProcess(ctx)
	go longProcess(ctx)
	time.Sleep(5 * time.Second)
}


/* セマフォの値が正でなければ終了させる */
var s *semaphore.Weighted = semaphore.NewWeighted(1)

func longProcess(ctx context.Context) {
	isAcquire := s.TryAcquire(1)
	if !isAcquire {
		fmt.Println("Could not get lock")
		return
	}
	defer s.Release(1)
	fmt.Println("Wait")
	time.Sleep(1 * time.Second)
	fmt.Println("Done")
}

func main() {
	ctx := context.TODO()
	go longProcess(ctx) // 実行
	go longProcess(ctx) // 終了
	go longProcess(ctx) // 終了
	time.Sleep(5 * time.Second)
	go longProcess(ctx) // 実行
	time.Sleep(3 * time.Second)
}


/*
		Mutex(Mutex Exclusion)
		
		複数のゴルーチンが実行されている時に同じ処理が衝突することがある
		mutexを使用すると、1つのゴルーチンだけが処理コードにアクセスできるように
		ロックして、処理の衝突を防ぐことができる

		ミューテックスとは、コンピュータで並列処理を行う際、
		同時に実行されているプログラム間で資源（リソース）の
		排他制御や同期を行う仕組みの一つ
		同時に一つのプログラムの流れのみが資源を占有し、他の使用を排除する方法
*/

// 一定確率で例外が発生
// cに同時に1つの変数にアクセスしようとすると衝突するため
func main() {
	c := make(map[string]int)
	go func() {
		for i := 0; i < 500; i++ {
			c["somekey"] += 1
		}
	}()

	go func() {
		for i := 0; i < 500; i++ {
			c["somekey"] += 1
		}
	}()

	time.Sleep(time.Second)
	fmt.Println(c, c["somekey"])
}


// Mutexを使うことで、衝突を起こさないようにできる

// Mutexを持つstructでmapをwrap
type SafeCounter struct {
	v   map[string]int
	mux sync.Mutex
}

func (c *SafeCounter) Inc(key string) {
	// 一度に1つのゴルーチンだけがc.vのマップに
	// アクセスできるようにロック
	c.mux.Lock()
	c.v[key]++
	// マップの値をインクリメントしたあとに、ロックを解除
	c.mux.Unlock()
}

func (c *SafeCounter) Value(key string) int {
	// 一度に1つのゴルーチンだけがc.vのマップに
	// アクセスできるようにロック
	c.mux.Lock()
	// マップの値にアクセス・値を返した後に、ロックを解除
	defer c.mux.Unlock()
	return c.v[key]
}

func main() {
	// Mutexを持つstructを初期化
	c := SafeCounter{v: make(map[string]int)}
	go func() {
		for i := 0; i < 1000; i++ {
			c.Inc("somekey")
		}
	}()

	go func() {
		for i := 0; i < 1000; i++ {
			c.Inc("somekey")
		}
	}()

	time.Sleep(time.Second)
	fmt.Println(c, c.Value("somekey"))
}


/*
    makeとnewの違い
    makeはポインタを返さず、newはポインタを返す
*/

func main() {
	s1 := make([]int, 0)
	fmt.Printf("%T\n", s1)

	s2 := new([]int)
	fmt.Printf("%T\n", s2)

	m1 := make(map[string]int)
	fmt.Printf("%T\n", m1)

	m2 := new(map[string]int)
	fmt.Printf("%T\n", m2)

	ch1 := make(chan int)
	fmt.Printf("%T\n", ch1)

	ch2 := new(chan int)
	fmt.Printf("%T\n", ch2)

	// makeはslice、配列、mapにしか使えない
	var p *int = new(int)
	fmt.Printf("%T\n", p)

	var st = new(struct{})
	fmt.Printf("%T\n", st)
}

/* 出力結果 */
// []int
// *[]int
// map[string]int
// *map[string]int
// chan int
// *chan int
// *int
// *struct {}




/*
    パッケージ iniの使い方
    configファイルの読み込み時に利用
*/

type ConfigList struct {
	Port      int
	DbName    string
	SQLDriver string
}

var Config ConfigList

func init() {
	cfg, _ := ini.Load("config.ini")
	Config = ConfigList{
		Port:      cfg.Section("web").Key("port").MustInt(),
		DbName:    cfg.Section("db").Key("driver").MustString("example.sql"),
		SQLDriver: cfg.Section("db").Key("driver").String(),
	}
}

func main() {
	fmt.Printf("%T %v\n", Config.Port, Config.Port)
	fmt.Printf("%T %v\n", Config.DbName, Config.DbName)
	fmt.Printf("%T %v\n", Config.SQLDriver, Config.SQLDriver)
}


/*
	サブコマンドの利用方法
	https://github.com/google/subcommands
*/

func main() {
	var intFlag int
	flag.IntVar(&intFlag, "age", 0, "please specify -age flag")
	flag.Parse()
	fmt.Println("The age flag is ", intFlag)
}

func main() {
	intFlag := flag.Int("n", 0, "please specify -n flag")
	flag.Parse()
	fmt.Println("The n flag is ", *intFlag)
}


func main() {
	strFlag := flag.String("s", "デフォルト", "Please specify -s flag")
	flag.Parse()
	fmt.Println("The s flag is ", *strFlag)
}

func main() {
	var strFlag string
	flag.StringVar(&strFlag, "s", "デフォルト", "Please specify -s flag")
	flag.Parse()
	fmt.Printf("flag's type is %T\n", strFlag)
	fmt.Println("The s flag is ", strFlag)
}

func main() {
	command := flag.NewFlagSet("command name", flag.ExitOnError)
	version := command.Bool("version", false, "Output version information and exit")

	command.Parse(os.Args[1:])

	if *version {
		fmt.Fprintf(os.Stderr, "%s v0.0.1", command.Name())
	}
}


/*
	テンプレート
*/

// htmlを共通化する例

//// layout.html
<!DOCTYPE html>
<html>
  <head>
    <title>Drone App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <div data-role="page">
      <div data-role="header">
        <a href="/" data-icon="home" data-dom-cache="false">Home</a>
        <h1>Drone App</h1>
      </div>
      <div data-role="content">
				// テンプレートを使用
        {{ block "content" .}} {{ end}}
      </div>
    </div>
  </body>
</html>
////

//// index.html
// テンプレートを使用
{{ template "layout.html"}}
// テンプレートを用意
{{ define "content"}}
<div align="center">
  <h1>Drone App</h1>
  <img width="100%" src="/static/img/Drone.png">
</div>
<ul data-role="listview">
  <li><a href="/controller/">Controller</a></li>
  <li><a href="/games/shake/">Shake game</a></li>
</ul>
{{ end }}
////

//// controller.html
// テンプレートを使用
{{ template "layout.html"}}
// テンプレートを用意
{{ define "content"}}
<style>
  .controller-box {
    text-align: center;
  }
</style>

<script>
  function sendCommand(command, params={}){
    params['command'] = command
    $.post("/api/command/", params).done(function(json){
      console.log({action: 'sendCommand', params: params, status: 'success'})
    }, 'json').fail(function (json) {
      console.log({action: 'sendCommand', params: params, json: json, status: 'fail'})
    }, 'json')
  }
</script>

<div class="controller-box">
  <div data-roler="controlgroup" data-type="horizontal">
    <a href="#" data-role="button" onclick="sendCommand('ceaseRotation'); return false;">cease</a>
    <a href="#" data-role="button" onclick="sendCommand('takeOff'); return false;">Take off</a>
    <a href="#" data-role="button" onclick="sendCommand('land'); return false;">Land</a>
    <a href="#" data-role="button" onclick="sendCommand('hover'); return false;">Hover</a>
  </div>
</div>
{{ end }}
////

//// テンプレートをパース
func getTemplate(temp string) (*template.Template, error) {
	return template.ParseFiles("app/views/layout.html", temp)
}

func viewIndexHandler(w http.ResponseWriter, r *http.Request) {
	t, err := getTemplate("app/views/index.html")
	if err != nil {
		panic(err.Error())
	}
	if err := t.Execute(w, nil); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func viewControllerHandler(w http.ResponseWriter, r *http.Request) {
	t, err := getTemplate("app/views/controller.html")
	if err != nil {
		panic(err.Error())
	}
	if err := t.Execute(w, nil); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}



/*
	JSON
*/

// json.Marshalをオーバーライドする
// 使用例: 
// structのフィールドがプライベート（小文字）だと{}しか返されないので、
// オーバーライドする必要がある
func (b *Block) MarshalJSON() ([]byte, error) {
	return json.Marshal(struct {
		Nonce        int      `json:"nonce"`
		PreviousHash [32]byte `json:"previous_hash"`
		Timestamp    int64    `json:"timestamp"`
		Transactions []string `json:"transactions"`
	}{
		Nonce:        b.nonce,
		PreviousHash: b.previousHash,
		Timestamp:    b.timestamp,
		Transactions: b.transactions,
	})
}


/*
	数値のデータ型について
	https://go.dev/ref/spec#:~:text=a%20defined%20type.-,Numeric%20types,-An%20integer%2C%20floating
*/

// 整数型、浮動小数点型、複素数型は、それぞれ整数値、浮動小数点値、複素数値の集合を表す。
// これらは総称して数値型と呼ばれる。あらかじめ宣言されたアーキテクチャ非依存の数値型は次のとおりである。
uint8       the set of all unsigned  8-bit integers (0 to 255)
uint16      the set of all unsigned 16-bit integers (0 to 65535)
uint32      the set of all unsigned 32-bit integers (0 to 4294967295)
uint64      the set of all unsigned 64-bit integers (0 to 18446744073709551615)

int8        the set of all signed  8-bit integers (-128 to 127)
int16       the set of all signed 16-bit integers (-32768 to 32767)
int32       the set of all signed 32-bit integers (-2147483648 to 2147483647)
int64       the set of all signed 64-bit integers (-9223372036854775808 to 9223372036854775807)

float32     the set of all IEEE-754 32-bit floating-point numbers
float64     the set of all IEEE-754 64-bit floating-point numbers

complex64   the set of all complex numbers with float32 real and imaginary parts
complex128  the set of all complex numbers with float64 real and imaginary parts

byte        alias for uint8
rune        alias for int32



/*
	float型のprintfの出力
*/

// width: 数値の左のスペースの数（default 1）
// precision: 表示する小数点の位
/*
	%f     default width, default precision
	%9f    width 9, default precision
	%.2f   default width, precision 2
	%9.2f  width 9, precision 2
	%9.f   width 9, precision 0
*/

// 使用例.
func main() {
	f :=  5.01234567890123456789

	// default width, default precision
	fmt.Printf("Float 1: %f \n",f)

	// width 9, default precision
	fmt.Printf("Float 2: %9f \n",f)

	// default width, precision 2
	fmt.Printf("Float 3: %.2f \n",f)

	// width 9, precision 2
	fmt.Printf("Float 4: %9.2f \n",f)

	// width 9, precision 0
	fmt.Printf("Float 5: %9.f \n",f)
}

/*
	$ go run example.go
		=>Float 1: 5.012346 
		=	Float 2:  5.012346 
		=	Float 3: 5.01 
		=	Float 4:      5.01 
		=	Float 5:         5 
*/



/*
	compiler error
*/

// no result values expected
//=> 引数の型の記述忘れ