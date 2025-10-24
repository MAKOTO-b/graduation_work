# サービス名：Spill Out

# 目次
- サービス概要
- サービスURL
- サービス開発の背景
- 機能紹介
- 技術構成について
  - 使用技術
  - ER図
  - 画面遷移図<br>
<br>

# サービス概要
　「Spiill Out」はユーザーの好きなように自分の気持ちを吐き出すことができるサービスです。<br>
　日々の何気ない物事を気軽に呟いたり、他者に話したりと自由にご利用ください。

# サービスURL
### https://spill-out.com/<br>
<br>

# サービス開発の背景
　自分自身が対人関係でストレスを感じやすく、さらに内側に溜め込んでしまう人間だったため、それを手軽に文字として吐き出す手段を探していたのですが、既存のサービスを使用するとどうしても人の目に触れる危険性があると感じたため、匿名性保ちつつ自身の言葉を気軽に外へ発信できるサービスを開発することにしました。<br>
<br>
　その時の気分に応じてサービスを利用してほしいため、1対多、1対1両方の発信機能を有したアプリを開発することとし、本サービス「Spill Out」を開発いたしました。
<br>

# 機能紹介
| ユーザー登録 / ログイン |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/9eec5b6b5ec82cabebc9595a4c5a5c41.png)](https://gyazo.com/9eec5b6b5ec82cabebc9595a4c5a5c41) |
| <p align="left">『メールアドレス』『ユーザーネームy』『パスワード』『確認用パスワード』を入力してユーザー登録を行います。ユーザー登録後は、自動的にログイン処理が行われるようになっており、そのまま直ぐにサービスを利用する事が出来ます。<br>また、Googleアカウントを用いてGoogleログインを行う事も可能です。</p> |
<br>

| 投稿機能 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/8e1381a2199f2a20a01bcc68dabdd2f7.gif)](https://gyazo.com/8e1381a2199f2a20a01bcc68dabdd2f7) |
| <p align="left"> 自分のその日の気持ちを100文字以内で自由に書き込み投稿することができます。投稿後は投稿一覧にて投稿内容を全ユーザーが確認することができます。いいね機能や自身の投稿は自由に削除できるため、自分に合った方法で気持ちを吐き出してください。<p> |
<br>

| チャット機能 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/0085e49e3f5956df58176eb707af6731.gif)](https://gyazo.com/0085e49e3f5956df58176eb707af6731) |
| <p align="left">登録者の一覧が表示されているので、そこから好きな人とチャットを楽しむことができます。匿名となっているため、普段言いにくいことをリアルタイムで他者と話したりといったように自由にご活用ください。<p> |
<br>

| チャットボット機能 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/a8ed46980d39b98f136cb5caff92eb42.png)](https://gyazo.com/a8ed46980d39b98f136cb5caff92eb42) |
| <p align="left">1日10件までAIとのチャットを楽しむことができます。カウンセラーとして振る舞うように設定しているため、軽い相談や会話などを行うことができます。対人と話すのは重たいなといった気分の時に気軽にご利用ください。<p> |
<br>

# 技術構成について
## 使用技術
| カテゴリ | 技術内容 |
| --- | --- |
| サーバーサイド | Ruby on Rails 7.2.2.1・ruby 3.3.6 |
| フロントエンド | Ruby on Rails・JavaScript |
| CSSフレームワーク | Bootstrap |
| Web API | OpenAI API(GPT-3.5)・Google API |
| データベースサーバー | MySQL |
| ファイルサーバー | AWS S3 |
| アプリケーションサーバー | puma |
| バージョン管理ツール | GitHub |
<br>

## ER図
[![Image from Gyazo](https://i.gyazo.com/59a9f67e2fde9ee3483d4b9b752d96bc.png)](https://gyazo.com/59a9f67e2fde9ee3483d4b9b752d96bc)

## 画面遷移図
https://www.figma.com/design/BCrnENDFp3uFbXed6p78rP/Untitled?node-id=0-1&t=UoUCtXJuBgtkhhlN-1