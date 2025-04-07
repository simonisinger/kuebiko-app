import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';

class PartParagraphElement extends ContentElement {

  final TextStyle style;
  final String text;

  PartParagraphElement(this.style, this.text);

  @override
  Widget render() {
    return Text(
      text,
      style: style,
    );
  }
}