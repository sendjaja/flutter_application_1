# flutter_application_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Setup in Linux
1. Download & install flutter from https://docs.flutter.dev/get-started/install and set PATH
2. sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
3. Run flutter config --no-analytics
4. Run 'flutter doctor'

#### Install firebase and login
1. curl -sL https://firebase.tools | bash
2. firebase login

### setup, configure, compile and run
3. dart pub global activate flutterfire_cli
4. flutterfire configure
5. flutter run

## Run the script
1. start_android.sh or start_iphone.sh or start_web.sh (chrome)
2. start_web.sh will disable chrome CORS (Cross Origin Requests)
3. If chrome is showing empty page, go to the index.html and change
```
<base href="/">
```
to
```
<base href="">
```

10/07/2022
[!] CocoaPods did not set the base configuration of your project because your project already has a custom config set. In order for CocoaPods integration to work at all, please either set the base configurations of the target `Runner` to `Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig` or include the `Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig` in your build configuration (`Flutter/Release.xcconfig`).
