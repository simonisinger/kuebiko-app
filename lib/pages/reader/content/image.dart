import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';

class ImageContent extends ContentElement {

  final Uint8List imageData;
  final bool fullSize;

  ImageContent(this.imageData, this.fullSize);

  @override
  Widget render() => Padding(
      key: key,
      padding: fullSize ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 10),
      child: Image.memory(imageData)
  );
}