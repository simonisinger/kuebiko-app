import 'dart:typed_data';

import 'package:epubx_kuebiko/epubx_kuebiko.dart' show EpubByteContentFileRef;
import 'package:flutter/material.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';

class ImageContent extends ContentElement {
  final EpubByteContentFileRef image;
  final bool fullSize;

  ImageContent(this.image, this.fullSize);

  @override
  Widget render() {
    return Padding(
        key: key,
        padding: fullSize
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder(
            future: image.readContent(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Placeholder();
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Image.memory(Uint8List.fromList(snapshot.data!));
              }
            }
        )
    );
  }
}