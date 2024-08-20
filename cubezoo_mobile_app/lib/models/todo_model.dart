class ToDo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  ToDo({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  // Convert Firestore document to ToDo object
  factory ToDo.fromMap(Map<String, dynamic> map, String documentId) {
    return ToDo(
      id: documentId,
      title: map['title'],
      description: map['description'],
    );
  }
}
