class Note {
  String id;
  String title;
  String description;
  bool completed;

  Note({required this.id, required this.title, required this.description, required this.completed});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    // MySQL returns 0/1 for BOOLEAN; normalize to Dart bool
    completed: (json['completed'] is bool)
        ? json['completed'] as bool
        : (json['completed'] is num)
            ? (json['completed'] as num) != 0
            : (json['completed']?.toString() == 'true' || json['completed']?.toString() == '1'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': completed,
  };
}
