import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/home/presentation/manger/pdf_cubit/pdf_state.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerCubit extends Cubit<PDFViewerState> {
  PDFViewerCubit() : super(PDFInitial());

  Future<void> checkIfDownloaded(String pdfUrl) async {
    if (await isPDFDownloaded(pdfUrl)) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = pdfUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.pdf');
      emit(PDFLoaded(file.path));
    }
  }

  Future<bool> isPDFDownloaded(String pdfUrl) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = pdfUrl.hashCode.toString();
    final file = File('${dir.path}/$fileName.pdf');
    return file.existsSync();
  }

  Future<void> downloadAndSavePDF(String pdfUrl) async {
    emit(PDFLoading());
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = pdfUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.pdf');

      if (!file.existsSync()) {
        // اظهار مؤشر التحميل فوراً
        emit(PDFProgress(0));

        await Dio().download(
          pdfUrl,
          file.path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              int progress = (received / total * 100).toInt();
              emit(PDFProgress(progress));
            }
          },
        );
      }

      await Future.delayed(const Duration(milliseconds: 250));

      emit(PDFLoaded(file.path));
    } catch (e) {
      emit(PDFError('Error downloading PDF: $e'));
    }
  }

  Future<void> deletePDF(String pdfUrl) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = pdfUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.pdf');

      if (file.existsSync()) {
        await file.delete();
        emit(PDFInitial());
      }
    } catch (e) {
      emit(PDFError('Error deleting PDF: $e'));
    }
  }
}
