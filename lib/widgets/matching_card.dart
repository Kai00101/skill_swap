

import 'package:flutter/material.dart';
import '../services/user_profile.dart';
import '../home_matching_details/person_matching.dart';
import '../home_matching_details/tech_card_match.dart';

class MatchingCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onSkip;
  final VoidCallback onSwap;

  const MatchingCard({
    super.key,
    required this.user,
    required this.onSkip,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(user.uid),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onSkip(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        color: Colors.redAccent,
        child: const Icon(Icons.close, color: Colors.white, size: 30),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: const Color(0xFFF4EEFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/chel2.png'),
                    radius: 35,
                  ),
                  const SizedBox(width: 13),
                  PersonMatching(city: user.city, name: user.name),
                ],
              ),

              const SizedBox(height: 8),
              const Text('Can Teach',style: TextStyle(color: Colors.black),),

              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: user.canTeach.map((e) => TeachCard(subject: e)).toList(),
              ),

              const SizedBox(height: 13),
              const Text('Want to Learn',style: TextStyle(color: Colors.black),),

              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: user.wantsToLearn.map((e) => TeachCard(subject: e)).toList(),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: onSwap,
                    child: const Text("Swap",style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: onSkip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2DAFF),
                    ),
                    child: const Text("Skip",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
