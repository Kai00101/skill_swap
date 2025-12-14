import 'package:flutter/material.dart';
import '../../services/user_profile.dart';
import '../../services/user_service.dart';

class PersonInfoPage extends StatelessWidget {
  const PersonInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text("Personal Information"),
        backgroundColor: Colors.transparent,
        elevation: 0,
       // foregroundColor: Colors.black,
      ),
      body: FutureBuilder<UserProfile?>(
        future: UserService.getMyProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [


                Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/chel.png"),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.city,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),


                infoCard(
                  title: "Email",
                  child: Text(
                    user.email,
                    style: const TextStyle(color:Colors.black,fontSize: 14),
                  ),
                ),

                infoCard(
                  title: "Can Teach",
                  child: chipList(user.canTeach),
                ),


                infoCard(
                  title: "Wants to Learn",
                  child: chipList(user.wantsToLearn),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurpleAccent,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }


  Widget chipList(List<String> list) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list.map((e) {
        return Chip(
          label: Text(e,style: TextStyle(color: Colors.black),),
          backgroundColor: const Color(0xFFF3F1FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFD9D4FF)),
          ),
        );
      }).toList(),
    );
  }
}
