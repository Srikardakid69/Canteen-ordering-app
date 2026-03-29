import 'package:firebase_auth/firebase_auth.dart';
class UserInfoHelper {
  static String emailUsername = '';

  static void loadEmailUsername() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailUsername = user.email?.split('@')[0] ?? 'User';
    }
  }
}