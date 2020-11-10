import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/db.dart';

class TaskProvider with ChangeNotifier {
  Map<String, TaskModel> _tasks = {};

  set tasks(List<TaskModel> inputTasks) {
    inputTasks.forEach((task) {
      _tasks[task.id] = task;
    });

    notifyListeners();
  }

  UnmodifiableListView<TaskModel> get tasks {
    final list = _tasks?.values?.toList();
    return UnmodifiableListView<TaskModel>(list);
  }

  DatabaseService dbService;
  TaskProvider({@required this.dbService});

  Future<void> getTasks() async {
    final retrievedTasks = await dbService.getTasks();
    this.tasks = retrievedTasks;
  }

  Future<void> deleteTask(String taskId) async {
    await dbService.deleteTask(taskId);

    _tasks.remove(taskId);
    notifyListeners();
  }

  Future<void> createOrUpdateTask({
    @required TaskModel task,
  }) async {
    await dbService.addOrUpdateTask(task);

    _tasks[task.id] = task;
    notifyListeners();
  }
}
