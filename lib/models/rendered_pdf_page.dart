import 'dart:ui' as ui;

class RenderedPdfPage {
  RenderedPdfPage({
    required this.pageNumber,
    required this.width,
    required this.height,
    required this.image,
  });

  final int pageNumber;
  final double width;
  final double height;
  final ui.Image image;

  void dispose() {
    image.dispose();
  }
}
