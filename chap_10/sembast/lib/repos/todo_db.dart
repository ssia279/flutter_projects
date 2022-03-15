import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

import '../models/todo.dart';

class TodoDb {
  static final TodoDb _singleton = TodoDb._internal();
  TodoDb._internal();

  factory TodoDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('todos');

  Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }

    return _database;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);

    return db;
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database!, todo.toMap());
  }

  Future updateTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id!));
    await store.update(_database!, todo.toMap(), finder: finder);
  }

  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id!));
    await store.delete(_database!, finder: finder);
  }

  Future deleteAll() async {
    await store.delete(_database!);
  }

  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [SortOrder('priority'), SortOrder('id'),]);
    final todosSnapshot = await store.find(_database!, finder: finder);

    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}