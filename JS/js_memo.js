//// 読むべき参考資料
const イマドキのJavaScriptの書き方2018 = 'https://qiita.com/shibukawa/items/19ab5c381bbb2e09d0d9'


// 連想配列
// JavaScriptのオブジェクトそのもの
// キーは文字列(に変換される)
// 連想配列に順番という概念がない(インデックスではアクセスできない)
let scores = {japanese: 50, '数学': 60, '社会': 80}
scores['japanese']
socres['数学']
// JavaScriptのすべてのオブジェクトは連想配列で書ける
// つまりObjectオブジェクトも、Stringオブジェクトも、Arrayオブジェクトも、
// みんな連想配列の形をしている
// 連想配列＝オブジェクト
// 正直イコール３つでも問題ないだろう（連想配列＝＝＝オブジェクト）
//true！ なのでキーというよりもプロパティ名と言った方が良い
// 一般的なプログラミング用語と JavaScript の用語を分けて考えるとわかりやすい
// 「連想配列」は一般的なプログラミングの用語
// 一方「Object」は JavaScript のデータ型
// JavaScript の Object は、単純に言うと「キーと値のペアの集合」
// なので、これは連想配列の性質を持っていると言える



// JSON
// キーには”文字列”を入れないとエラー発生
// 名前はJSONだが、これも連想配列
let json = {'japanese': 50, '数学': 60, '社会': 80}

//for文
let scores = [50, 70,90]
for(let i=0; i<scores.length; i++){
    console.log(scores[i]);
}

// for..in文
// 連想配列のプロパティを取ってくる
// 配列の場合、インデックスが取られる
let scores = {'国語': 50, '数学': 60, '社会': 80}
for(let key in scores){
  console.log(key);
  console.log(scores[key]);
}
// => 国語
// => 50
// => 数学
// => 60
// => 社会
// => 80

//// for..of文
// 配列の要素(value)を取ってくる
scores = [50, 60, 80]
for(let score of scores){
  console.log(score);
}
// => 50
// => 60
// => 80

//// 変数展開
//JavaScript(''ではなく``(バッククオーテーション)で囲む)
`私の名前は${firstName}です。`


//// クラス定義
class Menu{
  //処理
}
const menu1 = new Menu();


//// コンストラクター
// Rubyでの initialize
// class で作成されたオブジェクトの生成と初期化のための特殊なメソッド
// JavaScriptでは関数もオブジェクトとして扱われているため、コンストラクタの扱いが一般的なプログラミング言語のそれと若干異なる
class Menu {
  constructor() {
    this.name = 'rice';
  }
}
const menu1 = new Menu();
console.log(menu1.name) //=> "rice"


//// prototype
// 他言語に登場する概念のうち、「継承」に近い概念
// オブジェクトが他のオブジェクトの性質を引き継ぐ仕組みであるかのように振る舞う
// (正確には引き継いではいない)

// プロトタイプチェイン：
// JavaScriptにおける継承モデル
// オブジェクトが継承する「他のオブジェクトの参照（プロトタイプ）」の連鎖を意味する
// Object の prototype から参照するイメージ？？
// 継承する際は親のプロトタイプを参照し、その親のプロトタイプは、さらに親のプロトタイプを参照する感じ？？
// -> プロトタイプから継承してくる？
// 参照: https://qiita.com/howdy39/items/35729490b024ca295d6c

// 例.
// String.prototypeに追加したメソッドは、Stringを継承する全てのオブジェクトで使用可能になるため、
// ”文字列”.foo()という形式でメソッドを実行できる
String.prototype.foo = function() {
  return "オブジェクトのメソッド内のthis：" + this
}
console.log("文字列1".foo())  // => オブジェクトのメソッド内のthis：文字列1



// { } は new Object() の糖衣構文
let obj = {name: "taro"};
// ↑と同じオブジェクトが出来上がる
var obj = new Object();
obj.name = "taro";


//// __proto__プロパティ
// オブジェクトを作ると裏で作られるプロパティ

//// __proto__のオブジェクト(= prototypeオブジェクト)
// obj.__proto__ === Object.prototype; // true


// prototypeプロパティ：
// すべての関数オブジェクトが持つプロパティ
// prototypeプロパティに設定したメソッドは、コンストラクタ関数がnewキーワードで新規作成したオブジェクトから参照できる


//// prototype オブジェクト


//// this
// 通常、プログラミング言語において「this」は、自身が所属するオブジェクトを指す
// JavaScriptでは、thisは関数の呼ばれ方によって示す値を変える
// 参考: https://goworkship.com/magazine/javascript-beginner-mistakes/#8_this

// オブジェクトのメソッド内のthisは「呼び出したオブジェクト」を示す
String.prototype.foo = function() {
  return "オブジェクトのメソッド内のthis：" + this
}
console.log("文字列1".foo())
// オブジェクトのメソッド内のthis：文字列1
console.log("文字列2".foo())
// オブジェクトのメソッド内のthis：文字列2

