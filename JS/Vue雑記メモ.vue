<div id="app">
  <p>{{ message }}</p>
  <p>{{ number * 3 }}</p>
  <p>{{ ok ? 'YES' : 'NO' }}</p>
  <p>{{ sayHi() }}</p>
</div>

new Vue({
	el: '#app',
  data: {
  	message: 'Hello World!',
    number: 3,
    ok: false
  },
  methods: {
  	sayHi: function() {
    	return this.message;
    }
  }
})

Hello World!

9

NO

Hello World!



<div id="app">
  <p>{{ message }}</p>
  <p v-text="message"></p>
</div>

new Vue({
	el: '#app',
  data: {
  	message: 'Hello World!'
  }
})

Hello World!

Hello World!


<div id="app">
  <p>{{ message }}</p>
  <p>{{ sayHi() }}</p>
</div>

new Vue({
	el: '#app',
  data: {
  	message: 'Hello World!'
  },
  methods: {
  	sayHi() {
    	return 'Hi'
    }
  }
})

Hello World!

Hi


// methodsでmessageが書き換えられてしまう！！
// v-onceディレクティブで一度だけ描画させる！！ (データを変更させたくない場合)
<div id="app">
  <p v-once>{{ message }}</p>
  <p>{{ message }}</p>
  <p>{{ sayHi() }}</p>
</div>

new Vue({
	el: '#app',
  data: {
  	message: 'Hello World!'
  },
  methods: {
  	sayHi() {
    	this.message = 'Hello VueJS'
    	return 'Hi'
    }
  }
})

Hello World!

Hello VueJS

Hi


// v-html
// XSSの危険性がある！！
// HTMLを表示させる
<div id="app">
  <div>{{ html }}</div>
  <div v-html="html"></div>
</div>

new Vue({
	el: '#app',
  data: {
  	html: '<h1>h1やで</h1>'
  }
})

<h1>h1やで</h1>
h1やで


// v-bind(省略可)
<div id="app">
  <a v-bind:href="url">Google</a>  // hrefと"url"の２つの引数をとる
  <a :href="url">Google</a>        // 省略可能
</div>

new Vue({
	el: '#app',
  data: {
  	url: 'https://google.com'
  }
})

Google Google


// 以下は冗長なので修正が必要
<div id="app">
  <a :[attribute]="url">Google</a>
  <a :href="urlTwitter" id="number">Twitter</a>
</div>

new Vue({
	el: '#app',
  data: {
  	url: 'https://google.com',
    urlTwitter: 'https://twitter.com',
    number: 31,
    attribute: 'href'
  }
})

Google Twitter


// 修正１. テンプレでObjectにまとめる
<div id="app">
  <a v-bind="{href: urlTwitter, id: number}">Twitter</a>
</div>

// 修正２. Twitter Objectにまとめてしまうパターン
<div id="app">
  <a :[attribute]="url">Google</a>
  <a v-bind="twitterObject">Twitter</a>       // 省略できなくなる！（たぶん）
</div>

new Vue({
	el: '#app',
  data: {
  	url: 'https://google.com',
    attribute: 'href',
    twitterObject: {
    	href: 'https://twitter.com',
      id: 31
    }
  }
})


// v-on
// ボタンをクリックするとnumberが1づつ増えていく
<div id="app">
  <p>現在{{ number }}回クリックされています</p>
  <button v-on:click="countUp">カウントアップ</button>
</div>

new Vue({
	el: '#app',
  data: {
  	number: 0
  },
  methods: {
  	countUp: function() {
    	this.number += 1
    }
  }
})


// v-on を使ってマウスのポジションを表示する
<div id="app">
  <p v-on:mousemove="changeMousePosition">マウスを載せてください</p>
  <p>X:{{x}}, Y:{{y}}</p>
</div>

new Vue({
	el: '#app',
  data: {
    x: 0,
    y: 0
  },
  methods: {
    changeMousePosition: function(e) {
    	this.x = e.clientX,
      this.y = e.clientY
    }
  }
})

マウスを載せてください

X:7, Y:122


// v-on:の引数の使い方とか
<div id="app">
  <p>現在{{ number }}回クリックされています</p>
  <button v-on:click="countUp(2)">カウントアップ</button>
  <p v-on:mousemove="changeMousePosition(10, $event)">マウスを載せてください</p>
  <p>X:{{x}}, Y:{{y}}</p>
</div>

