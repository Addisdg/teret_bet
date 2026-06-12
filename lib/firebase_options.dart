// Firebase options for Teret Bet.
//
// Do not hard-code Google API keys in this file. Pass them at build/run time
// with --dart-define so secret scanners do not flag committed source files.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static const _webApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const _androidApiKey =
      String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  static const _iosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const _macosApiKey = String.fromEnvironment('FIREBASE_MACOS_API_KEY');
  static const _windowsApiKey =
      String.fromEnvironment('FIREBASE_WINDOWS_API_KEY');

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBlgXWzlIU0BXbwxKp1fpaV4MbCVODPq1A',
    appId: '1:391218282653:web:89f03e84bf7740d5bb9474',
    messagingSenderId: '391218282653',
    projectId: 'teret-bet',
    authDomain: 'teret-bet.firebaseapp.com',
    storageBucket: 'teret-bet.firebasestorage.app',
    measurementId: 'G-TD0YNXYVXE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmLXZTHxXhHrblodhtyXqjUmkDdY42NXA',
    appId: '1:391218282653:android:fd5955c8f7475445bb9474',
    messagingSenderId: '391218282653',
    projectId: 'teret-bet',
    storageBucket: 'teret-bet.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_Mtc6DkfNoHQCtUvCkdLS9gfjqdsBiMc',
    appId: '1:391218282653:ios:434e750f0c7d39a0bb9474',
    messagingSenderId: '391218282653',
    projectId: 'teret-bet',
    storageBucket: 'teret-bet.firebasestorage.app',
    iosBundleId: 'com.example.teretBetApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_Mtc6DkfNoHQCtUvCkdLS9gfjqdsBiMc',
    appId: '1:391218282653:ios:434e750f0c7d39a0bb9474',
    messagingSenderId: '391218282653',
    projectId: 'teret-bet',
    storageBucket: 'teret-bet.firebasestorage.app',
    iosBundleId: 'com.example.teretBetApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlgXWzlIU0BXbwxKp1fpaV4MbCVODPq1A',
    appId: '1:391218282653:web:9701a1cbf6e9522ebb9474',
    messagingSenderId: '391218282653',
    projectId: 'teret-bet',
    authDomain: 'teret-bet.firebaseapp.com',
    storageBucket: 'teret-bet.firebasestorage.app',
    measurementId: 'G-402T2G16D4',
  );

}