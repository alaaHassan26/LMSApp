class NewsModel {
  final String id;
  final String userId;
  final String? file;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? filename;
  final List<NewsImage> images;

  NewsModel({
    required this.id,
    required this.userId,
    this.file,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    this.filename,
    required this.images,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      userId: json['user_id'],
      file: json['file'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      filename: json['filename'],
      images: (json['images'] as List<dynamic>)
          .map((image) => NewsImage.fromJson(image))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'file': file,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'filename': filename,
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}

class NewsImage {
  final String id;
  final String imagePath;
  final String imageableType;
  final String imageableId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NewsImage({
    required this.id,
    required this.imagePath,
    required this.imageableType,
    required this.imageableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsImage.fromJson(Map<String, dynamic> json) {
    return NewsImage(
      id: json['id'],
      imagePath: json['image_path'],
      imageableType: json['imageable_type'],
      imageableId: json['imageable_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'imageable_type': imageableType,
      'imageable_id': imageableId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
