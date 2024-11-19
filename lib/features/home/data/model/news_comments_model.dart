import 'package:hive_flutter/hive_flutter.dart';
part 'news_comments_model.g.dart';

@HiveType(typeId: 2)
class NewsCommentModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String? newsId;
  @HiveField(3)
  final String? parentCommentId;
  @HiveField(4)
  final int? isProfessor;
  @HiveField(5)
  String? content;
  @HiveField(6)
  final DateTime? createdAt;
  @HiveField(7)
  final DateTime? updatedAt;
  @HiveField(8)
  final UserModel? user;
  @HiveField(9)
  late final List<NewsCommentModel> children;
  @HiveField(10)
  bool isExpanded; // Keep isExpanded as it is

  NewsCommentModel({
    this.id,
    this.userId,
    this.newsId,
    this.parentCommentId,
    this.isProfessor,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.isExpanded = false,
    List<NewsCommentModel>? children,
  }) : children = children ?? [];

  // Adding copyWith method
  NewsCommentModel copyWith({
    String? id,
    String? userId,
    String? newsId,
    String? parentCommentId,
    int? isProfessor,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    List<NewsCommentModel>? children,
    bool? isExpanded,
  }) {
    return NewsCommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      newsId: newsId ?? this.newsId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      isProfessor: isProfessor ?? this.isProfessor,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  factory NewsCommentModel.fromJson(Map<String, dynamic> json) {
    return NewsCommentModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      newsId: json['news_id'] as String?,
      parentCommentId: json['parent_comment_id'] as String?,
      isProfessor: json['is_professor'] as int?,
      content: json['content'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      children: json['children'] != null
          ? (json['children'] as List<dynamic>)
              .map((child) => NewsCommentModel.fromJson(child))
              .toList()
          : [],
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'news_id': newsId,
      'parent_comment_id': parentCommentId,
      'is_professor': isProfessor,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 3)
class UserModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? image;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? email;
  @HiveField(4)
  final int? userType;
  @HiveField(5)
  final int? accountStatus;
  @HiveField(6)
  final String? randomCode;
  @HiveField(7)
  final DateTime createdAt; // Keep this non-nullable
  @HiveField(8)
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.image,
    this.name,
    this.email,
    this.userType,
    this.accountStatus,
    this.randomCode,
    required this.createdAt,
    this.updatedAt,
  });

  // Adding copyWith method
  UserModel copyWith({
    String? id,
    String? image,
    String? name,
    String? email,
    int? userType,
    int? accountStatus,
    String? randomCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      accountStatus: accountStatus ?? this.accountStatus,
      randomCode: randomCode ?? this.randomCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      image: json['image'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      userType: json['user_type'] as int?,
      accountStatus: json['account_status'] as int?,
      randomCode: json['random_code'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'email': email,
      'user_type': userType,
      'account_status': accountStatus,
      'random_code': randomCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
