package main

import "fmt"

func init() {
	fmt.Println("init!")
}

func bazz() {
	fmt.Println("Bazz")
}

func main() {
	bazz()
	fmt.Printf("Hello world\n")
}

//// 出力
// init!
// Bazz
// Hello world

func main() {
	bazz()
	fmt.Println("Hello world!", "TEST TEST")
}

// Hello world! TEST TEST

/*
func init() {
	fmt.Println("init!")
}
*/

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("Hello world!", time.Now())
}




import (
	"fmt"
	"os/user"
	"time"
)

func main() {
	fmt.Println("Hello world!", time.Now())
	fmt.Println(user.Current())
}
// Hello world! 2021-07-14 23:09:50.323534 +0900 JST m=+0.000159064
// &{501 20 yagitadashito 八木雅斗 /Users/yagi0516} <nil>

func main() {
	var i int = 1
	var f64 float64 = 1.2
	var s string = "test"
	var t bool = true
	var f bool = false
	fmt.Println(i, f64, s, t, f)
}
// 1 1.2 test true false

func main() {
	var t, f bool = true, false
	fmt.Println(t, f)
}
// true false


func main() {
	var (
		s    string = "test"
		t, f bool   = true, false
	)
	fmt.Println(s, t, f)
}
// test true false


func main() {
	var (
		i    int
		f64  float64
		s    string
		t, f bool
	)
	fmt.Println(i, f64, s, t, f)
}
0 0  false false


func main() {
	var ( // 関数外でも宣言できる
		i    int     = 1
		f64  float64 = 1.2
		s    string  = "test"
		t, f bool    = true, false
	)
	fmt.Println(i, f64, s, t, f)

	// 関数内のみ
	xi := 1
	xf64 := 1.2
	xs := "test"
	xt, xf := true, false
	fmt.Println(xi, xf64, xs, xt, xf)
}
// 1 1.2 test true false
// 1 1.2 test true false


// 短い変数宣言だと浮動小数点は float64 にしかならない
func main() {
	xf64 := 1.2
	fmt.Printf("%T", xf64)
}
// float64

// float32にする場合は、長い記述で書かなければならない
func main() {
	var f32 float32 = 1.2
	fmt.Printf("%T", f32)
}
// float32

// Printfn は改行されない
func main() {
	xi := 1
	var f32 float32 = 1.2
	fmt.Printf("%T", xi)
	fmt.Printf("%T", f32)
}
// intfloat32


// 改行のために、\nを入れる必要あり
func main() {
	xi := 1
	var f32 float32 = 1.2
	fmt.Printf("%T\n", xi)
	fmt.Printf("%T\n", f32)
}
// int
// float32


func main() {
	xi := 1
	xi = 2
	fmt.Println(xi)
}
// 2


// 変数に代入する時は : はいらない
func main() {
	xi := 1
	xi := 2
	fmt.Println(xi)
}
// no new variables on left side of :=


const Pi = 3.14

const (
	Username = "test_user"
	Password = "password"
)

func main() {
	fmt.Println(Pi, Username, Password)
}
// 3.14 test_user password


// 数値型
func main() {
	var (
		u8  uint8     = 255
		i8  int8      = 127
		f32 float32   = 0.2
		c64 complex64 = -5 + 12i
	)
	fmt.Println(u8, i8, f32, c64)
	fmt.Printf("%T %v", u8, u8)
}
// 255 127 0.2 (-5+12i)
// uint8 255


func main() {
	var (
		u8  uint8     = 255
		i8  int8      = 127
		f32 float32   = 0.2
		c64 complex64 = -5 + 12i
	)
	fmt.Println(u8, i8, f32, c64)
	fmt.Printf("type=%T value=%v", u8, u8)
}
// 255 127 0.2 (-5+12i)
// type=uint8 value=255
// https://pkg.go.dev/fmt 参照


func main() {
	fmt.Println("1 + 1 =", 1+1)
	fmt.Println("10 - 1 =", 10-1)
	fmt.Println("10 / 2 =", 10/2)
	fmt.Println("10 / 3 =", 10/3)
	fmt.Println("10.0 / 3 =", 10.0/3)
	fmt.Println("10 / 3.0 =", 10/3.0)
	fmt.Println("10 % 2 =", 10%2)
	fmt.Println("10 % 3 =", 10%3)
}

// 1 + 1 = 2
// 10 - 1 = 9
// 10 / 2 = 5
// 10 / 3 = 3
// 10.0 / 3 = 3.3333333333333335
// 10 / 3.0 = 3.3333333333333335
// 10 % 2 = 0
// 10 % 3 = 1


func main(
	x := 0
	fmt.Println(x)
	// x = x + 1
	x++
	fmt.Println(x)
	// x = x + 1
	x--
	fmt.Println(x)
)
// 0
// 1
// 0


// シフト演算
func main(
	fmt.Println(1 << 0) // 0001 0001
	fmt.Println(1 << 1) // 0001 0010
	fmt.Println(1 << 2) // 0001 0100
	fmt.Println(1 << 3) // 0001 1000
)
// 1
// 2
// 4
// 8


