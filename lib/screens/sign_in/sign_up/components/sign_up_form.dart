import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';

import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

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
  String conform_password;
  bool remember = false;
  String address;
  String name;
  final List<String> errors = [];
  String phoneNumber;
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
          SizedBox(height: getProportionateScreenHeight(5)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(5)),
          DefaultButton(
            text: "Verify Phone Number",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                if (!checkdata()) {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);

                    User firebaseuser = FirebaseAuth.instance.currentUser;

                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: "+91$phoneNumber",
                      timeout: const Duration(minutes: 2),
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        // ANDROID ONLY!
                        // Sign the user in (or link) with the auto-generated credential
                        UserModel userm = new UserModel(
                            name, email, password, phoneNumber, address, 0, 0);
                        FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(firebaseuser.uid)
                            .set({
                          "name": name,
                          "email": email,
                          "phonenumber": phoneNumber,
                          "password": password,
                          "address": address,
                          "follower": 0,
                          "following": 0,
                          "imageurl": "image",
                        });
                        FirebaseFirestore.instance
                            .collection("PhoneNumbers")
                            .doc(phoneNumber)
                            .set({
                          "Present": "True",
                        });
                        print('verification auto completed');
                        print('updating phone number');
                        try {
                          print(
                              "inside updatephonenumber varificationCompleted");
                          firebaseuser.updatePhoneNumber(credential);
                        } catch (e) {
                          if (e.code ==
                              "ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
                            print(e.code);
                            try {
                              print("deleting user");
                              firebaseuser.delete();
                            } catch (e) {
                              print(e);
                            }
                          }
                          print(e);
                        }
                        //print('linking with credential');
                        try {
                          print(
                              "inside linkwithCredential varificationCompleted");
                          firebaseuser.linkWithCredential(credential);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        } catch (e) {
                          if (e.code == "credential-already-in-use") {
                            firebaseuser.delete();
                          }
                          print(e);
                        }
                        print("verification auto completed");
                        // await auth.signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        if (e.code == 'invalid-phone-number') {
                          print('The provided phone number is not valid.');
                          print('The provided phone number is not valid.');
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
                      codeSent: (String verificationId, int resendToken) async {
                        String smsCode = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen()));

                        // Create a PhoneAuthCredential with the code

                        PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: null, smsCode: null);
                        FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(firebaseuser.uid)
                            .set({
                          "name": name,
                          "email": email,
                          "phonenumber": phoneNumber,
                          "password": password,
                          "address": address,
                          "follower": 0,
                          "following": 0,
                          "imageurl": "image",
                        });
                        FirebaseFirestore.instance
                            .collection("PhoneNumbers")
                            .doc(phoneNumber)
                            .set({
                          "Present": "True",
                        });
                        // Sign the user in (or link) with the credential
                        try {
                          firebaseuser.updatePhoneNumber(phoneAuthCredential);
                        } catch (e) {
                          if (e.code ==
                              "ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
                            print(e.code);
                            try {
                              print("deleting user");
                              firebaseuser.delete();
                            } catch (e) {
                              print(e);
                            }
                          }
                        }
                        try {
                          firebaseuser.linkWithCredential(phoneAuthCredential);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        } catch (e) {
                          if (e.code == "credential-already-in-use") {
                            firebaseuser.delete();
                          }
                          print(e.code);
                        }
                        //await auth.signInWithCredential(phoneAuthCredential);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      print("Email id already exist please go to sign in page");
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                }
                 else 
                 {
                print(
                    "Phone number already exits please try some other phone number");
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

  bool checkdata() {
    bool ans = false;
    DocumentReference collectionReference =
        FirebaseFirestore.instance.collection("PhoneNumbers").doc(phoneNumber);
    collectionReference.get().then(
        (value) => {if (value.exists) return true; else print(phoneNumber)});
        print(ans);
        print(phoneNumber);
    return ans;
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
