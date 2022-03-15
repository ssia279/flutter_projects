import 'package:flutter/material.dart';
import 'package:sembast_todo/bloc/todo_bloc.dart';
import 'package:sembast_todo/repos/todo_db.dart';
import 'package:sembast_todo/views/todo_screen.dart';

import 'models/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {
  late TodoBloc todoBloc;
  List<Todo>? todos;

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    todos = todoBloc.todoList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Container(
        child: StreamBuilder<List<Todo>>(
          stream: todoBloc.todos,
          initialData: todos,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: Key(snapshot.data[index].id.toString()),
                      onDismissed: (_) => todoBloc.todoDeleteSink.add(snapshot.data[index]),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).highlightColor,
                          child: Text("${snapshot.data[index].priority}"),
                        ),
                        title: Text("${snapshot.data[index].name}"),
                        subtitle: Text("${snapshot.data[index].description}"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                 return TodoScreen(
                                    snapshot.data[index], false
                                );
                            }
                            )
                            );
                          },
                        ),
                      ));
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoScreen(todo, true)),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }
}