new Vue({
	el: '#app',
  data: {
  	number: 0,
    x: 0,
    y: 0
  },
  methods: {
  	countUp: function(times) {
    	this.number += 1 * times
    },
    changeMousePosition: function(divideNumber, e) {
    	this.x = e.clientX / divideNumber;
      this.y = e.clientY / divideNumber;
    }
  }
})

現在0回クリックされています

カウントアップ

マウスを載せてください

X:53.9, Y:10.6



//// 伝播させない(spanタグ下のpタグのmousemoveイベントを発火させない=バブリングを止める)
<div id="app">
  <p>現在{{ number }}回クリックされています</p>
  <button v-on:click="countUp(2)">カウントアップ</button>
  <p v-on:mousemove="changeMousePosition(10, $event)">マウスを載せてください
  <span v-on:mousemove="noEvent">反応しないでください</span></p>
  <p>X:{{x}}, Y:{{y}}</p>
</div>

new Vue({
	el: '#app',
  data: {
  	number: 0,
    x: 0,
    y: 0
  },
  methods: {
  	countUp: function(times) {
    	this.number += 1 * times
    },
    changeMousePosition: function(divideNumber, e) {
    	this.x = e.clientX / divideNumber;
      this.y = e.clientY / divideNumber;
    },
    noEvent: function(e) {
    	e.stopPropagation(); <- イベントを伝播させない（バブリングを止める）
    }
  }
})

// .stop(イベント修飾子)を使ったやり方
<div id="app">
  <p>現在{{ number }}回クリックされています</p>
  <button v-on:click="countUp(2)">カウントアップ</button>
  <p v-on:mousemove="changeMousePosition(10, $event)">マウスを載せてください
  <span v-on:mousemove.stop>反応しないでください</span></p>
  <p>X:{{x}}, Y:{{y}}</p>
</div>


現在0回クリックされています

カウントアップ

マウスを載せてください 反応しないでください

X:57.5, Y:10



// .stop(イベント修飾子)を使って、マウスイベントの伝播を止めて、他のイベントを発火させる場合
<div id="app">
  <p>現在{{ number }}回クリックされています</p>
  <button v-on:click="countUp(2)">カウントアップ</button>
  <p v-on:mousemove="changeMousePosition(10, $event)">マウスを載せてください
  <span v-on:mousemove.stop="popAlert">反応しないでください</span></p>   <-- ここ！！
  <p>X:{{x}}, Y:{{y}}</p>
</div>

new Vue({
	el: '#app',
  data: {
  	number: 0,
    x: 0,
    y: 0
  },
  methods: {
  	countUp: function(times) {
    	this.number += 1 * times
    },
    changeMousePosition: function(divideNumber, e) {
    	this.x = e.clientX / divideNumber;
      this.y = e.clientY / divideNumber;
    },
    popAlert: function() {
    	alert("マウスポジションではなく、popAlert関数を実行");
    }
  }
})


//// prevent(デフォルトの挙動をしない！)
<div id="app">
  <p v-on:mousemove="changeMousePosition(10, $event)">マウスを載せてください
  <span v-on:mousemove.stop>反応しないでください</span></p>
  <p>X:{{x}}, Y:{{y}}</p>
  <a v-on:click="noEvent" href="https:google.com">Google</a>
</div>

new Vue({
	el: '#app',
  data: {
  	number: 0,
    x: 0,
    y: 0
  },
  methods: {
    changeMousePosition: function(divideNumber, e) {
    	this.x = e.clientX / divideNumber;
      this.y = e.clientY / divideNumber;
    },
    noEvent: function(e) {
    	e.preventDefault();  <-- ここ！！ preventDefault()で、デフォルトの挙動を止めている
    }
  }
})


<div id="app">
  <p v-on:mousemove="changeMousePosition(10, $event)">マウスを載せてください
  <span v-on:mousemove.stop>反応しないでください</span></p>
  <p>X:{{x}}, Y:{{y}}</p>
  <a v-on:click.prevent="noEvent" href="https:google.com">Google</a>  <-- ここ！！(prevent修飾子)
</div>


// aタグのURLのページに飛ぶイベントが行われなくなる
<a href="https://Google.com" v-on:click.prevent>Google</a>

↓と同じ意味

<a href="https://Google.com" v-on:click="noEvent">Google</a>

...
    noEvent: function(evt) {
    	evt.preventDefault();
    }
...


