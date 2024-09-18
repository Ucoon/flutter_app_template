import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlWidget extends StatelessWidget {
  const HtmlWidget({
    Key? key,
    required this.data,
    this.style = const {},
  }) : super(key: key);
  final String data;
  final Map<String, Style> style;
  @override
  Widget build(BuildContext context) {
    return Html(
      key: ValueKey(data),
      data: data,
      style: style,
      shrinkWrap: true,
    );
  }
}
