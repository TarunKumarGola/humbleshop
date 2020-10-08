import 'package:flutter/material.dart';
import 'package:shop_app/services/auth.dart';

import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  //LoginSuccessScreen();
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Login Success"),
      ),
      body: Body(),
    );
  }
}
