import 'package:get_storage/get_storage.dart';

class StorageServices {
  static final session = GetStorage();

  // Define a constant key for the session storage
  static const String userSessionKey = 'userSession';

  // Use the key to read the session value
  static dynamic userSession = session.read(userSessionKey);
}
