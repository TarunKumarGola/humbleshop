import 'package:flutter/material.dart';
import 'package:shop_app/screens/productlist/productlist.dart';

class MenClothingBrands extends StatefulWidget {
  @override
  _MenClothingBrandsState createState() => _MenClothingBrandsState();
}

class _MenClothingBrandsState extends State<MenClothingBrands> {
  String brand = null;
  String _ctype = null;
  List _type = [
    'All',
    'Ethnic Wear',
    'T-Shirts',
    'Body Shape',
    'Jackets',
    'Jeans',
    'Indian',
    'Shirts',
    'Tuxedo',
    'Kargo Pants',
    'Track Pants'
  ];
  List _smartphonebrands = [
    'Peter england',
    'Raymond',
    'Louis Phillips',
    'Levis',
    'Lee'
  ];
  List _price = [
    "1000 - 2000",
    "2000 - 5000",
    "5000 - 10000",
    "10000 - 15000",
    "15000 and above"
  ];
  String startprice;
  String endprice;
  String _selectedprice = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(
            "Men's Wears",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white),
                child: DropdownButton(
                  hint: Text('Select Brand'),
                  elevation: 5,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36.0,
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                  value: brand,
                  dropdownColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      brand = value;
                    });
                  },
                  items: _smartphonebrands.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            /*
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white),
                child: DropdownButton(
                  hint: Text('Select Price Range'),
                  elevation: 5,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36.0,
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                  value: _selectedprice,
                  dropdownColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _selectedprice = value;
                    });
                  },
                  items: _price.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),*/
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white),
                child: DropdownButton(
                  hint: Text('Select Men Wear Type'),
                  elevation: 5,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36.0,
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                  value: _ctype,
                  dropdownColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _ctype = value;
                    });
                  },
                  items: _type.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "Continue To Product List",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.pinkAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink,
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.pink),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductList(
                              brand, startprice, endprice, "Men Clothing")));
                },
              ),
            ),
          ],
        ));
  }
}
