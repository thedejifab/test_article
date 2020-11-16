import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/creator.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/viewmodels/task.dart';

import '../mocks.dart';

TaskProvider _taskProvider;
NavigatorObserver _navigatorObserver;

void main() {
  setUp(() {
    _taskProvider = MockTaskProvider();
    _navigatorObserver = MockNavigatorObserver();
  });

  testWidgets('Display creator screen', (tester) async {
    await tester.pumpWidget(
      _constructApp(false),
    );

    final screenFinder = find.byType(Creator);
    expect(screenFinder, findsOneWidget);

    final titleFieldFinder = find.byKey(Key('title_field'));
    expect(titleFieldFinder, findsOneWidget);

    final descriptionFieldFinder = find.byKey(Key('description_field'));
    expect(descriptionFieldFinder, findsOneWidget);
  });

  group('Create/edit action button', () {
    testWidgets('Update text shown on button if task parameter is non-null',
        (tester) async {
      await tester.pumpWidget(
        _constructApp(true),
      );

      final btnFinder = find.byKey(Key('action_btn'));
      expect(btnFinder, findsOneWidget);

      final btnTextFinder =
          find.descendant(of: btnFinder, matching: find.byType(Text));
      expect(btnTextFinder, findsOneWidget);

      final buttonText = btnTextFinder.evaluate().first.widget as Text;
      expect(buttonText.data.toLowerCase(), contains('update'));
      expect(buttonText.data.toLowerCase(), isNot(contains('create')));
    });

    testWidgets('Create text shown on button if task parameter is null',
        (tester) async {
      await tester.pumpWidget(
        _constructApp(false),
      );

      final btnFinder = find.byKey(Key('action_btn'));
      expect(btnFinder, findsOneWidget);

      final btnTextFinder =
          find.descendant(of: btnFinder, matching: find.byType(Text));
      expect(btnTextFinder, findsOneWidget);

      final buttonText = btnTextFinder.evaluate().first.widget as Text;
      expect(buttonText.data.toLowerCase(), contains('create'));
      expect(buttonText.data.toLowerCase(), isNot(contains('update')));
    });
  });

  group('Create or edit task', () {
    testWidgets('Empty task title returns early with field error',
        (tester) async {
      await tester.pumpWidget(
        _constructApp(false),
      );

      final descriptionFieldFinder = find.byKey(Key('description_field'));
      await tester.enterText(descriptionFieldFinder, 'Task description');
      await tester.pump();

      final btnFinder = find.byKey(Key('action_btn'));
      await tester.tap(btnFinder);
      await tester.pumpAndSettle();

      final errorFinder = find.text('Task title cannot be empty');
      expect(errorFinder, findsOneWidget);

      verifyNever(_taskProvider.createOrUpdateTask(task: anyNamed('task')));
    });

    testWidgets('Empty task description returns early with field error',
        (tester) async {
      await tester.pumpWidget(
        _constructApp(false),
      );

      final titleFieldFinder = find.byKey(Key('title_field'));
      await tester.enterText(titleFieldFinder, 'Task title');
      await tester.pump();

      final btnFinder = find.byKey(Key('action_btn'));
      await tester.tap(btnFinder);
      await tester.pumpAndSettle();

      final errorFinder = find.text('Task description cannot be empty');
      expect(errorFinder, findsOneWidget);

      verifyNever(_taskProvider.createOrUpdateTask(task: anyNamed('task')));
    });
  });

  group('Filled task description and title', () {
    Widget homeApp;
    setUp(() {
      homeApp = ChangeNotifierProvider<TaskProvider>.value(
        value: _taskProvider,
        child: MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
          navigatorObservers: [_navigatorObserver],
        ),
      );
    });

    testWidgets(
        'Filled task title and description creates/edits task successfully and returns to home page',
        (tester) async {
      //Start open Creator screen
      await tester.pumpWidget(homeApp);
      final button = find.byKey(Key('create_btn'));
      await tester.tap(button);
      await tester.pumpAndSettle();
      //End open Creator screen

      when(_taskProvider.createOrUpdateTask(task: anyNamed('task')))
          .thenAnswer((realInvocation) => Future.value());

      final titleFieldFinder = find.byKey(Key('title_field'));
      await tester.enterText(titleFieldFinder, 'Task title');
      await tester.pump();

      final descriptionFieldFinder = find.byKey(Key('description_field'));
      await tester.enterText(descriptionFieldFinder, 'Task description');
      await tester.pump();

      final btnFinder = find.byKey(Key('action_btn'));
      await tester.tap(btnFinder);
      await tester.pumpAndSettle();

      verify(_taskProvider.createOrUpdateTask(task: anyNamed('task')))
          .called(1);

      final creatorFinder = find.byType(Creator);
      expect(creatorFinder, findsNothing);

      final homeFinder = find.byType(Home);
      expect(homeFinder, findsOneWidget);
    });

    testWidgets(
        'Filled task title and description fails from viewmodel and show snackbar',
        (tester) async {
      //Start open Creator screen
      await tester.pumpWidget(homeApp);
      final button = find.byKey(Key('create_btn'));
      await tester.tap(button);
      await tester.pumpAndSettle();
      //End open Creator screen

      when(_taskProvider.createOrUpdateTask(task: anyNamed('task')))
          .thenThrow(Error());

      final titleFieldFinder = find.byKey(Key('title_field'));
      await tester.enterText(titleFieldFinder, 'Task title');
      await tester.pump();

      final descriptionFieldFinder = find.byKey(Key('description_field'));
      await tester.enterText(descriptionFieldFinder, 'Task description');
      await tester.pump();

      final btnFinder = find.byKey(Key('action_btn'));
      await tester.tap(btnFinder);
      await tester.pumpAndSettle();

      verify(_taskProvider.createOrUpdateTask(task: anyNamed('task')))
          .called(1);

      final errorFinder = find.text('Failed to create task');
      expect(errorFinder, findsOneWidget);
    });
  });
}

Widget _constructApp(bool hasParameter) {
  final task1 = TaskModel()
    ..id = 'task1'
    ..title = 'title1'
    ..description = 'description2';

  return ChangeNotifierProvider<TaskProvider>.value(
    value: _taskProvider,
    child: MaterialApp(
      home: Scaffold(
        body: hasParameter ? Creator(task: task1) : Creator(),
      ),
      navigatorObservers: [_navigatorObserver],
    ),
  );
}
