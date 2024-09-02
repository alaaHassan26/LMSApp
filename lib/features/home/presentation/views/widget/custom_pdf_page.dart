import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;

  const PdfViewerPage({super.key, required this.filePath});

  @override
  State<StatefulWidget> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool isReady = false;
  int totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PDF'),
      ),
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
                // التعامل مع الأخطاء
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading PDF')),
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
