import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/views/home/home_page.dart';
import 'package:threads/views/notifications/notifications_page.dart';
import 'package:threads/views/profile/profile.dart';
import 'package:threads/views/search/search_page.dart';
import 'package:threads/views/threads/threads.dart';

class NavigationServices extends GetxController {
  var currIndex = 0.obs;
  var prevIdx = 0.obs;

  List<Widget> pages() {
    return [
      const HomePage(),
      const SearchPage(),
      const ThreadsPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];
  }

  void updateIdx(int idx){
    prevIdx.value = currIndex.value;
    currIndex.value = idx;
  }
}
