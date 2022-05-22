---
type: page
code: false
title: Flutter
description: KuzzleとFlutterをはじめよう
order: 0
---

# KuzzleとFlutterをはじめよう

<!-- This section deals with **Kuzzle v2**, the **Dart SDK v2** and **Flutter**. We will create **documents** in Kuzzle and subscribe to [document notifications](/sdk/dart/3/essentials/realtime-notifications#document-messages) to develop a realtime chat. -->

ここでは、**Kuzzle v2**、**Dart SDK v3**、**Flutte**について説明します。
Kuzzleで**ドキュメント**を作成し、[ドキュメントの通知](/sdk/dart/3/essentials/realtime-notifications#document-messages)を購読して、リアルタイムチャットを展開します。

## 必要条件

- **Kuzzle v2 Stackの実行** ([手順はこちら](/core/2/guides/getting-started/run-kuzzle))
- **エディタのセットアップ** ([手順はこちら](https://flutter.dev/docs/get-started/editor))
- **新規プロジェクトの作成** ([手順はこちら](https://flutter.dev/docs/get-started/test-drive?tab=androidstudio#create-app))

## Kuzzle SDKをflutterアプリで使用する

<!-- You can find the kuzzle package on pub.dev. ([https://pub.dev/packages/kuzzle](https://pub.dev/packages/kuzzle)) -->

kuzzleのパッケージはpub.devで公開されています。([https://pub.dev/packages/kuzzle](https://pub.dev/packages/kuzzle))

<!-- The `pubspec.yaml` file manages the assets and dependencies for a Flutter app. In `pubspec.yaml`, add kuzzle (2.0.1 or higher) to the dependencies list: -->

`pubspec.yaml` ファイルは Flutter アプリのアセットと依存関係を管理します。
`pubspec.yaml` で、kuzzle (3.0.2 以上) を依存関係リストに追加します。


```yaml
dependencies:
  flutter:
    sdk: flutter
  kuzzle: ^3.0.2
```

<!-- Then run `flutter pub get` to install the new dependency -->

それから `flutter pub` を実行し、新しい依存関係をインストールします。

```bash
$ flutter pub get
```

## アプリのエントリーポイント

<!-- Let's start with the main: -->

まずはメインから

_main.dart:_

<<< ./snippets/main.dart.snippet[dart]

## ユーザー名を設定する

<!-- Here we will ask the user to enter its username.
To keep it simple, this does not use the authentication system of Kuzzle but feel free to implement it for a better usage. -->

ここでは、ユーザーにユーザー名を入力してもらいます。
シンプルにするために、Kuzzleの認証システムを使用していませんが、より良い使い方をするために自由に実装してください。

_login.dart:_

<<< ./snippets/login.dart.snippet[dart]

## チャット

<!-- We have to connect the server so that our client can interact with it (note that the host is the API of an android emulator in this example). -->

クライアントがサーバーと対話できるように、サーバーに接続する必要があります（この例では、ホストはアンドロイドエミュレータのAPIであることに注意してください）。

<!-- In our _chat.dart_ let's import the sdk: -->

_chat.dart_で、sdkをインポートします。

<<< ./snippets/chat.dart.snippet:1[dart]

<!-- Then we will [establish the connection](/sdk/dart/3/core-classes/kuzzle/connect) to kuzzle and create, if they don't [exist](/sdk/dart/3/controllers/index/exists/), the [index](/sdk/dart/3/controllers/index/create) and [collection](/sdk/dart/3/controllers/collection/create) of our chat. We will also fetch messages sorted by creation date, and  subscribe to the same collection to receive new messages in realtime. -->

次に、kuzzleへの[接続を確立し](/sdk/dart/3/core-classes/kuzzle/connect)、チャットの[インデックス](/sdk/dart/3/controllers/index/create)と[コレクション](/sdk/dart/3/controllers/collection/create)を作成します（それらが[存在](/sdk/dart/3/controllers/index/exists/)しない場合）。
また、作成日順にメッセージを取得し、同コレクションを購読してリアルタイムに新しいメッセージを受信します。

### インデックスとコレクションの作成

<!-- So first let's write a method which will create the index/collection if it does not exist: -->

そこで、まず、インデックスやコレクションが存在しない場合にそれを作成するメソッドを書いてみましょう。

<<< ./snippets/chat.dart.snippet:2[dart]


### 既存のメッセージを取得する

<!-- The method _fetchMessage()_ will [search](/sdk/dart/3/controllers/document/search) for the first hundred newest messages.
It will then update the state of the widget to store those messages in the `messages` variable. -->

_fetchMessage()_ メソッドは、最新の100件のメッセージを[検索](/sdk/dart/3/controllers/document/search)します。
そして、ウィジェットの状態を更新して、それらのメッセージを`messages`変数に格納します。

<<< ./snippets/chat.dart.snippet:3[dart]

### 新しいメッセージをリアルタイムに受信する

<!-- And finally the method to subscribe to our collection.
It will call the Kuzzle's realtime controller to allow us to receive [real-time notifications](/core/2/api/payloads/notifications) on message creations. New messages received that way will then be added to our list of previously fetched `messages`, and rendered in our list, by updating the state. -->

最後に、コレクションを購読するための方法です。
Kuzzleのリアルタイムコントローラを呼び出して、メッセージ作成時の[リアルタイム通知](/core/2/api/payloads/notifications)を受け取れるようにします。
このようにして受信した新しいメッセージは、以前に取得した`メッセージ`のリストに追加され、状態を更新することでリストに表示されます。

<<< ./snippets/chat.dart.snippet:4[dart]

### ここまでに書いたメソッドを呼び出す

<!-- Then we are going to call all of those methods in the `initState` method of the State of our `StatefulWidget`: -->

そして、`StatefulWidget`のStateの`initState`メソッドで、これらのメソッドをすべて呼び出すことになります。

<<< ./snippets/chat.dart.snippet:5[dart]

<!-- As you can see we use a model to retrieve each message from the JSON Response to a Dart class. -->

ご覧のように、JSONレスポンスから各メッセージをDartクラスへ取得するためにモデルを使用しています。

<!-- Here: -->

こちら

<<< ./snippets/chat.dart.snippet:6[dart]

<!-- And here: -->

そしてこちら

<<< ./snippets/chat.dart.snippet:7[dart]

<!-- So here is the Dart class used for this model -->

このモデルに使用するDartクラスを以下に示します。

_message.dart:_

<<< ./snippets/message.dart.snippet[dart]

### すべてを表示する

<!-- Finally let's make a view to display everything and add an input to be able to send a message in our `build()` method: -->

最後に、すべてを表示するビューを作成し、`build()`メソッドにメッセージを送信できるようにするための入力を追加しましょう。

_chat.dart:_

<<< ./snippets/chat.dart.snippet:8[dart]

_chat_view.dart:_

<<< ./snippets/chat_view.dart.snippet[dart]

### メッセージの送信

<!-- Finally let's see how to send a new message using the Kuzzle sdk: -->

最後に、Kuzzle sdkを使って新しいメッセージを送信する方法を見てみましょう。

_chat.dart:_

<<< ./snippets/chat.dart.snippet:9[dart]

<!-- For this we simply [create](/sdk/dart/3/controllers/document/create) a document in our `messages` collection with a `username` and a `value`. Once this document is created it will trigger a notification to all clients who subscribed to this collection and receive the message. -->

そのために、`messages` コレクションに`username`と`value`を含むドキュメントを[作成](/sdk/dart/3/controllers/document/create)します。
ドキュメントが作成されると、このコレクションを購読しているすべてのクライアントに通知が送られ、メッセージを受信することになります。

## これからどうするのか？

<!-- Now that you're more familiar with Kuzzle, dive even deeper to learn how to leverage its full capabilities: -->

さて、Kuzzleをより深く知っていただいたところで、その機能をフルに活用する方法についてご紹介します。

<!-- - discover what this SDK has to offer by browsing other sections of this documentation -->
- このドキュメントの他のセクションを参照して、このSDKが提供するものを発見してください。
<!-- - learn more about Kuzzle [realtime engine](/core/2/guides/main-concepts/realtime-engine) -->
- リアルタイムエンジンKuzzleの詳細は[こちら](/core/2/guides/main-concepts/realtime-engine)
<!-- - follow our guide to learn how to [manage users, and how to set up fine-grained access control](/core/2/guides/main-concepts/permissions) -->
- [ユーザー管理と、きめ細かいアクセス制御を設定](/core/2/guides/main-concepts/permissions)する方法については、ガイドに従ってください。
<!-- - lean how to use Kuzzle [Admin Console](http://next-console.kuzzle.io) to manage your users and data -->
- Kuzzle [Admin Console](http://next-console.kuzzle.io) を使ってユーザーやデータを管理する方法を学びます。
<!-- - learn how to perform a [basic authentication](/sdk/dart/3/controllers/auth/login) -->
- [基本的な認証](/sdk/dart/3/controllers/auth/login)の実行方法を学ぶ
