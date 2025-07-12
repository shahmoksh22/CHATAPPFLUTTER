import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// A service class for managing Firebase initialization.
///
/// This class provides a static method to initialize Firebase
/// across the application.
class FirebaseService {
  /// Initializes Firebase for the current platform.
  ///
  /// This method should be called once at the start of the application
  /// to ensure Firebase services are ready for use.
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
