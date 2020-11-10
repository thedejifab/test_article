import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/creator.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/viewmodels/task.dart';
import 'package:todo_app/widgets/task.dart';

import '../mocks.dart';

void main() {
  TaskProvider taskProvider;
  Widget app;

  setUp(() {
    taskProvider = MockTaskProvider();

    app = ChangeNotifierProvider<TaskProvider>.value(
      value: taskProvider,
      child: MaterialApp(
          home: Scaffold(
        body: Home(),
      )),
    );
  });

  testWidgets('Screen is pumped', (tester) async {
    await tester.pumpWidget(app);

    final screenFinder = find.byType(Home);
    expect(screenFinder, findsOneWidget);
  });

  testWidgets('Empty list prompt displayed in the absence of tasks',
      (tester) async {
    await tester.pumpWidget(app);

    final emptyPrompt = find.byKey(Key('empty_tasks'));
    expect(emptyPrompt, findsOneWidget);

    final listviewFinder = find.byType(ListView);
    expect(listviewFinder, findsNothing);
  });

  testWidgets('Task list with N elements displayed in the presence of N tasks',
      (tester) async {
    final task1 = TaskModel()
      ..id = 'task1'
      ..title = 'title1'
      ..description = 'description2';
    final task2 = TaskModel()
      ..id = 'task2'
      ..title = 'title2'
      ..description = 'description2';

    final dummylist = UnmodifiableListView<TaskModel>([task1, task2]);

    when(taskProvider.tasks).thenReturn(dummylist);
    await tester.pumpWidget(app);

    final listviewFinder = find.byType(ListView);
    expect(listviewFinder, findsOneWidget);

    final tasksInListFinder =
        find.descendant(of: listviewFinder, matching: find.byType(Task));
    expect(tasksInListFinder, findsNWidgets(2));

    final emptyPrompt = find.byKey(Key('empty_tasks'));
    expect(emptyPrompt, findsNothing);
  });

  testWidgets('Tap create button to open create page', (tester) async {
    await tester.pumpWidget(app);

    final btnFinder = find.byKey(Key('create_btn'));
    expect(btnFinder, findsOneWidget);

    await tester.tap(btnFinder);
    await tester.pumpAndSettle();

    final createScreenFinder = find.byType(Creator);
    expect(createScreenFinder, findsOneWidget);

    final editScreen = createScreenFinder.evaluate().first.widget as Creator;
    expect(editScreen.task, isNull);
  });
}
