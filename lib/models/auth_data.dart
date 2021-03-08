import 'package:chat/models/user.dart';

enum AuthMode {
  SIGN_IN,
  SIGN_UP,
}

class AuthData {
  User user = User();
  AuthMode _mode = AuthMode.SIGN_IN;

  get isSignIn => _mode == AuthMode.SIGN_IN;
  get isSignUp => _mode == AuthMode.SIGN_UP;

  void toggleMode() {
    _mode = isSignIn ? AuthMode.SIGN_UP : AuthMode.SIGN_IN;
  }
}