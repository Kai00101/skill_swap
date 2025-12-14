import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_service.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  const ChatPage({super.key, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool _isBlocked = false;
  bool _loadingBlockStatus = true;

  @override
  void initState() {
    super.initState();
    _checkIfBlocked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/chel.png'),
              radius: 24,
            ),
            const SizedBox(width: 10),

            /// USER INFO
            FutureBuilder<DocumentSnapshot>(
              future: _getChatPartner(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("Loading...");
                }

                final user = snapshot.data!;
                final name = user["name"] ?? "User";
                final lastSeen = user["lastSeen"] as Timestamp?;

                final isOnline = lastSeen != null &&
                    DateTime.now().difference(lastSeen.toDate()).inMinutes < 5;

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isOnline ? "Online" : "Offline",
                        style: TextStyle(
                          fontSize: 12,
                          color: isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),


        actions: [
          const Icon(Icons.video_call),
          const SizedBox(width: 15),
          const Icon(Icons.call),

          // Block / Unblock
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "block") {
                _confirmBlock();
              }
              if (value == "unblock") {
                await _unblockUser();
              }
            },
            itemBuilder: (context) {
              if (_loadingBlockStatus) {
                return const [];
              }

              return [
                PopupMenuItem(
                  value: _isBlocked ? "unblock" : "block",
                  child: Text(_isBlocked ? "Unblock user" : "Block user"),
                ),
              ];
            },
          ),
        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    final isMe = msg["senderId"] == uid;

                    final ts = msg["createdAt"] as Timestamp?;
                    final currentDate = ts?.toDate() ?? DateTime.now();

                    DateTime? prevDate;
                    if (i + 1 < messages.length) {
                      final prevTs =
                      messages[i + 1]["createdAt"] as Timestamp?;
                      prevDate = prevTs?.toDate();
                    }

                    final showDate =
                        prevDate == null || !_isSameDay(currentDate, prevDate);

                    return Column(
                      children: [

                        if (showDate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _formatDateLabel(currentDate),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ),
                          ),


                        Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.deepPurpleAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg["text"],
                                  style: TextStyle(
                                    color:
                                    isMe ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(currentDate),
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),


          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    send();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _checkIfBlocked() async {
    try {
      final myDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final blocked =
      List<String>.from(myDoc.data()?["blocked"] ?? []);

      final partner = await _getChatPartner();

      setState(() {
        _isBlocked = blocked.contains(partner.id);
        _loadingBlockStatus = false;
      });
    } catch (_) {
      setState(() {
        _loadingBlockStatus = false;
      });
    }
  }


  void _confirmBlock() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block user?"),
        content: const Text(
            "This user will no longer see you or contact you."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _blockUser();
              Navigator.pop(context); // close chat
            },
            child: const Text("Block"),
          )
        ],
      ),
    );
  }


  Future<void> _blockUser() async {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final partner = await _getChatPartner();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(myUid)
        .update({
      "blocked": FieldValue.arrayUnion([partner.id]),
    });

    setState(() {
      _isBlocked = true;
    });
  }


  Future<void> _unblockUser() async {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final partner = await _getChatPartner();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(myUid)
        .update({
      "blocked": FieldValue.arrayRemove([partner.id]),
    });

    setState(() {
      _isBlocked = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User unblocked")),
    );
  }

  Future<bool> _isChatBlocked() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();

    final users = List<String>.from(chatDoc['users']);
    final partnerId = users.firstWhere((id) => id != uid);

    final meDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final partnerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(partnerId)
        .get();

    final myBlocked =
    List<String>.from(meDoc.data()?['blocked'] ?? []);
    final partnerBlocked =
    List<String>.from(partnerDoc.data()?['blocked'] ?? []);

    return myBlocked.contains(partnerId) ||
        partnerBlocked.contains(uid);
  }


  Future<DocumentSnapshot> _getChatPartner() async {
    final chat = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();

    final users = List<String>.from(chat["users"]);
    final partnerId = users.firstWhere((id) => id != uid);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(partnerId)
        .get();
  }


  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final blocked = await _isChatBlocked();
    if (blocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't send messages to this user."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await ChatService.sendMessage(widget.chatId, uid, text);
    controller.clear();
  }



  String _formatTime(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();

    if (_isToday(date, now)) return "Today";
    if (_isYesterday(date, now)) return "Yesterday";

    return "${date.day} ${_month(date.month)}";
  }

  bool _isToday(DateTime d, DateTime n) =>
      d.year == n.year &&
          d.month == n.month &&
          d.day == n.day;

  bool _isYesterday(DateTime d, DateTime n) {
    final y = n.subtract(const Duration(days: 1));
    return d.year == y.year &&
        d.month == y.month &&
        d.day == y.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _month(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[m - 1];
  }
}
