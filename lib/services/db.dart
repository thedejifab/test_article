import 'package:todo_app/models/task.dart';

abstract class DatabaseService {
  Future<void> addOrUpdateTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<List<TaskModel>> getTasks();
}

class SembastDbService implements DatabaseService {
  SembastDbService() {}

  @override
  Future<void> addOrUpdateTask(TaskModel task) {
    // TODO: implement addOrUpdateTask
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(String taskId) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }
}
