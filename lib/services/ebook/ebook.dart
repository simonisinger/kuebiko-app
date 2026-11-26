import 'dart:typed_data';

import 'package:epubx_kuebiko/epubx_kuebiko.dart' as epubx;
import 'package:flutter/material.dart' show BoxConstraints, InlineSpan, TextDirection, TextScaler, TextSpan, TextStyle;
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:image/image.dart' as image;
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:path/path.dart' as p;

import '../../pages/reader/content/content_element.dart';
import '../../pages/reader/content/horizontal_line.dart';
import '../../pages/reader/content/image.dart';
import '../../pages/reader/content/multi_part_paragraph.dart';
import '../../pages/reader/content/single_part_paragraph.dart';
import '../ebook/epub_reader.dart';
import '../ebook/reader_interface.dart';

final class EbookService {

  static const progressUnsynchedKey = 'progress.unsynched';

  static Future<BookMeta?> parseEpubMeta(String filename, Stream<List<int>> data, int length) async {
    epubx.EpubBookRef ebook;
    try {
      ebook = await epubx.EpubReader.openBookStream(data,length);
    } catch (e) {
      return null;
    }


    String baseFilename = p.basenameWithoutExtension(filename);
    RegExp regExp = RegExp(r'(?<name>.*)(Vol.|Volume|Bd.|Band)?( *)(?<volNumber>[0-9]+)(.*)$');

    RegExpMatch? match = regExp.firstMatch(ebook.Schema!.Package!.Metadata!.Titles!.first);

    // count elements for max_page parameter
    Reader reader = await EpubReader.fromEpubBookRef(ebook);
    Map<String, Map<String, List<ContentElement>>> elements = await reader.convertToObjects();
    int maxPage = 0;
    elements.forEach((chapter, files) => files.forEach((file, contentElements) => maxPage += contentElements.length));

    return BookMeta(
        name: match?.namedGroup('name') ?? baseFilename,
        volNumber: int.tryParse(match?.namedGroup('volNumber') ?? '') ?? 1,
        releaseDate: DateTime.now(),
        author: ebook.Author ?? 'Unknown Author',
        language: ebook.Schema?.Package?.Metadata?.Languages?.first ?? 'und',
        maxPage: maxPage
    );
  }

  /// Horizontal padding (left + right) applied to text elements during rendering.
  static const double textHorizontalPadding = 20;

  /// Vertical padding (top + bottom) applied to text elements during rendering.
  static const double textVerticalPadding = 10;

  /// Vertical padding (top + bottom) applied to non full-size images during rendering.
  static const double imageVerticalPadding = 20;

  /// Measures the rendered height of every element.
  ///
  /// The returned list always has the same length as [elements].
  /// [baseStyle] and [textScaler] must match what the `Text` widgets use while
  /// rendering (DefaultTextStyle and MediaQuery text scaler), otherwise the
  /// measured heights differ from the real ones.
  static Future<List<double>> generateHeight(
      List<ContentElement> elements,
      double maxWidth,
      double maxHeight, {
        TextStyle? baseStyle,
        TextScaler textScaler = TextScaler.noScaling,
        double dividerHeight = 16,
      }) async {
    List<double> heights = [];
    BoxConstraints constraints = BoxConstraints(
      maxWidth: maxWidth - textHorizontalPadding,
      minHeight: 0.0,
      minWidth: 0.0,
    );

    double measureText(InlineSpan span) {
      RenderParagraph renderParagraph = RenderParagraph(
        span,
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      );
      renderParagraph.layout(constraints);
      return renderParagraph.size.height + textVerticalPadding;
    }

    TextStyle resolve(TextStyle style) => baseStyle?.merge(style) ?? style;

    for (ContentElement element in elements) {
      switch (element) {
        case ImageContent imageContent:
          image.Image imageObject = image.decodeImage(
              Uint8List.fromList(await imageContent.content)
          )!;
          double padding = imageContent.fullSize ? 0 : imageVerticalPadding;
          double maxImageHeight = maxHeight - padding;
          double height = imageObject.height.toDouble();
          if (imageObject.width > maxWidth) {
            double multiplication = imageObject.height / imageObject.width;
            height = maxWidth * multiplication;
          }
          if (maxImageHeight < height) {
            height = maxImageHeight;
          }
          imageContent.maxHeight = maxImageHeight;
          heights.add(height + padding);
        case SinglePartParagraph singlePartParagraph:
          heights.add(measureText(TextSpan(
              text: singlePartParagraph.text,
              style: resolve(singlePartParagraph.style)
          )));
        case MultiPartParagraphElement multiPartParagraphElement:
          heights.add(measureText(TextSpan(
              style: baseStyle,
              children: multiPartParagraphElement.textElements.map(
                      (e) => TextSpan(text: e.text, style: e.style)
              ).toList()
          )));
        case HorizontalLine _:
          heights.add(dividerHeight);
        default:
          heights.add(0);
      }
    }

    return heights;
  }
}