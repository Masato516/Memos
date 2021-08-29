//// イベント修飾子

イベント修飾子は以下の6種類がある

.stop
.prevent
.capture
.self
.once
.passive

.stop
子要素のイベントが親のイベントを呼び出さないように設定
→ 親要素への伝搬を止める
JavaScriptのstopPropagationを呼び出す

.prevent
JavaScriptのEvent.preventDefaultメソッドを呼び出す
意図しない画面遷移、画面更新を避けるため.preventが有効
フォームのsubmitを押した後に、画面遷移を行わない 等


// キー修飾子
以下のキー修飾子が用意されている
指定したキーを押下した時に、関数を呼び出す事ができる

.enter
.tab
.delete
.esc
.space
.up
.down
.left
.right

(index.html)
<div id="app">
  // エンターキーを押した時にアラートを表示
  <input type="text" v-on:keyup.enter="alert">
</div>

(index.js)
new Vue({
  el: '#app',
  methods: {
    alert() {
      alert("アラート！");
    }
  }
})


//// v-onディレクティブ(省略形：@)
DOM イベントの購読、イベント発火時の JavaScript の実行が可能になる
v-on:DOMイベント="メソッド名"

methodプロパティは()を付けても付けなくても良い

//// v-model
双方向バインディング


////computed(算出)プロパティ
methodsは
描画されるたびに毎回実行される

computedは
参照先のデータ(number)が変わった時のみ実行される

()は付けない！


//// watch(監視)プロパティ
// ユースケース
基本的には、computedプロパティを使う！！
computedではHTMLに表示されるようなものにしか利用できない
↓
watch を利用する！
(Ajaxなどの非同期処理で利用される)

ウォッチャープロパティ
...
  watch: {
    // この関数は question が変わるごとに実行されます。
    // 監視する変数をキー？として登録する
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
...

