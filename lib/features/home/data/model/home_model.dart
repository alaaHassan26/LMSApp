class HomeModel {
  final List<String>? image;
  final String? title;
  final String? pdfUrl; // إضافة رابط PDF

  const HomeModel(
      {required this.image, required this.title, required this.pdfUrl});
}
