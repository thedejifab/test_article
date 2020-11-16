import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/viewmodels/task.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Creator extends StatefulWidget {
  final TaskModel task;

  const Creator({
    Key key,
    this.task,
  }) : super(key: key);
  @override
  _CreatorState createState() => _CreatorState();
}

class _CreatorState extends State<Creator> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _uuid = Uuid();

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  FocusNode _titleNode;
  FocusNode _descriptionNode;

  ValueNotifier<bool> _isProcessing;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();

    _isProcessing = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _titleNode.dispose();
    _descriptionNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF4169e1),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Icon(
                    Icons.create_new_folder_rounded,
                    size: 100,
                    color: Color(0xFF4169e1),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    key: Key('title_field'),
                    controller: _titleController,
                    focusNode: _titleNode,
                    cursorColor: Color(0xFF4169e1),
                    decoration: InputDecoration(
                      labelText: 'Enter task title',
                      labelStyle: TextStyle(color: Color(0xFF4169e1)),
                      alignLabelWithHint: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4169e1),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptionNode);
                    },
                    validator: (input) {
                      if (input.trim().isNotEmpty) return null;

                      return 'Task title cannot be empty';
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    key: Key('description_field'),
                    controller: _descriptionController,
                    focusNode: _descriptionNode,
                    maxLines: 10,
                    cursorColor: Color(0xFF4169e1),
                    decoration: InputDecoration(
                      labelText: 'Enter task description',
                      labelStyle: TextStyle(color: Color(0xFF4169e1)),
                      alignLabelWithHint: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4169e1),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (input) {
                      if (input.trim().isNotEmpty) return null;

                      return 'Task description cannot be empty';
                    },
                  ),
                  SizedBox(height: 100),
                  FlatButton(
                    key: Key('action_btn'),
                    onPressed: _onCreateOrUpdate,
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: Color(0xFF4169e1),
                    child: Text(
                      '${_isCreate ? 'CREATE' : 'UPDATE'} TASK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: _isProcessing,
              builder: (context, isProcessing, _) {
                if (!isProcessing) return IgnorePointer(ignoring: true);

                return Container(
                  color: Colors.white.withOpacity(0.4),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()),
                );
              }),
        ],
      ),
    );
  }

  Future<void> _onCreateOrUpdate() async {
    if (!_formKey.currentState.validate()) return;

    final taskProvider = context.read<TaskProvider>();
    _isProcessing.value = true;

    try {
      await taskProvider.createOrUpdateTask(task: _usableTaskModel);

      _isProcessing.value = false;

      _titleController.clear();
      _descriptionController.clear();

      Navigator.pop(
        context,
        'Successfully ${_isCreate ? 'created' : 'updated'} task',
      );
    } catch (e, t) {
      _isProcessing.value = false;

      final message = 'Failed to ${_isCreate ? 'create' : 'update'} task';
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  TaskModel get _usableTaskModel {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (!_isCreate) {
      widget.task.title = title;
      widget.task.description = description;

      return widget.task;
    }

    final task = TaskModel();
    task.id = _uuid.v4();
    task.title = title;
    task.description = description;
    return task;
  }

  bool get _isCreate {
    if (widget.task != null) return false;

    return true;
  }
}
