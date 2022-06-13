import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/padding_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

final _fireStore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String route = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 150.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value;
                  },
                  style: InputTextStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your username',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  style: InputTextStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  style: InputTextStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                PaddingButton(RegisterButtonColor, () async {
                  final progressBar = ProgressHUD.of(context);
                  progressBar.show();
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    await newUser.user.updateDisplayName(username);

                    if (newUser != null) {
                      DocumentReference docRef = await _fireStore
                          .collection('${username}_user_data')
                          .add({
                        'friends': [],
                        'sent_friend_requests': [],
                        'incoming_friend_requests': [],
                        'private_conversations': [],
                      });
                      String docId = docRef.id;
                      await FirebaseFirestore.instance
                          .collection('${username}_user_data')
                          .doc(docId)
                          .update({'id': docId});

                      progressBar.dismiss();
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                  } catch (e) {
                    progressBar.dismiss();
                    print(e);
                  }
                }, "Register"),
              ],
            ),
          );
        }),
      ),
    );
  }
}
