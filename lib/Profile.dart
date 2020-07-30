import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignOutButton();
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