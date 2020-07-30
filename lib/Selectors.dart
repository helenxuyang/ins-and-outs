import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelections extends StatefulWidget {
  DateTimeSelections(this.setterCallback);

  final Function setterCallback;

  @override
  _DateTimeSelectionsState createState() => _DateTimeSelectionsState();
}

class _DateTimeSelectionsState extends State<DateTimeSelections> {
  DateTime date;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text('DATE & TIME', style: Theme.of(context).textTheme.subtitle1),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  padding: EdgeInsets.only(left: 0),
                  child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 8),
                        Text(
                            DateFormat('E').format(date) + '. ' + DateFormat('MMMMd').format(date),
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                        Icon(Icons.arrow_drop_down),
                      ]
                  ),
                  onPressed: () async {
                    DateTime today = DateTime.now();
                    DateTime first = today.subtract(Duration(days: 14));
                    final DateTime selection = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: first,
                        lastDate: today
                    );
                    if (selection != null) {
                      date = selection;
                      widget.setterCallback(selection, time);
                    }
                  }
                ),
                FlatButton(
                  padding: EdgeInsets.only(left: 0),
                  child: Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 8),
                        Text(
                            DateFormat('jm').format(DateTime(1, 1, 1, time.hour, time.minute)),
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                        Icon(Icons.arrow_drop_down)
                      ]
                  ),
                  onPressed: () async {
                    final TimeOfDay selection = await showTimePicker(
                        context: context,
                        initialTime: time
                    );
                    if (selection != null) {
                      time = selection;
                      widget.setterCallback(date, selection);
                    }
                  },
                )
              ]
          ),
        ]
    );
  }
}

class Option {
  Option(this.name);
  String name;
  bool selected = false;
}

class OptionSelection extends StatefulWidget {
  OptionSelection(this.select, this.options, this.optionBuilder, this.crossAxisCount);
  final Function select;
  final List<Option> options;
  final Function optionBuilder;
  final int crossAxisCount;
  _OptionSelectionState createState() => _OptionSelectionState();
}

class _OptionSelectionState extends State<OptionSelection> {
  Option selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options[0];
    selectedOption.selected = true;
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.crossAxisCount),
      children: widget.options.map((option) {
        return GestureDetector(
          child: widget.optionBuilder(option),
          onTap: () {
            setState(() {
              widget.options.forEach((element) => element.selected = false);
              option.selected = true;
              widget.select(option.name);
            });
          },
        );
      }).toList(),
    );
  }
}

