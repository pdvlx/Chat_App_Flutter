import 'package:flash_chat/NetworkController.dart';
import 'package:flash_chat/screens/private_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';

final _fireStore = FirebaseFirestore.instance;


class FriendListScreen extends StatefulWidget {
  static const String route = "friendlist_screen";

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //returning all of the friends that users have.
      //backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _fireStore
              .collection('${loggedInUser.displayName}_user_data')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              final user_data = snapshot.data.docs;

              if(user_data.isNotEmpty){
                List<Widget> friendRelatedWidgets = [];
                for (var udata in user_data) {
                  final incoming_friendreq = udata.get('incoming_friend_requests');
                  final sent_friendreq = udata.get('sent_friend_requests');
                  final friends = udata.get('friends');
                  final id = udata.get('id');
                  Widget SizedBoxForCleanUI = SizedBox(height: 10.0,);
                  Widget DividerWidget = Divider(thickness: 3.0,);

                  Widget FriendsRequestWidget = Text('Friend Requests' , style: TextStyle(fontSize: 35.0 , color: Colors.green),textAlign: TextAlign.center,);
                  friendRelatedWidgets.add(FriendsRequestWidget);
                  friendRelatedWidgets.add(DividerWidget);


                  // Incoming Friend Request Array below
                  for(var i=0; i<incoming_friendreq.length ; i++){
                    final incomingReqTile = IncomingFriendReqTile(incoming_friendreq[i]);
                    friendRelatedWidgets.add(incomingReqTile);
                    friendRelatedWidgets.add(SizedBoxForCleanUI);

                  }

                  Widget FriendsTextWidget = Text('Friends' , style: TextStyle(fontSize: 35.0 , color: Colors.green),textAlign: TextAlign.center,);

                  friendRelatedWidgets.add(FriendsTextWidget);
                  friendRelatedWidgets.add(DividerWidget);

                  //  //Sent requests below
                  // for(var i=0; i<sent_friendreq.length ; i++){
                  //   final sentReqTile = FriendRequestTile(sent_friendreq[i]);
                  //   friendRelatedWidgets.add(sentReqTile);
                  //
                  // }

                  // Friend Array below
                  for(var i=0; i<friends.length ; i++){
                    final friendTile = FriendTile(friends[i]);
                    friendRelatedWidgets.add(friendTile);
                    friendRelatedWidgets.add(SizedBoxForCleanUI);
                  }
                }
                return Column(

                  children: friendRelatedWidgets,
                );
              }
              else{
                return Center(
                  child: Text('You dont have any friends.',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[800],
                    ),),
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

        //Navigator.pushNamed(context, PrivateChatScreen.route);

        print('youve tapped a friend. $friend');
      },
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white70,
        ),
        child: Text('$friend',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}

class IncomingFriendReqTile extends StatelessWidget {

  IncomingFriendReqTile(this.incoming_friend_req);
  final String incoming_friend_req;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white70,
      ),
      child: Row(
        children: [
          Text('$incoming_friend_req ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
            ),),
          SizedBox(width: 180,),
          GestureDetector(
            onTap: () async {
              await Provider.of<Network_Controller>(context,listen: false).AddFriend(incoming_friend_req, loggedInUser.displayName);
              print('friend accepted');
            },
            child: Container(
              color: Colors.green,
                child: Icon(Icons.check, color: Colors.white,size: 35.0,),),
          ),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: (){print('friend declined');},
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
