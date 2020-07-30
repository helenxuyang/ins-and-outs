import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';
import 'Food.dart';

class MealCard extends StatelessWidget {
  static const String breakfast = 'Breakfast';
  static const String lunch = 'Lunch';
  static const String dinner = 'Dinner';
  static const String snack = 'Snack';

  final DocumentSnapshot doc;
  final DateTime dateTime;
  final String type;
  final List<String> foodNames;

  MealCard.fromDoc(this.doc) :
        dateTime = DateTime(doc['year'], doc['month'], doc['day'], doc['hour'], doc['day']),
        type = doc['type'],
        foodNames = List.from(doc['foods']);

  @override
  Widget build(BuildContext context) {
    String userID = Provider.of<CurrentUserInfo>(context).id;
    return Card(
        child: Padding(
            padding: EdgeInsets.only(left: 16, bottom: 16),
            child: Column(
                children: [
                  Row(
                      children: [
                        Text(type,
                            style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        SizedBox(width: 16),
                        Text(DateFormat('jm').format(dateTime),
                            style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 20
                            )
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            //TODO: add edit
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await Firestore.instance.runTransaction((transaction) async {
                              await transaction.delete(doc.reference);
                            });
                          },
                        )
                      ]
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
                        Map<String, String> foodIcons = {};
                        for (DocumentSnapshot doc in snapshot.data.documents) {
                          foodIcons[doc['name']] = doc['icon'];
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: foodNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            String foodName = foodNames[index];
                            return Padding(
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              child: FoodRow(
                                  Food(foodName, foodIcons[foodName])),
                            );
                          },

                        );
                      }
                  )
                ]
            )
        )
    );
  }
}