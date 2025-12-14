  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:skill_swap/pages/widget_tree/search_page.dart';
  import '../../chat/chatting_page.dart';
  import '../../chat/chat_service.dart';
  import '../../services/user_profile.dart';
  import '../../widgets/matching_card.dart';
  import '../../services/user_service.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:google_fonts/google_fonts.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {

    List<UserProfile> _matches = [];
    bool _isLoading = true;

    @override
    void initState() {
      super.initState();
      UserService.updateLastSeen();
      _loadMatches();
    }

    Future<void> _loadMatches() async {
      final m = await UserService.getMatches();
      if (!mounted) return;
      setState(() {
        _matches = m;
        _isLoading = false;
      });
    }

    void _removeCard(int index) {
      if (index < 0 || index >= _matches.length) return;
      setState(() => _matches.removeAt(index));
    }


    Future<void> _skipUser(String targetUid) async {

      final myUid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection("users").doc(myUid).update({
        "skipped": FieldValue.arrayUnion([targetUid]),
      });
    }

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),

        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              FutureBuilder<UserProfile?>(
                future: UserService.getMyProfile(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) return const SizedBox();

                  final me = snapshot.data!;

                  return Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/chel.png"),
                        radius: 30,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome Back",
                              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          const SizedBox(height: 6),
                          Text(me.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold,)),
                        ],
                      ),
                      const Spacer(),


                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>  SearchPage()),
                        ),
                      )
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              Text("Matches:",
                  style: GoogleFonts.titanOne(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.deepPurple,
                  ),
              ),


              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _matches.isEmpty
                    ? const Center(child: Text("No matches found"))
                    : ListView.builder(
                  itemCount: _matches.length,
                  itemBuilder: (context, index) {

                    final user = _matches[index];

                    return MatchingCard(
                      user: user,


                      onSwap: () async {

                        final myUid = FirebaseAuth.instance.currentUser!.uid;

                        final chatId = await ChatService.createChat(myUid, user.uid);
                        _removeCard(index);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(chatId: chatId),
                          ),
                        );
                      },


                      onSkip: () async {
                        await _skipUser(user.uid);
                        _removeCard(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
