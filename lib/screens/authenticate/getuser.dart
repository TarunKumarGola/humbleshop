import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
//import 'package:flutter/material.dart'

import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/services/auth.dart';
import 'package:shop_app/models/sellermodel.dart';

AuthServices authobj;
SellerModel sellerobj;
bool isSeller = false;
BuildContext global;
var facebookuser;
int index = 0;
Map user;
final facebooklogin = FacebookLogin();

List<String> imagePaths = new List<String>();
Future<void> getImages() async {
  DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("HomePage")
      .doc("Q9MDDG4pLcv40zUXykSf")
      .get();
  if (querySnapshot.exists &&
      querySnapshot.data().containsKey("CaroselSliderImage") &&
      querySnapshot.data()['CaroselSliderImage'] is List) {
    // Create a new List<String> from List<dynamic>
    imagePaths = List<String>.from(querySnapshot.data()['CaroselSliderImage']);
  } else {
    imagePaths = [];
  }
}

Future<void> getuser(String uid) async {
  UserModel obj;
  await FirebaseFirestore.instance
      .collection('USERS')
      .doc(uid)
      .get()
      .then((querySnapshot) {
    print("string ${querySnapshot.data().toString()}");
    Map<String, dynamic> data = querySnapshot.data();

    obj = UserModel(
        uid: uid,
        name: data['name'],
        phonenumber: data['phonenumber'],
        address: data['address'],
        email: data['email'],
        follower: data['follower'],
        following: data['following'],
        imageurl: data['imageurl']);

    // print("userdata is ${obj.name} ${obj.address} ${user.phoneNumber}");
  });

  authobj = AuthServices(currentUser: obj);

  await FirebaseFirestore.instance
      .collection('SELLERS')
      .doc(uid)
      .get()
      .then((docSnapshot) async => {
            if (docSnapshot.exists)
              {
                await FirebaseFirestore.instance
                    .collection("SELLERS")
                    .doc(uid)
                    .get()
                    .then((querySnapshot) {
                  print("string ${querySnapshot.data().toString()}");
                  Map<String, dynamic> data = querySnapshot.data();
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
      .whenComplete(() => print("Tarun ${sellerobj.shoplocation}"));
}

List<String> liked;
Future<void> getLiked() async {
  print("tarun enter");
  DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("USER")
      .doc(FirebaseAuth.instance.currentUser.email)
      .get();
  print('tarun${querySnapshot.data()}');
  if (querySnapshot.exists &&
      querySnapshot.data().containsKey("Liked") &&
      querySnapshot.data()['Liked'] is List) {
    // Create a new List<String> from List<dynamic>
    liked = List<String>.from(querySnapshot.data()['Liked']);
    print("tarun yo yo");
    print(liked);
  } else {
    liked = [];
    print("tarun yo");
  }
}

Future<bool> updatelikes(String uid, String likedmem) {
  DocumentReference favoritesReference =
      FirebaseFirestore.instance.collection('USER').doc(uid);
  print('yoyo' + uid + " " + likedmem);
  return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
    if (postSnapshot.exists) {
      print("yes it exits");
      if (!postSnapshot.data()['Liked'].contains(likedmem)) {
        tx.update(favoritesReference, <String, dynamic>{
          'Liked': FieldValue.arrayUnion([likedmem])
        });
        print("inside add ");
        // Delete the recipe ID from 'favorites':
      } else {
        tx.update(favoritesReference, <String, dynamic>{
          'Liked': FieldValue.arrayRemove([likedmem])
        });
        print("inside remove");
      }
    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
      print("creating a new list");
      tx.set(favoritesReference, {
        'Liked': [likedmem]
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('TarunError: $error');
    return false;
  });
}
