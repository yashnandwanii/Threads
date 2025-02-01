import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/services/navigation_services.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final NavigationServices navigationServices = Get.put(NavigationServices());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationServices.currIndex.value,
          onDestinationSelected: (int index) {
            navigationServices.updateIdx(index);
          },
          
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              label: "Search",
              selectedIcon: Icon(Icons.search),
            ),
            NavigationDestination(
              icon: Icon(Icons.add_outlined),
              label: "Add",
              selectedIcon: Icon(Icons.add),
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              label: "Notifications",
              selectedIcon: Icon(Icons.notifications),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: "Profile",
              selectedIcon: Icon(Icons.person),
            ),
          ],
        ),
        body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child:
                navigationServices.pages()[navigationServices.currIndex.value]),
      ),
    );
  }
}
