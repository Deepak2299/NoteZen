import 'package:flutter/material.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/constants.dart';
import 'package:note_app/utils/snackbar.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  bool isObscure = true;
  bool isObscure2 = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController pwd2Controller = TextEditingController();
  final _key = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.clear();
    emailController.clear();
    pwdController.clear();
    pwd2Controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      primary: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: loading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ),
      body: Stack(children: [
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
                  'Create Account',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: inputTextDecorationWithLabel('Username', context),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context)
                    .appBarTheme
                    .iconTheme
                    .color
                    .withOpacity(0.8),
                controller: nameController,
                validator: (value) {
                  value = value.trim();
                  if (value.isNotEmpty) return null;
                  return 'Enter username';
                },
              ),
              SizedBox(
                height: 16,
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
                        color: Theme.of(context)
                            .appBarTheme
                            .iconTheme
                            .color
                            .withOpacity(0.8),
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
              TextFormField(
                obscureText: isObscure2,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                          isObscure2
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
                            isObscure2 = !isObscure2;
                          });
                        })),
                cursorColor: Theme.of(context)
                    .appBarTheme
                    .iconTheme
                    .color
                    .withOpacity(0.8),
                controller: pwd2Controller,
                validator: (value) {
                  value = value.trim();
                  if (value.length >= 6 &&
                      pwdController.text.compareTo(value) == 0) return null;
                  return 'Password cannot less than 6 characters';
                },
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
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
                        .signUpwithEmailPassword(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            pwdController.text.trim())
                        .then((_) async {
                      if (sb.hasError == false) {
                        sb.getTimestamp().then((value) => sb
                            .saveToFirebase()
                            .then((value) => sb
                                .guestSignout()
                                .then((value) => sb.userSignout().then((value) {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.pop(context);
                                    }))));
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
                  'Sign Up',
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
//                      backgroundColor: Colors.yellowAccent,
//                        strokeWidth: 10,

                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ]),
    );
  }
}
