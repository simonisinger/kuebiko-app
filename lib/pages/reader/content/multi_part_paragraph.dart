import 'package:flutter/material.dart';

import 'content_element.dart';
import 'part_paragraph.dart';

class MultiPartParagraphElement extends ContentElement {

  final List<PartParagraphElement> textElements;

  MultiPartParagraphElement(this.textElements);

  @override
  Widget render() {
    List<PartParagraphElement> newElements = [];
    // splitting text elements in single words to improve text wrapping
    for (PartParagraphElement textElement in textElements) {
      List<String> words = textElement.text.split(' ');
      for (int i  = 0; i < words.length; i++) {
        String word = words[i];
        if (i != words.length - 1) {
          word += " ";
        }
        newElements.add(PartParagraphElement(textElement.style, word));
      }
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Wrap(
          key: key,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: newElements.map((e) => e.render()).toList(),
        )
    );
  }
}