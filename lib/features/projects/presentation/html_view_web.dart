import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget createHtmlView(String viewId, String url) {
  // Register the view factory using dart:ui_web
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.borderRadius = '16px'
        ..style.backgroundColor = 'transparent';
      return iframe;
    },
  );

  return HtmlElementView(viewType: viewId);
}
