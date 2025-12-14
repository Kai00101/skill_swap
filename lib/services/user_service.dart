import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile.dart';

class UserService {


  static Future<void> saveProfile({
    required String name,
    required String city,
    required List<String> canTeach,
    required List<String> wantsToLearn,
    required List<String> skipped,
    required List<String> blocked
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final email = FirebaseAuth.instance.currentUser!.email;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "name": name,
      "city": city,
      "canTeach": canTeach,
      "wantsToLearn": wantsToLearn,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
      "online": true,
      "lastSeen": FieldValue.serverTimestamp(),
      "skipped": skipped,
      "blocked": blocked,

    }, SetOptions(merge: true));
  }


  static Future<UserProfile?> getMyProfile() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return UserProfile.fromFirestore(doc.id, doc.data()!);
  }


  static Future<void> updateProfile({
    required String name,
    required String city,
    required List<String> canTeach,
    required List<String> wantsToLearn,
  }) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      "name": name,
      "city": city,
      "canTeach": canTeach,
      "wantsToLearn": wantsToLearn,
    });
  }




  static Future<List<UserProfile>> getMatches() async {

    final myUid = FirebaseAuth.instance.currentUser!.uid;

    final myDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(myUid)
        .get();

    final data = myDoc.data() ?? {};

    final skipped = List<String>.from(data["skipped"] ?? []);
    final blocked = List<String>.from(data["blocked"] ?? []);
    final wanted = List<String>.from(data["wantsToLearn"] ?? []);
    final canTeach = List<String>.from(data["canTeach"] ?? []);

    final snapshot =
    await FirebaseFirestore.instance.collection("users").get();

    final result = snapshot.docs
        .where((doc) {


      if (doc.id == myUid) return false;


      if (skipped.contains(doc.id)) return false;
      if (blocked.contains(doc.id)) return false;

      final user = doc.data();


      final otherBlocked = List<String>.from(user["blocked"] ?? []);
      if (otherBlocked.contains(myUid)) return false;

      final otherTeach = List<String>.from(user["canTeach"] ?? []);
      final otherLearn = List<String>.from(user["wantsToLearn"] ?? []);

      final matchTeach = wanted.any(otherTeach.contains);
      final matchLearn = canTeach.any(otherLearn.contains);

      return matchTeach || matchLearn;
    })
        .map((doc) => UserProfile.fromFirestore(doc.id, doc.data()))
        .toList();

    return result;
  }



  static Future<List<UserProfile>> searchUsers(String query) async {

    final myUid = FirebaseAuth.instance.currentUser!.uid;

    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];


    final myDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(myUid)
        .get();

    final blocked = List<String>.from(myDoc.data()?["blocked"] ?? []);

    final snap = await FirebaseFirestore.instance.collection("users").get();

    return snap.docs


        .where((doc) => doc.id != myUid)


        .where((doc) => !blocked.contains(doc.id))

        .map((d) => UserProfile.fromFirestore(d.id, d.data()))
        .where((u) {

      final name = u.name.toLowerCase();
      final city = u.city.toLowerCase();
      final teach = u.canTeach.join(" ").toLowerCase();
      final learn = u.wantsToLearn.join(" ").toLowerCase();

      return name.contains(q)
          || city.contains(q)
          || teach.contains(q)
          || learn.contains(q);
    })
        .toList();
  }




  static Future<void> updateLastSeen() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      "lastSeen": FieldValue.serverTimestamp(),
    });
  }


  static Future<bool> isOnline(String uid) async {

    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) return false;

    final lastSeen = doc["lastSeen"];

    if (lastSeen == null || lastSeen is! Timestamp) return false;

    final now = DateTime.now();
    final diff = now.difference(lastSeen.toDate());

    return diff.inMinutes <= 5;
  }

  static Future<void> skipUser(String targetUid) async {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(myUid).update({
      "skipped": FieldValue.arrayUnion([targetUid]),
    });
  }


  static Future<void> blockUser(String targetUid) async {

    final myUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(myUid).update({
      "blocked": FieldValue.arrayUnion([targetUid]),
    });
  }


  static Future<void> unblockUser(String targetUid) async {

    final myUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(myUid).update({
      "blocked": FieldValue.arrayRemove([targetUid]),
    });
  }


}
