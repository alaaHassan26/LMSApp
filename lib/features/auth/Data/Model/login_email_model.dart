class User {
  final String id;
  final String image;
  final String name;
  final String email;
  final int userType;
  final int accountStatus;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.userType,
    required this.accountStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      accountStatus: json['account_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class LoginEmaliResponse {
  final int code;
  final String message;
  final List<User> result;
  final String token;

  LoginEmaliResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.token,
  });

  factory LoginEmaliResponse.fromJson(Map<String, dynamic> json) {
    return LoginEmaliResponse(
      code: json['code'],
      message: json['message'],
      result: List<User>.from(json['result'].map((x) => User.fromJson(x))),
      token: json['token'],
    );
  }
}
