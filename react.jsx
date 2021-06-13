// Todoアプリ ハンズオン
localhost:3000/ にアクセス
route.rb にて /todos にリダイレクト
site_controller の index アクションで処理
application.html.erb と index.html.erb が呼び出される
application.html.erb の javascript/packs/index.jsx を呼び出す
javascript/packs/index.jsx 内の id='root'のdivタグを取得して、
その中にAppコンポーネント(javascript/components/App.js)を描画している


// 画面遷移しない場合
// 1. import文の記述が間違っていると何も表示されなくなる

// ・()の登場する場面
// 式のグループ化
// 関数の引数、仮引数
// forやifなどの条件を囲う

// ・{}の登場する場面
// 複文（ifやforで、制御する文が複数になった場合などに使う）
// 関数の実行分を囲う
// オブジェクトリテラル
// classの中身を囲う
//  `${}` の形で、文字列中の変数展開を行う

// returnの後に置けるものは式なので、()は「式のグループ化」、{}は「オブジェクトリテラル」が唯一取りうる意味となります。


// エクスポート(2種類ある)

// 名前付きエクスポート
// 記述１
1: export { 変数名, 関数名, クラス名 };
// 記述２
2: export 定義(変数名, 関数名, クラス名)
例. export const value2 = 'value2';

// デフォルトエクスポート
// (1つのファイルに1回しか使えない)
// {}を使わない
export default 変数名 or 関数名 or クラス名;

// 複数の値をオブジェクトに格納して「オブジェクト.モジュール名」のように書く方法
// {}を使わない
import * as オブジェクト名 from 'ファイルパス';
console.log(オブジェクト名.モジュール名);

// インポート(エクスポートの種類によって書き方が異なる)

// 名前付きエクスポートで公開されている複数の値を読み込む場合
// (モジュール名は一致させる or asを使う必要がある)
import { モジュール名１, モジュール名２ } from 'ファイルパス';
import { 実際のモジュール名 as 好きなモジュール名 } from 'ファイルパス'; 

// デフォルトエクスポートで公開されている値を読み込む場合(モジュール名が一致してなくても良い)
import モジュール名 from 'ファイルパス';

// 名前付きとデフォルトを同時にインポート
import デフォルトのモジュール名, { 名前付きのモジュール名 } from 'ファイルパス'


// スタイルを整える方法(4つ)

// 1. CSSファイルのインポート
import 'ファイル名';
import './App.css';

// 2. インラインスタイルを使う
//   キャメルケースで書く
backgroud-color -> backgroudColor

// 3. CSS-in-JS(JSを用いてCSSを生成するパターン)
// CSS-in-JSを提供しているライブラリ -> styled-components、emotion など
import styled   from 'styled-components'
const Nabvar = styled.nav`
  background: #dbfffe;
  min-height: 8vh;
  display: flex;
  justify-content: space-around;
  align-items: center;
`

// Window オブジェクトや Document オブジェクト、DOMなど
// 参照: https://www.webdesignleaves.com/wp/jquery/1631/

//   Window オブジェクト

//   DOM: ドキュメントを構成するオブジェクトにアクセスする方法を定義した API


// クラス
// constructor(初期メソッド:rubyでいうinitialize)
class Menu {
  constructor (name, price){
    this.name = name;
    this.price = price;
  }
}
const menu1 = new Menu("ハンバーガー",300)

// インスタンスメソッドと呼び出し
show() {
  console.log(`こちらの${this.name}は${this.price}円です`);
}
menu1.show();
// => こちらのハンバーガーは300円です

// super(親クラスのメソッドをcallする)
// コンストラクター 内で使うと親クラスの コンストラクター をcallする
class Animal {
  constructor(age) {
    console.log('Animal being made');
    this.age = age;
  }
  returnAge() {
    return this.age;
  }  
}

