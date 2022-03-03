import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/models/todo_model.dart';
import 'package:note_app/providers/theme_data_provider.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/add_todo_screen.dart';
import 'package:note_app/screens/edit_note_screen.dart';
import 'package:note_app/screens/edit_todo_screen.dart';
import 'package:note_app/screens/reset_master_password.dart';
import 'package:note_app/screens/reset_password.dart';
import 'package:note_app/screens/signin_screens/signin_screen.dart';
import 'package:note_app/screens/subscription/sub_reminder.dart';
import 'package:note_app/utils/colors.dart';
import 'package:note_app/utils/time_ago.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> icons = [Icons.list, Icons.grid_view];
  int view = 1;
  int colorCode = 0;
  FirebaseUser firebaseUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  showViewDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select layout"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                    onTap: () {
                      view = 0;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Icon(icons[0]),
                    title: Text(
                      "List View",
                      style: TextStyle(fontSize: 20),
                    )),
                ListTile(
                    onTap: () {
                      view = 1;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: Icon(icons[1]),
                    title: Text(
                      "Grid View",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  showCreateMasterPasswordDialog(String id, bool lock) {
    var _key = GlobalKey<FormState>();
    bool isObscure = true, isObscure2 = true;
    TextEditingController pwdController = TextEditingController();
    TextEditingController pwd2Controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Enter Master Password"),
            content: Container(
              width: double.maxFinite,
              child: Form(
                key: _key,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: 4,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).appBarTheme.iconTheme.color,
                              fontSize: 15),
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
//                          focusColor: Colors.black38,
//                          fillColor: Colors.black38,
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
//                        value = value.trim();
                        if (value.length >= 4) return null;
                        return 'Password cannot less than 4 characters';
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      maxLength: 4,
                      obscureText: isObscure2,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                              color:
                                  Theme.of(context).appBarTheme.iconTheme.color,
                              fontSize: 15),
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
//            keyboardType: TextInputType.,
                      cursorColor: Theme.of(context)
                          .appBarTheme
                          .iconTheme
                          .color
                          .withOpacity(0.8),

                      controller: pwd2Controller,
                      validator: (value) {
//                        value = value.trim();
                        if (value.length >= 4 &&
                            pwdController.text.compareTo(value) == 0)
                          return null;
                        return 'Password cannot less than 4 characters';
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.iconTheme.color),
                  )),
              TextButton(
                  onPressed: () async {
                    if (_key.currentState.validate()) {
                      final SignInProvider sb =
                          Provider.of<SignInProvider>(context, listen: false);
                      await sb.updateUserMasterPassword(pwdController.text);
                      final CollectionReference ref = Firestore.instance
                          .collection('notes')
                          .document(sb.uid)
                          .collection("notes");
                      await ref.document(id).updateData({"isLock": !lock});
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.iconTheme.color),
                  )),
            ],
          );
        });
      },
    );
  }

  showMasterPasswordDialog(String id, bool lock) {
    bool isObscure = true;
    TextEditingController pwdController = TextEditingController();
//    TextEditingController pwd2Controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Enter master password"),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 4,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.iconTheme.color,
                            fontSize: 15),
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
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.iconTheme.color),
                  )),
              TextButton(
                  onPressed: () async {
                    final CollectionReference ref = Firestore.instance
                        .collection('notes')
                        .document(
                            Provider.of<SignInProvider>(context, listen: false)
                                .uid)
                        .collection("notes");
                    await ref.document(id).updateData({"isLock": !lock});
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.iconTheme.color),
                  )),
            ],
          );
        });
      },
    );
  }

  showColorFilterDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter by color"),
          content: Container(
//            height: 200,
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      onTap: () {
                        colorCode = 0;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80,
                        height: 27,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme
                                  .color
                                  .withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Text(
                          'Default',
                          style: TextStyle(
//                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        )),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        colorCode = colors[index].value;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 70,
                        height: 27,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(20),
                            color: colors[index]),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showNoteBottom() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'New',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Add Note'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNote(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.check_box_outlined),
                title: Text('Add ToDo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTodo(),
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showOptionBottom(String id, bool lock) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
//          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'Select Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<SignInProvider>(context, listen: false)
                                  .masterPassword ==
                              null ||
                          Provider.of<SignInProvider>(context, listen: false)
                                  .masterPassword ==
                              ""
                      ? showCreateMasterPasswordDialog(id, lock)
                      : showMasterPasswordDialog(id, lock);
                },
                leading: Icon(
                  !lock ? Icons.lock_outline : Icons.lock_open,
                  color: Colors.green,
                ),
                title: Text(
                  lock ? 'Unlock Note' : "Lock Note",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  final CollectionReference ref = Firestore.instance
                      .collection('notes')
                      .document(
                          Provider.of<SignInProvider>(context, listen: false)
                              .uid)
                      .collection("notes");
                  await ref.document(id).delete();
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete Note',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildListView(List<dynamic> notesList) {
    notesList = notesList
        .where((element) => colorCode == 0 ? true : element.color == colorCode)
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
//        final time = DateTime.parse(notesList[index].createdAt);
        if (notesList[index] is NoteModel) {
          return GestureDetector(
            onTap: notesList[index].isLock
                ? () {
                    showMasterPasswordDialog(
                        notesList[index].id, notesList[index].isLock);
                  }
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNote(
                            index: index,
                            model: notesList[index],
                          ),
                        ));
                  },
            onLongPress: () {
              showOptionBottom(notesList[index].id, notesList[index].isLock);
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(12)),
              color: Color(notesList[index].color),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
//                shrinkWrap: true,
//                physics: NeverScrollableScrollPhysics(),
                    children: [
                      notesList[index].isLock
                          ? Center(
                              child: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ))
                          : ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Text(
                                  notesList[index].title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                Text(
                                  notesList[index].notes ?? "",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          TimeAgo.timeAgoSinceDate(notesList[index].createdAt),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: notesList[index].isLock
              ? () {
                  showMasterPasswordDialog(
                      notesList[index].id, notesList[index].isLock);
                }
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTodo(
                          index: index,
                          model: notesList[index],
                        ),
                      ));
                },
          onLongPress: () {
            showOptionBottom(notesList[index].id, notesList[index].isLock);
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5),
                borderRadius: BorderRadius.circular(12)),
            color: Color(notesList[index].color),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    notesList[index].isLock
                        ? Center(
                            child: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, todoIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    child:
                                        notesList[index].todos[todoIndex].check
                                            ? Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.black38,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: Colors.black38,
                                              ),
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    notesList[index].todos[todoIndex].task,
                                    style:
                                        notesList[index].todos[todoIndex].check
                                            ? TextStyle(
                                                color: Colors.black38,
                                                decoration:
                                                    TextDecoration.lineThrough)
                                            : TextStyle(color: Colors.black),
                                  )
                                ],
                              );
                            },
                            itemCount: notesList[index].todos.length,
                          ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        TimeAgo.timeAgoSinceDate(
                          notesList[index].createdAt,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: notesList.length,
    );
  }

  buildStaggeredGridView(List<dynamic> notesList) {
    notesList = notesList
        .where((element) => colorCode == 0 ? true : element.color == colorCode)
        .toList();
    return StaggeredGridView.countBuilder(
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      crossAxisCount: 4,
      itemCount: notesList.length,
      primary: false,
      itemBuilder: (context, index) {
        if (notesList[index] is NoteModel) {
          return GestureDetector(
            onTap: notesList[index].isLock
                ? () {
                    showMasterPasswordDialog(
                        notesList[index].id, notesList[index].isLock);
                  }
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNote(
                            index: index,
                            model: notesList[index],
                          ),
                        ));
                  },
            onLongPress: () {
              showOptionBottom(notesList[index].id, notesList[index].isLock);
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(12)),
              color: Color(notesList[index].color),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
//                shrinkWrap: true,
//                physics: NeverScrollableScrollPhysics(),
                    children: [
                      notesList[index].isLock
                          ? Center(
                              child: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ))
                          : ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Text(
                                  notesList[index].title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                Text(
                                  notesList[index].notes ?? "",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          TimeAgo.timeAgoSinceDate(
                            notesList[index].createdAt,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: notesList[index].isLock
              ? () {
                  showMasterPasswordDialog(
                      notesList[index].id, notesList[index].isLock);
                }
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTodo(
                          index: index,
                          model: notesList[index],
                        ),
                      ));
                },
          onLongPress: () {
            showOptionBottom(notesList[index].id, notesList[index].isLock);
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5),
                borderRadius: BorderRadius.circular(12)),
            color: Color(notesList[index].color),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    notesList[index].isLock
                        ? Center(
                            child: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, todoIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    child:
                                        notesList[index].todos[todoIndex].check
                                            ? Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.black38,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: Colors.black38,
                                              ),
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    notesList[index].todos[todoIndex].task,
                                    style:
                                        notesList[index].todos[todoIndex].check
                                            ? TextStyle(
                                                color: Colors.black38,
                                                decoration:
                                                    TextDecoration.lineThrough)
                                            : TextStyle(color: Colors.black),
                                  )
                                ],
                              );
                            },
                            itemCount: notesList[index].todos.length,
                          ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        TimeAgo.timeAgoSinceDate(
                          notesList[index].createdAt,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  buildView(List<dynamic> documentList) {
    List<dynamic> notesList = [];
    for (int i = 0; i < documentList.length; i++) {
      print(documentList[i].data);
      if (documentList[i].data["todos"] != null) {
        notesList.add(TodoModel.fromMap(
            new Map<dynamic, dynamic>.from(documentList[i].data)));
      } else {
        notesList.add(NoteModel.fromMap(
            new Map<dynamic, dynamic>.from(documentList[i].data)));
      }
    }

    if (view == 0) return buildListView(notesList);
    return buildStaggeredGridView(notesList);
  }

  buildDrawer() {
    final SignInProvider sb = Provider.of<SignInProvider>(context);
    final ThemeProvider tp = Provider.of<ThemeProvider>(context);
    return Drawer(
      elevation: 0,
      child: ListView(
        shrinkWrap: true,
        children: [
          sb.isSignedIn
              ? Column(
                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(sb.imageUrl),
//                          child: Image.network(sb.imageUrl),
                      ),
                      accountName: Text(sb.name),
                      accountEmail: Text(sb.email),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 0.5))),
                    ),
                  ],
                )
              : Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(''),
                      accountEmail: Text(''),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 0.5))),
                    ),
                  ],
                ),
