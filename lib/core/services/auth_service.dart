import 'package:firebase_auth/firebase_auth.dart';

/// A service class for handling Firebase Authentication operations.
///
/// This class provides methods for user sign-in, registration, sign-out,
/// getting the current user, and listening to authentication state changes.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs in a user with the given [email] and [password].
  ///
  /// Returns a [UserCredential] if successful, otherwise throws a [FirebaseAuthException].
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Registers a new user with the given [email] and [password].
  ///
  /// Returns a [UserCredential] if successful, otherwise throws a [FirebaseAuthException].
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Returns the currently logged-in [User].
  ///
  /// Returns `null` if no user is currently signed in.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// A stream that emits the current [User] whenever the authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
