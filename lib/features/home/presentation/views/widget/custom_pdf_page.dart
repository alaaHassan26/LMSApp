import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/utils/appstyles.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;
  final String pdfName;

  const PdfViewerPage(
      {super.key, required this.filePath, required this.pdfName});

  @override
  State<StatefulWidget> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool isReady = false;
  int totalPages = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.pdfName),
          titleTextStyle: AppStyles.styleMedium18(context)
              .copyWith(color: isDarkMode ? whiteColor : Colors.black)),
      body: SafeArea(
        child: Stack(
          children: [
            PDFView(
              filePath: widget.filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              onRender: (pages) {
                setState(() {
                  totalPages = pages!;
                  isReady = true;
                });
              },
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error loading PDF')),
                );
              },
            ),
            if (!isReady)
              Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.onPrimary, size: 56),
              ),
          ],
        ),
      ),
    );
  }
}
