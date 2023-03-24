import 'package:flutter/material.dart';

void main() {
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
                primarySwatch: Colors.blue,
                brightness: Brightness.light
            )
                .copyWith(secondary: Colors.orange)),
        home: Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todos = [];
  String input = "";

  @override
  void initState() {
    todos.add("item1");
    todos.add("item2");
    todos.add("item3");
    todos.add("item4");
    super.initState();
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
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  title: const Text("Add todo list"),
                  content: TextField(
                    onChanged: (String value){
                      input = value;
                    },
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Add"),
                      onPressed: (){
                       setState(() {
                         todos.add(input);
                       });
                       Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        },
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, index){
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: ListTile(
                    title: Text(todos[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,  color: Colors.red),
                      onPressed: (){
                      setState(() {
                        todos.remove(todos[index]);
                      });
                      },
                    ),
                  ),
                )
            );
          }
      ),
    );
  }
}
