import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:threads/routes/routes.dart';
import 'package:threads/routes/routes_name.dart';
import 'package:threads/services/storage_services.dart';
import 'package:threads/services/supabase_services.dart';
import 'package:threads/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(SupabaseServices());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Threads",
      theme: theme,
      getPages: Routes.pages,
      initialRoute: StorageServices.userSession != null
          ? RoutesName.home
          : RoutesName.login,
    );
  }
}
