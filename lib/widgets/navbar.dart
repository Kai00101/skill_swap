import 'package:flutter/material.dart';

import '../constr/notifier.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:selectedPageNotifier,
        builder: (context, selectedPage, child) {
return NavigationBar(destinations: [
  NavigationDestination(icon:selectedPage==0? Icon(Icons.home,color: Colors.deepPurple,): Icon(Icons.home_outlined,), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.manage_search_sharp,color:selectedPage==1? Colors.deepPurple:null,), label: 'Search'),
  NavigationDestination(icon:selectedPage==2? Icon(Icons.chat_bubble,color: Colors.deepPurple,): Icon(Icons.chat_bubble_outline,), label: 'Chat'),
  NavigationDestination(icon:selectedPage==3? Icon(Icons.person_2,color: Colors.deepPurple,): Icon(Icons.person_2_outlined,), label: 'Profile'),
],
    onDestinationSelected:(int value) {
  selectedPageNotifier.value = value;
},
  selectedIndex: selectedPage,
);
        },);
  }
}
