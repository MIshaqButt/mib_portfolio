import 'package:flutter/material.dart';

Widget createHtmlView(String viewId, String url) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Text(
        'Dynamic HTML details are fully supported on Web. Use standard web clients to view this report.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ),
  );
}
