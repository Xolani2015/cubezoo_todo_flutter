class ToDo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  ToDo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Convert ToDo object to Firestore format (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert Firestore document to ToDo object
  factory ToDo.fromMap(Map<String, dynamic> map, String documentId) {
    return ToDo(
      id: documentId,
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
