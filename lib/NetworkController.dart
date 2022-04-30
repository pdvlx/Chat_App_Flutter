import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Network_Controller {


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



  }
}


