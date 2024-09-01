import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_localiizations.dart';

import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/auth/presentation/views/widget/custom_text_field_login_code.dart';
import 'package:lms/features/auth/presentation/views/widget/logo_and_name_sign_in.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _onEmailChanged(String value) {
    if (!_isEmailValid && value.isNotEmpty) {
      setState(() {
        _isEmailValid = true;
      });
    }
  }

  void _onPasswordChanged(String value) {
    if (!_isPasswordValid && value.isNotEmpty) {
      setState(() {
        _isPasswordValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 4.0),
                const LogoAndNameSignIn(),
                const SizedBox(height: 20.0),
                const Row(
                  children: [
                    Text('ForgotPassword'),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFieldLogInCodeAndforgotPassword(
                  labelText: AppLocalizations.of(context)!.translate('email'),
                  errorText: _isEmailValid
                      ? null
                      : AppLocalizations.of(context)!
                          .translate('please_enter_email'),
                  emailController: _emailController,
                  isEmailValid: _isEmailValid,
                  passwordController: _passwordController,
                  isPasswordValid: _isPasswordValid,
                  onEmailChanged: _onEmailChanged,
                  onPasswordChanged: _onPasswordChanged,
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Send to the email',
                      style: AppStyles.styleMedium20(context).copyWith(
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
