import 'package:flutter/material.dart';
import 'package:shop_app/screens/productlist/productlist.dart';

class KitchenBrands extends StatefulWidget {
  @override
  _KitchenBrandsState createState() => _KitchenBrandsState();
}

class _KitchenBrandsState extends State<KitchenBrands> {
  String brand = null;
  List _smartphonebrands = ['Apple', 'OnePlus', 'Realme', 'Samsung'];
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
            'Home & Kitchen',
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
                      if (_selectedprice == "1000 - 2000") {
                        startprice = "1000";
                        endprice = "2000";
                      } else if (_selectedprice == "2000 - 5000") {
                        startprice = "2000";
                        endprice = "5000";
                      } else if (_selectedprice == "5000 - 10000") {
                        startprice = "5000";
                        endprice = "10000";
                      } else if (_selectedprice == "10000 - 15000") {
                        startprice = "10000";
                        endprice = "15000";
                      } else if (_selectedprice == "15000 and above") {
                        startprice = "15000";
                        endprice = "100000";
                      }
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
            ),*/
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
                              brand, startprice, endprice, "Home & Kitchen")));
                },
              ),
            ),
          ],
        ));
  }
}
