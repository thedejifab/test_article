import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class Task extends StatelessWidget {
  final TaskModel task;

  const Task({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: _colorFor(task.title).withOpacity(0.3),
        child: Text(
          task.title.substring(0, 1),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ),
      title: Text(
        task.title,
        style: TextStyle(fontSize: 20),
        maxLines: 1,
      ),
      subtitle: Text(
        task.description,
        maxLines: 2,
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
    print(finalHash);
    final red = ((finalHash & 0xFF0000) >> 16);
    final blue = ((finalHash & 0xFF00) >> 8);
    final green = ((finalHash & 0xFF));
    final color = Color.fromRGBO(red, green, blue, 1);
    return color;
  }
}
