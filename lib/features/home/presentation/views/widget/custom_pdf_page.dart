import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lms/features/home/presentation/manger/pdf_cubit/pdf_cubit.dart';
import 'package:lms/features/home/presentation/manger/pdf_cubit/pdf_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PDFViewerCubit()..downloadAndSavePDF(pdfUrl),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('PDF'),
        ),
        body: BlocBuilder<PDFViewerCubit, PDFViewerState>(
          builder: (context, state) {
            if (state is PDFLoading) {
              return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 58));
            } else if (state is PDFLoaded) {
              return PDFView(filePath: state.filePath);
            } else if (state is PDFError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: Text('Initializing...'));
            }
          },
        ),
      ),
    );
  }
}
