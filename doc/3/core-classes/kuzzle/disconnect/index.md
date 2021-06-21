---
code: true
type: page
title: disconnect
description: Disconnects the SDK from Kuzzle
---

# connect

Disconnect from Kuzzle using the underlying protocol `close` method. 

Subsequent calls have no effect if the SDK is already disconnected.

## Arguments

```dart
Future<void> disconnect()
```

## Usage

<<< ./snippets/disconnect.dart
