import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/friendlist_screen.dart';
import 'package:flash_chat/screens/private_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/NetworkController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => Network_Controller(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: WelcomeScreen.route,
        routes: {
          WelcomeScreen.route: (context) => WelcomeScreen(),
          LoginScreen.route: (context) => LoginScreen(),
          RegistrationScreen.route: (context) => RegistrationScreen(),
          ChatScreen.route: (context) => ChatScreen(),
          FriendListScreen.route: (context) => FriendListScreen(),
         // PrivateChatScreen.route: (context) => PrivateChatScreen(),
        },
      ),
    );
  }
}
