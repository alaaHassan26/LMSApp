abstract class PDFViewerState {}

class PDFInitial extends PDFViewerState {}

class PDFLoading extends PDFViewerState {}

class PDFLoaded extends PDFViewerState {
  final String filePath;
  PDFLoaded(this.filePath);
}

class PDFError extends PDFViewerState {
  final String errorMessage;
  PDFError(this.errorMessage);
}
