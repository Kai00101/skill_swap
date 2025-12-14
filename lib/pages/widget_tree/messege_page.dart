import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../chat/chatting_page.dart';
import 'messege_page.dart';

class MessageCenterPage extends StatelessWidget {
  const MessageCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Messages"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("users", arrayContains: myUid)
            .orderBy("updatedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, i) {
              final chat = chats[i];
              final last = chat["lastMessage"];

              final otherUid = chat["users"].firstWhere(
                      (uid) => uid != myUid);

              return ListTile(
                leading:
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/chel.png'),
                  radius: 30,
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(otherUid)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading...");
                          }
                          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                            return const Text("No name available");
                          }
                          final userName = userSnapshot.data!["name"];
                          return Text(userName,style: TextStyle(fontSize: 17,),);
                        },
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text(
                            last == "" ? "No messages yet" : last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Text(
                            _formatDate(chat["updatedAt"].toDate()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,)
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(chatId: chat.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (_isToday(date, now)) {
      return "Today";
    }

    if (_isYesterday(date, now)) {
      return "Yesterday";
    }

    final formattedDate = "${date.day} ${_getMonthName(date.month)}";
    return formattedDate;
  }

  bool _isToday(DateTime date, DateTime now) {
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date, DateTime now) {
    final yesterday = now.subtract(Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  String _getMonthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }
}
