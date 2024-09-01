import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/home/presentation/manger/pdf_cubit/pdf_state.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerCubit extends Cubit<PDFViewerState> {
  PDFViewerCubit() : super(PDFInitial());

  Future<void> downloadAndSavePDF(String pdfUrl) async {
    emit(PDFLoading());
    try {
      final dir = await getApplicationDocumentsDirectory();

      // إنشاء اسم فريد للملف بناءً على رابط الـ PDF
      final fileName = pdfUrl.hashCode.toString();
      final file = File('${dir.path}/$fileName.pdf');

      if (!file.existsSync()) {
        final response = await Dio().download(pdfUrl, file.path);
        if (response.statusCode == 200) {
          emit(PDFLoaded(file.path));
        } else {
          emit(PDFError('Failed to download PDF'));
        }
      } else {
        emit(PDFLoaded(file.path)); // إذا كان الملف موجودًا مسبقًا
      }
    } catch (e) {
      emit(PDFError('Error downloading PDF: $e'));
    }
  }
}
