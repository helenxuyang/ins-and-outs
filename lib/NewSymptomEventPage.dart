import 'package:flutter/material.dart';
import 'Selectors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Providers.dart';
import 'package:provider/provider.dart';

class SymptomChip extends StatefulWidget {
  SymptomChip(this.name, this.callback);
  final String name;
  final Function callback;

  @override
  _SymptomChipState createState() => _SymptomChipState();
}

class _SymptomChipState extends State<SymptomChip> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.name),
      selectedColor: Colors.blue,
      showCheckmark: false,
      labelStyle: TextStyle(fontSize: 16, color: selected ? Colors.white : Colors.black),
      selected: selected,
      onSelected: (newBool) {
        selected = newBool;
        widget.callback(widget.name, selected);
      },
    );
  }
}

class NewSymptomEventPage extends StatefulWidget {
  @override
  _NewSymptomEventPageState createState() => _NewSymptomEventPageState();
}

class _NewSymptomEventPageState extends State<NewSymptomEventPage> {
  DateTime selectedDateAndTime;
  List<String> symptomNames = ['pain', 'cramps', 'bloating', 'gassy', 'nausea', 'vomiting'];
  List<String> selectedSymptoms = [];
  String notes = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDateAndTime = DateTime.now();
  }

  void toggleChip(String symptom, bool selected) {
    if (selected) {
      setState(() {
        selectedSymptoms.add(symptom);
      });
    }
    else {
      setState(() {
        selectedSymptoms.remove(symptom);
      });
    }
  }

  void setDateAndTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDateAndTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void addSymptomEvent(String userID, DateTime dateTime, List<String> symptoms, String notes) async {
    CollectionReference mealsCollection = Firestore.instance
        .collection('users')
        .document(userID)
        .collection('symptomEvents');
    await mealsCollection.add({
      'year': dateTime.year,
      'month': dateTime.month,
      'day': dateTime.day,
      'hour': dateTime.hour,
      'minute': dateTime.minute,
      'symptoms': symptoms,
      'notes': notes
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title: Text('Pain/Symptoms'),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    padding: EdgeInsets.only(right: 8),
                      icon: Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        if (selectedSymptoms.isEmpty) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Select at least 1 symptom.')
                              )
                          );
                        }
                        else {
                          String userID = Provider.of<CurrentUserInfo>(context, listen: false).id;
                          addSymptomEvent(userID, selectedDateAndTime, selectedSymptoms, notes);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }
                  );
                },
              )
            ]
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
              children: [
                DateTimeSelections(setDateAndTime),
                Divider(),
                Text('SYMPTOMS', style: Theme.of(context).textTheme.subtitle1),
                Wrap(
                  children: symptomNames.map((str) => SymptomChip(str, toggleChip)).toList(),
                  spacing: 8,
                  runSpacing: -4,
                ),
                FlatButton(
                  child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Create new symptom')
                      ]
                  ),
                  onPressed: () async {
                    String newSymptom;
                    TextEditingController dialogController = TextEditingController();
                    showDialog(
                        context: context,
                        child: AlertDialog(
                            content: TextField(
                              controller: dialogController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'New symptom'
                              ),
                              onChanged: (String input) {
                                newSymptom = input;
                              },
                            ),
                            actions: [
                              FlatButton(
                                child: Text('CANCEL'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              FlatButton(
                                child: Text('CREATE'),
                                onPressed: () {
                                  //TODO: connect to backend
                                  setState(() {
                                    symptomNames.add(newSymptom);
                                    //TODO: figure out how to select properly
                                    //selectedSymptoms.add(newSymptom);
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            ]
                        )
                    );
                  },
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text('NOTES', style: Theme.of(context).textTheme.subtitle1),
                ),
                TextField(
                  scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'e.g. pain location, symptom severity, duration, etc.',
                      hintMaxLines: 3
                  ),
                  onChanged: (input) {
                    notes = input;
                  },
                )
              ]
          ),
        )
    );
  }
}