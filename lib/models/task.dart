class TaskModel {
  String id;
  String title;
  String description;

  TaskModel();

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;

  @override
  bool operator ==(Object other) {
    return other is TaskModel &&
        this.id == other.id &&
        this.title == other.title &&
        this.description == other.description;
  }

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    final task = TaskModel();

    task.id = map['id'] ?? '';
    task.title = map['title'] ?? '';
    task.description = map['description'] ?? '';

    return task;
  }

  Map<String, dynamic> toJson() {
    final jsonMap = <String, dynamic>{};

    jsonMap['id'] = this.id;
    jsonMap['title'] = this.title;
    jsonMap['description'] = this.description;

    return jsonMap;
  }
}
