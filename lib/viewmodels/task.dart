import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/db.dart';
import 'package:uuid/uuid.dart';

class TaskProvider with ChangeNotifier {
  final _uuid = Uuid();

  Map<String, TaskModel> _tasks;

  set tasks(List<TaskModel> inputTasks) {
    inputTasks.forEach((task) {
      _tasks[task.id] = task;
    });

    notifyListeners();
  }

  UnmodifiableListView<TaskModel> get tasks => _tasks?.values?.toList();

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

  Future<void> createTask({
    @required String title,
    @required String description,
  }) async {
    final task = TaskModel();
    task.id = _uuid.v4();
    task.title = title;
    task.description = description;

    await dbService.addOrUpdateTask(task);

    _tasks[task.id] = task;
    notifyListeners();
  }

  Future<void> updateTask(
    TaskModel task, {
    @required String updatedTitle,
    @required String updatedDescription,
  }) async {
    task.title = updatedTitle;
    task.description = updatedDescription;

    await dbService.addOrUpdateTask(task);

    notifyListeners();
  }
}
