import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/colors.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  NoteModel model;
  AddNote({@required this.model});
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController;
  TextEditingController noteController;
  Color color = Colors.white;
  final Firestore firestore = Firestore.instance;
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
              )
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
    titleController = TextEditingController(text: "");
    noteController = TextEditingController(text: "");
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
          'Add Note',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          (titleController.text.trim().isNotEmpty ||
                  noteController.text.trim().isNotEmpty)
              ? FlatButton(
                  padding: EdgeInsets.zero,
                  minWidth: 60,
//                  color: Colors.black,
                  visualDensity: VisualDensity(horizontal: -4),
                  onPressed: () async {
                    final CollectionReference ref = Firestore.instance
                        .collection('notes')
                        .document(
                            Provider.of<SignInProvider>(context, listen: false)
                                .uid)
                        .collection("notes");
                    var id = ref.document().documentID;
//                    Provider.of<NoteProvider>(context, listen: false).addNotes(
                    NoteModel noteModel = NoteModel(
                      id: id,
                      title: titleController.text ?? "",
                      notes: noteController.text ?? "",
                      color: color.value,
                      createdAt: DateTime.now().toIso8601String(),
                      isLock: false,
                    );
                    await ref.document(id).setData(noteModel.toMap());
//                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ))
              : Container(),
          IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
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
