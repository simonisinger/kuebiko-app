import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'content_element.dart';

class ImageContent extends ContentElement {
  final Future<List<int>> Function() _loader;
  final bool fullSize;
  // the image is needed for the height calculation and the rendering, so it is only loaded once
  late final Future<List<int>> content = _loader();
  // set by the page layout so the rendered image matches the measured height
  double? maxHeight;

  ImageContent(this._loader, this.fullSize);

  @override
  Widget render() {
    return Padding(
        key: key,
        padding: fullSize
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder(
            future: content,
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
                  Widget image = Image.memory(Uint8List.fromList(snapshot.data!));
                  if (maxHeight != null) {
                    image = ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxHeight!),
                      child: image,
                    );
                  }
                  return image;
              }
            }
        )
    );
  }
}