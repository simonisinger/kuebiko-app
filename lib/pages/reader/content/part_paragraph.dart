import 'package:flutter/material.dart';

import 'content_element.dart';

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