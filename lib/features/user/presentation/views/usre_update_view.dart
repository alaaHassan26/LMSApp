import 'package:flutter/material.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/user/presentation/views/widget/user_updaate_body.dart';

class UserUpdateView extends StatelessWidget {
  const UserUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isDarkMode ? black38Color : greyColor,
        appBar: AppBar(
          backgroundColor: isDarkMode ? black38Color : greyColor,
          title: const Text('تعديل الملف الشخصي'),
        ),
        body: const UserUpdateProfileBody());
  }
}
