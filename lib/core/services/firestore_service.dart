import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/models/message_model.dart';
import '../../core/models/user_model.dart';

/// A service class for interacting with Firestore for chat and user data.
///
/// This class provides methods for fetching users, sending messages,
/// and retrieving messages for a specific chat room.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the User ID of the currently logged-in user.
  ///
  /// Returns `null` if no user is signed in.
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Retrieves a stream of all users from Firestore.
  ///
  /// The current user is excluded from the list.
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel(id: doc.id, email: doc['email']))
          .where((user) => user.id != _auth.currentUser!.uid) // Exclude current user
          .toList();
    });
  }

  // Get user by ID (returns DocumentSnapshot, less direct for email)
  Future<DocumentSnapshot> getUserById(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  /// Retrieves the email address of a user by their [userId].
  ///
  /// Returns 'Unknown User' or 'User Not Found' if the user or email is not available.
  Future<String> getUserEmailById(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc['email'] ?? 'Unknown User';
    } else {
      return 'User Not Found';
    }
  }

  // Get number of unread messages
  Stream<int> getUnreadMessagesCount(String userId) {
    final String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, userId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .snapshots()
        .asyncMap((chatRoomSnapshot) async {
      DateTime? lastRead;
      if (chatRoomSnapshot.exists && chatRoomSnapshot.data()!.containsKey('lastRead')) {
        lastRead = DateTime.parse((chatRoomSnapshot.data()!['lastRead'] as String));
      }

      QuerySnapshot messageSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .orderBy('timestamp')
          .get();

      int unreadCount = messageSnapshot.docs.where((doc) {
        Timestamp timestamp = doc['timestamp'];
        DateTime messageDateTime = timestamp.toDate();
        return lastRead == null || messageDateTime.isAfter(lastRead!);  //Check Last Read Time
      }).length;

      return unreadCount;
    });
  }

  // Update last read message timestamp
  Future<void> updateLastReadMessage(String userId) async {
    final String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, userId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastRead': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Sends a message from the current user to a specific [receiverId].
  ///
  /// The message is stored in a chat room identified by a sorted combination
  /// of the sender's and receiver's IDs.
  Future<void> sendMessage(
      String receiverId, String messageContent) async {
    final String currentUserId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message model.
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      receiverId: receiverId,
      message: messageContent,
      timestamp: timestamp,
    );

    // Construct chat room ID by sorting UIDs to ensure a unique ID for each pair.
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Add the message to the 'messages' subcollection of the specific chat room.
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

     await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastRead': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  /// Retrieves a stream of messages for a chat room between the current user and [userId].
  ///
  /// Messages are ordered by timestamp in ascending order.
  Stream<List<MessageModel>> getMessages(String userId) {
    final String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, userId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel(
          senderId: doc['senderId'],
          receiverId: doc['receiverId'],
          message: doc['message'],
          timestamp: doc['timestamp'],
        );
      }).toList();
    });
  }
}
