import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/widget/custom_text_filed.dart';

class CustomTextFieldSignIn extends StatelessWidget {
  const CustomTextFieldSignIn({
    super.key,
    required TextEditingController emailController,
    required bool isEmailValid,
    required TextEditingController passwordController,
    required bool isPasswordValid,
  })  : _emailController = emailController,
        _isEmailValid = isEmailValid,
        _passwordController = passwordController,
        _isPasswordValid = isPasswordValid;

  final TextEditingController _emailController;
  final bool _isEmailValid;
  final TextEditingController _passwordController;
  final bool _isPasswordValid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          labelText: AppLocalizations.of(context)!.translate('email'),
          controller: _emailController,
          errorText: _isEmailValid
              ? null
              : AppLocalizations.of(context)!.translate('please_enter_email'),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          labelText: AppLocalizations.of(context)!.translate('password'),
          isPassword: true,
          controller: _passwordController,
          errorText: _isPasswordValid
              ? null
              : AppLocalizations.of(context)!
                  .translate('please_enter_password'),
        ),
      ],
    );
  }
}
