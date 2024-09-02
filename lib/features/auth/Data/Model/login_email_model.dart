class LoginEmailResponse {
  final int code;
  final String message;
  final List<LoginEmailResult> result;
  final String token;
  final int count;

  LoginEmailResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.token,
    required this.count,
  });

  factory LoginEmailResponse.fromJson(Map<String, dynamic> json) {
    return LoginEmailResponse(
      code: json['code'],
      message: json['message'],
      result: List<LoginEmailResult>.from(
          json['result'].map((x) => LoginEmailResult.fromJson(x))),
      token: json['token'],
      count: json['count'],
    );
  }
}

class LoginEmailResult {
  final String id;
  final String image;
  final String name;
  final String email;
  final int userType;
  final int accountStatus;
  final String randomCode;
  final String createdAt;
  final String updatedAt;

  LoginEmailResult({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.userType,
    required this.accountStatus,
    required this.randomCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoginEmailResult.fromJson(Map<String, dynamic> json) {
    return LoginEmailResult(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      accountStatus: json['account_status'],
      randomCode: json['random_code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
