import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';

class CurrentUserInfo with ChangeNotifier{
  String id;

  void setID(String id) {
    this.id = id;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;
    bool isSignedIn = await _googleSignIn.isSignedIn();

    if (isSignedIn) {
      user = await _auth.currentUser();
    }
    else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential cred = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      user = (await _auth.signInWithCredential(cred)).user;
    }
    return user;
  }

  void signIn(BuildContext context) async {
    //TODO: finish sign in for multiple users
    FirebaseUser user = await _handleSignIn();
    setID(user.uid);
    if (user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
    else {
      Firestore.instance.collection('users').document(user.uid).setData({'email': user.email});
    }
  }

  Future<void> signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
  }
}

