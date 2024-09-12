import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:lms/features/home/presentation/manger/download_image_cubit/download_image_state.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());

  Future<void> downloadImage(String imageUrl) async {
    emit(DownloadLoading());

    // التحقق من إصدار أندرويد الحالي لمعالجة الأذونات المناسبة
    if (await _requestPermission()) {
      try {
        Dio dio = Dio();
        final response = await dio.get(imageUrl,
            options: Options(responseType: ResponseType.bytes));

        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data));

        if (result['isSuccess'] == true) {
          emit(DownloadSuccess());
        } else {
          emit(DownloadFailure('Failed to save image.'));
        }
      } catch (e) {
        emit(DownloadFailure('Download failed: ${e.toString()}'));
      }
    } else {
      emit(DownloadFailure('Permission denied to access media.'));
    }
  }

  Future<bool> _requestPermission() async {
    // التحقق من إصدار Android 13 وما بعده لاستخدام أذونات الوسائط الجديدة
    if (await Permission.storage.isGranted) {
      return true;
    } else if (await Permission.photos.isGranted) {
      return true;
    } else {
      // طلب الأذونات بناءً على إصدار أندرويد
      PermissionStatus storagePermission;
      if (await Permission.storage.isRestricted ||
          await Permission.storage.isPermanentlyDenied ||
          await Permission.photos.isRestricted) {
        return false;
      }

      // إذا كان الجهاز Android 13 وما بعده، استخدم إذن الصور
      if (await Permission.photos.request().isGranted) {
        return true;
      } else {
        storagePermission = await Permission.storage.request();
        return storagePermission.isGranted;
      }
    }
  }
}
