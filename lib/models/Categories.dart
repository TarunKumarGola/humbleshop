import 'package:flutter/material.dart';

class Category {
  final String image, title;
  final int price, size, id;
  final Color color;
  Category({
    this.id,
    this.image,
    this.title,
    this.price,
    //this.description,
    this.size,
    this.color,
  });
}

List<Category> category = [
  Category(
      id: 1,
      title: "Toys",
      price: 234,
      size: 12,
      // description: dummyText,
      image: "assets/images/babytoy.png",
      color: Color(0xFF3D82AE)),
  Category(
      id: 2,
      title: "Home & Kitchen",
      price: 234,
      size: 8,
      //description: dummyText,
      image: "assets/images/homeandkitchen.png",
      color: Color(0xFFD3A984)),
  Category(
      id: 3,
      title: "Medicines",
      price: 234,
      size: 10,
      // description: dummyText,
      image: "assets/images/medicines.png",
      color: Color(0xFF989493)),
  Category(
      id: 4,
      title: "Men Clothing",
      price: 234,
      size: 11,
      // description: dummyText,
      image: "assets/images/menclothing.png",
      color: Color(0xFFE6B398)),
  Category(
      id: 5,
      title: "Women Clothing",
      price: 234,
      size: 12,
      // description: dummyText,
      image: "assets/images/womenclothing.png",
      color: Color(0xFFFB7883)),
  Category(
    id: 6,
    title: "Mobile & Accessories",
    price: 234,
    size: 12,
    //description: dummyText,
    image: "assets/images/mobileaccessories.png",
    color: Colors.black, //Color(0xFFAEAEAE),
  ),
];
