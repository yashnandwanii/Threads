import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:threads/controller/settings_controller.dart';
import 'package:threads/utils/helper.dart';

class Settings extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () {
                confirmDialog(
                  "Are you Sure?",
                  "Are you sure you want to logout?",
                  controller.logout,
                );
                // Navigate to edit profile page
                // Get.toNamed("/edit_profile");
                // controller.logout();
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
