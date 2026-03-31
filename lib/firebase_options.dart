import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDAjWf62fNArIYxI5wYqVNe-Nm8TjsjLMs',
    appId: '1:462993823923:web:6495a3ee960d1f734db8c6',
    messagingSenderId: '462993823923',
    projectId: 'mattei-dev',
    authDomain: 'mattei-dev.firebaseapp.com',
    storageBucket: 'mattei-dev.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxtkF57rv1NQwfAvbfsdW8gaamMn4CQ8o',
    appId: '1:462993823923:android:3e268e21b5ec7a384db8c6',
    messagingSenderId: '462993823923',
    projectId: 'mattei-dev',
    storageBucket: 'mattei-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGjPDGHR05uip0L8GmHINro_waE4-7DjY',
    appId: '1:462993823923:ios:33a387a83570b3b54db8c6',
    messagingSenderId: '462993823923',
    projectId: 'mattei-dev',
    storageBucket: 'mattei-dev.firebasestorage.app',
    iosClientId: '462993823923-n4n0jppog5c7oek7ca7a6se6t9s218gj.apps.googleusercontent.com',
    iosBundleId: 'com.michaelmattei.check2check.check2Check',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGjPDGHR05uip0L8GmHINro_waE4-7DjY',
    appId: '1:462993823923:ios:33a387a83570b3b54db8c6',
    messagingSenderId: '462993823923',
    projectId: 'mattei-dev',
    storageBucket: 'mattei-dev.firebasestorage.app',
    iosClientId: '462993823923-n4n0jppog5c7oek7ca7a6se6t9s218gj.apps.googleusercontent.com',
    iosBundleId: 'com.michaelmattei.check2check.check2Check',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}