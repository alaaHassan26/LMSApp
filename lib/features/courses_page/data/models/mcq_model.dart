class McqCategory {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  McqCategory({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory McqCategory.fromJson(Map<String, dynamic> json) {
    return McqCategory(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
