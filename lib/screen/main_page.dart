import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/material.dart';

import 'pages/activity/activity_page.dart';
import 'pages/order/order_page.dart';
import 'pages/menu/menu_page.dart';
import 'pages/other/notification_page.dart';
import 'pages/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    this.initialIndex = 0,
    this.badge = false,
  });

  final int initialIndex;
  final bool badge;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    pages = [
      OrderPage(currentUser: currentUser),
      ActivityPage(currentUser: currentUser),
      MenuPage(currentUser: currentUser),
      ProfilePage(currentUser: currentUser),
    ];
  }

  late User currentUser;

  late List<Widget> pages;

  final List<String> title = [
    'Order',
    'Activity',
    'Menu',
    'Profile',
  ];

  final List<IconData> icon = [
    Iconsax.menu_board_outline,
    Iconsax.directbox_notif_outline,
    Iconsax.note_21_outline,
    Iconsax.personalcard_outline,
  ];

  final List<IconData> iconSelect = [
    Iconsax.menu_board_bold,
    Iconsax.directbox_notif_bold,
    Iconsax.note_1_bold,
    Iconsax.personalcard_bold,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          iconSelect[currentIndex],
          size: 25,
        ),
        titleSpacing: 0,
        title: Text(title[currentIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              icon: const Icon(
                Iconsax.notification_bing_outline,
              ),
            ),
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text(
            'Press again to Exit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: Colors.black38, width: 1),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          hitTestBehavior: HitTestBehavior.translucent,
          width: 160,
        ),
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.deepPurpleAccent.shade400,
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          if (currentIndex == value) return;
          setState(() {
            currentIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              icon[0],
              color: Colors.black54,
            ),
            selectedIcon: Icon(
              iconSelect[0],
              color: Colors.white,
            ),
            label: title[0],
          ),
          NavigationDestination(
            icon: Icon(
              icon[1],
              color: Colors.black54,
            ),
            selectedIcon: Icon(
              iconSelect[1],
              color: Colors.white,
            ),
            label: title[1],
          ),
          NavigationDestination(
            icon: Icon(
              icon[2],
              color: Colors.black54,
            ),
            selectedIcon: Icon(
              iconSelect[2],
              color: Colors.white,
            ),
            label: title[2],
          ),
          NavigationDestination(
            icon: Icon(
              icon[3],
              color: Colors.black54,
            ),
            selectedIcon: Icon(
              iconSelect[3],
              color: Colors.white,
            ),
            label: title[3],
          ),
        ],
      ),
    );
  }
}
