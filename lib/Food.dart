import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  Food(this.name, this.iconName);
  String name;
  String iconName;

  //TODO: probably convert all the food backend stuff to a provider
  static Future<String> fetchIcon(String userID, String foodName) async {
    QuerySnapshot query = await Firestore.instance.collection('users').document(userID).collection('foods').where('name', isEqualTo: foodName).getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    print(docs.length);
    if (docs.isNotEmpty) return docs[0]['icon'];
    print('Food fetchIcon: defaulting to leaves');
    return 'leaves';
  }

  static Future<List<Food>> fetchFoods(String userID) async {
    QuerySnapshot query = await Firestore.instance.collection('users').document(userID).collection('foods').getDocuments();
    List<DocumentSnapshot> docs = query.documents;
    return docs.map((doc) => Food(doc['name'], doc['icon'])).toList();
  }
}

class FoodRow extends StatelessWidget {
  final Food food;

  FoodRow(this.food);
  FoodRow.fromPair(String name, String icon) :
      food = Food(name, icon);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Container(
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/icon_' + food.iconName + '.png'),
            ),
          ),
          SizedBox(width: 16),
          Text(food.name, style: Theme.of(context).textTheme.bodyText1)
        ]
    );
  }
}