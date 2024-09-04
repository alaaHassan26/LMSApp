import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_dropdown_lang.dart';
import 'package:lms/core/widget/dialog.dart';
import 'package:lms/features/auth/presentation/views/widget/custom_text_field_login_code.dart';
import 'package:lms/features/auth/presentation/views/widget/logo_and_name_sign_in.dart';

import '../../manger/auth_cubit/auth_cubit.dart';
import '../../manger/auth_cubit/auth_state.dart';

class LogInCode extends StatefulWidget {
  const LogInCode({super.key});

  @override
  State<StatefulWidget> createState() => _LogInCodeState();
}

class _LogInCodeState extends State<LogInCode> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  String? _deviceId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _getDeviceId();
    });
    print('test');
  }

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId;

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      } else {
        deviceId = '';
      }
      setState(() {
        _deviceId = deviceId;
        print(deviceId);
        print('this is id');
      });
    } catch (e) {
      print("Error fetching device ID: $e");
    }
  }

  void _signIn() {
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty;
      _isPasswordValid = _passwordController.text.isNotEmpty;
    });

    if (!_agreedToTerms) {
      _showAgreementDialog();
      return;
    }

    if (_isEmailValid && _agreedToTerms) {
      final macAddress = _deviceId;
      final loginCode = _emailController.text;

      print(_deviceId);
      context.read<LoginCubit>().loginWithCode(macAddress!, loginCode);
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
      appBar: AppBar(),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LanguageSelector(),
                  const SizedBox(height: 4.0),
                  const LogoAndNameSignIn(),
                  const SizedBox(height: 20.0),
                  CustomTextFieldLogInCodeAndforgotPassword(
                    errorText: _isEmailValid
                        ? null
                        : AppLocalizations.of(context)!.translate('entercode'),
                    labelText:
                        AppLocalizations.of(context)!.translate('entercode'),
                    emailController: _emailController,
                    isEmailValid: _isEmailValid,
                    passwordController: _passwordController,
                    isPasswordValid: _isPasswordValid,
                    onEmailChanged: _onEmailChanged,
                    onPasswordChanged: _onPasswordChanged,
                  ),
                  const SizedBox(height: 16.0),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
