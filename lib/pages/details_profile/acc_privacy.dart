import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/user_profile.dart';
import '../../services/user_service.dart';

class AccountPrivacyPage extends StatefulWidget {
  const AccountPrivacyPage({super.key});

  @override
  State<AccountPrivacyPage> createState() => _AccountPrivacyPageState();
}

class _AccountPrivacyPageState extends State<AccountPrivacyPage> {

  bool _loading = true;
  List<UserProfile> _blockedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }


  Future<void> _loadBlockedUsers() async {
    try {
      final myUid = FirebaseAuth.instance.currentUser!.uid;

      final meDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUid)
          .get();

      final data = meDoc.data() ?? {};


      final rawBlocked = List<String>.from(data['blocked'] ?? []);


      final blockedIds = rawBlocked
          .where((id) => id.trim().isNotEmpty)
          .toSet()
          .toList();

      if (blockedIds.isEmpty) {
        setState(() {
          _blockedUsers = [];
          _loading = false;
        });
        return;
      }


      final snap =
      await FirebaseFirestore.instance.collection('users').get();

      final users = snap.docs
          .where((d) => blockedIds.contains(d.id))
          .map((d) => UserProfile.fromFirestore(d.id, d.data()))
          .toList();

      setState(() {
        _blockedUsers = users;
        _loading = false;
      });

    } catch (e) {
      debugPrint("Error loading blocked users: $e");
      setState(() => _loading = false);
    }
  }


  Future<void> _unblock(UserProfile user) async {
    await UserService.unblockUser(user.uid);

    setState(() {
      _blockedUsers.removeWhere((u) => u.uid == user.uid);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${user.name} unblocked')),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loading = true;
              });
              _loadBlockedUsers();
            },
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _blockedUsers.isEmpty
          ? const Center(
        child: Text(
          'No blocked users',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _blockedUsers.length,
        itemBuilder: (context, i) {
          final user = _blockedUsers[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF6246EA),
                width: 1.5,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage:
                  AssetImage('assets/images/chel.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6246EA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _unblock(user),
                  child: const Text(
                    'Unblock',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
