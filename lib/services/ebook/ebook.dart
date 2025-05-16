import 'dart:typed_data';

import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart' show BoxConstraints, TextDirection, TextSpan, TextStyle;
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:image/image.dart' as image;
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:path/path.dart' as p;

import '../../pages/reader/content/content_element.dart';
import '../../pages/reader/content/image.dart';
import '../../pages/reader/content/multi_part_paragraph.dart';
import '../../pages/reader/content/single_part_paragraph.dart';

final class EbookService {
  static Future<BookMeta> parseEpubMeta(String filename, Uint8List data) async {
    EpubBook ebook = await EpubReader.readBook(data);

    String baseFilename = p.basenameWithoutExtension(filename);
    RegExp regExp = RegExp(r'(?<name>.*)(Vol.|Volume|Bd.|Band)?( *)(?<volNumber>[0-9]+)(.*)$');

    RegExpMatch? match = regExp.firstMatch(p.basenameWithoutExtension(filename));
    return BookMeta(
        name: match?.namedGroup('name') ?? baseFilename,
        volNumber: int.tryParse(match?.namedGroup('volNumber') ?? '') ?? 1,
        releaseDate: DateTime.now(),
        author: ebook.Author ?? 'Unknown Author',
        language: ebook.Schema?.Package?.Metadata?.Languages?.first ?? 'und'
    );
  }

  static List<double> generateHeight(List<ContentElement> elements, double maxWidth, double maxHeight) {
    List<double> heights = [];
    BoxConstraints constraints = BoxConstraints(
      maxWidth: maxWidth, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );

    for (ContentElement element in elements) {
      RenderParagraph renderParagraph;
      switch(element.runtimeType) {
        case ImageContent:
          ImageContent imageContent = element as ImageContent;
          image.Image imageObject = image.decodeImage(imageContent.imageData)!;
          double height = imageObject.height.toDouble();
          if (imageObject.width > maxWidth) {
            double multiplication = imageObject.height / imageObject.width;
            height = maxWidth * multiplication;
          }
          if (maxHeight < height) {
            height = maxHeight;
          }
          heights.add(height);
        case SinglePartParagraph:
          SinglePartParagraph singlePartParagraph = element as SinglePartParagraph;
          renderParagraph = RenderParagraph(
            TextSpan(
                text: singlePartParagraph.text,
                style: singlePartParagraph.style
            ),
            textDirection: TextDirection.ltr,
          );

          renderParagraph.layout(constraints);
          heights.add(renderParagraph.size.height + 10);
        case MultiPartParagraphElement:
          MultiPartParagraphElement multiPartParagraphElement = element as MultiPartParagraphElement;

          renderParagraph = RenderParagraph(
            TextSpan(
                text: '',
                style: const TextStyle(),
                children: multiPartParagraphElement.textElements.map(
                        (e) => TextSpan(
                        text: e.text,
                        style: e.style
                    )
                ).toList()
            ),
            textDirection: TextDirection.ltr,
          );
          renderParagraph.layout(constraints);
          heights.add(renderParagraph.size.height + 10);
      }
    }

    return heights;
  }
}