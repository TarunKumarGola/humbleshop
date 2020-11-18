import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
//import 'package:flutter/material.dart'

import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/services/auth.dart';
import 'package:shop_app/models/sellermodel.dart';

AuthServices authobj;
SellerModel sellerobj;
bool isSeller = false;
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
                    shoplocation: data['shoplocation'],
                    shopname: data['shopname'],
                    position: Geoflutterfire().point(
                        latitude: geoPoint.latitude,
                        longitude: geoPoint.longitude),
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
      .collection("USERS")
      .doc(authobj.currentUser.uid)
      .get();
  print('tarun${querySnapshot.data()}');
  if (querySnapshot.exists &&
      querySnapshot.data().containsKey("Liked") &&
      querySnapshot.data()['Liked'] is List) {
    // Create a new List<String> from List<dynamic>
    liked = List<String>.from(querySnapshot.data()['Liked']);
    print("tarun yo yo");
  } else {
    liked = [];
    print("tarun yo");
  }
}

Future<bool> updatelikes(String uid, String likedmem) {
  DocumentReference favoritesReference =
      FirebaseFirestore.instance.collection('USERS').doc(uid);

  return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
    if (postSnapshot.exists) {
      // Extend 'favorites' if the list does not contain the recipe ID:
      if (!postSnapshot.data()['Liked'].contains(likedmem)) {
        await tx.update(favoritesReference, <String, dynamic>{
          'Liked': FieldValue.arrayUnion([likedmem])
        });
        // Delete the recipe ID from 'favorites':
      } else {
        await tx.update(favoritesReference, <String, dynamic>{
          'Liked': FieldValue.arrayRemove([likedmem])
        });
      }
    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
      await tx.set(favoritesReference, {
        'Liked': [likedmem]
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('Error: $error');
    return false;
  });
}
