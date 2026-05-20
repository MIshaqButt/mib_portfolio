import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:mib_portfolio/features/home/presentation/file_picker_stub.dart';

Future<PickedFileResult?> pickHtmlFileMobile() async {
  final completer = Completer<PickedFileResult?>();
  
  final uploadInput = html.FileUploadInputElement()..accept = '.html';
  uploadInput.click();
  
  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) {
        final bytes = reader.result as Uint8List;
        
        // Read again as text to get raw HTML string
        final textReader = html.FileReader();
        textReader.readAsText(file);
        textReader.onLoadEnd.listen((e) {
          final text = textReader.result as String;
          
          completer.complete(
            PickedFileResult(
              filename: file.name,
              textContent: text,
              bytes: bytes,
            ),
          );
        });
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}
