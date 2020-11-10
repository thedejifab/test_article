import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/db.dart';
import 'package:todo_app/viewmodels/task.dart';

import '../mocks.dart';

void main() {
  DatabaseService dbService;
  TaskProvider taskProvider;

  setUp(() {
    dbService = MockDatabaseService();
    taskProvider = TaskProvider(dbService: dbService);
  });

  //writing this test first because other tests will depend on it
  test('Task setter and getter', () async {
    final task1 = TaskModel()..id = 'task1';
    final task2 = TaskModel()..id = 'task2';

    expect(taskProvider.tasks, isEmpty);

    taskProvider.tasks = [task1];

    expect(taskProvider.tasks, hasLength(1));
    expect(taskProvider.tasks, contains(task1));

    taskProvider.tasks = [task1, task2];

    expect(taskProvider.tasks, hasLength(2));
    expect(taskProvider.tasks, containsAllInOrder([task1, task2]));
  });

  test('Get tasks from db', () async {
    final task1 = TaskModel()..id = 'task1';
    final task2 = TaskModel()..id = 'task2';

    when(dbService.getTasks()).thenAnswer(
      (realInvocation) => Future.value([task1, task2]),
    );

    await taskProvider.getTasks();

    verify(dbService.getTasks()).called(1);
    expect(taskProvider.tasks, hasLength(2));
    expect(taskProvider.tasks, containsAllInOrder([task1, task2]));
  });

  test('Delete task', () async {
    final taskId = 'taskId';
    final task = TaskModel()..id = taskId;

    when(dbService.deleteTask(taskId)).thenAnswer(
      (realInvocation) => Future.value(),
    );
    taskProvider.tasks = [task];

    expect(taskProvider.tasks, isNotEmpty);
    expect(taskProvider.tasks, contains(task));

    await taskProvider.deleteTask(taskId);

    verify(dbService.deleteTask(taskId)).called(1);
    expect(taskProvider.tasks, isEmpty);
  });

  test('Create/update task', () async {
    final taskId = 'taskId';
    final task = TaskModel()..id = taskId;

    when(dbService.addOrUpdateTask(task)).thenAnswer(
      (realInvocation) => Future.value(),
    );

    expect(taskProvider.tasks, isEmpty);
    expect(taskProvider.tasks, isNot(contains(task)));

    await taskProvider.createOrUpdateTask(task: task);

    verify(dbService.addOrUpdateTask(task)).called(1);
    expect(taskProvider.tasks, isNotEmpty);
    expect(taskProvider.tasks, contains(task));
  });
}
