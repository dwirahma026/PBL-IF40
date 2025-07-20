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
    apiKey: 'AIzaSyDxHN4zqIxmVNj7cxSKUKxq5Yxgsz60X5Q',
    appId: '1:573584464318:web:e00059defa4b878b83c1ef',
    messagingSenderId: '573584464318',
    projectId: 'yukparkir-ead06',
    authDomain: 'yukparkir-ead06.firebaseapp.com',
    storageBucket: 'yukparkir-ead06.firebasestorage.app',
    measurementId: 'G-3HQZ9NTP9F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0PYbi3vgWnqZzQhhOJi0Go2n2dT8cpNA',
    appId: '1:573584464318:android:1c80057595d9e10f83c1ef',
    messagingSenderId: '573584464318',
    projectId: 'yukparkir-ead06',
    storageBucket: 'yukparkir-ead06.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOo152e1x_2zjO6mYN8BsZLGYktvOBOAM',
    appId: '1:573584464318:ios:41e5339b4563eb8283c1ef',
    messagingSenderId: '573584464318',
    projectId: 'yukparkir-ead06',
    storageBucket: 'yukparkir-ead06.firebasestorage.app',
    iosBundleId: 'com.example.parkir',
  );
}