// キー修飾子
...
  <input type="text" v-on:keyup.enter="myAlert">
...

...
    myAlert: function() {
    	alert("Enterしましたよね？はい か いいえ で答えてください")
    }
...


// v-onディレクティブの引数を[ ]を使って動的に表現する
...
  <p>現在{{ number }}回クリックされています</p>
  <button v-on:[event]="countUp()">カウントアップ</button>
...

...
  data: {
  	number: 0,
		event: 'click' <--- ここ！！
  },
...


// @マークを使ってv-onを省略記法で書く
...
  <p>現在{{ number }}回クリックされています</p>
  <button @click="countUp()">カウントアップ</button>
...

...
  methods: {
  	countUp: function() {
    	this.number += 1
    }
  }
...


// v-modelを使用して、双方向バインディングを作成する
// input の内容がすぐに message に反映される
<div id="app">
  <input type="text" v-model="message">  <--- ここ！！
  <h1>{{ message }}</h1>   <--- ここ！！
</div>

new Vue({
	el: '#app',
  data: {  // モデルといったりもする
  	message: 'こんにちは！'   <--- ここ！！
  }
})


// computedプロパティを使って、動的なデータを表現する
...
  <p>{{ number > 3 ? '3より上' : '3以下' }}</p> <-- 動的なプロパティ
  <button @click="number += 1">+</button>     <-- クリックでnumberを足していく
...

...
  data: {  // dataはあくまでも固定値(初期値)
  	number: 0  <-- data内でJSコードやthis.~~ で他のデータにアクセスできない
  }
...

↓ computedプロパティで書く
...
  <p>{{ lessThanThree }}</p>
  <button @click="number += 1">+</button>
...

...
  data: {
  	number: 0
  },
  computed: {    <-- ここ！！
  	lessThanThree: function() {
    	return this.number > 3 ? '3より上' : '3以下'
    }
  }
...


// computedとmethodの違いを理解

<div id="app">
  <p>数値: {{ number }}</p>
  
  <p>{{ lessThanThreeComputed }}</p>
  <p>{{ lessThanThreeMethod() }}</p>
  <button @click="number += 1">+</button>
  
  // otherNumber が変化（再描画）する度に、lessThanThreeMethod()が実行される
  <p>別の数値: {{ otherNumber }}</p>
  <button @click="otherNumber += 1">別の+</button>
</div>

...
  data: {
  	number: 0,
    otherNumber: 0
  },
  computed: { // 参照先のデータ(number)が変わった時のみ実行される
  	lessThanThreeComputed: function() {
    	console.log('computedが呼ばれました');
    	return this.number > 3 ? '3より上' : '3以下'
    }
  },
  methods: { // 描画されるたびに毎回実行される
  	lessThanThreeMethod: function() {
    	console.log('methodが呼ばれました');
    	return this.number > 3 ? '3より上' : '3以下'
    }
  }
...


// ウォッチャを使って、データが変わった時に特定の処理をする
 
...
  <p>クリック数: {{ number }}</p>
  
  <p>{{ lessThanThreeComputed }}</p>
  <button @click="number += 1">+1</button>
...

...
  data: {
  	number: 0,
    otherNumber: 0
  },
  computed: { // 参照先のデータが変わった時のみ実行される
  	lessThanThreeComputed: function() {
    	return this.number > 3 ? '3より上' : '3以下'
    }
  },
  watch: {
  	number: function() {  // 監視するデータ(number)を記述する！！！
    	const vm = this;    // データにアクセスする際は、左記のように書く！！(ES6は const、varをよく見る？)
      setTimeout(function(){
      	vm.number = 0
      }, 3000)
    }
  }
...



// 丸カッコ()は、二重中括弧とv-onディレクティブにおいて、いつ必要なのか

...
  <p>クリック数: {{ counter }}</p>

  <-- v-onディレクティブ内では、()は付けても付けなくても良い -->
  <button @click="countUp">+1</button>　　<-- ()なしでは、Vue側で処理している
  <button @click="countUp()">+1</button>  <-- ()ありでは、JSコードとして処理している
  
  <p>{{ doubleCounterComputed }}</p>  <-- computedプロパティには、()をつけない
  <p>{{ doubleCounterMethod }}</p>    <-- methodプロパティには、()を付ける必要がある！！！
  <p>{{ doubleCounterMethod() }}</p>  <-- methodプロパティには、()を付ける必要がある！！！
