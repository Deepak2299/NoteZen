import 'package:flutter/material.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/snackbar.dart';
import 'package:provider/provider.dart';

class ResetMasterPassword extends StatefulWidget {
  @override
  _ResetMasterPasswordState createState() => _ResetMasterPasswordState();
}

class _ResetMasterPasswordState extends State<ResetMasterPassword> {
  bool curPass = true, newPass = true, confirmPass = true, loading = false;
  var _key = GlobalKey<FormState>();
  TextEditingController curPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);
    print(sb.masterPassword);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        title: Text('Reset Master Password'),
      ),
      body: Stack(
        children: [
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.start,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  TextFormField(
                    maxLength: 4,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: curPass,
                    decoration: InputDecoration(
                        labelText: 'Current Password',
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
                              curPass
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
                                curPass = !curPass;
                              });
                            })),
//            keyboardType: TextInputType.,
                    cursorColor: Theme.of(context)
                        .appBarTheme
                        .iconTheme
                        .color
                        .withOpacity(0.8),

                    controller: curPwdController,
                    validator: (value) {
                      value = value.trim();
                      print(sb.masterPassword);
                      if (value.compareTo(sb.masterPassword) == 0) return null;
                      return 'Current password is invalid';
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 4,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (value.length >= 4) return null;
                      return 'Password must be 4';
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 4,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        hasFloatingPlaceholder: false,
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
                      if (value.length < 4)
                        return 'Password must be 4';
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
                          Future.delayed(Duration(milliseconds: 1500), () {
                            sb
                                .updateUserMasterPassword(newPwdController.text)
                                .then((value) {
                              setState(() {
                                loading = false;
                              });

                              openSnacbar(_scaffoldKey,
                                  "Reset Master Password is successful");
                              Navigator.pop(context);
                            });
                          });
//                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Change Master Password',
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

  @override
  void dispose() {
    // TODO: implement dispose
    confirmPwdController.clear();
    newPwdController.clear();
    curPwdController.clear();
    super.dispose();
  }
}
