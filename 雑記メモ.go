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
