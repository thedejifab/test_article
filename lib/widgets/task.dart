import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/creator.dart';
import 'package:todo_app/viewmodels/task.dart';
import 'package:provider/provider.dart';

class Task extends StatelessWidget {
  final TaskModel task;

  const Task({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${task.id}'),
      onDismissed: (_) {
        _onDelete(context);
      },
      background: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        onTap: () async {
          await _onOpenCreate(context);
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _colorFor(task.title).withOpacity(0.3),
          child: Text(
            toBeginningOfSentenceCase(task.title.substring(0, 1)),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(fontSize: 20),
          maxLines: 1,
        ),
        subtitle: Text(
          task.description,
          maxLines: 1,
        ),
      ),
    );
  }

  void _onDelete(BuildContext context) async {
    final taskProvider = context.read<TaskProvider>();
    await taskProvider.deleteTask(task.id);
  }

  Future<void> _onOpenCreate(BuildContext context) async {
    final String successMessage = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Creator(task: task)),
    );

    if (successMessage == null) return;

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
      ),
    );
  }

  //Reference: https://github.com/anoop4real/Flutter_ColorHash_fromString
  Color _colorFor(String text) {
    var hash = 0;
    for (var i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final finalHash = hash.abs() % (256 * 256 * 256);

    final red = ((finalHash & 0xFF0000) >> 16);
    final blue = ((finalHash & 0xFF00) >> 8);
    final green = ((finalHash & 0xFF));
    final color = Color.fromRGBO(red, green, blue, 1);
    return color;
  }
}
