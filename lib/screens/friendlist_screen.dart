import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/NetworkController.dart';
import 'package:flash_chat/components/friend_list_related.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _fireStore = FirebaseFirestore.instance;
TextEditingController countEditingController = TextEditingController();

class FriendListScreen extends StatefulWidget {
  static const String route = "friendlist_screen";

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  var networkProviderRef;
  List<dynamic> incomingFriendRequests = [];

  @override
  void initState() {
    super.initState();
    networkProviderRef =
        Provider.of<Network_Controller>(context, listen: false);
    networkProviderRef.getIncomingFriendRequests(loggedInUser.displayName);


  }

  List<Widget> createFriendListObject(AsyncSnapshot<dynamic> snapshot) {
    List<Widget> FriendListWidgets = [];

    Widget SizedBoxForCleanUI = SizedBox(
      height: 5.0,
    );
    FriendListWidgets.add(SizedBoxForCleanUI);
    for (var i = 0; i < snapshot.data.length; i++) {
      var friendTile = FriendCard(snapshot.data[i]);
      FriendListWidgets.add(friendTile);
      FriendListWidgets.add(SizedBoxForCleanUI);
    }
    if (snapshot.data.length <= 0) {
      print('NO FRIENDS FOUND ========');
    }
    return FriendListWidgets;
  }

  Future<List<Widget>> createFriendRequestList() async {
    incomingFriendRequests = await networkProviderRef
        .getIncomingFriendRequests(loggedInUser.displayName);

    List<Widget> friendRequestsWidgetList = [];
    friendRequestsWidgetList.add(Text('Friend Requests',
        style: TextStyle(fontSize: 20.0, color: Colors.white)));

    for (var req in incomingFriendRequests) {
      var incomingReqTile = IncomingFriendReqTile(req);
     // networkProviderRef.friendReqCountChanger('increment');
      friendRequestsWidgetList.add(incomingReqTile);
    }
    return friendRequestsWidgetList;
  }

  void xdddd(){}
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState((){

    });
  }

  @override
  Widget build(BuildContext context) {
    //int requestCount= 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Friends',
            style: TextStyle(fontSize: 20.0, color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () async {
                    var list = await createFriendRequestList();
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              color: Colors.black.withOpacity(0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: list,
                              ),
                            )).then((_) => setState((){}));
                  },
                  icon: Icon(
                    Icons.person_add,
                    size: 30.0,
                  )),
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
                    context.watch<Network_Controller>().friendReqCount.toString(),
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
      body: SafeArea(
          child: FutureBuilder<dynamic>(
        future: networkProviderRef.getFriendList(loggedInUser.displayName),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            //getting friend list via local method which gives me a list of Widget;
            var friendList = createFriendListObject(snapshot);
            return Column(
              children: friendList,
            );
          } else if (snapshot.hasError) {
            return Text('There is an error, which is ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      )
          ),
    );
  }
}
