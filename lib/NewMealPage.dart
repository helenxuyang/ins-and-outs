import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Food.dart';
import 'AddFoodPage.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';
import 'Selectors.dart';

class NewMealPage extends StatefulWidget {
  static double iconRadius = 25;
  _NewMealPageState createState() => _NewMealPageState();
}

class _NewMealPageState extends State<NewMealPage> {
  OptionSelection typeSelection;
  String selectedType;
  DateTime selectedDateAndTime;
  List<Food> foods;

  initState() {
    super.initState();
    typeSelection = OptionSelection(_selectType, ['breakfast', 'lunch', 'dinner', 'snack'].map((str) => Option(str)).toList(), makeTypeOption, 4);
    selectedDateAndTime = DateTime.now();
    selectedType = typeSelection.options[0].name;
    foods = [];
  }

  void _addFood(Food food) {
    setState(() {
      foods.add(food);
    });
  }

  void _selectType(String type) {
    setState(() {
      selectedType = type;
    });
  }

  void addMeal(String userID, DateTime dateTime, String type, List<Food> foods) async {
    CollectionReference mealsCollection = Firestore.instance
        .collection('users')
        .document(userID)
        .collection('meals');
    List<String> foodNames = foods.map((food) => food.name).toList();
    await mealsCollection.add({
      'year': dateTime.year,
      'month': dateTime.month,
      'day': dateTime.day,
      'hour': dateTime.hour,
      'minute': dateTime.minute,
      'type': type,
      'foods': foodNames
    });
  }

  Widget makeTypeOption(Option option) {
    return Container(
        color: option.selected ? Colors.blue[200] : Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
            CircleAvatar(radius: NewMealPage.iconRadius),
            Text(option.name)
          ],
        )
    );
  }

  void setDateAndTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDateAndTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    double padTop = 16;
    Divider div = Divider(height: padTop * 2);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('New Meal'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                Builder(
                  builder: (context) {
                    return FlatButton(
                      child: Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        if (foods.isEmpty) {
                          ScaffoldState scaffold = Scaffold.of(context);
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text('Add at least one food to create a meal.'),
                            ),
                          );
                        }
                        else {
                          String userID = Provider.of<CurrentUserInfo>(context, listen: false).id;
                          addMeal(userID, selectedDateAndTime, selectedType, foods);
                          //TODO: update list of recently eaten foods
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DateTimeSelections(setDateAndTime),
                    div,
                    Text('TYPE', style: Theme.of(context).textTheme.subtitle1),
                    Container(
                        child: typeSelection,
                        height: NewMealPage.iconRadius * 4
                    ),
                    div,
                    Text('FOODS', style: Theme.of(context).textTheme.subtitle1),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: foods.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                                children: [
                                  FoodRow(foods[index]),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        foods.removeAt(index);
                                      });
                                    },
                                  )
                                ]
                            )
                        );
                      },
                    ),
                    Align (
                        alignment: Alignment.bottomLeft,
                        child: FlatButton(
                          child: Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 6),
                                Text('ADD FOOD', style: TextStyle(fontSize: 16)),
                              ]
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddFoodPage(_addFood)));
                          },
                        )
                    )
                  ]
                ),
              )
            )
        )
    );
  }
}