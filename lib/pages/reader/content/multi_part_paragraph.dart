import 'package:flutter/material.dart';

import 'content_element.dart';
import 'part_paragraph.dart';

class MultiPartParagraphElement extends ContentElement {

  final List<PartParagraphElement> textElements;

  MultiPartParagraphElement(this.textElements);

  @override
  Widget render() {
    // rendered as a single rich text so it wraps exactly like the height measurement
    return Padding(
        key: key,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text.rich(
          TextSpan(
            children: textElements
                .map((e) => TextSpan(text: e.text, style: e.style))
                .toList(),
          ),
        )
    );
  }
}
