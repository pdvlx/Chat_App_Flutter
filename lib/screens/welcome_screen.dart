import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/padding_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String route = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  //mixin for the animation controller.
  AnimationController controller, colorAnimController;
  Animation curvedAnimation;
  @override
  void initState() {
    super.initState();
    colorAnimController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    colorAnimController.forward();
    colorAnimController.addListener(() {
      setState(() {});
    });

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curvedAnimation = ColorTween(begin: Colors.black54, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    colorAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: curvedAnimation
          .value, //Colors.white.withOpacity(colorAnimController.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value * 60,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(seconds: 1),
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      speed: const Duration(milliseconds: 250),
                      textStyle: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddingButton(LoginButtonColor, () {
              Navigator.pushNamed(context, LoginScreen.route);
            }, "Log in"),
            PaddingButton(RegisterButtonColor, () {
              Navigator.pushNamed(context, RegistrationScreen.route);
            }, "Register"),
          ],
        ),
      ),
    );
  }
}
