import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/home/HomeScreen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

class Authenticate extends StatefulWidget {
  static String routeName = "/Authenticate";
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    if (FirebaseAuth.instance.currentUser == null) {
      return SplashScreen();
    } else {
      // AuthServices obj = new AuthServices();
      // Future<UserModel> currentUser = obj.getUser(user.uid);
      // print("User uid is ${user.uid}");
      getuser(FirebaseAuth.instance.currentUser.uid);
      //UserModel obj=await getuser(user.uid);

      //AuthServices authobj = new AuthServices(currentUser: obj);
      return HomeScreen();
    }
  }
}
