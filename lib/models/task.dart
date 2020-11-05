class TaskModel {
  String id;
  String title;
  String description;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;

  @override
  bool operator ==(Object other) {
    return other is TaskModel &&
        this.id == other.id &&
        this.title == other.title &&
        this.description == other.description;
  }
}
