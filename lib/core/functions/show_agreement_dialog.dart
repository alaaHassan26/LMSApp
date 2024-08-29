import 'package:flutter/material.dart';

void showAgreementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('شروط الاستخدام'),
        content:
            const Text('يجب عليك الموافقة على شروط الاستخدام قبل المتابعة.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('حسنًا'),
          ),
        ],
      );
    },
  );
}
