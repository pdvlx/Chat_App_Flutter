import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/components/friend_list_related.dart';

final _fireStore = FirebaseFirestore.instance;
List<Widget> FriendRequestWidgets = [];
int requestCount= 0;


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
    //int requestCount= 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends' , style: TextStyle(fontSize: 20.0 , color: Colors.white)),
        automaticallyImplyLeading:false,
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          Stack(
            children: [
              IconButton(onPressed: (){
                showModalBottomSheet(context: context, builder: (context) => Container(
                  color: Colors.black,
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    children:FriendRequestWidgets ,
                  ),
                ));
              }, icon: Icon(Icons.person_add,size: 30.0,)),
              Positioned(
                right: 5,
                top: 25,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${requestCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
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
                List<Widget> FriendListWidgets = [];
                for (var udata in user_data) {
                  final incoming_friendreq = udata.get('incoming_friend_requests');
                  //final sent_friendreq = udata.get('sent_friend_requests');
                  final friends = udata.get('friends');
                  Widget SizedBoxForCleanUI = SizedBox(height: 10.0,);
                  requestCount = 0;
                  FriendRequestWidgets.clear();
                  FriendListWidgets.add(SizedBoxForCleanUI);

                  FriendRequestWidgets.add(Text('Friend Requests' , style: TextStyle(fontSize: 20.0 , color: Colors.white)));
                  // Incoming Friend Request Array below
                  for(var i=0; i<incoming_friendreq.length ; i++){
                    final incomingReqTile = IncomingFriendReqTile(incoming_friendreq[i]);
                    FriendRequestWidgets.add(incomingReqTile);
                  }


                  requestCount = FriendRequestWidgets.length -1;

                  print(requestCount);

                  // Friend Array below
                  for(var i=0; i<friends.length ; i++){
                    final friendTile = FriendTile(friends[i]);
                    FriendListWidgets.add(friendTile);
                    FriendListWidgets.add(SizedBoxForCleanUI);

                  }
                }
                //  //Sent requests below == NOT USING RIGHT NOW
                // for(var i=0; i<sent_friendreq.length ; i++){
                //   final sentReqTile = FriendRequestTile(sent_friendreq[i]);
                //   FriendListWidgets.add(sentReqTile);
                //
                // }
                return Column(

                  children: FriendListWidgets,
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


