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

    test('Tap existing task', () async {
      final listFinder = find.byType('ListView');
      final taskFinder = find.byType('Task');
      final firstTaskFinder = find.descendant(
        of: listFinder,
        matching: taskFinder,
        firstMatchOnly: true,
      );

      await driver.waitFor(firstTaskFinder);
      await driver.tap(firstTaskFinder);
    }, timeout: Timeout.none);

    test('Opens edit screen', () async {
      final editFinder = find.byType('Creator');
      await driver.waitFor(editFinder);
      await delay(1);
    });

    test('Update task description', () async {
      final descriptionFinder = find.byValueKey('description_field');

      await driver.tap(descriptionFinder);
      await driver.enterText('Adding this update to task description');
      await delay(2);
    });

    test('Update task', () async {
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
