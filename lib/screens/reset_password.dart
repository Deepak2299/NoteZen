import 'package:flutter/material.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/snackbar.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool curPass = true, newPass = true, confirmPass = true, loading = false;
  bool check = true;
  var _key = GlobalKey<FormState>();
  TextEditingController curPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        title: Text('Reset Password'),
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
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: newPass,
                    decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.iconTheme.color,
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
                              newPass
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
                                newPass = !newPass;
                              });
                            })),
//            keyboardType: TextInputType.,
                    cursorColor: Theme.of(context)
                        .appBarTheme
                        .iconTheme
                        .color
                        .withOpacity(0.8),

                    controller: newPwdController,
                    validator: (value) {
                      value = value.trim();
                      if (value.length >= 6) return null;
                      return 'Password cannot less than 6 characters';
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: confirmPass,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.iconTheme.color,
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
                              confirmPass
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
                                confirmPass = !confirmPass;
                              });
                            })),
//            keyboardType: TextInputType.,
                    cursorColor: Theme.of(context)
                        .appBarTheme
                        .iconTheme
                        .color
                        .withOpacity(0.8),

                    controller: confirmPwdController,
                    validator: (value) {
                      value = value.trim();
                      if (value.length < 6)
                        return 'Password cannot less than 6 characters';
                      else if (newPwdController.text.compareTo(value) != 0)
                        return 'Confirm Password does not match';
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
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
                          setState(() {
                            loading = true;
                          });
//                          check =
//                              await sb.validatePassword(curPwdController.text);
//                          setState(() {});
                          if (check) {
                            await sb.updatePassword(newPwdController.text);
                          } else {
                            openSnacbar(_scaffoldKey, "Password is incorrect");
                          }
                          setState(() {
                            loading = false;
                          });
                          openSnacbar(
                              _scaffoldKey, "Reset Password is successful");
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Change Password',
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
        ],
      ),
    );
  }
}
