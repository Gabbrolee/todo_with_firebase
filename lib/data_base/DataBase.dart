import 'package:cloud_firestore/cloud_firestore.dart';


class DataBase{

  String todoTitle = "";
  createTodo() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);
    Map<String, String> todos = {"todoTitle": todoTitle};
    documentReference.set(todos).whenComplete(() {
      print("todos created");
    });
  }

  deleteTodo(item) {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(item);
    documentReference.delete().whenComplete(() {
      print("$item todos deleted");
    });
  }
}