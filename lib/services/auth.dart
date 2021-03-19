import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/models/sellermodel.dart';
import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

//  class to work with firebase auth services
class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollectionReference = 
      FirebaseFirestore.instance.collection("USERS");
  UserModel currentUser = new UserModel();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isUserSignedIn = false;
  final facebooklogin = FacebookLogin();
  var profile;
  AuthServices({this.currentUser});
  Future _populateCurrentUser(User user) async {
    if (user != null) {
      currentUser = await getUser(user.uid);
    }
  }

  // method to sign in with email id and password.
  Future signInEmail(email, password, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await _populateCurrentUser(result.user); // Populate the user information
      Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      return result.user != null;
      // User user = result.user;
      // return user;
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign out
  Future signOut(context) async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("error");
    }
  }

  logonwithfb(context) async {
    final result = await facebooklogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        profile = JSON.jsonDecode(graphResponse.body);
        print("olalala$profile");
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
    }
  }

  _logout() {
    facebooklogin.logOut();
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference
          .doc(FirebaseAuth.instance.currentUser.email)
          .get();
      return UserModel.fromData(userData.data());
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> updateUser({String name, String email, String address}) {
    return _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({'name': name, 'email': email, 'address': address}).then(
            (value) {
      print("User Updated");
      currentUser.name = name;
      currentUser.address = address;
      currentUser.email = email;
      return true;
    }).catchError((error) {
      print("Failed to update user: $error");
      return false;
    });
  }

  Future handlefacebooklogin(context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FacebookLogin _facebook = FacebookLogin();
    FacebookLoginResult _result = await _facebook.logIn(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.loggedIn:
        await _loginfacebook(_result, context);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelledByUser");
        break;
      case FacebookLoginStatus.error:
        Toast.show("Error Please Try again", context);
        // TODO: Handle this case.
        break;
    }
  }

  Future _loginfacebook(FacebookLoginResult _result, context) async {
    FacebookAccessToken accessToken = _result.accessToken;
    AuthCredential authCredential =
        FacebookAuthProvider.credential(accessToken.token);
    facebookuser = await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .catchError((onError) {
      print("tarunHere$onError");
    });
    User user = facebookuser.user;
    _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) => {
              if (!value.exists)
                {
                  _usersCollectionReference.doc(user.email).set({
                    "name": user.displayName,
                    "email": user.email,
                    "phonenumber": user.phoneNumber,
                    "password": "Not available",
                    "address": "Not available",
                    "follower": 0,
                    "following": 0,
                    "imageurl": user.photoURL,
                  })
                }
              else
                {
                  getUser(FirebaseAuth.instance.currentUser.email),
                  FirebaseFirestore.instance
                      .collection('SELLERS')
                      .doc(user.email)
                      .get()
                      .then((docSnapshot) async => {
                            if (docSnapshot.exists)
                              {
                                await FirebaseFirestore.instance
                                    .collection("SELLERS")
                                    .doc(user.email)
                                    .get()
                                    .then((querySnapshot) {
                                  print(
                                      "string ${querySnapshot.data().toString()}");
                                  Map<String, dynamic> data =
                                      querySnapshot.data();
                                  isSeller = true;
                                  GeoPoint geoPoint = data['shoplocation'];
                                  sellerobj = SellerModel(
                                    aadhar: data['aadhar'],
                                    name: data['name'],
                                    pan: data['pan'],
                                    productsuid: data['productsuid'],
                                    shopdescription: data['shopdescription'],
                                    shopname: data['shopname'],
                                    selleruid: data['selleruid'],
                                  );
                                })
                              }
                          })
                }
            });
    UserModel ob = UserModel(
        uid: user.uid,
        name: user.displayName,
        email: user.email,
        address: "No Address",
        phonenumber: "No PhoneNumber",
        follower: 0,
        following: 0,
        imageurl: user.photoURL);
    authobj = AuthServices(currentUser: ob);

    return user;
  }

  Future<User> googlesignin() async {
    // hold the instance of the authenticated user
    User user;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // get the credentials to (access / id token)
    // to sign in via Firebase Authentication
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    user = (await _auth.signInWithCredential(credential)).user;
    _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) => {
              if (!value.exists)
                {
                  _usersCollectionReference
                      .doc(FirebaseAuth.instance.currentUser.email)
                      .set({
                    "name": user.displayName,
                    "email": user.email,
                    "phonenumber": "Not Availalbe",
                    "password": "Not available",
                    "address": "Not available",
                    "follower": 0,
                    "following": 0,
                    "imageurl": user.photoURL,
                  })
                }
              else
                {
                  getUser(FirebaseAuth.instance.currentUser.email),
                  FirebaseFirestore.instance
                      .collection('SELLERS')
                      .doc(FirebaseAuth.instance.currentUser.email)
                      .get()
                      .then((docSnapshot) async => {
                            if (docSnapshot.exists)
                              {
                                await FirebaseFirestore.instance
                                    .collection("SELLERS")
                                    .doc(
                                        FirebaseAuth.instance.currentUser.email)
                                    .get()
                                    .then((querySnapshot) {
                                  print(
                                      "string ${querySnapshot.data().toString()}");
                                  Map<String, dynamic> data =
                                      querySnapshot.data();
                                  isSeller = true;
                                  GeoPoint geoPoint = data['shoplocation'];
                                  sellerobj = SellerModel(
                                    aadhar: data['aadhar'],
                                    name: data['name'],
                                    pan: data['pan'],
                                    productsuid: data['productsuid'],
                                    shopdescription: data['shopdescription'],
                                    shopname: data['shopname'],
                                    selleruid: data['selleruid'],
                                  );
                                })
                              }
                          })
                }
            });
    UserModel ob = UserModel(
        uid: user.uid,
        name: user.displayName,
        email: user.email,
        address: "No Address",
        phonenumber: "No PhoneNumber",
        follower: 0,
        following: 0,
        imageurl: user.photoURL);
    authobj = AuthServices(currentUser: ob);

    return user;
  }

  Future<bool> googleupdateUser({String name, String email, String uid}) {
    return _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'name': name,
      'email': email,
      'address': "No address availble"
    }).then((value) {
      print("User Updated");
      currentUser.name = name;
      currentUser.address = "No address availble";
      currentUser.email = email;
      return true;
    }).catchError((error) {
      print("Failed to update user: $error");
      return false;
    });
  }
}
