import 'package:flash_chat/screens/friendlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _fireStore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String route = "chat_screen";


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.displayName);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        leading: null,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              print(loggedInUser);
              //Navigator.pushNamed(context, FriendListScreen.route);
              print('add friend functionality');
            },
            icon: Icon(Icons.person_add,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, FriendListScreen.route);
            },
            icon: Icon(Icons.new_label,
              color: Colors.white,),
          ),
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.red[600],
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
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
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = loggedInUser.email;

            final messageWidget = MessageBubble(
                messageSender, messageText, currentUser == messageSender);
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

class MessageBubble extends StatelessWidget {
  MessageBubble(this.sender, this.text, this.isCurrentUser);

  final String sender;
  final String text;
  final bool isCurrentUser;

  //Color messageColor;

  Color changeColorMessages(bool isMe) {
    if (isMe) {
      return kCurrentUserMessageColor;
    } else
      return kOtherUserMessageColor;
  }

  CrossAxisAlignment changeAlignment(bool isMe) {
    if (isMe) {
      return CrossAxisAlignment.end;
    } else
      return CrossAxisAlignment.start;
  }

  BorderRadius changeBorderRadius(bool isMe) {
    if (isMe) {
      return BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0));
    } else
      return BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: changeAlignment(isCurrentUser),
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.blueGrey,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: changeBorderRadius(isCurrentUser),
            color: changeColorMessages(isCurrentUser),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
