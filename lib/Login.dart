import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CurrentUserInfo userInfo = Provider.of<CurrentUserInfo>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            RaisedButton(
              child: Text('Sign in with Google'),
              onPressed: () {
                userInfo.signIn(context);
              },
            ),
            SignOutButton()
          ]
        )
      )
    );
  }
}

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentUserInfo userInfo = Provider.of<CurrentUserInfo>(context);
    return RaisedButton(
      child: Text('Sign out'),
      onPressed: () {
        userInfo.signOut();
      },
    );
  }
}
