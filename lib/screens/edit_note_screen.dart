import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:note_app/screens/homescreen.dart';

class EditNote extends StatefulWidget {
  NoteModel model;
  int index;
  EditNote({@required this.model, @required this.index});
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController titleController;
  TextEditingController noteController;
  Color color;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  showBottom() {
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
                'Select Note Color',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
//                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: colors.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            color = colors[index];
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: colors[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              GestureDetector(
                onTap: () async {
                  final CollectionReference ref = Firestore.instance
                      .collection('notes')
                      .document(
                          Provider.of<SignInProvider>(context, listen: false)
                              .uid)
                      .collection("notes");
                  await ref.document(widget.model.id).delete();
//                  Provider.of<NoteProvider>(context, listen: false)
//                      .deleteNotes(widget.index);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Delete this todo',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController(text: widget.model.title);
    noteController = TextEditingController(text: widget.model.notes);
    color = Color(widget.model.color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(color.value),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(color.value),
        title: Text(
          'Edit Note',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          FlatButton(
              padding: EdgeInsets.zero,
              minWidth: 60,
              visualDensity: VisualDensity(horizontal: -4),
              onPressed: () async {
                final CollectionReference ref = Firestore.instance
                    .collection('notes')
                    .document(
                        Provider.of<SignInProvider>(context, listen: false).uid)
                    .collection("notes");
//                var id = ref.document().documentID;
//                    Provider.of<NoteProvider>(context, listen: false).addNotes(
                NoteModel noteModel = NoteModel(
                  id: widget.model.id,
                  title: titleController.text ?? "",
                  notes: noteController.text ?? "",
                  color: color.value,
                  createdAt: DateTime.now().toIso8601String(),
                  isLock: widget.model.isLock,
                );
                await ref
                    .document(widget.model.id)
                    .updateData(noteModel.toMap());

                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              )),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showBottom();
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: titleController,
                onChanged: (value) {
                  setState(() {});
                },
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                  border: InputBorder.none,
                )),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: TextFormField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: TextStyle(color: Colors.black),
                    controller: noteController,
                    keyboardType: TextInputType.multiline,
                    scrollPadding: EdgeInsets.all(20.0),
                    maxLines: double.maxFinite.toInt(),
                    decoration: InputDecoration(
                      hintText: 'Write Notes here',
                      hintStyle: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                      border: InputBorder.none,
                    )))
          ],
        ),
      ),
    );
  }
}
