import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'forgot_password.dart';

class AuthUser extends StatefulWidget {
  const AuthUser({super.key});

  @override
  State<AuthUser> createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {
  bool isLogin = true;
  bool isForget = false;

  void togglepage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void togglepage2() {
    setState(() {
      isLogin = !isLogin;
      isForget = !isForget;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return login(
        onPressed: togglepage,
        onPressed2: togglepage2,
      );
    } else if (isForget) {
      return ForgotPassword(
        onPressed2: togglepage2,
      );
    } else {
      return signup(
        onPressed: togglepage,
      );
    }
  }
}
