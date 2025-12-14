import 'package:flutter/material.dart';
import 'package:skill_swap/pages/details_profile/edit_profile_page.dart';
import 'package:skill_swap/pages/details_profile/person_info_page.dart';
import 'package:skill_swap/pages/details_profile/delete_page.dart';

import '../../services/user_profile.dart';
import '../../services/user_service.dart';
import '../details_profile/acc_privacy.dart';
import '../details_profile/setting_page.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Profile')),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(
                  //   //color: Colors.purple,
                  //   width: 2,
                  // ),
                  color: Colors.grey[300]
                ),
              ),

              InkWell(
              child: Image.asset('assets/images/person_edit.png', height: 36,color: Colors.deepPurpleAccent,),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfilePage();
                },));

              },
            ),
              ]
          ),
          SizedBox(width: 7,)
        ],
      ),

      body: FutureBuilder<UserProfile?>(
        future: UserService.getMyProfile(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Profile not found"));
          }

          final user = snapshot.data!;

          return Column(
            children: [


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/chel.png'),
                      radius: 35,
                    ),
                    const SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(

                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          user.city,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),


              InkWell(
                child: const ListTile(
                  leading: Icon(Icons.person_pin, color: Colors.grey),
                  title: Text('Personal Information'),
                  trailing: Icon(Icons.chevron_right),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PersonInfoPage()),
                  );
                },
              ),
              const Divider(thickness: 1.5),


              InkWell(
                child: const ListTile(
                  leading: Icon(Icons.privacy_tip, color: Colors.grey),
                  title: Text('Account Privacy'),
                  trailing: Icon(Icons.chevron_right),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountPrivacyPage(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 1.5),


              InkWell(
                child: const ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey),
                  title: Text('Setting'),
                  trailing: Icon(Icons.chevron_right),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingPage()),
                  );
                },
              ),
              const Divider(thickness: 1.5),


              InkWell(
                child: const ListTile(
                  leading: Icon(Icons.delete, color: Colors.grey),
                  title: Text('Delete Account'),
                  trailing: Icon(Icons.chevron_right),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DeletePage()),
                  );
                },
              ),
              const Divider(thickness: 1.5),
            ],
          );
        },
      ),
    );
  }
}
