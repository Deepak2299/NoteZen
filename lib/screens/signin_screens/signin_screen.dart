import 'package:flutter/material.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/screens/homescreen.dart';
import 'package:note_app/screens/signin_screens/forget_password.dart';
import 'package:note_app/screens/signin_screens/signup_screen.dart';
import 'package:note_app/utils/constants.dart';
import 'package:note_app/utils/snackbar.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isObscure = true;
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  final _key = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    emailController.clear();
    pwdController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Form(
            key: _key,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/app_icon.png',
//            scale: 3,
                  height: 200,
                  width: 100,
                ),
                Center(
                  child: Text(
                    'NoteZen',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: inputTextDecorationWithLabel('Email', context),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Theme.of(context)
                      .appBarTheme
                      .iconTheme
                      .color
                      .withOpacity(0.8),
                  controller: emailController,
                  validator: (value) {
                    value = value.trim();
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) return null;
                    return 'Enter valid email address';
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: isObscure,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Theme.of(context).appBarTheme.iconTheme.color,
                          fontSize: 20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .appBarTheme
                                .iconTheme
                                .color
                                .withOpacity(0.8),
                            width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .appBarTheme
                                .iconTheme
                                .color
                                .withOpacity(0.8),
                            width: 1),
                      ),
                      focusColor: Theme.of(context)
                          .appBarTheme
                          .iconTheme
                          .color
                          .withOpacity(0.8),
                      fillColor: Theme.of(context)
                          .appBarTheme
                          .iconTheme
                          .color
                          .withOpacity(0.8),
                      suffixIcon: IconButton(
                          icon: Icon(
                            isObscure
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            color: Theme.of(context)
                                .appBarTheme
                                .iconTheme
                                .color
                                .withOpacity(0.8),
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          })),
//            keyboardType: TextInputType.,
                  cursorColor: Theme.of(context)
                      .appBarTheme
                      .iconTheme
                      .color
                      .withOpacity(0.8),

                  controller: pwdController,
                  validator: (value) {
                    value = value.trim();
                    if (value.length >= 6) return null;
                    return 'Password cannot less than 6 characters';
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ));
                    },
                    child: Text(
                      "Forget password?",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.grey.shade200,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_key.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      final SignInProvider sb =
                          Provider.of<SignInProvider>(context, listen: false);
                      sb
                          .signInwithEmailPassword(emailController.text.trim(),
                              pwdController.text.trim())
                          .then((_) async {
                        if (sb.hasError == false) {
                          sb
                              .getUserDatafromFirebase(sb.uid)
//                          .then((value) => sb.guestSignout())
                              .then((value) => sb
                                  .saveDataToSP()
                                  .then((value) => sb.setSignIn().then((value) {
                                        setState(() {
                                          loading = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(),
                                            ));
                                      })));
                        } else {
                          setState(() {
                            loading = false;
                          });
                          openSnacbar(_scaffoldKey, sb.errorCode);
                        }
                      });
                    }
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                RaisedButton(
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.grey.shade200,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                            fullscreenDialog: true));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
//            mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context)
                              .appBarTheme
                              .iconTheme
                              .color
                              .withOpacity(0.8),
                        ),
                      ),
                      Text('  with social media  '),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context)
                              .appBarTheme
                              .iconTheme
                              .color
                              .withOpacity(0.8),
                        ),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  elevation: 5,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    final SignInProvider sb =
                        Provider.of<SignInProvider>(context, listen: false);
                    await sb.signInWithGoogle().then((_) {
                      if (sb.hasError == true) {
                        setState(() {
                          loading = false;
                        });
                        openSnacbar(_scaffoldKey,
                            'something is wrong. please try again.');
                      } else {
                        sb.checkUserExists().then((value) {
                          if (value == true) {
                            sb
                                .getUserDatafromFirebase(sb.uid)
//                            .then((value) => sb.guestSignout())
                                .then((value) => sb.saveDataToSP().then(
                                    (value) => sb.setSignIn().then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(),
                                              ));
                                        })));
                          } else {
                            sb.getTimestamp().then((value) => sb
                                .saveToFirebase()
                                .then((value) => sb.guestSignout())
                                .then((value) => sb.saveDataToSP().then(
                                    (value) => sb.setSignIn().then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(),
                                              ));
                                        }))));
                          }
                        });
                      }
                    });
                  },
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.grey.shade200,
                  child: Text(
                    'Goolgle Sign In',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          loading
              ? Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellowAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