...

...
  data: {
  	counter: 0
  },
  computed: {
  	doubleCounterComputed: function() {
    	return this.counter * 2;
    }
  },
  methods: {
  	countUp: function() {
    	this.counter += 1;
    },
    doubleCounterMethod: function() {
    	return this.counter * 2;
    }
  }
...


// クラスをデータにバインディング(紐付け)する方法その１

CSS
.red {
  color: red;
}
.bg-blue {
  background: blue;
}


<div id="app">
  <h1 :class="{ red: isActive, 'bg-blue': !isActive }">Hello</h1>
  <button @click='isActive = !isActive'>切り替え</button>
</div>

...
  data: {
  	isActive: true
  }
...


...(classObjectにまとめる ver)
  data: {
  	isActive: true
  },
  computed: {
  	classObject: function() {  // classObject内の isActive が変化するたびに算出が行われる
    	return {
      	red: this.isActive,
        'bg-blue': !this.isActive
      }
    }
  }
...


// クラスをデータにバインディングする方法その2。
// 配列を使って適応させたいクラスを並べる

...
  <button @click='isActive = !isActive'>切り替え</button>
  <h1 :class="[color, bg]">Hello</h1>            <-- 固定値で指定
  <h1 :class="[{red: isActive}, bg]">Hello</h1>  <-- colorについては表示切替可能にする
...

...
  data: {
  	isActive: true,
    color: 'red',
    bg: 'bg-blue'
  },
  computed: {
  	classObject: function() {
    	return {
      	red: this.isActive,
        'bg-blue': !this.isActive  <-- isActive を切り替えている
      }
    }
  }
...


// スタイル属性を、オブジェクトを用いて動的にバインディング

...
  <h1 style="color: red; background-color: blue;">Hello</h1>
  <-- ↓スタイル属性をdataとバインディングして、動的に切り替える -->
  <h1 :style="{color: textColor, 'background-color': bgColor}">Hello</h1>
...

new Vue({
	el: '#app',
  data: {
  	textColor: 'red',
    bgColor: 'blue'
  }
})


// スタイルオブジェクトをデータに書いて、コードを見やすくする

<div id="app">
  <h1 style="color: red; background-color: blue;">Hello</h1>
  
  <h1 :style="styleObject">Hello</h1>  <-- ここ！！
</div>

...
  data: {
  	styleObject: {  // オブジェクトにまとめている！！
    	color: 'red',
      'background-color': 'blue'
    }
  }
...



// 動的なstyleの切替（自作）
<div id="app">  
  <h1 :class="{red: isActive, blue: isActive}">Hello</h1>
  <button @click="changeColor()">切替</button>
</div>

.red {
  color: red;
}
.blue {
  background-color: blue;
}

new Vue({
	el: '#app',
  data: {
    isActive: true
  },
  methods: {
  	changeColor: function() {
    	this.isActive = !this.isActive
    }
  }
})


// スタイルオブジェクトをデータに書いて、コードを見やすくする
<div id="app">
  <h1 style="color: red; background-color: blue;">Hello</h1>
  <h1 :style="styleObject">Hello</h1>  <-- 上と同じ属性をもつ！！
</div>

new Vue({
	el: '#app',
  data: {
    styleObject: {  // ここ！！
    	color: 'red',
      'background-color': 'blue'
    }
  }
})


// 複数のスタイルオブジェクトを配列構文を用いて適応させる

<div id="app">
  <-- ↓ベーススタイルと固有スタイルを適用させている！！(配列で渡す) -->
  <h1 :style="[baseStyles, styleObject]">大きくなっちゃった</h1>
</div>

new Vue({
	el: '#app',
  data: {
    styleObject: {  // 固有スタイル
    	color: 'red',
      'background-color': 'blue'
    },
    baseStyles: {  // ベーススタイル
    	fontSize: '60px'
    }
  }
})


// v-ifディレクティブを使って、条件に応じて描画する処理を書く

<div id="app">
  <p v-if="isOK">OK!</p>
</div>

new Vue({
	el: '#app',
  data: {
  	isOK: true
  }
})


// v-elseを使って、v-ifがfalseの場合の処理を書く

<div id="app">
  <p v-if="isOK">OK!</p>
  <p v-else>NG!</p>    <-- v-ifの直下に存在する必要がある！！！
</div>

new Vue({
	el: '#app',
  data: {
  	isOK: false
  }
})


