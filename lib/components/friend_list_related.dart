import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/private_chat_screen.dart';
import 'package:flash_chat/NetworkController.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/friendlist_screen.dart';

class FriendCard extends StatelessWidget {
  FriendCard(this.friend);

  final String friend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      leading: CircleAvatar(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(
          Icons.photo,
          color: Colors.white,
        ),
      ),
      title: Text(
        '$friend',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
        ),
      ),
      onTap: () async {
        var private_session_id =
            await Provider.of<Network_Controller>(context, listen: false)
                .GetPrivateSessionId(loggedInUser.displayName, friend);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PrivateChatScreen(friend, private_session_id)),
        );
      },
    );
  }
}

class IncomingFriendReqTile extends StatefulWidget {
  IncomingFriendReqTile(this.request_sender_username);

  final String request_sender_username;

  @override
  State<IncomingFriendReqTile> createState() => _IncomingFriendReqTileState();
}

class _IncomingFriendReqTileState extends State<IncomingFriendReqTile> {
  @override
  Widget build(BuildContext context) {
    print('created ==================');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        //color: Colors.white,
      ),
      child: Card(
        elevation: 5,
        color: Colors.white,
        // color: Colors.lightBlue[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('images/logo.png'),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.request_sender_username} ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    Provider.of<Network_Controller>(context, listen: false)
                        .friendReqCountChanger('decrement');
                    await Provider.of<Network_Controller>(context, listen: false)
                        .AddFriend(widget.request_sender_username,
                            loggedInUser.displayName);
                    setState((){

                    });
                    Navigator.pop(context);

                    ///TODO: ADD RESPONSIVE UI FOR REQUEST REPLYS, EX= WHEN ACCEPTED REMOVE FROM THE LIST AND DECREASE THE COUNTER.
                    print('friend accepted');
                  },
                  child: Container(
                    color: Colors.white,
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 35.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    ///TODO : Add delete functuonality.
                    Provider.of<Network_Controller>(context, listen: false)
                        .friendReqCountChanger('decrement');
                    setState((){

                    });
                    Navigator.pop(context);
                    print('friend declined');
                  },
                  child: Container(
                    color: Colors.white,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 35.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
