import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stomach_tracker/SymptomEvent.dart';
import 'NewEventPage.dart';
import 'Meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';

class TodayPage extends StatelessWidget {

  Widget buildSymptomCards(String userID) {
    DateTime today = DateTime.now();
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(userID)
            .collection('symptomEvents')
            .where('year', isEqualTo: today.year)
            .where('month', isEqualTo: today.month)
            .where('day', isEqualTo: today.day)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> symptomEventsSnapshot) {
          if (!symptomEventsSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: symptomEventsSnapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = symptomEventsSnapshot.data.documents[index];
              return SymptomCard.fromDoc(doc);
            },
          );
        }
    );
  }
  
  Widget buildMealCards(String userID) {
    DateTime today = DateTime.now();
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(userID)
            .collection('meals')
            .where('year', isEqualTo: today.year)
            .where('month', isEqualTo: today.month)
            .where('day', isEqualTo: today.day)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> mealsSnapshot) {
          if (!mealsSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: mealsSnapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = mealsSnapshot.data.documents[index];
              return MealCard.fromDoc(doc);
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    String userID = Provider.of<CurrentUserInfo>(context).id;
    DateTime now = DateTime.now();
    return Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListView(
              children: [
                Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        DateFormat('E').format(now) + '. ' + DateFormat('Md').format(now),
                        style: TextStyle(fontFamily: 'NotoSans', fontSize: 30, fontWeight: FontWeight.bold)
                    )
                ),
                buildMealCards(userID),
                buildSymptomCards(userID)
              ]
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventPage()));
              },
            ),
          ),
        ]
    );
  }
}
