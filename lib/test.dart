import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEventPage> {
  DateTime date;

  void setDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          // other widgets for creating an event
          DateSelection(setDate)
        ]
    );
  }
}
class DateSelection extends StatefulWidget {
  DateSelection(this.callback);
  final Function callback;

  @override
  _DateSelectionState createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  DateTime date;

  Future<Null> makeDateSelector(BuildContext context, DateTime currentSelected, Function callback) async {
    DateTime today = DateTime.now();
    DateTime first = today.subtract(Duration(days: 14));
    final DateTime selection = await showDatePicker(
        context: context,
        initialDate: currentSelected,
        firstDate: first,
        lastDate: today
    );
    if (selection != null) {
      callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
          children: [
            Icon(Icons.calendar_today),
            SizedBox(width: 8),
            Text(date.toString()),
            Icon(Icons.arrow_drop_down),
          ]
      ),
      onPressed: () => makeDateSelector(context, date, widget.callback),
    );
  }
}