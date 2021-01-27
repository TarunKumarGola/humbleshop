import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/authenticate/authenticate.dart';
import 'package:shop_app/services/auth.dart';
import 'package:shop_app/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthServices().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Humble Market",
          theme: theme(),
          home: Authenticate(),
          routes: routes,
        ));
  }
}
