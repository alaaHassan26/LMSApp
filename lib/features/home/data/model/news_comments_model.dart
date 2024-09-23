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
  late final List<NewsCommentModel>? children; 

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
    this.children,
  });

  factory NewsCommentModel.fromJson(Map<String, dynamic> json) {
    return NewsCommentModel(
      id: json['id'],
      userId: json['user_id'],
      newsId: json['news_id'],
      parentCommentId: json['parent_comment_id'],
      isProfessor: json['is_professor'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      user: UserModel.fromJson(json['user']),
      children: json['children'] != null
          ? (json['children'] as List<dynamic>)
              .map((child) => NewsCommentModel.fromJson(child))
              .toList()
          : null,
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
      'children': children != null
          ? children!.map((child) => child.toJson()).toList()
          : null,
    };
  }
}

class UserModel {
  final String id;
  final String? image;  // Nullable
  final String name;
  final String email;
  final int userType;
  final int accountStatus;
  final String randomCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    this.image,  // Nullable
    required this.name,
    required this.email,
    required this.userType,
    required this.accountStatus,
    required this.randomCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',  // Provide a default value
      image: json['image'],  // Nullable handling
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userType: json['user_type'] ?? 0,  // Provide default value
      accountStatus: json['account_status'] ?? 0,  // Provide default value
      randomCode: json['random_code'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,  // Nullable handling
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
