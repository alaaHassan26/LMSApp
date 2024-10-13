import 'package:flutter/material.dart';
import 'package:lms/features/user/presentation/views/widget/user_updaate_body.dart';

class UserUpdateView extends StatelessWidget {
  const UserUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الملف الشخصي'),
        ),
        body: const UserUpdateProfileBody());
  }
}
