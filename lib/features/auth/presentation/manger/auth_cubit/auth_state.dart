
import '../../../Data/Model/login_email_model.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginEmailResponse loginResponse;

  LoginSuccess(this.loginResponse);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}