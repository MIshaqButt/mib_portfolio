import 'dart:typed_data';

class PickedFileResult {
  final String filename;
  final String textContent;
  final Uint8List bytes;

  PickedFileResult({
    required this.filename,
    required this.textContent,
    required this.bytes,
  });
}

Future<PickedFileResult?> pickHtmlFileMobile() async {
  return null;
}
