import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
import 'Providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        child: MaterialApp(
          title: 'Stomach Tracker',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'NotoSans',
              textTheme: TextTheme(
                  subtitle1: TextStyle(
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                  ),
                  subtitle2: TextStyle(
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[700]
                  ),
                  bodyText1: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 16
                  ),
              )
          ),
          home: LoginPage(),
        ),
        create: (context) => CurrentUserInfo()
    );
  }
}


