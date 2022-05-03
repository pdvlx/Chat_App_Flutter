import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Network_Controller {
  final _fireStore = FirebaseFirestore.instance;
  var uuid = Uuid();

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

  // PROJECT DONT USE SESSION ID METHODS YET. I WILL ADD THESE FOR SECURITY REASONS LATER.

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
}


