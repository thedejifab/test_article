import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/services/db.dart';
import 'package:todo_app/viewmodels/task.dart';

void main() {
  final dbService = SembastDbService();

  final taskProvider = TaskProvider(
    dbService: dbService,
  );
  taskProvider.getTasks();

  runApp(MyApp(taskProvider: taskProvider));
}

class MyApp extends StatelessWidget {
  final TaskProvider taskProvider;

  const MyApp({
    Key key,
    @required this.taskProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.inconsolataTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: Home(),
      ),
    );
  }
}
