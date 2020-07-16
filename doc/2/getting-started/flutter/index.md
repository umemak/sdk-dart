---
type: page
code: false
title: Flutter
description: Getting started with Kuzzle and Flutter
order: 0
---

# Getting Started with Kuzzle and Flutter

This section deals with **Kuzzle V2** (+ **Dart SDK 2**) and **VueJS**. We will create **documents** in Kuzzle and subscribe to [document notifications](/sdk/dart/2/essentials/realtime-notifications#document-messages) to develop a realtime chat.

## Requirements

- **Running Kuzzle V2 Stack** ([instructions here](/core/2/guides/getting-started/running-kuzzle))
- **Setup an editor** ([instructions here](https://flutter.dev/docs/get-started/editor))
- **Create a new project** ([instructions here](https://flutter.dev/docs/get-started/test-drive?tab=androidstudio#create-app))

After creating a new Flutter project we will start with a clean base code like this one:

<<< ./snippets/base.dart.snippet[dart]

## Use the Kuzzle SDK in your flutter app

You can find the kuzzle package on pub.dev. ([https://pub.dev/packages/kuzzle](https://pub.dev/packages/kuzzle))

The `pubspec.yaml` file manages the assets and dependencies for a Flutter app. In `pubspec.yaml`, add kuzzle (2.0.1 or higher) to the dependencies list:

```yaml
dependencies:
  flutter:
    sdk: flutter
  kuzzle: ^2.0.1
```

Then run `flutter pub get` to install the new dependency

```bash
$ flutter pub get
```

## Instantiating Kuzzle SDK

We have to connect the server so that our client can interact with it.

In our _main.dart_ let's import the sdk:

<<< ./snippets/main.dart.snippet:1[dart]

Now let's instanciate the Kuzzle instance with WebSocket:

<<< ./snippets/main.dart.snippet:2[dart]

Then we will [establish the connection](/sdk/js/7/core-classes/kuzzle/connect) to kuzzle and create, if they don't [exist](/sdk/js/7/controllers/index/exists/), the [index](/sdk/js/7/controllers/index/create) and [collection](/sdk/js/7/controllers/collection/create) of our chat. 
Add the following `valid()` method in the export of the `<script>` tag of your _App.vue_ file:

<<< ./snippets/main.dart.snippet:3[dart]
