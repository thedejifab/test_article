import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Create task', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    final homeFinder = find.byType("Home");

    test('check Flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('Opens home screen', () async {
      await driver.waitFor(homeFinder);
      await delay(1);
    }, timeout: Timeout.none);

    test('Tap create button', () async {
      final createBtn = find.byValueKey('create_btn');
      await driver.waitFor(createBtn);
      await driver.tap(createBtn);
    }, timeout: Timeout.none);

    test('Opens create screen', () async {
      final createFinder = find.byType('Creator');
      await driver.waitFor(createFinder);
      await delay(1);
    });

    test('Enter task title and description', () async {
      final titleFinder = find.byValueKey('title_field');
      final descriptionFinder = find.byValueKey('description_field');

      await driver.tap(titleFinder);
      await driver.enterText('Task title');

      await driver.tap(descriptionFinder);
      await driver.enterText('This is the task description');
      await delay(2);
    });

    test('Create task', () async {
      final actionBtn = find.byValueKey('action_btn');
      await driver.tap(actionBtn);

      await driver.waitFor(homeFinder);
      await delay(2);
    });
  });
}

Future<void> delay([int seconds = 1]) async {
  await Future<void>.delayed(Duration(seconds: seconds));
}
