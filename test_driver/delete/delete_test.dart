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

    test('Swipe existing task', () async {
      final listFinder = find.byType('ListView');
      final taskFinder = find.byType('Task');

      final firstTaskFinder = find.descendant(
        of: listFinder,
        matching: taskFinder,
        firstMatchOnly: true,
      );

      await driver.waitFor(firstTaskFinder);
      await driver.scroll(firstTaskFinder, -200, 0, Duration(milliseconds: 200));
    }, timeout: Timeout.none);

    test('No tasks again', () async {
      final taskFinder = find.byType('Task');
      final noTaskFinder = find.byValueKey('empty_tasks');

      await driver.waitForAbsent(taskFinder);
      await driver.waitFor(noTaskFinder);
      await delay(1);
    });
  });
}

Future<void> delay([int seconds = 1]) async {
  await Future<void>.delayed(Duration(seconds: seconds));
}
