import 'file_picker_stub.dart';
import 'file_picker_stub.dart'
    if (dart.library.html) 'file_picker_web.dart' as impl;

export 'file_picker_stub.dart' show PickedFileResult;

class PortfolioFilePicker {
  static Future<PickedFileResult?> pickHtmlReport() async {
    return impl.pickHtmlFileMobile();
  }
}
