import 'dart:async';

import 'package:sembast_todo/repos/todo_db.dart';

import '../models/todo.dart';

class TodoBloc {
  TodoDb? db;
  List<Todo>? todoList;
  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  TodoBloc() {
    db = TodoDb();
    getTodos();
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
  }

  Future getTodos() async {
    List<Todo>? todos = await db?.getTodos();
    todoList = (todos != null) ? todos! : <Todo>[];
    todosSink.add(todoList!);
  }

  List<Todo> returnTodos(todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db?.deleteTodo(todo).then((result) {
      getTodos();
    });
  }

  Future<void> _updateTodo(Todo todo) async {
    await db?.updateTodo(todo).then((value) {
      getTodos();
    });
  }

  Future<void> _addTodo(Todo todo) async{
    await db?.insertTodo(todo).then((result) {
      getTodos();
    });
  }

  void dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }
}