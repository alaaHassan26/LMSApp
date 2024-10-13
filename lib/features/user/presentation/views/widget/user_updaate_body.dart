import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms/features/user/presentation/views/widget/pik_image.dart';

class UserUpdateProfileBody extends StatefulWidget {
  const UserUpdateProfileBody({super.key});

  @override
  State<StatefulWidget> createState() => _UserUpdateProfileBodyState();
}

class _UserUpdateProfileBodyState extends State<UserUpdateProfileBody> {
  final TextEditingController _nameController = TextEditingController();
  final String _defaultName = "علاء حسن";

  @override
  void initState() {
    super.initState();
    _nameController.text = _defaultName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const PickImageWidget(),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم المستخدم',
              border: OutlineInputBorder(),
            ),
            onTap: () {
              if (_nameController.text == _defaultName) {}
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                print('تم حفظ الاسم: ${_nameController.text}');
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
