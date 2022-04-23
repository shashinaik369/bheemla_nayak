import 'package:flutter/material.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/views/widgets/custom_icon.dart';
import 'package:iconsax/iconsax.dart';

import 'package:iconly/iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIdx],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_1, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal_1, size: 30),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.add_circle,
              size: 34,
            ),
            // CustomIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message, size: 30),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_2user, size: 30),
            label: 'Profile',
          ),
        ],
      ),

      // full screen

      // body: Stack(
      //   children: [
      //     pages[pageIdx],
      //     // Divider(
      //     //   thickness: 100,
      //     // ),
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Theme(
      //         data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      //         child: BottomNavigationBar(
      //           onTap: (idx) {
      //             setState(() {
      //               pageIdx = idx;
      //             });
      //           },
      //           type: BottomNavigationBarType.fixed,
      //           selectedItemColor: Colors.red,
      //           unselectedItemColor: Colors.white,
      //           currentIndex: pageIdx,
      //           items: const [
      //             BottomNavigationBarItem(
      //               icon: Icon(Iconsax.home_1, size: 30),
      //               label: 'Home',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(Iconsax.search_normal_1, size: 30),
      //               label: 'Search',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(
      //                 Iconsax.add_circle,
      //                 size: 34,
      //               ),
      //               // CustomIcon(),
      //               label: '',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(Iconsax.message, size: 30),
      //               label: 'Messages',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(Iconsax.profile_2user, size: 30),
      //               label: 'Profile',
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
