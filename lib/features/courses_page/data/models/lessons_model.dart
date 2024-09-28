import 'courses_model.dart';

class Lesson {
  final String? id;
  final String? categoryId;
  final String? userId;
  final String? title;
  final String? content;
  final int? uploadType;
  final String? videoUrl;
  final String? video;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? file;
  final Course? course;
  final User? user;

  Lesson({
    this.id,
    this.categoryId,
    this.userId,
    this.title,
    this.content,
    this.uploadType,
    this.videoUrl,
    this.video,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.file,
    this.course,
    this.user,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      categoryId: json['category_id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      uploadType: json['upload_type'],
      videoUrl: json['video_url'],
      video: json['video'],
      image: json['image'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      file: json['file'],
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'user_id': userId,
      'title': title,
      'content': content,
      'upload_type': uploadType,
      'video_url': videoUrl,
      'video': video,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'file': file,
      'course': course?.toJson(),
      'user': user?.toJson(),
    };
  }
}
