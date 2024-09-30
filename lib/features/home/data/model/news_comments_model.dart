class NewsCommentModel {
  final String id;
  final String userId;
  final String newsId;
  final String? parentCommentId;
  final int isProfessor;
  String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel user;
  late final List<NewsCommentModel> children;

  NewsCommentModel({
    required this.id,
    required this.userId,
    required this.newsId,
    this.parentCommentId,
    required this.isProfessor,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.user,
    List<NewsCommentModel>? children,
  }) : children = children ?? [];

  // إضافة copyWith
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
    );
  }

  factory NewsCommentModel.fromJson(Map<String, dynamic> json) {
    return NewsCommentModel(
      id: json['id'],
      userId: json['user_id'],
      newsId: json['news_id'],
      parentCommentId: json['parent_comment_id'],
      isProfessor: json['is_professor'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      user: UserModel.fromJson(json['user']),
      children: json['children'] != null
          ? (json['children'] as List<dynamic>)
              .map((child) => NewsCommentModel.fromJson(child))
              .toList()
          : [],
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user.toJson(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

class UserModel {
  final String id;
  final String? image;
  final String name;
  final String email;
  final int userType;
  final int accountStatus;
  final String randomCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    this.image,
    required this.name,
    required this.email,
    required this.userType,
    required this.accountStatus,
    required this.randomCode,
    required this.createdAt,
    required this.updatedAt,
  });

  // إضافة copyWith
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
      id: json['id'] ?? '',
      image: json['image'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userType: json['user_type'] ?? 0,
      accountStatus: json['account_status'] ?? 0,
      randomCode: json['random_code'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
