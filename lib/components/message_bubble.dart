import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/NetworkController.dart';


class MessageBubble extends StatelessWidget {
  MessageBubble(this.sentTo, this.text, this.isCurrentUser);

  final String sentTo;
  final String text;
  final bool isCurrentUser;

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
      child: InkWell(
        onLongPress: () async{
          if(!isCurrentUser){
            bool isFriends = await Provider.of<Network_Controller>(context,listen: false).isAlreadyFriends(loggedInUser.displayName, sentTo);
            if(isFriends){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.lightBlue[100],
                duration: const Duration(milliseconds: 1500),
                content: Text("You and $sentTo is already friends." , style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
              ));
              return;
            }
            try {
              showModalBottomSheet(context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading:Icon(Icons.person_add),
                      title: Text('Send friend request'),
                      onTap: () async{

                        Provider.of<Network_Controller>(context, listen: false).SendFriendRequest(sentTo);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            } catch (e, s) {
              print(s);
            }
          }
        },
        child: Column(
          crossAxisAlignment: changeAlignment(isCurrentUser),
          children: [
            Text(
              sentTo,
              style: TextStyle(
                fontSize: 15.0,
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
      ),
    );
  }
}