class Dog extends Animal {
  constructor (age){
    super(age);
  }
  logAgeDog () {
    console.log(`This dog is: ${ super.returnAge()} years old`);
  }
}

const dog = new Dog(5); //=> Animal being made
console.log(dog);
dog.logAgeDog();

// 4. 実装済みの component を利用する場合
// MATERIAL-UI や React Bootstrap などのライブラリを利用


// コンポーネント

// 1. 関数コンポーネント
//   アロー関数でも記述可能
//   stateを持たない
//   props を引数に受け取る
//   JSXを戻り値として返す関数(主に表示だけを行うシンプルなコンポーネント)

// 記述例(アロー関数)
const Welcome = () => {
  return (
    <div>
      <h1>Hello, Func!</h1>
      <button>ボタン</button>
    </div>
  );
};

// 記述例(通常のfunctionコンポーネント)
function Welcome() {
  return (
    <div>
      <h1>Hello, Func!</h1>
      <button>ボタン</button>
    </div>
  );
};


// 2. クラスコンポーネント
//   React.component を継承したクラスでJSXを返す render メソッドを実装する
//   props にはthisが必要
//   ライフサイクルやstateを持つ
//   (コンポーネント自身に値の保持や更新など複雑な機能をもたせるコンポーネント)

// クラスコンポーネントの書き方(constructorを使わない場合)
class Button extends React.Component {
  render() {
    return (
      <div className="Button">
        ボタン in Classコンポーネント
      </div>
    )
  }
}

// props (読み取り専用：引数みたいなもの？)
//   JSXでコンポーネントをセットする時、HTMLタグのように埋め込む
//   HTMLタグの「属性="属性値"」の部分が「prop名="prop値"」

// 1.関数コンポーネントでの props
// 関数コンポーネントを定義
// /component/Button/Button.jsx
function Button(props) {
  return (
    <span className="Button-container">
      { props.title }
    </span>
  );
}
// 値("ボタン１")を渡す
// /App.js
function App() {
  return (
    <div className="App">
      <h1>Hello World</h1>
      <Button title="ボタン１" />
      <Button title="ボタン２" />
    </div>
  );
}

// 2. クラスコンポーネントでの props
//  (constructorを使わない場合)
class Button extends React.Component {
  render() {
    return (
      <span className="Button-container">
        { this.props.title }  // this の後に props をつける？
      </span>
    );
  }
}
//  (constructorを使う場合)
class Button extends React.component {
  constructor(props) {
    super(props); // constructor を使う場合は明示的に super(props); を実行する必要がある
    this.value = "コンストラクターだよ";
  }

  render() {
    return (
      <span className="Button-container">
        { this.value }  // this.props.value とは書かない
      </span>
    );
  }
}

// 値("ボタン１")を渡す
// /App.js
function App() {
  return (
    <div className="App">
      <h1>Hello World</h1>
      <Button title="ボタン１" />
      <Button title="ボタン２" />
    </div>
  );
}

// props.childern
// 開始タグと終了タグに記述された部分を「props.children」という特別なプロパティで取得する
// =開始タグと終了タグの間の値が反映される
// 1. 関数コンポーネントでのprops.children
//   /components/Button/Button.jsx
function Button(props) {
    return (
        <div className="Button">
            { props.children }
        </div>
    )
}
// App.js
function App() {
  return (
    <div className="App">
      <Button>ボタン１１</Button>
    </div>
  );
}

// 2. クラスコンポーネントでのprops.children
// constructorを使う場合
//   /component/Button/Button.jsx
class Button extends React.Component {
  render() {
      return (
          <div className="Button">
              { this.props.children }
          </div>
      );
  }
}
// App.js
function App() {
  return (
    <div className="App">
      <Button>ボタン１１</Button>
    </div>
  );
}

// コンポーネントには親子関係がある
// 親コンポーネント(組み込んでいる側)
// 子コンポーネント(組み込まれている側)


