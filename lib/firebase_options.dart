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
    apiKey: 'AIzaSyDDl9ampVOjdQvqGese-EDHXVcVnOzOBgo',
    appId: '1:814029290671:web:5a16d5f5ddc9f0aca2e85a',
    messagingSenderId: '814029290671',
    projectId: 'kgppanchayat-6356e',
    authDomain: 'kgppanchayat-6356e.firebaseapp.com',
    storageBucket: 'kgppanchayat-6356e.appspot.com',
    measurementId: 'G-EC3BTK70GX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgX-va5MGmiJfvYqxryjFM2Nn1ggvoNpc',
    appId: '1:814029290671:android:51f055672ce562a0a2e85a',
    messagingSenderId: '814029290671',
    projectId: 'kgppanchayat-6356e',
    storageBucket: 'kgppanchayat-6356e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6Y38QOdF7J9VO6QW8npMZ1SOkmTyyGBU',
    appId: '1:814029290671:ios:3576a0af90962cdea2e85a',
    messagingSenderId: '814029290671',
    projectId: 'kgppanchayat-6356e',
    storageBucket: 'kgppanchayat-6356e.appspot.com',
    iosClientId: '814029290671-b5f8e5uj8mt6ua1uncpp64j2d8ig4dop.apps.googleusercontent.com',
    iosBundleId: 'jd.kgp.kgppanchayat.kgppanchayat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6Y38QOdF7J9VO6QW8npMZ1SOkmTyyGBU',
    appId: '1:814029290671:ios:3576a0af90962cdea2e85a',
    messagingSenderId: '814029290671',
    projectId: 'kgppanchayat-6356e',
    storageBucket: 'kgppanchayat-6356e.appspot.com',
    iosClientId: '814029290671-b5f8e5uj8mt6ua1uncpp64j2d8ig4dop.apps.googleusercontent.com',
    iosBundleId: 'jd.kgp.kgppanchayat.kgppanchayat',
  );
}
