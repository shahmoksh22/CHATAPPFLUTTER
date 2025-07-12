import 'package:cloud_firestore/cloud_firestore.dart';

/// A data model representing a single chat message.
///
/// This model is used to store and retrieve message information
/// from Firestore.
class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  /// Constructs a [MessageModel] with the given parameters.
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  /// Converts this [MessageModel] into a [Map<String, dynamic>]
  /// suitable for storage in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