// アロー関数のthis
// thisを宣言した場所で固定するという特徴がある
// アロー関数のthisは、定義したそのスコープのthisの値のまま固定される
String.prototype.hoo = () => "アロー関数のthis：" + this
console.log("文字列1".hoo()) //=> アロー関数のthis：[object Window]

// コンストラクタ関数のthis
// 「新規作成するオブジェクト」を示す
var Member = function(name, address) {
  this.name = name
  this.address = address
  console.log("コンストラクタ関数内のthis：", this)
}
var sig_Left = new Member("sig_Left", "okinawa")
// コンストラクタ関数内のthis： ▶︎ Member {name: "sig_Left", address: "okinawa"}

// DOMイベントハンドラのthis
// DOMイベントハンドラ内では、thisは「イベントを発火させたHTML要素に対応するDOM」を示す
// DOMイベントハンドラのthisは「イベントを発火させたDOM」が入る
document.querySelector("button").addEventListener("mouseover", function(e) {
  console.log("DOMイベントハンドラのthis：" + this)
})
// => DOMイベントハンドラのthis：[object HTMLButtonElement]

// インラインイベントハンドラのthis
// インラインイベントハンドラとは、通常のDOMイベントハンドラと異なり、HTML上に書くもの
// HTMLのbuttonタグのonclick属性や、inputタグのonchange属性、onblur属性などを示す
// HTML上のonclick属性内に書く ”もっとも浅い階層” のthisには、
//「イベントが発火したDOM」が割り当てられる
// それより深い階層（割り当てたfunction内）では、
// thisはグローバルオブジェクトであるWindowを示している
// これはもっとも浅い階層がDOMのonclickメソッドとして所属しているのに対し、
// そのメソッド内のfunctionはどのオブジェクトにも所属していないことが原因


// ===演算子
// ・同じデータ型で、かつ値が同じであればtrueを返す
// ・つまりRubyの ==と同じ

// letとvarの違い
if (true) {
    //if内はスコープが無いのでグローバルスコープ扱い
    var test = 'hoge';
}
//ブロックスコープではないので、アクセスできる
console.log(test);
  
if (true) {
    //ブロックスコープになる
    let test2 = 'hoge2';
}
//アクセスできない
console.log(test2);

// const
// 再代入不可能な変数を作る (つまり定数にできる)
// 再代入しようとするとエラーになる
// letと同じブロックスコープ
// 巻き上げは起きる
// ほとんどは再代入は不要なのでconstを使う
// constを使っておけば値が変わることが無いので、値が変わるかも?という懸念が無くてコードが読みやすい
// forのイテレータのような再代入が必要な所のみletを使う
const test3 = 'hoge';
test3 = 'fuga'; //エラー
console.log(test3);


//// Imageオブジェクト
// HTMLのimage要素（埋め込み画像）を扱うオブジェクト
// HTMLImageElementインスタンス(<img>)を "作成"
// document.createElement('img')と同じ

// onloadによるイベントハンドラーは、
// 同一要素の同一イベントに対して複数のイベントハンドラーを設定できない
// もし同一要素の同一イベントに対して複数のイベントハンドラーを設定したい場合には
// addEventListenerを使用する
let img = new Image();
img.onload = function() {
  alert("画像が読み込まれました！");
};
img.src = 'xxx.png'; // imgに画像が読み込まれて、onload 内の関数が実行される
img.src = blobUrl; // BlobURLの表示

// // 画像の表示

// Blob URL を使う場合
// ファイルのブラウザ上でのURLを取得
// Blob URL はブラウザ内のローカルでのみ有効なURL
// ファイル選択時に選択されたファイルのデータから、
// Blob URL を生成し、それを imgタグの src に設定すると、画像の表示が可能
document.getElementById('file-sample').addEventListener('change', function (e) {
  // 1枚だけ表示する
  var file = e.target.files[0];
  // ファイルのブラウザ上でのURLを取得する
  var blobUrl = window.URL.createObjectURL(file);
  // img要素に表示
  var img = document.getElementById('file-preview');
  img.src = blobUrl;
});

// Data URL (Base64) を使う場合
// 生のバイナリのサイズより30%ほどデータサイズが大きくなる
// データのエンコードに気持ち時間がかかる印象
// データ自体はエンコードされた文字列がすべてなので、ページが破棄されても再表示できる
document.getElementById('file-sample').addEventListener('change', function (e) {
  // 1枚だけ表示する
  var file = e.target.files[0];
  // ファイルリーダー作成
  var fileReader = new FileReader();
  fileReader.onload = function() {
      // Data URIを取得
      var dataUri = this.result;
      // img要素に表示
      var img = document.getElementById('file-preview');
      img.src = dataUri;
  }
  // ファイルをData URIとして読み込む
  fileReader.readAsDataURL(file);
});



