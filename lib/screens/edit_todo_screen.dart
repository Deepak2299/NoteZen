import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/todo_model.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:note_app/screens/homescreen.dart';

class EditTodo extends StatefulWidget {
  TodoModel model;
  int index;
  EditTodo({@required this.model, @required this.index});
  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  Color color;
  List<Todo> todos = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todos = widget.model.todos;
    color = Color(widget.model.color);
  }

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
  Widget build(BuildContext context) {
//    print(color.value);
    return Scaffold(
      backgroundColor: Color(color.value),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(color.value),
        title: Text(
          'Add Todo',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          todos.length > 0
              ? FlatButton(
                  padding: EdgeInsets.zero,
                  minWidth: 60,
                  visualDensity: VisualDensity(horizontal: -4),
                  onPressed: () async {
                    final CollectionReference ref = Firestore.instance
                        .collection('notes')
                        .document(
                            Provider.of<SignInProvider>(context, listen: false)
                                .uid)
                        .collection("notes");
//                    var id = ref.document().documentID;
//                    Provider.of<NoteProvider>(context, listen: false).addNotes(

                    TodoModel todoModel = TodoModel(
                      id: widget.model.id,
                      todos: todos,
                      color: color.value,
                      createdAt: DateTime.now().toIso8601String(),
                      isLock: widget.model.isLock,
                    );
                    await ref
                        .document(widget.model.id)
                        .updateData(todoModel.toMap());
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ))
              : Container(),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showBottom();
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
//                minLines: 1,
//                keyboardType: TextInputType.multiline,
                controller: _controller,
                cursorColor: Colors.black,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
                onFieldSubmitted: (value) {
                  print(value);
                  if (value.trim().isNotEmpty)
                    todos.add(new Todo(task: value, check: false));
                  _controller.clear();
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: 'Click to Add ToDo',
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w300,
                        fontSize: 20),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.add,
                      color: Colors.black38,
                      size: 20,
                    ),
                    focusColor: Colors.black38)),
            Divider(
              color: Colors.black,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ListTile(
                    visualDensity: VisualDensity(vertical: -4),
                    key: ObjectKey(todos[index]),
                    title: Text(
                      todos[index].task,
                      style: todos[index].check
                          ? TextStyle(
                              color: Colors.black38,
                              decoration: TextDecoration.lineThrough)
                          : TextStyle(color: Colors.black),
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.black,
                      ),
                      child: Checkbox(
                        value: todos[index].check,
                        activeColor: Colors.black,
                        focusColor: Colors.black,
                        hoverColor: Colors.black,
//                        checkColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            todos[index].check = value;
                            if (!value)
                              todos.insert(0, todos.removeAt(index));
                            else
                              todos.add(todos.removeAt(index));
                          });
                        },
                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          todos.removeAt(index);
                          setState(() {});
                        }),
                  ),
                );
              },
              itemCount: todos.length,
            ),
          ],
        ),
      ),
    );
  }
}
