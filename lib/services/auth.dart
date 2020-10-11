import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';

//  class to work with firebase auth services
class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  UserModel currentUser;

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
  Future signOut() async {
    try {
      return await _auth.signOut();
      // ignore: dead_code
      currentUser.address = null;
      currentUser.email = null;
      currentUser.follower = null;
      currentUser.following = null;
      currentUser.imageurl = null;
      currentUser.name = null;
      currentUser.phonenumber = null;
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
}