//// FileReaderオブジェクト
// ユーザーのコンピュータに保存されているファイル (または生データ バッファ) の内容を
// 非同期に読み取ることができる
// File インターフェース または Blob オブジェクトを使用して、読み込むファイルまたはデータを指定

//// HTMLInputElement オブジェクト
// <input> 要素のオプション、レイアウト、表示を操作するための特別なプロパティやメソッドを提供


// // ハンドラ
// イベントを扱う仕組み

// // 予約状態
// // jsの処理を一旦予約状態で止めておいて
// // HTMLの読み込みが全て完了した後に実行されるようにする
// 全部同じ働き
$(function(){
  //処理
})
$(document).ready(function{
  //処理
});
jQuery(document).ready(function(){
  //処理
});
jQuery(function(){
  //処理
});


//// onload イベント
// loadイベントのハンドラ
// (ページ全体が、スタイルシートや画像などのすべての依存するリソースを含めて読み込まれたときに発生)
// 読み込み操作が正常に完了するたびにトリガされる

////// イベント
// あなたがプログラムを書いているシステムで生じた動作、出来事を指す
// システムからあなたへ、イベントとして何かあった事を知らせてくるので、必要であればそれに何らかの反応を返す事ができる

// 例.
// ユーザーがある要素の上をマウスでクリックしたり、ある要素の上にカーソルを持ってくる
// ユーザーがキーボードのキーを押す
// ユーザーがブラウザー画面をリサイズしたり閉じたりする
// ウェブページのロードの完了
// フォームの送信
// ビデオが再生中、停止中、再生が終わった
// エラーの発生 など


//// イベントハンドラー
// イベントへの応答
// イベントに発火した時に実行される (通常はユーザー定義の JavaScript 関数) コードのブロックのこと
// ボタンが押されると関数が実行される
const btn = document.querySelector('button');
btn.onclick = function() {...}


//// イベントリスナー
// イベントの発生を監視

//// イベントオブジェクト
// イベントハンドラー関数内で event、e などと名付けられた引数
// イベントの追加機能や情報を提供する目的でイベントハンドラーに自動的に渡される

// target プロパティ
// 常にイベントが生じた要素への参照

// ウェブのイベントは JavaScript 言語の主要部分の一部ではない
// ブラウザーに組み込まれた JavaScript API の一部(ブラウザーの Web API に属するもの)として定義されたもの


// // Fileインターフェイス(File API)

// ファイルについての情報を提供したり、ウェブページ内の JavaScript でその内容にアクセスできるようにする
// File オブジェクトは一般的に <input> 要素を使用して
// ユーザがファイルを選択した結果として返された FileList オブジェクトや、
// ドラッグアンドドロップ操作の DataTransfer オブジェクト、 HTMLCanvasElement の mozGetAsFile() API から情報を取得

// File オブジェクトは特別な種類の Blob オブジェクトであり、 Blob が利用できる場面ではどこでも利用できる
// 特に、 FileReader, URL.createObjectURL(), createImageBitmap(), XMLHttpRequest.send()はBlob と File の両方を受け付けることができる
// オブジェクトURLを開放するにはURL.revokeObjectURL()を用いる

// // プロパティ
File.lastModified 
// 読取専用
// ファイルの最終更新時刻を、 UNIX 時刻 (1970年1月1日0:00からの経過ミリ秒数) を返します

File.lastModifiedDate 
// 読取専用
// File オブジェクトが参照しているファイルの最終更新時刻の Date オブジェクトを返します。

File.name
// 読取専用
// File オブジェクトが参照しているファイルのファイル名を返します。

File.webkitRelativePath
// 読取専用
// File オブジェクトが関連付けられている URL のパスを返します。
// File は Blob インターフェイスを実装していますので、以下のプロパティも持っています。

// File.size
// 読取専用
// ファイルのサイズをバイト単位で返します。

// File.type
// 読取専用
// ファイルの MIME タイプを返します


// // FileReader()
// # fileオブジェクトの読み込み
const reader = new FileReader();

// onloadend
// 読み込みが終了した時に発火するイベント
reader.onloadend = function() { 
  preview.src = reader.result;
};

// readAsDataURL(file);
// ファイルのデータを示すURLを格納
reader.readAsDataURL(file);


// 読み込まれた画像が読み込まれると画像の縦横を取得するコード例(imgに反映されてから)
 var image = new Image();
 image.onload = function(){
   console.log(image.naturalWidth);
   console.log(image.naturalHeight);
 }
// 新しいオブジェクトURLをimgタグのsrc属性に入れる
image.src = URL.createObjectURL(file);
// Imageインスタンスから実際にHTMLに描写する
var preview = document.getElementById("preview")
preview.setAttribute('src', resourceURL)

