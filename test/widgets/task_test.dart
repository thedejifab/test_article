import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/creator.dart';
import 'package:todo_app/viewmodels/task.dart';
import 'package:todo_app/widgets/task.dart';

import '../mocks.dart';

void main() {
  final taskModel = TaskModel();
  taskModel.id = 'taskId';
  taskModel.title = 'title';
  taskModel.description = 'description';

  TaskProvider taskProvider;
  Widget app;

  setUp(() {
    taskProvider = MockTaskProvider();
    app = ChangeNotifierProvider<TaskProvider>.value(
      value: taskProvider,
      child: MaterialApp(
          home: Scaffold(
        body: Task(task: taskModel),
      )),
    );
  });

  testWidgets('Rightly rendered', (tester) async {
    await tester.pumpWidget(app);

    final titleFinder = find.text(taskModel.title);
    expect(titleFinder, findsOneWidget);

    final descriptionFinder = find.text(taskModel.description);
    expect(descriptionFinder, findsOneWidget);
  });

  testWidgets('Tap to open edit page with task', (tester) async {
    await tester.pumpWidget(app);

    final taskFinder = find.byKey(Key('${taskModel.id}'));
    expect(taskFinder, findsOneWidget);

    await tester.tap(taskFinder);
    await tester.pumpAndSettle();

    final editScreenFinder = find.byType(Creator);
    expect(editScreenFinder, findsOneWidget);

    final editScreen = editScreenFinder.evaluate().first.widget as Creator;
    expect(editScreen.task, taskModel);
  });


}
