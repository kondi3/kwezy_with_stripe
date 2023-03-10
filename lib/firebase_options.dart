// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCE_Zg_JyaXA2ZfEnMaX4WKmtA-HQ2lL9Y',
    appId: '1:669305332183:web:fd2488ecfd1f3e08ce6b92',
    messagingSenderId: '669305332183',
    projectId: 'kwezy-2f770',
    authDomain: 'kwezy-2f770.firebaseapp.com',
    databaseURL: 'https://kwezy-2f770-default-rtdb.firebaseio.com',
    storageBucket: 'kwezy-2f770.appspot.com',
    measurementId: 'G-ERDEE99R88',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUdz92Sqfyd5zWixP7dxPTfc_bJ1SvDtA',
    appId: '1:669305332183:android:3d88909114c9abfcce6b92',
    messagingSenderId: '669305332183',
    projectId: 'kwezy-2f770',
    databaseURL: 'https://kwezy-2f770-default-rtdb.firebaseio.com',
    storageBucket: 'kwezy-2f770.appspot.com',
  );
}
