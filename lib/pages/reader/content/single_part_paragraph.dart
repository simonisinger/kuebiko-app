import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';

class SinglePartParagraph extends ContentElement {

  final String text;
  final TextStyle style;

  SinglePartParagraph(this.text, this.style);

  @override
  Widget render() {
    return Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
            text,
            style: style
        )
    );
  }
}