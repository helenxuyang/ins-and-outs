import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Food.dart';
import 'Providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'NewFoodPage.dart';

class FoodsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    String userID = Provider.of<CurrentUserInfo>(context).id;
    return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(
                    'Your Foods',
                    style: TextStyle(fontFamily: 'NotoSans', fontSize: 30, fontWeight: FontWeight.bold)
                ),
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(userID)
                      .collection('foods')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data.documents[index];
                        return Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          //TODO: add option to favorite, edit, and delete
                          child: FoodRow(Food(doc['name'], doc['icon'])),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFoodPage('')));
              },
            ),
          ),
        ]
    );
  }
}