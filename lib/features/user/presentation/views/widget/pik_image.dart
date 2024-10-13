import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({
    super.key,
  });

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      // طلب إذن READ_MEDIA_IMAGES لأندرويد 13 وما فوق
      if (await Permission.photos.status.isDenied &&
          await Permission.photos.isGranted) {
        await Permission.photos.request();
      }
      // طلب إذن READ_EXTERNAL_STORAGE لأندرويد 11 وما تحت
      else if (await Permission.storage.status.isDenied) {
        await Permission.storage.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 130,
          height: 130,
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const AssetImage('assets/images/avatar.png'),
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {
                      await _requestPermission();

                      // التأكد من حالة الأذونات لأندرويد 13 وما فوق
                      var photoPermission = await Permission.photos.status;
                      // التأكد من حالة الأذونات لأندرويد 11 وما تحت
                      var storagePermission = await Permission.storage.status;

                      if (photoPermission.isGranted ||
                          storagePermission.isGranted) {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          // التعامل مع الصورة المختارة
                          print('Image path: ${image.path}');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Permission to access photos is denied'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.camera_alt_sharp,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
