class LoginResponse {
  final int code;
  final String message;
  final List<LoginResult> result;
  final String token;
  final int? count;

  LoginResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.token,
    this.count,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      result: List<LoginResult>.from(
          json['result'].map((x) => LoginResult.fromJson(x))),
      token: json['token'] as String,
      count: json['count'] != null ? json['count'] as int : null,
    );
  }
}

class LoginResult {
  final String id;
  final String? image;
  final String? name;
  final String? email;
  final int userType;
  final int accountStatus;
  final String randomCode;
  final String createdAt;
  final String updatedAt;
  final String? emailVerifiedAt;
  final String? macAddress;
  final String? loginCode;

  LoginResult({
    required this.id,
    this.image,
    this.name,
    this.email,
    required this.userType,
    required this.accountStatus,
    required this.randomCode,
    required this.createdAt,
    required this.updatedAt,
    this.emailVerifiedAt,
    this.macAddress,
    this.loginCode,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      id: json['id'] as String,
      image: json['image'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      userType: json['user_type'] as int,
      accountStatus: json['account_status'] as int,
      randomCode: json['random_code'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      macAddress: json['mac_address'] as String?,
      loginCode: json['login_code'] as String?,
    );
  }
}
