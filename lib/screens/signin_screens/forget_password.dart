import 'package:flutter/material.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/constants.dart';
import 'package:note_app/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool check = true;
  var _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        title: Text('Forgot Password'),
      ),
      body: Stack(
        children: [
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Text(
                    "You forgot your password?",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Enter your email address. We will send you and email to reset your password.",
                    style: TextStyle(decorationThickness: 10, height: 1.5),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (value.isEmpty)
                        return 'This field is required';
                      else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))
                        return 'Enter valid email address';
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.black,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_key.currentState.validate()) {
                          sb.resetPassword(emailController.text);

                          openSnacbar(_scaffoldKey,
                              "An email has just been sent to you");
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
