import 'package:flutter/material.dart';
import 'package:lms/core/widget/custom_text_filed.dart';

class CustomTextFieldLogInCodeAndforgotPassword extends StatelessWidget {
  const CustomTextFieldLogInCodeAndforgotPassword({
    super.key,
    required TextEditingController emailController,
    required bool isEmailValid,
    required TextEditingController passwordController,
    required bool isPasswordValid,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    this.labelText,
    this.errorText,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final String? labelText;
  final String? errorText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          labelText: labelText,
          controller: _emailController,
          errorText: errorText,
          onChanged: onEmailChanged,
        ),
      ],
    );
  }
}
