import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/creator.dart';
import 'package:todo_app/viewmodels/task.dart';
import 'package:todo_app/widgets/task.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Keep your morale high, and your Ts crossed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Builder(builder: (context) {
              final tasks = context.watch<TaskProvider>().tasks;

              if (tasks == null || tasks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.tag_faces_rounded,
                        size: 60,
                        color: Color(0xFF4169e1),
                      ),
                      Text(
                        'No tasks yet. Do something',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemBuilder: (_, index) => Task(
                  task: tasks.elementAt(index),
                ),
                itemCount: tasks.length,
                shrinkWrap: true,
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onOpenCreate,
        backgroundColor: Color(0xFF4169e1),
        child: Icon(
          Icons.add,
          size: 36,
        ),
      ),
    );
  }

  void _onOpenCreate() async {
    final String successMessage = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Creator()),
    );

    if (successMessage == null) return;

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
      ),
    );
  }
}
