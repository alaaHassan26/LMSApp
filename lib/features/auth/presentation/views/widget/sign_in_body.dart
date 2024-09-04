import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_dropdown_lang.dart';
import 'package:lms/core/widget/dialog.dart';
import 'package:lms/features/auth/presentation/views/widget/custom_text_field_sign_in.dart';
import 'package:lms/features/auth/presentation/views/widget/logo_and_name_sign_in.dart';

import '../../manger/auth_cubit/auth_cubit.dart';
import '../../manger/auth_cubit/auth_state.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<StatefulWidget> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _signIn() {
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty;
      _isPasswordValid = _passwordController.text.isNotEmpty;
    });

    if (!_agreedToTerms) {
      _showAgreementDialog();
      return;
    }

    if (_isEmailValid && _isPasswordValid && _agreedToTerms) {
      final email = _emailController.text;
      final password = _passwordController.text;

      context.read<LoginCubit>().loginEmailUser(email, password);
    }
  }

  void _showAgreementDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('terms_of_use'),
            style: AppStyles.styleSemiBold24(context),
          ),
          content: Text(
            AppLocalizations.of(context)!
                .translate('must_agree_terms_before_proceeding'),
            style: AppStyles.styleMedium20(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate('okay'),
                style: AppStyles.styleMedium16(context),
              ),
            ),
          ],
        );
      },
    );
  }

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
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            LoadingDialog.show(context);
          } else if (state is LoginSuccess) {
            Navigator.of(context).pop();
            SuccessDialog.show(context);
            GoRouter.of(context).go(AppRouter.kNavigationMenu);
          } else if (state is LoginFailure) {
            Navigator.of(context).pop();
            ErrorDialog.show(context, state.error);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LanguageSelector(),
                  const SizedBox(height: 4.0),
                  const LogoAndNameSignIn(),
                  const SizedBox(height: 20.0),
                  CustomTextFieldSignIn(
                    emailController: _emailController,
                    isEmailValid: _isEmailValid,
                    passwordController: _passwordController,
                    isPasswordValid: _isPasswordValid,
                    onEmailChanged: _onEmailChanged,
                    onPasswordChanged: _onPasswordChanged,
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: isArabic(context)
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(AppRouter.kForgotPassword);
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('forgot_password'),
                        style: AppStyles.styleMedium16(context),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('agree_to_terms_of_use'),
                          style: AppStyles.styleRegular20(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: _agreedToTerms ? _signIn : _showAgreementDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: greyColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('sign_in'),
                      style: AppStyles.styleMedium20(context).copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRouter.kLogInCode);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate('logincode'),
                          style: AppStyles.styleMedium16(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
