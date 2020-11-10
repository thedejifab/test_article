import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';
import 'package:todo_app/services/db.dart';
import 'package:todo_app/viewmodels/task.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockTaskProvider extends Mock implements TaskProvider{}
