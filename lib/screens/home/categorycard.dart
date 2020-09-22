import 'package:flutter/material.dart';
import 'package:shop_app/models/Categories.dart';

class CategoryCard extends StatelessWidget {
  static const kDefaultPaddin = 20.0;
  static const kTextColor = Color(0xFF535353);
  static const kTextLightColor = Color(0xFFACACAC);
  final Category category;
  final Function press;
  const CategoryCard({
    Key key,
    this.category,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              //height: 80,
              ///width: 90,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${category.id}",
                child: Image.asset(category.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              category.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
        ],
      ),
    );
  }
}
