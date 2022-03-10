package main

// func main() {
// 	var p *int = new(int)
// 	fmt.Println(p)
// 	fmt.Println(*p)
// 	*p++
// 	fmt.Println(*p)
//
// 	var p2 *int
// 	fmt.Println(p2)
// 	*p2++ //=>メモリに確保されていないので、invalid memory errorを起こす
// 	fmt.Println(p2)
// }

// func main() {
// 	n := []int{1, 2, 3, 4, 5, 6}
// 	fmt.Println(n)
// 	fmt.Println(n[1:4])
//
// 	n[2] = 300
// 	fmt.Println(n)
//
// 	var board = [][]int{
// 		{0, 1, 2},
// 		{3, 4, 5},
// 		{6, 7, 8},
// 	}
// 	fmt.Println(board)
//
// 	n = append(n, 100, 200, 300)
// 	fmt.Println(n)
// }

// func main() {
// 	n := []int{1, 2, 3, 4, 5, 6}
// 	fmt.Println(n)
//
// 	n[2] = 20
//
// 	var board = [][]int{
// 		{1, 2, 3},
// 		{4, 5, 6},
// 		{7, 8, 9},
// 	}
// 	fmt.Println(board)
//
// 	fmt.Println(&n)
// 	n = append(n, 100, 200, 300)
// 	fmt.Println(&n)
// }

// func main() {
// 	n := make([]int, 3, 5)
// 	fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
//
// 	n = append(n, 1, 2)
// 	fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
//
// 	n = append(n, 3, 4, 5)
// 	fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
//
// 	n = append(n, 6, 7, 8)
// 	fmt.Printf("len=%d cap=%d value=%v\n", len(n), cap(n), n)
// }

// func goroutine(s string, wg *sync.WaitGroup) {
// 	defer wg.Done()
// 	for i := 0; i < 5; i++ {
// 		fmt.Println(s)
// 	}
// }
//
// func normal(s string) {
// 	for i := 0; i < 5; i++ {
// 		fmt.Println(s)
// 	}
// }
//
// func main() {
// 	var wg sync.WaitGroup
// 	wg.Add(1)
// 	go goroutine("だあああああ", &wg)
// 	normal("てぃああああ")
// 	wg.Wait()
// }

// func goroutine1(s []int, c chan int) {
// 	sum := 0
// 	for _, v := range s {
// 		sum += v
// 	}
// 	c <- sum
// }
//
// func goroutine2(s []int, c chan int) {
// 	sum := 0
// 	for _, v := range s {
// 		sum += v
// 	}
// 	c <- sum
// }
//
// func main() {
// 	s1 := []int{1, 2, 3, 4, 5}
// 	s2 := []int{6, 7, 8, 9, 10}
// 	c := make(chan int)
// 	go goroutine1(s1, c)
// 	go goroutine2(s2, c)
// 	x := <-c
// 	fmt.Println(x)
// 	y := <-c
// 	fmt.Println(y)
// }

// func main() {
// 	s1 := make([]int, 0)
// 	fmt.Printf("%T\n", s1)
//
// 	s2 := new([]int)
// 	fmt.Printf("%T\n", s2)
//
// 	m1 := make(map[string]int)
// 	fmt.Printf("%T\n", m1)
//
// 	m2 := new(map[string]int)
// 	fmt.Printf("%T\n", m2)
//
// 	ch1:= make(chan int)
// 	fmt.Printf("%T\n", ch1)
//
// 	ch2 := new(chan int)
// 	fmt.Printf("%T\n", ch2)
//
// 	// makeはslice、配列、mapにしか使えない
// 	var p *int = new(int)
// 	fmt.Printf("%T\n", p)
//
// 	var st = new(struct{})
// 	fmt.Printf("%T\n", st)
//
// }
//

// type ConfigList struct {
// 	Port      int
// 	DbName    string
// 	SQLDriver string
// }
//
// var Config ConfigList
//
// func init() {
// 	cfg, _ := ini.Load("config.ini")
// 	Config = ConfigList{
// 		Port:      cfg.Section("web").Key("port").MustInt(),
// 		DbName:    cfg.Section("db").Key("driver").MustString("example.sql"),
// 		SQLDriver: cfg.Section("db").Key("driver").String(),
// 	}
// }
//
// func main() {
// 	fmt.Printf("%T %v\n", Config.Port, Config.Port)
// 	fmt.Printf("%T %v\n", Config.DbName, Config.DbName)
// 	fmt.Printf("%T %v\n", Config.SQLDriver, Config.SQLDriver)
// }
//

// func longProcess(ctx context.Context, ch chan string) {
// 	fmt.Println("run")
// 	time.Sleep(3 * time.Second)
// 	fmt.Println("finish")
// 	ch <- "result"
// }
//
// func main() {
// 	ch := make(chan string)
// 	ctx := context.Background()
// 	ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
// 	defer cancel()
// 	go longProcess(ctx, ch)
//
// CTXLOOP:
// 	for {
// 		select {
// 		case <-ctx.Done():
// 			fmt.Println(ctx.Err())
// 			break CTXLOOP
// 		case <-ch:
// 			fmt.Println("success")
// 			break CTXLOOP
// 		}
// 	}
// 	fmt.Println("##################")
// }
//

// var s *semaphore.Weighted = semaphore.NewWeighted(1)
//
// func longProcess(ctx context.Context) {
// 	isAcquire := s.TryAcquire(1)
// 	if !isAcquire {
// 		fmt.Println("Could not get lock")
// 		return
// 	}
// 	defer s.Release(1)
// 	fmt.Println("Wait")
// 	time.Sleep(1 * time.Second)
// 	fmt.Println("Done")
// }
//
// func main() {
// 	ctx := context.TODO()
// 	go longProcess(ctx) // 実行
// 	go longProcess(ctx) // 終了
// 	go longProcess(ctx) // 終了
// 	time.Sleep(5 * time.Second)
// 	go longProcess(ctx) // 実行
// 	time.Sleep(3 * time.Second)
// }
//

