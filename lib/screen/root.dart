import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:planet/controllers/plant/pagenation_plants_controller.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/controllers/user/user_info_controller.dart';
import 'package:planet/screen/plant/plants_screen.dart';
import 'package:planet/screen/home.dart';
import 'package:planet/screen/user_info/user_info_screen.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/services/user_api_service.dart';
import 'package:planet/theme.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenWidgetState();
}

class _RootScreenWidgetState extends State<RootScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const PlantsScreen(),
    const UserInfoScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RecentPlantsController());
    Get.put(PopularPlantsController());
    Get.put(RandomPlantsController());
    Get.put(PlantController(PlantsApiClient()));
    Get.put(UserInfoController(UserApiClient()));

    return Container(
      color: Colors.white,
      child: SafeArea(
          bottom: false,
          child: Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/home.svg',
                      color: _selectedIndex == 0
                          ? ColorStyles.mainAccent
                          : Colors.black,
                      width: _selectedIndex == 0 ? 25 : 23,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/pot.svg',
                      color: _selectedIndex == 1
                          ? ColorStyles.mainAccent
                          : Colors.black,
                      width: _selectedIndex == 1 ? 25 : 23,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/user.svg',
                      color: _selectedIndex == 2
                          ? ColorStyles.mainAccent
                          : Colors.black,
                      width: _selectedIndex == 2 ? 28 : 23,
                    ),
                  ),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          )),
    );
  }
}
