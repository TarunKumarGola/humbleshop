import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shop_app/components/socal_card.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import '../../../size_config.dart';
import 'package:shop_app/services/auth.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';

class Body extends StatelessWidget {
  User _user;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your Gmail  or Facebook ID",
                  textAlign: TextAlign.center,
                ),
                /* SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {
                        showAlertDialog(context);
                        AuthServices ob = new AuthServices();
                        ob
                            .googlesignin()
                            .whenComplete(() => {
                                  Navigator.pop(context),
                                  if (FirebaseAuth.instance.currentUser != null)
                                    {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginSuccessScreen())),
                                      custumersendMail(
                                          authobj.currentUser.email)
                                    }
                                })
                            .catchError((error) {
                          Navigator.pop(context);
                          print(error);
                        });
                      },
                    ),
                  /*  SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {
                        // showAlertDialog(context);
                        AuthServices ob = new AuthServices();
                        ob
                            .logonwithfb()
                            .whenComplete(() => {
                                  if (FirebaseAuth.instance.currentUser != null)
                                    {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginSuccessScreen())),
                                      custumersendMail(
                                          authobj.currentUser.email)
                                    }
                                })
                            .catchError((error) {
                          // Navigator.pop(context);
                          print("tarun$error");
                        });
                      },
                      */
                    ),

                    /* 
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),*/
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                /*NoAccountText(),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  custumersendMail(String email) async {
    String username = 'humblemarketofficial@gmail.com';
    String password = 'qwerty123qwertyK';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add(email)
      ..ccRecipients.addAll([email, email])
      ..bccRecipients.add(Address(email))
      ..subject =
          'You have been Logined  at Humble Market :: 😀 :: ${DateTime.now()}'
      ..text =
          'You have been Register , Thanks for Registering , Wish you millions of orders'
      ..html =
          "<h1>You have been Logined  at Humble Market :: 😀 :</h1>\n<p>Hey! Here's some HTML content</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