// func goroutine1(ch chan string) {
// 	for {
// 		ch <- "packet from 1"
// 		time.Sleep(1 * time.Second)
// 	}
// }
//
// func goroutine2(ch chan string) {
// 	for {
// 		ch <- "packet from 2"
// 		time.Sleep(1 * time.Second)
// 	}
// }
//
// func main() {
// 	c1 := make(chan string)
// 	c2 := make(chan string)
//
// 	go goroutine1(c1)
// 	go goroutine2(c2)
//
// 	for {
// 		select {
// 		case msg1 := <-c1:
// 			fmt.Println(msg1)
// 		case msg2 := <-c2:
// 			fmt.Println(msg2)
// 		}
// 	}
// }
//

// func main() {
// 	tick := time.Tick(100 * time.Millisecond)
// 	boom := time.After(500 * time.Millisecond)
// OuterLoop:
// 	for {
// 		select {
// 		case <-tick:
// 			fmt.Println("tick.")
// 		case <-boom:
// 			fmt.Println("BOOM!")
// 			break OuterLoop
// 		default:
// 			fmt.Println("    .")
// 			time.Sleep(50 * time.Millisecond)
// 		}
// 	}
// 	fmt.Println("###################")
// }
//

// type Vertex struct {
// 	x, y int
// }
//
// func (v *Vertex) Area() int {
// 	return v.x * v.y
// }
//
// func (v *Vertex) Scale(i int) {
// 	v.x *= i
// 	v.y *= i
// }
//
// type Vertex3D struct {
// 	Vertex
// 	z int
// }
//
// func (v *Vertex3D) Area3D() int {
// 	return v.x * v.y * v.z
// }
//
// func (v *Vertex3D) Scale3D(i int) {
// 	v.x *= i
// 	v.y *= i
// 	v.z *= i
// }
//
// func New(x, y, z int) *Vertex3D {
// 	return &Vertex3D{Vertex{x, y}, z}
// }
//
// func main() {
// 	v := New(3, 4, 5)
// 	v.Scale3D(10)
// 	fmt.Println(v.Area())
// 	fmt.Println(v.Area3D())
// }
//

// type Vertex struct {
// 	x, y int
// }
//
// func (v *Vertex) Scale(i int) {
// 	v.x *= i
// 	v.y *= i
// }
//
// func (v *Vertex) Area() int {
// 	return v.x * v.y
// }
//
// type Vertex3D struct {
// 	Vertex
// 	z int
// }
//
// func (v *Vertex3D) Scale3D(i int) {
// 	v.x *= i
// 	v.y *= i
// 	v.z *= i
// }
//
// func (v *Vertex3D) Area3D() int {
// 	return v.x * v.y * v.z
// }
//
// func New(x, y, z int) *Vertex3D {
// 	return &Vertex3D{Vertex{x, y}, z}
// }
//
// func main() {
// 	v := New(1, 2, 3)
// 	v.Scale3D(10)
// 	fmt.Println(v.Area3D())
// }
//

// type Person struct {
// 	Name string
// 	Age  int
// }
//
// func (p Person) String() string {
// 	return fmt.Sprintf("My name is %v.", p.Name)
// }
//
// func main() {
// 	mike := Person{"Mike", 22}
// 	fmt.Println(mike)
// 	fmt.Print(mike)
// 	log.Println(mike)
// 	// My name is Mike.
// 	// My name is Mike.
// 	// 2022/03/01 23:58:31 My name is Mike.
// }
//

// // エラー出力するためのstruct
// type UserNotFound struct {
// 	Username string
// }
//
// // エラー内容
// func (e *UserNotFound) Error() string {
// 	return fmt.Sprintf("User not found: %v", e.Username)
// }
//
// // エラーを起こす関数
// func errFunc() error {
// 	ok := false
// 	if !ok {
// 		return &UserNotFound{Username: "Mcgregor"}
// 	}
// 	return nil
// }
//
// func main() {
// 	if err := errFunc(); err != nil {
// 		fmt.Println(err)
// 	}
// }
//

// func main() {
// 	var intFlag int
// 	flag.IntVar(&intFlag, "age", 0, "please specify -age flag")
// 	flag.Parse()
// 	fmt.Println("The age flag is ", intFlag)
// }

// func main() {
// 	intFlag := flag.Int("n", 0, "please specify -n flag")
// 	flag.Parse()
// 	fmt.Println("The n flag is ", *intFlag)
// }
//

// func main() {
// 	strFlag := flag.String("s", "デフォルト", "Please specify -s flag")
// 	flag.Parse()
// 	fmt.Println("The s flag is ", *strFlag)
// }

// func main() {
// 	var strFlag string
// 	flag.StringVar(&strFlag, "s", "デフォルト", "Please specify -s flag")
// 	flag.Parse()
// 	fmt.Printf("flag's type is %T\n", strFlag)
// 	fmt.Println("The s flag is ", strFlag)
// }

// func main() {
// 	command := flag.NewFlagSet("command name", flag.ExitOnError)
// 	version := command.Bool("version", false, "Output version information and exit")
//
// 	command.Parse(os.Args[1:])
//
// 	if *version {
// 		fmt.Fprintf(os.Stderr, "%s v0.0.1", command.Name())
// 	}
// }
// 