import 'package:dio/dio.dart';

abstract class Failure {
  final String err;

  Failure(this.err);
}


class UnexpectedError extends Failure {
UnexpectedError() : super('حصلت مشكلة غير متوقعة');
}

class ServerFailure extends Failure {
  ServerFailure(super.err);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('انقطع الاتصال بالانترنت');
      case DioExceptionType.sendTimeout:
        return ServerFailure('السيرفر لا يستجيب  ');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('السيرفر لا يستجيب  ');
      case DioExceptionType.badCertificate:
        return ServerFailure('انقطع الاتصال بالسيرفر');
      case DioExceptionType.badResponse:
        return ServerFailure('انقطع الاتصال بالسيرفر');
      case DioExceptionType.cancel:
        return ServerFailure('تم الغاء العملية  ');
      case DioExceptionType.connectionError:
        return ServerFailure('لا يوجد اتصال بالانترنت  ');
      case DioExceptionType.unknown:
        return ServerFailure('هناك مشكلة غير متوقعة  ');
      default:
        return ServerFailure(' اوووبس !! هناك مشكلة حاول مجددًا  ');
    }
  }
}
