# webview_integration_template

A integrate webview flutter template


## Getting Started

```bash
git clone https://github.com/liuvigongzuoshi/webview-integration-template.git
```

## 准备环境

### Flutter 安装和环境配置

https://flutter.cn/docs/get-started/install

#### 注意点：

1. 选择 Flutter Stable 版本

https://flutter.cn/docs/development/tools/sdk/releases

2. 配置 flutter 到系统环境变量里面

4. 安装 Android Studio 及插件 Flutter plugin 与 Dart plugin

5. 运行命令监测安装结果

```
flutter doctor -v
```
 
正常运行结果

```bash

[✓] Flutter (Channel stable, 1.22.3, on Mac OS X 10.15.7 19H2, locale zh-Hans-CN)
    • Flutter version 1.22.3 at /Users/john/DevelopmentSDK/flutter
    • Framework revision 8874f21e79 (7 days ago), 2020-10-29 14:14:35 -0700
    • Engine revision a1440ca392
    • Dart version 2.10.3
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn

 
[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
    • Android SDK at /Users/john/Library/Android/sdk
    • Platform android-29, build-tools 29.0.3
    • Java binary at: /Users/john/Library/Application Support/JetBrains/Toolbox/apps/AndroidStudio/ch-0/201.6858069/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 12.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.1, Build version 12A7403
    • CocoaPods version 1.9.3

[✓] Android Studio (version 4.1)
    • Android Studio at /Users/john/Library/Application Support/JetBrains/Toolbox/apps/AndroidStudio/ch-0/201.6858069/Android Studio.app/Contents
    • Flutter plugin installed
    • Dart plugin installed
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)

[✓] IntelliJ IDEA Ultimate Edition (version 2020.2.3)
    • IntelliJ at /Users/john/Applications/JetBrains Toolbox/IntelliJ IDEA Ultimate.app
    • Flutter plugin installed
    • Dart plugin version 202.7319.5

[✓] VS Code (version 1.50.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.16.0

[✓] Connected device (1 available)
    • VRD AL09 (mobile) • X8F6R19712003505 • android-arm64 • Android 10 (API 29)
```

### 运行项目

提前链接好设备或配置好模拟器，进入到项目根目录，执行 `flutter pub get` 获取项目依赖包。

将 `assets` 目录下的 `www.zip` 替换成最新的 web 打包工程。

执行 `flutter run` 运行命令将项目跑起来。

### APP 打包

打包 Android，`flutter build apk`；打包 iOS，`flutter build ios`。

安装到链接 Android 设备 `flutter install apk`，iOS 同理

## 更多

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Flutter documentation](https://flutter.dev/docs)