var reader = new FileReader();
reader.onload = function() {
  //imgタグに表示した画像をimageオブジェクトとして取得
  var image = new Image();
  //Fileのバイナリ
  image.src = reader.result;
  image.onload = function(){
    //縦横比を維持した縮小サイズを取得
    var w = 180;
    var ratio = w / image.naturalWidth;
    console.log(image.naturalHeight);
    var h = image.naturalHeight * ratio;
    console.log(image);
    var canvas = document.getElementById("canvas");
    canvas.setAttribute("width", w);
    canvas.setAttribute("height", h);

    // canvas.getContext('2d')の指定で、描画機能が利用できるように2Dコンテキストを取得
    // (getElementByIdメソッドでHTMLと関連付けて、getContextメソッドで描画機能を有効)
    var ctx = canvas.getContext('2d');

    // 前にcanvasに描写されている画像をクリア
    ctx.clearRect(0,0,w,h);

    //使用範囲を指定してイメージを描画
    ctx.drawImage(image, 0, 0, w, h);

    // canvasのイメージを取得してバイナリ化(デフォルトはpng)
    // 画質を0.9倍
    var canvasImage = canvas.toDataURL(file.type, 0.9);

    //blobからFileに変換
    processedFile = new File([canvasImage], `${file.name}`, {
      type: `${file.type}`
    });

    //オリジナル容量(画質落としてない場合の容量)を取得
    var compressedBinary = canvasImage.toBlob()

    var xhr = new XMLHttpRequest;
    /* HTTPリクエスト初期化＋HTTPメソッドおよびリクエスト先URLの設定 */
    xhr.open("POST", "/photos.json", true)
    xhr.setRequestHeader("X-CSRF-Token", Rails.csrfToken());
    xhr.upload.onprogress = function(event){
      var progress = event.loaded / event.total * 100;
      attachment.setUploadProgress(progress);
    }
  }
}



//// CSS
// ハイフンがつくCSSプロパティはJavaScriptではキャメルケースになる





//////////////////////////// 実装 /////////////////////////////

//// ポップアップ
// HTML
/*
<div id="popup">
  <div class="black-background" id="js-black-bg"></div>
  <div id="expanded-kebab-menu">
    <div class="expanded-kebab-menu-item expanded-item--show">
      <%# link_to '表示', id: "expanded-item--show-link" %>
      <a id="expanded-item--show-link">表示</a>
    </div>
    <div class="expanded-kebab-menu-item expanded-item--edit">
      <%# link_to '編集', id: "expanded-item--edit-link" %>
      <a id="expanded-item--edit-link">編集</a>
    </div>
    <div class="expanded-kebab-menu-item expanded-item--destroy">
      <%# link_to '削除', id: "expanded-item--destroy-link" %>
      <a id="expanded-item--destroy-link">削除</a>
    </div>
  </div>
</div>
*/

// CSS
/*
#popup {
  position: fixed;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  z-index: 9999;
  opacity: 0;
  visibility: hidden;
  transition: .3s;
}

.black-background {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,.3);
  z-index: 1;
  cursor: pointer;
}

#expanded-kebab-menu {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%,-50%);
  width: 40%;
  background-color: #fff;
  z-index: 2;
  text-align: center;
  font-size: 25px;
  border-radius: 10px;
}

.expanded-item--show {
  border-bottom: 1px solid #e5e5e5;
}

.expanded-item--destroy {
  border-top: 1px solid #e5e5e5;
}
*/

// JS
const kebabMenus = document.querySelectorAll(".kebab-menu");

kebabMenus.forEach(function(kebabMenu) {
  kebabMenu.addEventListener('click', (e) => {
    const companyId = e.target.dataset.companyId;
    const blogId    = e.target.dataset.blogId;
    popupMenu(companyId, blogId);
  });
});

const popupLayer = document.getElementById("js-black-bg");
popupLayer.addEventListener("click", () => {
  popdownMenu();
})

function popupMenu(company_id, blog_id) {
  let popupStyle = document.getElementById("popup").style;

  const showButton = document.getElementById("expanded-item--show-link");
  showButton.href =`/companies/${company_id}/blogs/${blog_id}`;

  const editButton = document.getElementById("expanded-item--edit-link");
  editButton.href = `/companies/${company_id}/blogs/${blog_id}`;

  const destroyButton = document.getElementById("expanded-item--destroy-link");
  destroyButton.href = `/companies/${company_id}/blogs/${blog_id}`;

  popupStyle.visibility = "visible";
  popupStyle.opacity = 1.0;
}

function popdownMenu() {
  let popupStyle = document.getElementById("popup").style;

  popupStyle.visibility = "hidden";
  popupStyle.opacity = 0;
} 

//////////////////////////// GAS ////////////////////////////////////////
