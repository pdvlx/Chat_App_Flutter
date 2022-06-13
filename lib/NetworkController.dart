import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Network_Controller extends ChangeNotifier{
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var uuid = Uuid();
  int friendReqCount=0;

  void friendReqCountChanger(String operation) {
      if(operation=='increment'){
        this.friendReqCount++;
        print('incremented and count is $friendReqCount');
        notifyListeners();
      }else if(operation=='decrement'){
        this.friendReqCount--;
        print('decremented and count is $friendReqCount');
        notifyListeners();
      }
  }

  Future<dynamic> getFriendList(String userDisplayName) async{

    var collection = FirebaseFirestore.instance.collection('${userDisplayName}_user_data');
    var querySnapshot = await collection.get();
    var friends;
    final user_data = querySnapshot.docs;
    if (user_data.isNotEmpty) {
      friends = user_data.first.get('friends');
    }
    return friends;

  }
  Future<dynamic> getIncomingFriendRequests(String userDisplayName) async{

    var collection = FirebaseFirestore.instance.collection('${userDisplayName}_user_data');
    var querySnapshot = await collection.get();
    var friendRequests;
    final user_data = querySnapshot.docs;
    if (user_data.isNotEmpty) {
      friendRequests = user_data.first.get('incoming_friend_requests');
    }

    if(this.friendReqCount == 0){
      for(var req in friendRequests){
        this.friendReqCount++;
      }
      notifyListeners();
    }

    return friendRequests;

  }
  Future<bool> isAlreadyFriends(String userDisplayName ,String sentToDisplayName )async{
    var friendlist = await getFriendList(userDisplayName);
    if(friendlist.contains(sentToDisplayName)){
      return true;
    }
    return false;
  }


    Future<String> getDocumentRef (String userDisplayName) async{

    var collection = FirebaseFirestore.instance.collection('${userDisplayName}_user_data');
    var querySnapshot = await collection.get();

    var docRef;

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      docRef = data['id'];
    }
    return docRef;
  }
  void AddFriend(String SenderUsername, String ReceiverUsername) async {

    bool isFriends = await isAlreadyFriends(SenderUsername,ReceiverUsername);
    if(isFriends){
      return;
    }
     var senderDocref = await  getDocumentRef(SenderUsername);
     var receiverDocref = await  getDocumentRef(ReceiverUsername);

    await FirebaseFirestore.instance.collection('${SenderUsername}_user_data').doc(senderDocref).update(
        {
          'friends': FieldValue.arrayUnion([ReceiverUsername]),
          'sent_friend_requests' : FieldValue.arrayRemove([ReceiverUsername])
        });
     await FirebaseFirestore.instance.collection('${ReceiverUsername}_user_data').doc(receiverDocref).update(
         {
           'friends': FieldValue.arrayUnion([SenderUsername]),
           'incoming_friend_requests' : FieldValue.arrayRemove([SenderUsername])
         });

     await CreatePrivateSessionBetween(SenderUsername, ReceiverUsername);
  }


  Future<String> GetPrivateSessionId(String currentUser, String UsersFriend) async{


    //users private session collection.
    var private_session_id;

    var currentUsersCollection = FirebaseFirestore.instance.collection('${currentUser}_user_data');
    var currentUserQuerySnapshot = await currentUsersCollection.get();

    var currentUsersPrivateSessions;

    for (var queryDocumentSnapshot in currentUserQuerySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      currentUsersPrivateSessions = data['private_conversations'];
    }


    // Users friends private session collection.
    var FriendsCollection = FirebaseFirestore.instance.collection('${UsersFriend}_user_data');
    var FriendsQuerySnapshot = await FriendsCollection.get();

    var friendsPrivateSessions;

    for (var queryDocumentSnapshot in FriendsQuerySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      friendsPrivateSessions = data['private_conversations'];
    }

    for(var sessionid in currentUsersPrivateSessions){
      if(friendsPrivateSessions.contains(sessionid)){
        private_session_id = sessionid;
        print('foundit it is $private_session_id');
        return private_session_id;
      }
    }
  }

  // THIS IS SEPERATED BECAUSE IN THE LATER WE MAYBE WILL ADD ENCRYPTION TO SESSIONS OR/AND MESSAGES.
  void CreatePrivateSessionBetween(String SenderUsername, String ReceiverUsername) async {
    var senderDocref = await  getDocumentRef(SenderUsername);
    var receiverDocref = await  getDocumentRef(ReceiverUsername);
    var session_id = uuid.v1();
    print(session_id);

    await FirebaseFirestore.instance.collection('${SenderUsername}_user_data').doc(senderDocref).update(
        {
          'private_conversations': FieldValue.arrayUnion([session_id]),
        });
    await FirebaseFirestore.instance.collection('${ReceiverUsername}_user_data').doc(receiverDocref).update(
        {
          'private_conversations': FieldValue.arrayUnion([session_id]),
        });
    _fireStore.collection('$session_id').add({

    });
  }
  void SendFriendRequest(String sentTo) async{
    var loggedInUser = await getCurrentUser();
    var SenderDocRef = await getDocumentRef(loggedInUser.displayName);
    var ReceiverDocRef = await getDocumentRef(sentTo);

    await FirebaseFirestore.instance.collection('${loggedInUser.displayName}_user_data').doc(SenderDocRef).update(
        {
          'sent_friend_requests': FieldValue.arrayUnion([sentTo])
        });
    await FirebaseFirestore.instance.collection('${sentTo}_user_data').doc(ReceiverDocRef).update(
        {
          'incoming_friend_requests': FieldValue.arrayUnion([loggedInUser.displayName])
        });

    print('request sended to $sentTo');
  }
  Future<User> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return user;
      }
    } on Exception catch (e) {
      print(e);
    }
  }


}


