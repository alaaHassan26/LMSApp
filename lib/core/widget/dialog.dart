//الاسدعاء هيج
// لإظهار الـ
// LoadingDialog.show(context);

// لإخفاء الـ
// LoadingDialog.hide(context);
// مع تمرير البراميتر النص والوجيت

import 'package:flutter/material.dart';
import 'package:lms/core/utils/appstyles.dart';

class LoadingDialog {
  static Future<void> show(BuildContext context,
      {String? text, Widget? widget}) async {
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
                  widget!,
                  const SizedBox(height: 32),
                  Text(
                    text!,
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
