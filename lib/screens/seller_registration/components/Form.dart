// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:shop_app/models/sellermodel.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:toast/toast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({Key key}) : super(key: key);

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();
}

class SellerData {
  String name = '';
  String aadhar = '';
  String pan = '';
  String shopdescription = '';
  String shopname = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      cursorColor: Theme.of(context).cursorColor,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            // semanticLabel: _obscureText
            //     ? GalleryLocalizations.of(context)
            //         .demoTextFieldShowPasswordLabel
            //     : GalleryLocalizations.of(context)
            //         .demoTextFieldHidePasswordLabel,
          ),
        ),
      ),
    );
  }
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SellerData seller = SellerData();
  Position _currentposition;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  Future<void> _handleSubmitted() async {
    final form = _formKey.currentState;
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint point = geo.point(latitude: 0, longitude: 0);
    if (!form.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBar("please fix the errors in red before submitting");
    } else {
      form.save();
      await FirebaseFirestore.instance
          .collection("SELLERS")
          .doc(FirebaseAuth.instance.currentUser.email)
          .set({
        "name": seller.name,
        "shopname": seller.shopname,
        "shopdescription": seller.shopdescription,
        "pan": seller.pan,
        "aadhar": seller.aadhar,
        "productsuid": [],
        "position": point.data,
        "selleruid": FirebaseAuth.instance.currentUser.email,
      });
      isSeller = true;
      sellerobj = SellerModel(
          name: seller.name,
          shopname: seller.shopname,
          shopdescription: seller.shopdescription,
          pan: seller.pan,
          aadhar: seller.aadhar,
          productsuid: [],
          position: point);
      showInSnackBar("Registration successful");
      custumersendMail(authobj.currentUser.email);
      newSellersendMail();
      Toast.show("Please Restart the app", context, duration: 5);
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "This field can't be empty";
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Please Enter Only Alphabets";
    }
    return null;
  }

  String validatePan(String value) {
    return null;
  }

  String validateShopDescription(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    return null;
  }

  String validateAadhar(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    if (value.length < 12) {
      return "Please enter correct pan number";
    }
    return null;
  }

  String validateGST(String value) {
    return null;
  }

  String validateShopName(String value) {
    if (value.isEmpty) {
      return "this field can't be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Scrollbar(
                  //padding: EdgeInsets.only(right: 8.0, left: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        sizedBoxSpace,
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                            filled: true,
                            icon: const Icon(Icons.person),
                            hintText: "Enter your Name",
                            labelText: "Name*",
                          ),
                          onSaved: (value) {
                            seller.name = value;
                          },
                          validator: _validateName,
                        ),
                        sizedBoxSpace,
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                            filled: true,
                            icon: const Icon(Icons.home),
                            hintText: "Enter your Shop Name",
                            labelText: "Shop Name*",
                          ),
                          onSaved: (value) {
                            seller.shopname = value;
                          },
                          validator: validateShopName,
                        ),
                        sizedBoxSpace,
                        // TextFormField(
                        //   cursorColor: cursorColor,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     icon: const Icon(Icons.phone),
                        //     hintText: "98XXXXXXXX",
                        //     labelText: "Phone number*",
                        //     prefixText: '+1 91',
                        //   ),
                        //   keyboardType: TextInputType.phone,
                        //   onSaved: (value) {
                        //     person.phoneNumber = value;
                        //   },
                        //   maxLength: 10,
                        //   maxLengthEnforced: true,
                        //   validator: _validatePhoneNumber,
                        //   // TextInputFormatters are applied in sequence.
                        // ),
                        // sizedBoxSpace,
                        // TextFormField(
                        //   cursorColor: cursorColor,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     icon: const Icon(Icons.email),
                        //     hintText: "Your email address",
                        //     labelText: "Email*",
                        //   ),
                        //   keyboardType: TextInputType.emailAddress,
                        //   onSaved: (value) {
                        //     person.email = value;
                        //   },
                        // ),
                        sizedBoxSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            cursorColor: cursorColor,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Tell Us about your Shop",
                              helperText: "Keep it short",
                              labelText: "Description",
                            ),
                            onSaved: (value) {
                              seller.shopdescription = value;
                            },
                            validator: validateShopDescription,
                            maxLines: 3,
                          ),
                        ),
                        sizedBoxSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            cursorColor: cursorColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "PAN number*",
                                hintText: "Enter your 10 digit Pan"),
                            maxLength: 10,
                            maxLines: 1,
                            validator: validatePan,
                            onSaved: (value) {
                              seller.pan = value;
                            },
                          ),
                        ),
                        sizedBoxSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            cursorColor: cursorColor,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "AAdhar number*",
                                hintText: "Enter your 12 digit AAdhar"),
                            maxLength: 12,
                            maxLines: 1,
                            validator: validateAadhar,
                            onSaved: (value) {
                              seller.aadhar = value;
                            },
                          ),
                        ),
                        sizedBoxSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            cursorColor: cursorColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "GST Number",
                                hintText: "Please enter GST Number"),
                            maxLength: 15,
                            maxLines: 1,
                            validator: validateGST,
                            onSaved: (value) {
                              seller.aadhar = value;
                            },
                          ),
                        ),
                        // PasswordField(
                        //   helperText: "No more than 8 characters",
                        //   labelText: "Password*",
                        //   onFieldSubmitted: (value) {
                        //     setState(() {
                        //       person.password = value;
                        //     });
                        //   },
                        // ),
                        // sizedBoxSpace,
                        // TextFormField(
                        //   cursorColor: cursorColor,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     labelText: "Re-type password*",
                        //   ),
                        //   maxLength: 8,
                        //   obscureText: true,
                        // ),
                        /*Center(
                          child: RaisedButton(
                            child: Text(
                              "Shop Current location",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.pinkAccent,
                            onPressed: () {
                              _getCurrentLocation();
                            },
                          ),
                        ),*/
                        sizedBoxSpace,

                        Center(
                          child: RaisedButton(
                            child: Text("Register",
                                style: TextStyle(color: Colors.white)),
                            color: primary,
                            onPressed: _handleSubmitted,

                            // await FirebaseFirestore.instance
                            //     .collection("SELLERS")
                            //     .doc(authobj.currentUser.uid)
                            //     .set({
                            //   "name": seller.name,
                            //   "shopname":seller.shopname,
                            //   "shopdescription": seller.shopdescription,
                            //   "shopname": seller.shopname,
                            //   "pan": seller.pan,
                            //   "aadhar": seller.aadhar,
                            //   "productsuid":[],
                            //   "shoplocation":GeoPoint(_currentposition.latitude, _currentposition.longitude)
                            // });
                          ),
                        ),
                        sizedBoxSpace,
                        Text(
                          "By clicking on Register you agree to our terms and conditions",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          "*indicates required field",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        sizedBoxSpace,
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentposition = position;
      });
    }).catchError((e) {
      print(e);
    });
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
          'You have been Registered as a seller at Humble Market :: 😀 :: ${DateTime.now()}'
      ..text =
          'You have been Register , Thanks for Registering , Wish you millions of orders'
      ..html =
          "<h1>You have been Registered as a seller at Humble Market :: 😀 :</h1>\n<p>Hey! Here's some HTML content</p>";

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

  newSellersendMail() async {
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
      ..recipients.add(username)
      ..ccRecipients.addAll([username, username])
      ..bccRecipients.add(Address(username))
      ..subject =
          'New Seller registered on Humble Market :: 😀 :: ${DateTime.now()}'
      ..text = 'Seller name ' +
          seller.name +
          " " +
          "With email id " +
          authobj.currentUser.email +
          " Having Shop " +
          seller.shopname +
          " For Other Information check on Admin Panel"
      ..html =
          "<h1>New Seller registered on Humble Market :: 😀</h1>\n<p>Hey! Here's some HTML content</p>";

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

// /// Format incoming numeric text to fit the format of (###) ###-#### ##
// class _UsNumberTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final newTextLength = newValue.text.length;
//     final newText = StringBuffer();
//     var selectionIndex = newValue.selection.end;
//     var usedSubstringIndex = 0;
//     if (newTextLength >= 1) {
//       newText.write('(');
//       if (newValue.selection.end >= 1) selectionIndex++;
//     }
//     if (newTextLength >= 4) {
//       newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
//       if (newValue.selection.end >= 3) selectionIndex += 2;
//     }
//     if (newTextLength >= 7) {
//       newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
//       if (newValue.selection.end >= 6) selectionIndex++;
//     }
//     if (newTextLength >= 11) {
//       newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
//       if (newValue.selection.end >= 10) selectionIndex++;
//     }
//     // Dump the rest.
//     if (newTextLength >= usedSubstringIndex) {
//       newText.write(newValue.text.substring(usedSubstringIndex));
//     }
//     return TextEditingValue(
//       text: newText.toString(),
//       selection: TextSelection.collapsed(offset: selectionIndex),
//     );
//   }
// }