// state (クラスコンポーネントで利用できる機能:関数コンポーネントでも使えるように)
// props は親・子コンポーネントで共通の値を扱うが、state は１つのコンポーネントに管理されるプライベートな値
class Timer extends React.Component {
  constructor(props) {
      super(props);
      this.state = {
          seconds: 10
      };
      // this.setState({プロパティ名: 更新後の値})のように
      // メソッド経由でstateの値を更新することで、コンポーネントの表示が更新される
      // (set.Stateメソッドを使わなくても値を更新できるがJSXが更新されない！！)
      window.setInterval(() => {
          this.setState({
              seconds: this.state.seconds - 1 
          });
      }, 1000);
  }

  render() {
      return <div>残り時間： { this.state.seconds }</div>
  }
}

// props 経由で受け取った値でも props の値をstateにセットすれば更新出来る
// App.js
function App() {
  return (
    <div className="App">
      <h1>タイマー</h1>
      <Timer seconds={30} />
    </div>
  );
}
// /components/Timer/Timer
class Timer extends React.Component {
  constructor(props) {
      super(props);
      this.state = {
          seconds: props.seconds
      };
      window.setInterval(() => {
          this.setState({
              seconds: this.state.seconds - 1 // props の値？ を state にセットしている
          })
      }, 1000);
  }

  render() {
      return <div>{ this.state.seconds }/{ this.props.seconds }</div>
  }
}

// ハンズオン
//// $ yarn add react-router-dom axios styled-components react-icons react-toastify
// react-router-dom：Reactでのroutingの実現
// axios：サーバとのHTTP通信を行う
// styled-components：CSS in JS のライブラリ
// react-icons：Font Awesomeなどのアイコンが簡単に利用できるライブラリ


// スプレッド構文
// 配列の作成
const a = [1,2] 

//①配列の複製
// sort()メソッドのような破壊的メソッドを使用する際に元の配列を変更させたくない時などに使う
const b = [...a] //[1,2]

const a = [ 1, 9, 4, 6 ]
const b = a // そのまま複製できない！！
// => Uncaught SyntaxError: Identifier 'a' has already been declared

const a = [ 1, 9, 4, 6 ]
const b = [...a]
const c = b.sort()

console.log(a) // [ 1, 9, 4, 6 ]
console.log(b) // [ 1, 4, 6, 9 ]
console.log(c) // [ 1, 4, 6, 9 ]


//②配列要素を追加した新しい配列の生成
const c = [...a, 3,4] //[1,2,3,4]

//③配列の結合
const d = [...b,...c] //[ 1, 2, 1, 2, 3, 4 ]



// hook(React 16.8から導入)
// クラスの機能(stateやライフサイクル)を関数コンポーネントでも使える
// useState() ステートフック
// 関数コンポーネントでstateを管理（ state の保持と更新）するためのReactフックで最も利用されるフック
// クラスコンポーネントにおけるthis.state と this.setState() を代替
// 複数のstateを扱うときはstate毎に宣言

// useState の使い方
// 1. useState 関数をインポート
import React, { useState } from 'react';
// 2. 宣言する
// state変数名は クラスコンポーネントでの this.state に当たる役割
// state変更関数名は クラスコンポーネントでの this.setState に当たる役割
// useState(初期値)は state変数名の初期値を設定する
const [state変数名, state変更関数名] = useState(初期値);
// 3. JSX内で使う
<input /** 中略 */ onClick={() => togglePublished(!isPublished)}/>
// = クリックされたら 関数togglePublishを呼び出して isPublished の値を反転したものを渡す
// 使用例.
const Welcome = () => {
  const [title, setTitle] = React.useState('ハロー、ファンク！');

  //追加
  const handleClick = () => {
    setTitle('クリックされました。');
  };

  return (
    <div>
      <h1>{title}</h1>
      <button onClick={handleClick}>ボタン</button>
    </div>
  );
};