// v-else-ifを使って、複雑な条件式を作る

<div id="app">
  <p v-if="isOK">OK!</p>
  <p v-else-if="maybeOK">maybe OK...</p>
  <p v-else>NG!</p>
</div>

new Vue({
	el: '#app',
  data: {
  	isOK: false,
    maybeOK: true
  }
})

maybe OK...


// templateタグを使用して、不必要な要素を加えずにv-ifでHTMLの表示切替を行う

<div id="app">
  <template v-if="isOK">
    <p>切り替えられるHTML</p>
  </template>
  <button @click="isOK = !isOK">表示切替</button>
</div>

new Vue({
	el: '#app',
  data: {
  	isOK: true
  }
})

切り替えられるHTML

表示切替



// v-showを使って、頻繁に何かを切り替える処理のパフォーマンスを考える
<div id="app">
  <p v-if="isOK">v-ifで切り替えられる</p>        <-- HTMLごと消える(処理が重い)
  <p v-show="isOK">v-showで切り替えられる</p>    <-- display: noneで消える(初期描画のコストが掛かる)
  <template v-show="isOK">
    <p>template内なので、表示切替されない</p>      <-- 消えない
  </template>
  <button @click="isOK = !isOK">表示切替</button>
</div>

new Vue({
	el: '#app',
  data: {
  	isOK: true
  }
})


// v-forディレクティブを使用して、配列に基づいてリストを描画する

<div id="app">
  <li v-for="fruit in fruits">{{ fruit }}</li>
</div>

new Vue({
	el: '#app',
  data: {
  	fruits: ['バナナ', 'グレープフルーツ', 'いちご']
  }
})

バナナ
グレープフルーツ
いちご


// ２つ目の引数に配列のインデックスを取ってv-forを使用する
<div id="app">
  <li v-for="(fruit, index) in fruits">{{ index }}: {{ fruit }}</li>
</div>

new Vue({
	el: '#app',
  data: {
  	fruits: ['バナナ', 'グレープフルーツ', 'いちご']
  }
})

0: バナナ
1: グレープフルーツ
2: いちご



// オブジェクトに対してv-forディレクティブを使用する
// オブジェクトのv-forには、第２引数と第３引数にキーとインデックスをとる

<div id="app">
  <ul>
    <li v-for="(value, key, index) in nameObj">
      ({{ index }}) {{ key }}: {{ value }}
     </li>
  </ul>
</div>

new Vue({
	el: '#app',
  data: {
    nameObj: {
    	firstName: '太郎',
      lastName: '未来',
      age: 21
    }
  }
})

(0) firstName: 太郎
(1) lastName: 未来
(2) age: 21


// templateタグを使用して、不必要な要素を加えずにv-forを複数表示させる
<div id="app">
  <ul>
    <template v-for="fruit in fruits">
      <li>{{ fruit }}</li>
      <hr>
    </template>
  </ul>
</div>

new Vue({
	el: '#app',
  data: {
    fruits: ['りんご', 'バナナ', 'ぶどう']
  }
})

りんご
バナナ
ぶどう


// n in 10 のように、整数値に対してv-forを適用する
<div id="app">
  <ul>
    <template v-for="n in 5">
      <li>番号: {{ n }}</li>
      </template>
  </ul>
</div>



// inの代わりにofを使用する

<div id="app">
  <ul>
    <li v-for="fruit of fruits">{{ fruit }}</li>  <-- in ではなく of でも書ける！！
  </ul>
</div>

new Vue({
	el: '#app',
  data: {
    fruits: ['りんご', 'バナナ', 'ぶどう']
  }
})

りんご
バナナ
ぶどう



// key属性をつける必要性を学び、予期せぬバグを起こさないv-forを作る

<div id="app">
  <ul>
    <div v-for="fruit in fruits">
      <p>{{ fruit }}</p>
      <input type="text">
    </div>
  </ul>
  <button @click="remove">先頭を削除</button>
</div>

new Vue({
	el: '#app',
  data: {
    fruits: ['りんご', 'バナナ', 'ぶどう']
  },
  methods: {
  	remove: function() {
    	this.fruits.shift()
    }
  }
})

りんご        <-- removeを押すとりんごは削除されるが、、、
Apple Input  <-- Input tagに入ったAppleは残り、Apple Input と Banana Input が残る

バナナ
Banana Input

ぶどう
Grape Input


* divタグに一意のキーを与える

