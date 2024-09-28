class Course {
  final String id;
  final String courseId;
  final String userId;
  final String image;
  final String title;
  final String timeCourse;
  final String timeType;
  final String? description;
  final int? price;
  final int courseType;
  final String createdAt;
  final String updatedAt;
  final User? user;
  final CourseDetails? course;

  Course({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.image,
    required this.title,
    required this.timeCourse,
    required this.timeType,
    this.description,
    this.price,
    required this.courseType,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.course,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      userId: json['user_id'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      timeCourse: json['time_course'] as String,
      timeType: json['time_type'] as String,
      description: json['description'] as String?,
      price: json['price'] as int?,
      courseType: json['course_type'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      course: json['course'] != null ? CourseDetails.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'user_id': userId,
      'image': image,
      'title': title,
      'time_course': timeCourse,
      'time_type': timeType,
      'description': description,
      'price': price,
      'course_type': courseType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'course': course?.toJson(),
    };
  }
}

class User {
  final String id;
  final String image;
  final String name;
  final String email;
  final int userType;
  final int accountStatus;

  User({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.userType,
    required this.accountStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as int,
      accountStatus: json['account_status'] as int,
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
    };
  }
}

class CourseDetails {
  final String id;
  final String image;
  final String title;
  final String createdAt;
  final String updatedAt;

  CourseDetails({
    required this.id,
    required this.image,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseDetails.fromJson(Map<String, dynamic> json) {
    return CourseDetails(
      id: json['id'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CoursesResponse {
  final int code;
  final String message;
  final List<dynamic> errors;
  final List<Course> result;
  final String? token;
  final int count;

  CoursesResponse({
    required this.code,
    required this.message,
    required this.errors,
    required this.result,
    this.token,
    required this.count,
  });

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      errors: json['errors'] as List<dynamic>,
      result: (json['result'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
      token: json['token'] as String?,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'errors': errors,
      'result': result.map((course) => course.toJson()).toList(),
      'token': token,
      'count': count,
    };
  }
}
