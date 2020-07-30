import 'package:flutter/material.dart';
import 'package:stomach_tracker/NewMealPage.dart';
import 'NewSymptomEventPage.dart';

class EventButton extends StatelessWidget {
  EventButton(this.text, this.icon, this.color, this.page);
  final String text;
  final String icon;
  final Color color;
  final Widget page;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8),
      child: FlatButton(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(icon, style: TextStyle(fontSize: 35)),
              SizedBox(height: 8),
              Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}

class NewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: GridView(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: <Widget>[
          //TODO: replace with actual pages
          EventButton('MEAL', '🍴', Colors.green[700], NewMealPage()),
          EventButton('PAIN/SYMPTOM', '😢', Colors.blue[800],
              NewSymptomEventPage()
          ),
          EventButton('BOWEL MOVEMENT', '🚽', Colors.brown[600], NewMealPage()),
          EventButton('MAKE A NOTE', '📝', Colors.orangeAccent[400], NewMealPage()),
        ],
      )
    );
  }
}