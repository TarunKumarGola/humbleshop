import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/addtocartpage/addtocart.dart';
import 'package:shop_app/screens/cartpage/cartpage.dart';
import 'package:shop_app/screens/productscreen/productscreen.dart';

class ProductList extends StatelessWidget {
  String brand;
  String startprice;
  String endprice;
  String category;
  ProductList(
      String brand, String startprice, String endprice, String category) {
    this.brand = brand;
    this.startprice = startprice;
    this.endprice = endprice;
    this.category = category;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      width: 200,
                      child: Text(
                        "Humble Market",
                        style: TextStyle(color: Colors.white),
                      ),
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => CartPage()));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("PRODUCT")
              .where('category', isEqualTo: category)
              .where('brand', isEqualTo: brand)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.vertical,
              itemCount:
                  snapshot.data == null ? 0 : snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data == null) return Text("NO DATA");
                DocumentSnapshot ds = snapshot.data.documents[index];
                return _buildProductCard(
                    ds.data()['name'],
                    ds.data()['price'],
                    ds.data()['speciality'],
                    ds.data()['description'],
                    ds.data()['productuid'],
                    ds.data()['imageurl1'],
                    ds.data()['imageurl2'],
                    ds.data()['imageurl3'],
                    ds.data()['category'],
                    ds.data()['offer'],
                    ds.data()['videoUrl'],
                    ds.data()['likes'],
                    ds.data()['comments'],
                    ds.data()['profileImg'],
                    ds.data()['albumimg'],
                    ds.data()['shopnow'],
                    ds.data()['phonenumber'],
                    ds.data()['selleruid'],
                    ds.data()['colors'],
                    ds.data()['shares'],
                    context);
              },
            );
          }),
    );
  }

  _buildProductCard(
      String name,
      String price,
      String speciality,
      String description,
      String productuid,
      String imageurl1,
      String imageurl2,
      String imageurl3,
      String category,
      String offer,
      String videourl,
      String likes,
      String comments,
      String profileImg,
      String albumImg,
      String shopnow,
      String phonenumber,
      String selleruid,
      List<dynamic> colors,
      String shares,
      BuildContext context) {
    Product p = new Product(
        likes: likes,
        name: name,
        shares: shares,
        comments: comments,
        productuid: productuid,
        profileImg: profileImg,
        colors: colors,
        offer: offer,
        albumImg: albumImg,
        description: description,
        speciality: speciality,
        shopnow: shopnow,
        videourl: videourl,
        price: price,
        phonenumber: phonenumber,
        selleruid: selleruid,
        imageurl1: imageurl1,
        imageurl2: imageurl2,
        imageurl3: imageurl3);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: 360,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.pink,
              offset: Offset(0.0, 2.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(0),
                child: Column(children: [
                  Image(
                    image: NetworkImage(imageurl1),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '₹${price}',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ]),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddToCart(
                              product: p,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
