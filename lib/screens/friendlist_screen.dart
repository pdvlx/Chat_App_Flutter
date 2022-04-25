import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';


final _fireStore = FirebaseFirestore.instance;


class FriendListScreen extends StatefulWidget {
  static const String route = "friendlist_screen";

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  final _auth = FirebaseAuth.instance;



  // void getCurrentUser() async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       loggedInUser = user;
  //       print(loggedInUser.email);
  //     }
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _fireStore
              .collection('${loggedInUser.displayName}_friends')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              final friends = snapshot.data.docs;

              if(friends.isNotEmpty){
                List<Widget> messageWidgets = [];
                for (var friend in friends) {
                  // final messageText = message.get('text');
                  // final messageSender = message.get('sender');
                  // final currentUser = loggedInUser.email;

                  // final messageWidget = MessageBubble(
                  //     messageSender, messageText, currentUser == messageSender);
                  // messageWidgets.add(messageWidget);
                }
                return ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: [Text('Data var hala lmao'),
                  ],
                );
              }
              else{
                return Center(
                  child: Text('You dont have any friends.',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[800],
                    ),),
                  // child: CircularProgressIndicator(
                  //   backgroundColor: Colors.lightBlueAccent,
                  // ),
                );
              }

            } else
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
          },
        ),
      ),
    );
  }
}
