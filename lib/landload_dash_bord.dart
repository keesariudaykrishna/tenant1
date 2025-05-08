import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_models/controllers/dash_bord/nav_bar_controller.dart';
import 'views/home/home_view.dart';
import 'views/profile/profile_view.dart';
import 'views/serch/search_view.dart';

// ignore: must_be_immutable
class LandlordDashBord extends StatefulWidget {
  const LandlordDashBord({super.key});

  @override
  State<LandlordDashBord> createState() => _LandlordDashBordState();
}

class _LandlordDashBordState extends State<LandlordDashBord> {
  List<Widget> pageList = [HomeScreen(), SearchScreen(), ProfileScreen()];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((TabIndexController()));
    // print(cartController.count);
    return Scaffold(
        body: Obx(
      () => Stack(
        children: [
          Container(child: pageList[controller.tabIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.white),
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.black38),
                  selectedIconTheme:
                      const IconThemeData(color: Colors.deepOrange),
                  onTap: (value) {
                    controller.setTabIndex = value;
                  },
                  currentIndex: controller.tabIndex,
                  items: const [
                    BottomNavigationBarItem(
                        activeIcon: Icon(
                          Icons.home,
                          // color: kDark,
                        ),
                        icon: Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        activeIcon: Icon(
                          Icons.search,
                          // color: kDark,
                        ),
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        label: 'Search'),
                    BottomNavigationBarItem(
                        activeIcon: Icon(
                          Icons.person_3,
                          // color: kDark,
                        ),
                        icon: Icon(
                          Icons.person_3,
                          color: Colors.grey,
                        ),
                        label: 'Profile'),
                    // BottomNavigationBarItem(
                    //     activeIcon: Icon(
                    //       Icons.favorite,
                    //       // color: kDark,
                    //     ),
                    //     icon: Icon(
                    //       Icons.favorite_border,
                    //       color: Colors.grey,
                    //     ),
                    //     label: 'Favorites'),
                    // BottomNavigationBarItem(
                    //     activeIcon: Icon(
                    //       Icons.person_3,
                    //       // color: kDark,
                    //     ),
                    //     icon: Icon(
                    //       Icons.person_3_outlined,
                    //       color: Colors.grey,
                    //     ),
                    //     label: 'Profile'),
                  ],
                )),
          )
        ],
      ),
    ));
  }
}