func main() {
	fmt.Println("Hello, World!")
	fmt.Println("Hello," + " World!")
}
// Hello, World!
// Hello, World!


func main() {
	fmt.Println("Hello, World!"[0])
}
// 72   「H」ではなくASCIIコードか出力される


func main() {
	fmt.Println("Hello, World!"[0])
}


func main() {
	fmt.Println(string("Hello, World!"[0]))
}
// 「H」が出力される


func main() {
	var s string = "Hello, World"
	s[0] = "X"
	fmt.Println(s)
}
// cannot assign to s[0] (strings are immutable)
// 他の言語のように、配列っぽく扱えない！！


// 文字列の文字を置き換えるには、strings.Replace を使う
func main() {
	var s string = "Hello, World"
	fmt.Println(string("Hello, World!"[0]))
	fmt.Println(strings.Replace(s, "H", "X", 1))
}
// H
// Xello, World


func main() {
	var s string = "Hello, World"
	fmt.Println(strings.Contains(s, "World"))
}
// true


func main() {
	fmt.Println("Test" +
		"Test")
}
// TestTest


func main() {
	fmt.Println("Test\n" +
		"Test")
}
// Test
// Test



// バッククォートで見た目通りに文字列を出力
func main() {
	fmt.Println(`Test1
	                  Test2
	Test3`)
}
// Test1
// 	                  Test2
// 	Test3


func main() {
	fmt.Println(`"`)
	fmt.Println("\"")
}
// "
// "



type Page struct {
	Title string
	Body  []byte
}

// Page構造体に対してsaveメソッドを定義してる
func (p *Page) save() error {
	filename := p.Title + ".txt"
	return ioutil.WriteFile(filename, p.Body, 0600)
}

// string型の引数を取り、Pageのポインタを返す関数
func loadPage(title string) (*Page, error) {
	filename := title + ".txt"
	body, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	// ポインタで返す
	return &Page{Title: "test", Body: body}, nil
}

func main() {
	// ファイルを作成・保存
	p1 := &Page{Title: "test", Body: []byte("This is a sample Page.")}
	p1.save()
	// ファイルを読み込む
	p2, _ := loadPage(p1.Title)
	fmt.Println(string(p2.Body))
}




// section9-76
type Page struct {
	Title string
	Body  []byte
}

// Page構造体に対してsaveメソッドを定義してる
func (p *Page) save() error {
	filename := p.Title + ".txt"
	return ioutil.WriteFile(filename, p.Body, 0600)
}

// string型の引数を取り、Pageのポインタを返す関数
func loadPage(title string) (*Page, error) {
	filename := title + ".txt"
	body, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	// ポインタで返す
	return &Page{Title: "test", Body: body}, nil
}

func viewHandler(w http.ResponseWriter, r *http.Request) {
	title := r.URL.Path[len("/view/"):]
	p, _ := loadPage(title)
	fmt.Fprintf(w, "<h1>%s</h1><div>%s</div>", p.Title, p.Body)
}

func main() {
	// /view/~であれば、http.ListenAndServeに行く前にviewHandlerを呼び出す
	http.HandleFunc("/view/", viewHandler)
	// ポート8080でサーバーを起動
	log.Fatal(http.ListenAndServe(":8080", nil))
}




// section9-77
type Page struct {
	Title string
	Body  []byte
}

// Page構造体に対してsaveメソッドを定義してる
func (p *Page) save() error {
	filename := p.Title + ".txt"
	return ioutil.WriteFile(filename, p.Body, 0600)
}

// string型の引数を取り、Pageのポインタを返す関数
func loadPage(title string) (*Page, error) {
	filename := title + ".txt"
	body, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	// ポインタで返す
	return &Page{Title: "test", Body: body}, nil
}

// テンプレートを描画する関数
func renderTemplate(w http.ResponseWriter, tmpl string, p *Page) {
	t, _ := template.ParseFiles(tmpl + ".html")
	t.Execute(w, p)
}

// view.htmlにview/以下のページ名を渡す
func viewHandler(w http.ResponseWriter, r *http.Request) {
	title := r.URL.Path[len("/view/"):]
	p, _ := loadPage(title)
	renderTemplate(w, "view", p)
}

// edit.htmlにedit/以下のページ名を渡す
func editHandler(w http.ResponseWriter, r *http.Request) {
	title := r.URL.Path[len("/edit/"):]
	p, err := loadPage(title)
	if err != nil {
		p = &Page{Title: title}
	}
	renderTemplate(w, "edit", p)
}

func main() {
	// /view/~であれば、http.ListenAndServeに行く前にviewHandlerを呼び出す
	http.HandleFunc("/view/", viewHandler)
	http.HandleFunc("/edit/", editHandler)
	// ポート8080でサーバーを起動
	log.Fatal(http.ListenAndServe(":8080", nil))
}