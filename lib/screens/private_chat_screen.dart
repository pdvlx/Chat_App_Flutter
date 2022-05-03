import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import 'chat_screen.dart';


final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class PrivateChatScreen extends StatelessWidget {
  PrivateChatScreen(this.friendUsername , this.session_id);
  final String friendUsername;
  final String session_id;

  static const String route = "private_chat_screen";
  final messageTextController = TextEditingController();
  String messageText;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('$friendUsername',),
        automaticallyImplyLeading:false,
        leading: null,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(session_id),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {

                      print(messageText);
                      messageTextController.clear();
                      _fireStore.collection('$session_id').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'username': loggedInUser.displayName,
                        'createdAt': Timestamp.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessagesStream extends StatelessWidget {

  MessagesStream(this.sessionid);
  final String sessionid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('${sessionid}')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSenderEmail = message.get('sender');
            final messageSenderUsername = message.get('username');
            final currentUserEmail = loggedInUser.email;

            final messageWidget = MessageBubble(
                messageSenderUsername, messageText, currentUserEmail == messageSenderEmail);
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageWidgets,
            ),
          );
        } else
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
      },
    );
  }
}