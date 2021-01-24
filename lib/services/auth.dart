import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';

//  class to work with firebase auth services
class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("USERS");
  UserModel currentUser = new UserModel();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isUserSignedIn = false;

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

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromData(userData.data());
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> updateUser({String name, String email, String address}) {
    return _usersCollectionReference.doc(currentUser.uid).update(
        {'name': name, 'email': email, 'address': address}).then((value) {
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
    _usersCollectionReference.doc(user.uid).get().then((value) => {
          if (!value.exists)
            {
              _usersCollectionReference.doc(user.uid).set({
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
    return _usersCollectionReference.doc(uid).update({
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
