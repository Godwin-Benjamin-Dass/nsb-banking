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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBZwJvJQSx81qheJCi7P_ISDHKECW0fF8I',
    appId: '1:821011153504:web:cc87b61c0772d72dcc3905',
    messagingSenderId: '821011153504',
    projectId: 'nsb-banking',
    authDomain: 'nsb-banking.firebaseapp.com',
    storageBucket: 'nsb-banking.appspot.com',
    measurementId: 'G-LJXV9MPW2E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnY879EY9bxaHjlkYApW--PSoC4vtgcLc',
    appId: '1:821011153504:android:8283bd8d11bfe777cc3905',
    messagingSenderId: '821011153504',
    projectId: 'nsb-banking',
    storageBucket: 'nsb-banking.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgQIDfVWee-DvFLfM_oEV0YXcfau-uX3o',
    appId: '1:821011153504:ios:42bfb71a4579d116cc3905',
    messagingSenderId: '821011153504',
    projectId: 'nsb-banking',
    storageBucket: 'nsb-banking.appspot.com',
    iosClientId: '821011153504-m3fk8t78kqevg9h4rbeolbbi0cl9daqg.apps.googleusercontent.com',
    iosBundleId: 'com.example.nsbBank',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgQIDfVWee-DvFLfM_oEV0YXcfau-uX3o',
    appId: '1:821011153504:ios:42bfb71a4579d116cc3905',
    messagingSenderId: '821011153504',
    projectId: 'nsb-banking',
    storageBucket: 'nsb-banking.appspot.com',
    iosClientId: '821011153504-m3fk8t78kqevg9h4rbeolbbi0cl9daqg.apps.googleusercontent.com',
    iosBundleId: 'com.example.nsbBank',
  );
}