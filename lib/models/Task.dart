class Task {
  int id;
  String name;
  String description;
  String img;
  int progress = 0;
  bool isExt = true;
  bool archived;
  DateTime creationDate;
  DateTime dueDate;

  Task({this.id, this.description, this.name, this.img, this.progress = 0, this.isExt = true, this.archived = false, this.dueDate, this.creationDate }) {
    this.creationDate = this.creationDate ?? DateTime.now();
  }

  isEqual(Task task) {
    return task.id == id;
  }

  archive() {
    this.archived = true;
  }

  activate() {
    this.archived = false;
  }

  // Create a Task from JSON data
  factory Task.fromJson(Map<String, dynamic> json) => new Task(
        id: json['id'],
        name: json['name'],
        img: json['img'],
        progress: json['progress'],
        description: json['description'],
        archived: json['archived'] == 1,
        dueDate: DateTime.fromMillisecondsSinceEpoch(json['dueDate']),
        creationDate: DateTime.fromMillisecondsSinceEpoch(json['creationDate'])
      );

  // Convert our Task to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'img': img,
        'progress': progress,
        'archived': archived ? 1 : 0,
        'creationDate': creationDate.toUtc().millisecondsSinceEpoch,
        'dueDate': dueDate.toUtc().millisecondsSinceEpoch
      };
}
