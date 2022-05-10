import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/private_chat_screen.dart';
import 'package:flash_chat/NetworkController.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/friendlist_screen.dart';



class FriendTile extends StatelessWidget {

  FriendTile(this.friend);
  final String friend;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{

        var private_session_id = await Provider.of<Network_Controller>(context, listen: false).GetPrivateSessionId(loggedInUser.displayName, friend);
        Navigator.push(
          context, MaterialPageRoute(builder: (context) =>  PrivateChatScreen(friend,private_session_id)),
        );
      },
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Text('$friend',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
      ),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Text('${widget.request_sender_username} ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
            ),),
          SizedBox(width: 180,),
          GestureDetector(
            onTap: () async {
              await Provider.of<Network_Controller>(context,listen: false).AddFriend(widget.request_sender_username, loggedInUser.displayName);

              setState(() {
                FriendRequestWidgets.remove(this.widget);
                //requestcount--;
              });
              print('friend accepted');
            },
            child: Container(
              color: Colors.green,
              child: Icon(Icons.check, color: Colors.white,size: 35.0,),),
          ),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: ()
            {
              FriendRequestWidgets.remove(this.widget);
              print('friend declined');
              },
            child: Container(
              color:Colors.red,
              child: Icon(Icons.close,
                color: Colors.white,
                size: 35.0,),),
          ),
        ],
      ),
    );
  }
}




// For SENT requests
// class FriendRequestTile extends StatelessWidget {
//
//   FriendRequestTile(this.requestedUser);
//   final String requestedUser;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.0),
//         color: Colors.white70,
//       ),
//       child: Text('$requestedUser <= you requested to be friend.',
//       style: TextStyle(
//         color: Colors.black54,
//         fontSize: 25.0,
//       ),),
//     );
//   }
// }