// ライフサイクルメソッド
//   コンポーネントがDOMに追加されること: マウント
//   コンポーネントがDOMから削除されること: アンマウント

// componentWillUnmount()

// コンポーネントがアンマウントされて破棄される直前に呼び出される
// タイマーの無効化、ネットワークリクエストのキャンセル、componentDidMount() で
// 作成された購読の解除など、このメソッドで必要なクリーンアップを実行する
// コンポーネントは再レンダーされないため、
// componentWillUnmount() で setState() を呼び出さないでください
// 使用例.
componentWillUnmount() { // if文の '<div>Timer消した</div>' が反映される直前に実行される
    console.log('componentWillUnmount!! : ', this.props);
    window.clearInterval(this.intervalID);
}

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      hasRenderedTwice: false
    }

    window.setTimeout(() => {
      this.setState({hasRenderedTwice: true});
    }, 2000)
  }

  render() {
    if (this.state.hasRenderedTwice) {
      return <div>Timer消した</div>
    }

    return (// hasRenderedTwice=true だと消える
      <div className="App">
        <h1>タイマー</h1>
        <Timer seconds={30} />
      </div>
    );
  }
}

// DOM更新直後に実行される
componentDidUpdate(prevProps, prevState, snapshot) {
    console.log('propsの状態 : ', prevProps, this.props);
    console.log('stateの状態 : ', prevState, this.state);
    console.log('スナップショット : ', snapshot)
}


// React Router

// インストール:
// npm install react-router-dom

// ルーティングの設定

// BrowserRouter と Route のインポート (as で BrowserRouter を Router に置き換える)
import { BrowserRouter as Router, Route } from "react-router-dom";

// <Router>
//   <Route exact path="/" component={Home} />
//   <Route exact path="/about/" component={About} />
// </Router>

// exactの path に完全に一致すると指定された component が描画される
// switch component によりurlによって描画する component が切り替わる(条件分岐)
// Switch は最初に条件一致したRouteをrenderする
<Switch>
    <Route exact path="/todos" component={TodoList} />
    <Route exact path="/todos/new" component={AddTodo} />
    <Route path="/todos/:id/edit" component={EditTodo} />
</Switch>


// ページを切り替えるときはLinkコンポーネントを使う(aタグだと全てのDOM要素が再読み込みされる)
// -> webブラウザの再読み込みを行わず、
//    URLに紐付いたコンポーネントの部分的な読み込みが可能になる
import { BrowserRouter as Router, Route, Link } from "react-router-dom";

<Router> // Linkコンポーネント は Router 内で使用する！
  <ul>
    <li>
      <Link to="/">Home</Link>  // href ではなく to を使う
    </li>
    <li>
      <Link to="/about">About</Link>
    </li>
  </ul>

  <Route exact path="/" component={Home} />
  <Route exact path="/about/" component={About} />
</Router>


// useEffect
// classコンポーネントのライフサイクルcomponentDidMount, componentDidUpdateとcomponentWillUnmountの
// 3つと同様な処理を行うことができるHook
import React,{ useState, useEffect } from 'react';

function App() {
  const [count, setCount] = useState(0);

  // render される度に実行される
  useEffect(() => {
    console.log("useEffectが実行されました");
  });

  // state 変数である count が更新されると useEffect が実行されるようにする
  // useEffect(() => {
  //   console.log("useEffectが実行されました");
  // }, [count]); 　　//　配列内の引数がないと最初のrenderのみの実行

  return (
    <div className="App">
      <h1>Count: {count}</h1>
      <button onClick={() => setCount(count + 1)}>+</button>
      <h1>Count: {count2}</h1>
      <button onClick={() => setCount2(count2 + 1)}>+</button>
    </div>
  );
}
// useEffectを利用することでコンポーネントの内容を表示する際に
// 外部のサーバからAPIを経由してデータを取得することや
// コンポーネントが更新する度に別の処理を実行するということが可能になる