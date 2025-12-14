import 'package:flutter/material.dart';
import 'package:skill_swap/constr/notifier.dart';
import 'package:skill_swap/pages/widget_tree/messege_page.dart';
import 'package:skill_swap/pages/widget_tree/search_page.dart';

import '../pages/widget_tree/home_page.dart';
import '../pages/widget_tree/profile_page.dart';
import 'navbar.dart';

List<Widget> pages =[
  HomePage(),
  SearchPage(),
  MessageCenterPage(),
  ProfilePage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ValueListenableBuilder(valueListenable: selectedPageNotifier,
          builder: (context, selectedPage, child) {
             return pages.elementAt(selectedPage);
          },),
      bottomNavigationBar:NavBar(),
    );
  }
}
