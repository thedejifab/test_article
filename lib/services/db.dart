import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:todo_app/models/task.dart';
import 'package:path/path.dart' as path;

abstract class DatabaseService {
  Future<void> addOrUpdateTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<List<TaskModel>> getTasks();
}

class SembastDbService implements DatabaseService {
  Database database;
  StoreRef store;

  Future<void> initializeDbAndCreateStore() async {
    String dbPath = 'tasks.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    final appDocDir = await getApplicationDocumentsDirectory();
    database = await dbFactory.openDatabase(path.join(appDocDir.path, dbPath),
        version: 1);

    store = StoreRef.main();
  }

  @override
  Future<void> addOrUpdateTask(TaskModel task) async {
    await store.record('${task.id}').put(database, task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await store.record(taskId).delete(database);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final tasksList = await store.find(database);
    final mappedTasks =
        tasksList.map((e) => e.value as Map<String, dynamic>).toList();

    final tasksListOfMap = List<Map<String, dynamic>>.from([])
      ..addAll(mappedTasks);

    List<TaskModel> tasks = tasksListOfMap.map((map) {
      return TaskModel.fromJson(map);
    }).toList();

    return tasks;
  }
}
