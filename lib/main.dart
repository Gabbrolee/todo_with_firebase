import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo with Firebase',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.blue, brightness: Brightness.light)
                .copyWith(secondary: Colors.orange)),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todos"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    title: const Text("Add todo list"),
                    content: TextField(
                      onChanged: (String value) {
                        todoTitle = value;
                      },
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Add"),
                        onPressed: () {
                          createTodo();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context,  snapshot) {
           if(snapshot.hasData){
             return ListView.builder(
                 shrinkWrap: true,
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context, index) {
                   DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                   return Dismissible(
                       onDismissed: (direction){
                         deleteTodo(documentSnapshot["todoTitle"]);
                       },
                       key: Key(documentSnapshot["todoTitle"]),
                       child: Card(
                         margin: const EdgeInsets.all(8),
                         elevation: 4.0,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0)),
                         child: ListTile(
                           title: Text(documentSnapshot['todoTitle']),
                           trailing: IconButton(
                             icon: const Icon(Icons.delete, color: Colors.red),
                             onPressed: () {
                               deleteTodo(documentSnapshot["todoTitle"]);
                             },
                           ),
                         ),
                       ));
                 });
           }else {
             return const CircularProgressIndicator();
           }
          },
        ));
  }
}
