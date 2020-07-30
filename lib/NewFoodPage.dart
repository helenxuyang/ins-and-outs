import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';
import 'Selectors.dart';

class CreateFoodPage extends StatefulWidget {
  final String initName;
  CreateFoodPage(this.initName);
  _CreateFoodPageState createState() => _CreateFoodPageState();
}

class _CreateFoodPageState extends State<CreateFoodPage> {
  TextEditingController controller;
  String name;
  OptionSelection iconSelection;
  String selectedIcon;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = widget.initName;
    name = widget.initName;
    iconSelection = OptionSelection(_selectIcon, ['apple', 'leaves'].map((str) => Option(str)).toList(), buildIconOption, 5);
    selectedIcon = iconSelection.options[0].name;
  }

  void _selectIcon(String iconName) {
    setState(() {
      selectedIcon = iconName;
    });
  }

  Widget buildIconOption(Option option) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/icon_' + option.name + '.png'),
          ),
          decoration: option.selected ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2)
          ) : null
      ),
    );
  }

  void addFood(String userID, String name, String icon) async {
    CollectionReference mealsCollection = Firestore.instance
        .collection('users')
        .document(userID)
        .collection('foods');
    await mealsCollection.add({
      'name': name,
      'icon': icon
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text('New Food'),
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
                      child: Text('ADD',
                          style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                              color: Colors.white
                          )
                      ),
                      onPressed: () {
                        if (name == null || name.isEmpty) {
                          ScaffoldState scaffold = Scaffold.of(context);
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text('Give your food a name.'),
                            ),
                          );
                        }
                        else {
                          String userID = Provider.of<CurrentUserInfo>(context, listen: false).id;
                          addFood(userID, name, selectedIcon);
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('NAME', style: Theme.of(context).textTheme.subtitle1),
                    ),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                      onChanged: (input) {
                        setState(() {
                          name = input;
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 4),
                      child: Text('ICON', style: Theme.of(context).textTheme.subtitle1),
                    ),
                    iconSelection
                  ]
              ),
            )
        )
    );
  }
}
