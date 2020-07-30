import 'dart:collection';
import 'Food.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';
import 'NewFoodPage.dart';

class PaddedSubtitle extends StatelessWidget {
  final String text;
  PaddedSubtitle(this.text);
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 16, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.subtitle1)
    );
  }
}

class AddFoodPage extends StatelessWidget {
  final Function add;
  AddFoodPage(this.add);

  Widget buildFoodSelection(BuildContext context, snapshot, index) {
    String userID = Provider.of<CurrentUserInfo>(context).id;
    String name = snapshot.data.documents[index]['name'];
    return FutureBuilder(
      future: Food.fetchIcon(userID, name),
      builder: (context, iconSnapshot) {
        if (!iconSnapshot.hasData) return Container();
        String icon = iconSnapshot.data;
        return InkWell(
          child: FoodRow(Food(name, icon)),
          onTap: () {
            add(Food(name, icon));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String userID = Provider.of<CurrentUserInfo>(context).id;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: Text('Add Food'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
          ),
          body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  children: [
                    FutureBuilder(
                      future: Food.fetchFoods(userID),
                      builder: (context, AsyncSnapshot<List<Food>> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        List<Food> foods = snapshot.data;
                        Map<String, String> foodIcons = Map.fromIterables(
                            foods.map((food) => food.name),
                            foods.map((food) => food.iconName)
                        );
                        return SearchWidget<String>(
                            dataList: snapshot.data.map((food) => food.name).toList(),
                            textFieldBuilder: (controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter the food name...'
                                ),
                                onSubmitted: (name) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFoodPage(name)));
                                  //TODO: fix so that this also adds food to the meal
                                },
                              );
                            },
                            onItemSelected: (foodName) {
                              add(Food(foodName, foodIcons[foodName]));
                              Navigator.pop(context);
                            },
                            popupListItemBuilder: (foodName) {
                              return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: FoodRow(Food(foodName, foodIcons[foodName]))
                              );
                            },
                            queryBuilder: (String query, List<String> list) {
                              String lowercaseQuery = query.toLowerCase();
                              List<String> starts = list.where((String food) => food.toLowerCase().startsWith(lowercaseQuery)).toList();
                              List<String> contains = list.where((String food) => food.toLowerCase().contains(lowercaseQuery)).toList();
                              List<String> noDups = LinkedHashSet<String>.from(starts + contains).toList();
                              return noDups;
                            },
                            selectedItemBuilder: (String selection, VoidCallback deleteSelectedItem) {
                              return Container();
                            },
                            noItemsFoundWidget: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('''No foods found, press enter to create and add a food with this name.''')
                            )
                        );
                      },
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Text('Recently eaten:', style: Theme.of(context).textTheme.subtitle1),
                        )
                    ),
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(userID)
                          .collection('recentFoods')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (!snapshot.hasData) return CircularProgressIndicator();
                              return buildFoodSelection(context, snapshot, index);
                            }
                        );
                      },
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 24, bottom: 16),
                          child: Text('Favorites:', style: Theme.of(context).textTheme.subtitle1),
                        )
                    ),
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(userID)
                          .collection('favoriteFoods')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (!snapshot.hasData) return CircularProgressIndicator();
                              return buildFoodSelection(context, snapshot, index);
                            }
                        );
                      },
                    )
                  ]
              )
          )
      ),
    );
  }
}

