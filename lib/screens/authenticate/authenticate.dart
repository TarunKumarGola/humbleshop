import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/home/HomeScreen.dart';
import 'package:shop_app/screens/splash/loader.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

class Authenticate extends StatefulWidget {
  static String routeName = "/Authenticate";
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool state = false;
  @override
  Future<void> initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      getLiked().whenComplete(() {
        setState(() {
          state = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final user = Provider.of<User>(context);
    //final user = Provider.of<User>(context);

    if (FirebaseAuth.instance.currentUser == null) {
      return SplashScreen();
    } else {
      getuser(FirebaseAuth.instance.currentUser.uid);
      return Scaffold(
        body: state ? HomeScreen() : Loader(),
      );
    }
  }
}
