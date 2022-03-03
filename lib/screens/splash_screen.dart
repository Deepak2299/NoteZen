import 'package:flutter/material.dart';
import 'package:note_app/providers/theme_data_provider.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/screens/signin_screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'homescreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  afterSplash() {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);
    Provider.of<ThemeProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      sb.isSignedIn == true ? gotoHomePage() : gotoSignInPage();
    });
  }

  gotoHomePage() {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);
    if (sb.isSignedIn == true) {
      sb.getDataFromSp();
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
    print("home");
  }

  gotoSignInPage() {
    print("sign");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ));
  }

  @override
  void initState() {
    super.initState();
    afterSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/app_logo.png'),
      ),
    );
  }
}
