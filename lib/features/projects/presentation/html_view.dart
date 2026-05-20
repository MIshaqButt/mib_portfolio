import 'package:flutter/material.dart';
import 'html_view_stub.dart'
    if (dart.library.html) 'html_view_web.dart' as impl;

class HtmlView extends StatelessWidget {
  final String viewId;
  final String url;

  const HtmlView({
    super.key,
    required this.viewId,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return impl.createHtmlView(viewId, url);
  }
}
