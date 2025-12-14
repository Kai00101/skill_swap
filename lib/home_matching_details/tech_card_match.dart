import 'package:flutter/material.dart';

class TeachCard extends StatelessWidget {
  final String subject;
  const TeachCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      width: 100,
      alignment: Alignment.center,
      child: Text(subject,style: TextStyle(color: Colors.black),),
    );
  }
}
