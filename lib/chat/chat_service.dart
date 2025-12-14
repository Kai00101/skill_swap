import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {

  static final _fire = FirebaseFirestore.instance;

  static Future<String> createChat(String uid1, String uid2) async {

    final query = await _fire
        .collection("chats")
        .where("users", arrayContains: uid1)
        .get();

    for (var doc in query.docs) {
      final users = List<String>.from(doc["users"]);
      if (users.contains(uid2)) {
        return doc.id;
      }
    }

    final doc = await _fire.collection("chats").add({
      "users": [uid1, uid2],
      "lastMessage": "",
      "updatedAt": FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  static Stream<QuerySnapshot> getMessages(String chatId) {
    return _fire
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      String chatId,
      String senderId,
      String text,
      ) async {

    final doc = _fire.collection("chats").doc(chatId);

    await doc.collection("messages").add({
      "senderId": senderId,
      "text": text,
      "createdAt": FieldValue.serverTimestamp()
    });

    await doc.update({
      "lastMessage": text,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

}
