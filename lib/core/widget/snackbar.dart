import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackBar(
      BuildContext context, String message, TextStyle? style) {
    Flushbar(
      margin: const EdgeInsets.fromLTRB(8, kToolbarHeight + 4, 8, 0),
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      icon: const Icon(
        Icons.check_circle,
      ),
      messageText: Text(
        message,
        style: style,
      ),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}







// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// void showTopSanckBar(BuildContext context, String title, String message) =>
//     Flushbar(
//       icon: const Icon(Iconsax.chart_success),
//       shouldIconPulse: false,
//       title: title,
//       message: message,
//       duration: const Duration(seconds: 6),
//       flushbarPosition: FlushbarPosition.TOP,
//       borderRadius: BorderRadius.circular(16),
//       margin: const EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 0),
//     )..show(context);
