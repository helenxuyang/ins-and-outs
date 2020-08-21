import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Providers.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FlutterLocalNotificationsPlugin notifsPlugin = FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings initSettingsAndroid;
  IOSInitializationSettings initSettingsIOS;
  InitializationSettings initSettings;

  @override
  void initState() {
    super.initState();
    initSettingsAndroid = AndroidInitializationSettings('app_icon');
    initSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotif
    );
    initSettings = InitializationSettings(initSettingsAndroid, initSettingsIOS);
    notifsPlugin.initialize(initSettings);
  }

  Future onDidReceiveLocalNotif(int id, String title, String body, String payload) async{
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(body)
        );
      }
    );
  }
  void _showNotif() async {
    AndroidNotificationDetails notifDetailsAndroid = AndroidNotificationDetails(
        'test', 'test', 'test',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    IOSNotificationDetails notifDetailsIOS = IOSNotificationDetails();
    NotificationDetails notifDetails = NotificationDetails(
        notifDetailsAndroid, notifDetailsIOS);
    await notifsPlugin.show(
        0, 'plain title', 'plain body', notifDetails,
        payload: 'item x'
    );
    await notifsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        DateTime.now().add(Duration(seconds: 5)),
        notifDetails
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          child: Text('Notification'),
          onPressed: () {
            _showNotif();
          },
        ),
        SignOutButton()
      ]
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