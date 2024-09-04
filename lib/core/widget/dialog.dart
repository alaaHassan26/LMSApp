//الاسدعاء هيج
// لإظهار الـ
// LoadingDialog.show(context);

// لإخفاء الـ
// LoadingDialog.hide(context);

import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDialog {
  static Future<void> show(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 46,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.translate('please_wait'),
                    style: AppStyles.styleMedium20(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class ErrorDialog {
  static Future<void> show(BuildContext context, String errorMessage) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
            child: AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.error, color: redColor),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.translate('error'),
                style: AppStyles.styleSemiBold24(context),
              ),
            ],
          ),
          content: Text(
            errorMessage,
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
        ));
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class SuccessDialog {
  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
            child: AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: greenColor),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.translate('success'),
                style: AppStyles.styleSemiBold24(context),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('login_successful'),
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
        ));
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class ShowAgreementDialog {
  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
            child: AlertDialog(
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
        ));
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
