import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String city;
  final List<String> canTeach;
  final List<String> wantsToLearn;
  final bool online;
  final Timestamp? lastSeen;
  final String? photo;
  final String email;

  UserProfile({
    required this.uid,
    required this.name,
    required this.city,
    required this.canTeach,
    required this.wantsToLearn,
    required this.online,
    this.lastSeen,
    this.photo,
    required this.email,
  });

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      name: map['name'],
      city: map['city'],
      canTeach: List<String>.from(map['canTeach']),
      wantsToLearn: List<String>.from(map['wantsToLearn']),
      online: map['online'] ?? false,
      lastSeen: map['lastSeen'],
      photo: map['photo'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'city': city,
      'canTeach': canTeach,
      'wantsToLearn': wantsToLearn,
      'online': online,
      'lastSeen': lastSeen,
      'photo': photo,
      'email': email,
    };
  }
}

