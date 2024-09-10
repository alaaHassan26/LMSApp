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

    PermissionStatus permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
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
    } else if (permissionStatus.isDenied ||
        permissionStatus.isPermanentlyDenied) {
      emit(DownloadFailure('Permission denied to access storage.'));
    }
  }
}
