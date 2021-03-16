import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:toast/toast.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../sign_in_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  // ignore: non_constant_identifier_names
  String conform_password;
  bool remember = false;
  String address;
  String name;
  final List<String> errors = [];
  String phoneNumber;
  final _codeController = TextEditingController();
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Verify Phone Number",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Toast.show("We are Sending OTP please wait", context,
                    duration: 10);
                bool checkdata = false;

                await FirebaseFirestore.instance
                    .collection("PhoneNumbers")
                    .doc("+91$phoneNumber")
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  if (documentSnapshot.exists) {
                    Toast.show(
                        "Phone Number Already Registered \nPlease Try Some Other phone Number",
                        context,
                        duration: 5);
                    checkdata = true;
                  } else {
                    print("this phone number does not exist");
                    checkdata = false;
                  }
                });

                if (!checkdata) {
                  try {
                    // ignore: unused_local_variable
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);

                    User firebaseuser = FirebaseAuth.instance.currentUser;

                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: "+91$phoneNumber",
                      timeout: const Duration(minutes: 2),
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        await FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(firebaseuser.uid)
                            .set({
                          "name": name,
                          "email": email,
                          "phonenumber": "+91$phoneNumber",
                          "password": password,
                          "address": "Manually add Address",
                          "follower": 0,
                          "following": 0,
                          "imageurl": "image",
                        });
                        await FirebaseFirestore.instance
                            .collection("PhoneNumbers")
                            .doc("+91$phoneNumber")
                            .set({});

                        firebaseuser.updatePhoneNumber(credential);

                        //print('linking with credential');

                        firebaseuser.linkWithCredential(credential);
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));

                        // await auth.signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        if (e.code == 'invalid-phone-number') {
                          Toast.show(
                              'The provided phone number is Invalid.', context,
                              duration: 3);
                        } else {
                          print(e);
                        }
                        try {
                          print('deleting user');
                          firebaseuser.delete();
                        } catch (e) {
                          print(e);
                        }
                      },
                      codeSent: (String verificationId,
                          [int forceResendingToken]) {
                        //show dialog to take input from the user
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                                  title: Text("Enter SMS Code"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextField(
                                        controller: _codeController,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Done"),
                                      textColor: Colors.white,
                                      color: Colors.redAccent,
                                      onPressed: () async {
                                        // ignore: unused_local_variable
                                        FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        String smsCode =
                                            _codeController.text.trim();
                                        PhoneAuthCredential
                                            phoneAuthCredential =
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode: smsCode);
                                        FirebaseFirestore.instance
                                            .collection("USERS")
                                            .doc(firebaseuser.uid)
                                            .set({
                                          "name": name,
                                          "email": email,
                                          "phonenumber": "+91$phoneNumber",
                                          "password": password,
                                          "address": address,
                                          "follower": 0,
                                          "following": 0,
                                          "imageurl": "image",
                                        });
                                        FirebaseFirestore.instance
                                            .collection("PhoneNumbers")
                                            .doc(phoneNumber)
                                            .set({});
                                        // Sign the user in (or link) with the credential

                                        firebaseuser.updatePhoneNumber(
                                            phoneAuthCredential);

                                        firebaseuser.linkWithCredential(
                                            phoneAuthCredential);
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInScreen()));
                                      },
                                    )
                                  ],
                                ));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      Toast.show('The password provided is too weak', context);
                    } else if (e.code == 'email-already-in-use') {
                      Toast.show(
                          'The account already exists for that email', context);
                      print("Email id already exist please go to sign in page");
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                } else {
                  Toast.show(
                      "Phone number already exits please try some other phone number",
                      context,
                      duration: 3);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        prefixText: "+91",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your  name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
