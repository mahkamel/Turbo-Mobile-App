// File generated by FlutterFire CLI.
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
    apiKey: 'AIzaSyCuv-dClDgcZ6wipHzGg4APYUe6mNC6Ye8',
    appId: '1:675552575914:web:3c30505db507250e7e2bd3',
    messagingSenderId: '675552575914',
    projectId: 'turbo-app-53a6a',
    authDomain: 'turbo-app-53a6a.firebaseapp.com',
    storageBucket: 'turbo-app-53a6a.appspot.com',
    measurementId: 'G-RB941ZM42G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3uiFGJf-oWzqmp2xhU12rLWMl3LD-nEs',
    appId: '1:675552575914:android:b103dbad13c0d6c97e2bd3',
    messagingSenderId: '675552575914',
    projectId: 'turbo-app-53a6a',
    storageBucket: 'turbo-app-53a6a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDdzs6dM_6yO_SC3_aBj0L3RYZSXpXbOJA',
    appId: '1:675552575914:ios:792b150e013737097e2bd3',
    messagingSenderId: '675552575914',
    projectId: 'turbo-app-53a6a',
    storageBucket: 'turbo-app-53a6a.appspot.com',
    iosBundleId: 'com.turbo.turbo',
  );
}
