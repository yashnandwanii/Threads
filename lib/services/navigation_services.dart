import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threads/views/home/home_page.dart';
import 'package:threads/views/notifications/notifications_page.dart';
import 'package:threads/views/profile/profile.dart';
import 'package:threads/views/search/search_page.dart';
import 'package:threads/views/threads/add_thread.dart';

class NavigationServices extends GetxController {
  var currIndex = 0.obs;
  var prevIdx = 0.obs;

  List<Widget> pages() {
    return [
      HomePage(),
      Search(),
      AddThread(),
      const NotificationsPage(),
      const ProfilePage(),
    ];
  }

  void updateIdx(int idx) {
    prevIdx.value = currIndex.value;
    currIndex.value = idx;
  }

  void backToPrevPage() {
    currIndex.value = prevIdx.value;
  }
}