//          SizedBox(
//            height: 10,
//          ),
          ListTile(
            leading: Icon(tp.darkTheme ? Icons.nights_stay : Icons.wb_sunny),
            minLeadingWidth: 5,
            title: Text(
              "Dark Theme",
              style: TextStyle(fontSize: 17),
            ),
            trailing: Switch(
              value: tp.darkTheme,
              onChanged: (value) {
                tp.toggleTheme();
              },
            ),
          ),
          ListTile(
            minLeadingWidth: 5,
            leading: Icon(Icons.notifications_active_outlined),
            title: Text(
              "Subscription Reminder",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionReminder(),
                  ));
            },
          ),
          ListTile(
            minLeadingWidth: 5,
            leading: Icon(Icons.lock_outline),
            title: Text(
              "Change app password",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPassword(),
                  ));
            },
          ),
          ListTile(
            minLeadingWidth: 5,
            leading: Icon(Icons.lock_outline),
            title: Text(
              "Change master password",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetMasterPassword(),
                  ));
            },
          ),
          ListTile(
            minLeadingWidth: 5,
            leading: Icon(Icons.logout),
            title: Text(
              sb.isSignedIn ? "Sign Out" : "Sign In",
              style: TextStyle(fontSize: 17),
            ),
            onTap: sb.isSignedIn
                ? () {
                    sb.afterUserSignOut().then((_) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            maintainState: false,
                            builder: (context) => SignInScreen(),
                          ));
                    });
                  }
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ));
                  },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Notes"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.color_lens,
                color: colorCode == 0
                    ? Theme.of(context).appBarTheme.iconTheme.color
                    : Color(colorCode),
              ),
              onPressed: () {
                showColorFilterDialog();
              }),
          IconButton(
              icon: Icon(icons[view]),
              onPressed: () {
                showViewDialog();
              })
        ],
      ),
      drawer: buildDrawer(),
      body: Provider.of<SignInProvider>(context, listen: false).isSignedIn
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('notes')
                    .document(
                        Provider.of<SignInProvider>(context, listen: false).uid)
                    .collection("notes")
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.data == null)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return snapshots.data.documents.length > 0
                      ? buildView(snapshots.data.documents)
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/no_data.png",
                                scale: 5,
                              ),
                              Text("No Data")
                            ],
                          ),
                        );
                },
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/no_data.png",
                    scale: 5,
                  ),
                  Text("No Data")
                ],
              ),
            ),
//          buildView(Provider.of<NoteProvider>(context, listen: true).getNotes),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showNoteBottom();
        },
      ),
    );
  }
}
