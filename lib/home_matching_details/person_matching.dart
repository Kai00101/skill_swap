import 'package:flutter/material.dart';

class PersonMatching extends StatelessWidget {
  const PersonMatching({
    super.key,
  required this.city,
    required this.name,
  });

  final String name;
  final String city;

  @override
  Widget build(BuildContext context) {
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
        ),
        Text(city,
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500]
          ),
        )
      ],
    );
  }
}