<div id="app">
  <ul>
    <-- v-forを使う時は、必ず一意のキー属性を付ける！！ -->
    <div v-for="fruit in fruits" :key="fruit">  <- 配列に同じ要素があると使えなくなる！(=一意でなくなる)
      <p>{{ fruit }}</p>
      <input type="text">
    </div>
  </ul>
  <button @click="remove">先頭を削除</button>
</div>



// Vue インスタンスは複数作ることができる
// 独立したVue インスタンス同士でやり取りする場合、
// 処理が複雑になるので、その場合は１つにまとめる！！
<div id="app1">
  <p>{{ message }}</p>
</div>
<div id="app2">
  <p>{{ message }}</p>
</div>

new Vue({
	el: '#app1',
  data: {
  	message: 'メッセージ１'
  }
})
new Vue({
	el: '#app2',
  data: {
  	message: 'メッセージ２'
  }
})



// 外側からVue インスタンスにアクセスする方法

<div id="app1">
  <p>{{ message }}</p>
</div>
<div id="app2">
  <p>{{ message }}</p>
  <button @click="changeMessage1">メッセージ1を変更</button>
</div>
<button @click="changeMessage1">動かないボタン</button>  <-- #app2の外側なので動作しない！！

var vm1 = new Vue({
	el: '#app1',
  data: {
  	message: 'メッセージ１'
  }
})
var vm2 = new Vue({
	el: '#app2',
  data: {
  	message: 'メッセージ２'
  },
  methods: {
  	changeMessage1: function() {
    	vm1.message = '変更済みメッセージ１'  <-- 外側のVueインスタンスのアクセスには、変数経由で書き換える
    }
  }
})



// リアクティブシステム(getter、setter、Watcher)がどのように動いているか確認し、
// プロパティが後から追加できないことを確認する

<div id="app">
  <p>{{ message }}</p>
  <p>{{ name }}</p>
  <button @click="addition = '変更済データ'">変更</button>  <- HTMLのnameは変化しない(リアクティブでない
</div>

var vm = new Vue({
	el: '#app',
  data: { // getterとsetter(get message、set message)が作成される
  	message: 'デフォルト'
  }
})

// あと付けのdata
vm.addition = '追加で加えたデータ'




// あと付けだとリアクティブにはならないが、先にオブジェクトを作成して入れ込むことはできる！！！

<div id="app">
  <p>{{ message }}</p>
  <p>{{ name }}</p>
</div>

// ↓これ！！！
var data = {
	message: 'こんにちは',
  name: '八木'
}

var vm = new Vue({
	el: '#app',
  data: data
})

// dataプロパティにアクセス
console.log(vm.$data);  <- 大体、元々備わっているプロパティには、$(ダラー)がついている

console.log(vm.$data == data) 
//=> true



// dataはなぜコンポーネントにおいて関数である必要があるの
Vue.component('my-component', {
	data: function() {   <-- コンポーネントにおいては、関数である必要がある
  	return {
    	number: 12
    }
  },
  template: '<p>いいね({{ number }})</p>'
})

new Vue({
	el: '#app'
})


var global_data = { // numberを共有する
	number: 12
}

Vue.component('my-component', {
	data: function() {
  	return global_data 　 <-- 共有の変数
  },
  template: '<p>いいね({{ number }})<button @click="increment">+1</button></p>',
  methods: {
  	increment: function() {
    	this.number += 1
    }
  }
})

new Vue({
	el: '#app'
})

// 全て一緒に数値が追加される
いいね(17)+1

いいね(17)+1

いいね(17)+1


// コンポーネントにおける、ローカル登録とグローバル登録の違いを理解する

var component = {
	data: function() {
  	return {
    	number: 12
    }
  },
  template: '<p>いいね({{ number }})<button @click="increment">+1</button></p>',
  methods: {
  	increment: function() {
    	this.number += 1;
    }
  }
}

new Vue({
	el: '#app1',
  components: {
  	'my-component': component
  }
})

new Vue({
	el: '#app2'
})


//// コンポーネントのローカル登録
var ComponentA = { /* ... */ }

var ComponentB = {
  components: {
    'component-a': ComponentA
  },
  // ...
}
// もしくは、Babel と Webpack のようなものを用いて 
// ES2015 モジュールを利用しているならば、このようになる
import ComponentA from './ComponentA.vue'

export default {
  components: {
    ComponentA
  },
  // ...
}