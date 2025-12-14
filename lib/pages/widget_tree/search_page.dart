import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_profile.dart';
import '../../services/user_service.dart';
import '../../widgets/matching_card.dart';
import '../../chat/chat_service.dart';
import '../../chat/chatting_page.dart';
import '../../widgets/widget_tree.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final controller = TextEditingController();
  List<UserProfile> results = [];
  bool loading = false;

  Future<void> search() async {
    setState(() => loading = true);

    final q = controller.text.trim();
    final res = await UserService.searchUsers(q);

    if (!mounted) return;

    setState(() {
      results = res;
      loading = false;
    });
  }

  void removeResult(int index) {
    if (index < 0 || index >= results.length) return;
    setState(() => results.removeAt(index));
  }

  Future<void> skipUser(String targetUid) async {
    await UserService.skipUser(targetUid);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Search"),
      leading: BackButton(onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return WidgetTree();
        },));
      },),
      ),

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [

            SizedBox(height: 2,),
            TextField(
              controller: controller,
              onSubmitted: (_) => search(),
              decoration: InputDecoration(
                hintText: "Search by name, city, skill...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: search,
                  icon: const Icon(Icons.arrow_forward),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            if (!loading && results.isEmpty)
              const Text("No results"),

            if (!loading)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {

                    final user = results[index];

                    return MatchingCard(
                      user: user,


                      onSwap: () async {

                        final myUid = FirebaseAuth.instance.currentUser!.uid;
                        final chatId = await ChatService.createChat(myUid, user.uid);

                        removeResult(index);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(chatId: chatId),
                          ),
                        );
                      },


                      onSkip: () async {
                        await skipUser(user.uid);
                        removeResult(index);
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
