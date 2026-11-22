import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'content_element.dart';

class ImageContent extends ContentElement {
  final Future<List<int>> Function() _loader;
  final bool fullSize;
  // the image is needed for the height calculation and the rendering, so it is only loaded once
  late final Future<List<int>> content = _loader();

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
                  return Image.memory(Uint8List.fromList(snapshot.data!));
              }
            }
        )
    );
  }
}