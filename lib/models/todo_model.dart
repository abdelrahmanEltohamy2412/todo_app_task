class Todo {
  int? id;
  String title;
  String priority;
  bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }


  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? priority,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
