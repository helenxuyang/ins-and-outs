import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomCard extends StatelessWidget{
  final DocumentSnapshot doc;
  final DateTime dateTime;
  final List<String> symptoms;
  final String note;

  SymptomCard.fromDoc(this.doc) :
        dateTime = DateTime(doc['year'], doc['month'], doc['day'], doc['hour'], doc['day']),
        symptoms = List.from(doc['symptoms']),
        note = doc['notes'];

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.only(left: 16, bottom: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children: [
                      Text('symptoms',
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
                Wrap(
                  children: symptoms.map((symptom) => Container(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                        child: Text(symptom, style: Theme.of(context).textTheme.bodyText1),
                      )
                  )
                  ).toList(),
                  spacing: 10,
                  runSpacing: 8,
                ),
                if (note.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Notes: ' + note, style: Theme.of(context).textTheme.bodyText1),
                  )
              ]
          ),
        )
    );
  }
}

