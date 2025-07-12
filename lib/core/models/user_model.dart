/// A data model representing a user in the application.
///
/// This model is used to store and retrieve user information
/// from Firestore.
class UserModel {
  final String id;
  final String email;

  /// Constructs a [UserModel] with the given [id] and [email].
  UserModel({required this.id, required this.email});
}
