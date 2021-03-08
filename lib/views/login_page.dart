import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _onSubmit(AuthData authData) async {
    setState(() => isLoading = true);
    try {
      if (authData.isSignIn) {
        await _auth.signInWithEmailAndPassword(
          email: authData.user.email,
          password: authData.user.password,
        );
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
          email: authData.user.email,
          password: authData.user.password,
        );

        final ref = FirebaseStorage.instance.ref().child('profile_images').child(authResult.user.uid + '.jpg');
        await ref.putFile(authData.user.avatarImage).whenComplete(() => null);
        final imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set(
          {
            'name': authData.user.name,
            'email': authData.user.email,
            'imageUrl': imageUrl,
          },
        );
      }
    } catch (error) {
      print(error);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AuthForm(_onSubmit),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
