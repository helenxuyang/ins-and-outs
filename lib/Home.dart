import 'package:flutter/material.dart';
import 'Today.dart';
import 'Profile.dart';
import 'FoodsPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int TODAY = 0;
  static const int FOODS = 1;
  static const int HISTORY = 2;
  static const int DATA = 3;
  static const int PROFILE = 4;
  int _selectedIndex = 0;

  Widget getPage(BuildContext context, int selection) {
    switch (_selectedIndex) {
      case TODAY: return TodayPage();
      case FOODS: return FoodsPage();
      case PROFILE: return ProfilePage();
      default: return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: getPage(context, _selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
              BottomNavigationBarItem(icon: Icon(Icons.restaurant), title: Text('Foods')),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text('History')),
              BottomNavigationBarItem(icon: Icon(Icons.insert_chart), title: Text('Data')),
              BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile'))
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            }
        ),
      ),
    );
  }
}
