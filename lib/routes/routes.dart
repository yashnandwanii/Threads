import 'package:get/get.dart';
import 'package:threads/routes/routes_name.dart';
import 'package:threads/views/auth/login.dart';
import 'package:threads/views/auth/register.dart';
import 'package:threads/views/home.dart';
import 'package:threads/views/profile/edit_profile.dart';
import 'package:threads/views/replies/add_reply.dart';
import 'package:threads/views/settings/settings.dart';

class Routes {
  static final pages = [
    GetPage(
      name: RoutesName.home,
      page: () => Home(),
    ),
    GetPage(
      name: RoutesName.login,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RoutesName.register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.editProfile,
      page: () => const EditProfile(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: RoutesName.settings,
      page: () => Settings(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutesName.addreply,
      page: () => AddReply(),
      transition: Transition.downToUp,
    ),
  ];
}
