# Blinker

[![pub package](https://img.shields.io/pub/v/fade_shimmer.svg)](https://pub.dev/packages/blinker)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
![GitHub stars](https://img.shields.io/github/stars/AbdullahProjects/blinker.svg?style=social)

Customizable Flutter package for **fade transitions** and **color cycling animations**, perfect for highlighting UI elements, creating dynamic loading placeholders, or adding subtle animated effects to your app.


## Features

- **Fade Mode** (`Blinker.fade`) — Smoothly animates between two colors.
- **Cycle Mode** (`Blinker.cycle`) — Loops through a sequence of colors.
- **Customizable animation speed** and easing curve.
- **Loop control**: Run infinitely or a set number of times.
- **Lightweight & Pure Dart**: No native dependencies.

## Demo

| Loading List | Rating | TImer |
|------------------|--------------------|------------------|
| ![Loading List](https://raw.githubusercontent.com/AbdullahProjects/blinker/main/screenshots/loading_list.gif) | ![Rating](https://raw.githubusercontent.com/AbdullahProjects/blinker/main/screenshots/rating.gif) | ![Timer](https://raw.githubusercontent.com/AbdullahProjects/blinker/main/screenshots/timer.gif) |


## Installation

Add `blinker` to your `pubspec.yaml` file:

```yaml
dependencies:
  blinker: ^1.0.3
```

Run the following command to install:

```bash
flutter pub get
```

Import the package

```dart
import 'package:blinker/blinker.dart';
```

## 💡 Usage (Example)

### Fade Mode

```dart
Blinker.fade(
  startColor: Colors.white,
  endColor: Colors.blue,
  duration: const Duration(milliseconds: 800),
  curve: Curves.easeInOut,
  times: null, // Infinite loop
  child: Container(
    width: 150,
    height: 40,
    color: Colors.white,
  ),
)
```

### Cycle Mode

```dart
Blinker.cycle(
  colors: [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ],
  duration: const Duration(milliseconds: 800),
  curve: Curves.easeInOut,
  times: null, // Infinite loop
  child: Container(
    width: 150,
    height: 40,
    color: Colors.grey.shade300,
  ),
)
```

