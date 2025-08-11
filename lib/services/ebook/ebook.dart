import 'dart:convert';
import 'dart:typed_data';

import 'package:epubx_kuebiko/epubx_kuebiko.dart' as epubx;
import 'package:flutter/material.dart' show BoxConstraints, TextDirection, TextSpan, TextStyle;
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:image/image.dart' as image;
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:path/path.dart' as p;

import '../../pages/reader/content/content_element.dart';
import '../../pages/reader/content/image.dart';
import '../../pages/reader/content/multi_part_paragraph.dart';
import '../../pages/reader/content/single_part_paragraph.dart';
import '../../cache/storage.dart';
import '../ebook/epub_reader.dart';
import '../ebook/reader_interface.dart';

final class EbookService {
  static const readerCacheKey = 'pageConfigList';
  static const progressUnsynchedKey = 'progress.unsynched';

  static Future<BookMeta> parseEpubMeta(String filename, Stream<List<int>> data, int length) async {
    epubx.EpubBookRef ebook = await epubx.EpubReader.openBookStream(data,length);

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

  static Future<List<double>> generateHeight(List<ContentElement> elements, double maxWidth, double maxHeight) async {
    List<double> heights = [];
    BoxConstraints constraints = BoxConstraints(
      maxWidth: maxWidth, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );

    for (ContentElement element in elements) {
      RenderParagraph renderParagraph;
      switch (element) {
        case ImageContent imageContent:
          image.Image imageObject = image.decodeImage(
              Uint8List.fromList(await imageContent.image.readContent())
          )!;
          double height = imageObject.height.toDouble();
          if (imageObject.width > maxWidth) {
            double multiplication = imageObject.height / imageObject.width;
            height = maxWidth * multiplication;
          }
          if (maxHeight < height) {
            height = maxHeight;
          }
          heights.add(height);
        case SinglePartParagraph singlePartParagraph:
          renderParagraph = RenderParagraph(
            TextSpan(
                text: singlePartParagraph.text,
                style: singlePartParagraph.style
            ),
            textDirection: TextDirection.ltr,
          );

          renderParagraph.layout(constraints);
          heights.add(renderParagraph.size.height + 10);
        case MultiPartParagraphElement multiPartParagraphElement:
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

  Future<void> clearRenderCache() async {
    List renderCacheKeys = jsonDecode(await storage.read(key: readerCacheKey) ?? '[]');
    for (String key in renderCacheKeys) {
      await storage.delete(key: key);
    }
    await storage.write(key: readerCacheKey, value: '[]');
  }
}