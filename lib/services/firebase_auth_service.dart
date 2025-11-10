import 'package:project_mobile/models/user_model.dart';

class AuthService {
  Future<bool> login(UserModel user) async {
    // simulasi login delay
    await Future.delayed(const Duration(seconds: 1));

    // login dummy
    if (user.email == 'admin@gmail.com' && user.password == '123456') {
      return true;
    } else {
      return false;
    }
  }
}
