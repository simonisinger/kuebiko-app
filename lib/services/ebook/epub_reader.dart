
import 'dart:convert';

import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/rendering.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:kuebiko_web_client/cache/storage.dart';
import 'package:kuebiko_web_client/enum/book_type.dart';
import 'package:kuebiko_web_client/enum/read_direction.dart';
import 'package:kuebiko_web_client/pages/reader/content/content_element.dart';
import 'package:kuebiko_web_client/pages/reader/content/image.dart';
import 'package:kuebiko_web_client/pages/reader/content/multi_part_paragraph.dart';
import 'package:kuebiko_web_client/pages/reader/content/part_paragraph.dart';
import 'package:kuebiko_web_client/pages/reader/content/single_part_paragraph.dart';
import 'package:kuebiko_web_client/services/css/property.dart';
import 'package:kuebiko_web_client/services/css/rule.dart';
import 'package:kuebiko_web_client/services/css_parser.dart';
import 'package:kuebiko_web_client/services/ebook/models/epub_raw_content_element.dart';
import 'package:kuebiko_web_client/services/ebook/reader_interface.dart';
import 'package:path/path.dart' as p;

class EpubReader implements Reader {
  late final epubx.EpubBookRef _book;
  late final List<EpubRawContentElement> rawElements;

  static Future<EpubReader> fromEpubBookRef(epubx.EpubBookRef book) async {
    EpubReader epubReader = EpubReader();
    epubReader._book = book;
    await epubReader.convert();
    return epubReader;
  }

  @override
  ReadDirection get readDirection => _book.Schema?.Package?.Spine?.ltr ?? true ? ReadDirection.ltr : ReadDirection.rtl;

  @override
  Future<void> convert() async {
    Map<String, CssParser> cssFiles = await _parseCssFiles();
    _EpubReaderTmpDataStorage elements = await _getHtmlElements(cssFiles);

    // parse each css file
    cssFiles.forEach((cssFilename, cssFile) {
      for (CssRule cssRule in cssFile.rules) {
        if (elements.documents[cssFilename] == null) {
          continue;
        }
        // search through the css files and find matching html elements
        for (int d = 0; d < elements.documents[cssFilename]!.length; d++) {
          dom.Document document = elements.documents[cssFilename]![d];
          List<dom.Element> selectedElements;
          try {
            selectedElements = document.querySelectorAll(cssRule.selector);
          } catch (exception) {
            selectedElements = document.querySelectorAll('.${cssRule.selector}');
          }
          // match the elements to the css rules
          for (dom.Element selectedElement in selectedElements) {
            EpubRawContentElement rawContentElement;
            try {
              rawContentElement = elements.elements[cssFilename]!.firstWhere((element) => selectedElement == element.contentElement);
            } catch (e) {
              continue;
            }
            _addCssPropertyToRawContent(rawContentElement, cssRule.properties);
          }
        }
      }
      elements.documents[cssFilename];
    });
    List<EpubRawContentElement> allElements = [];
    elements.elements.forEach((key, value) => allElements.addAll(value));
    for (EpubRawContentElement element in allElements) {
      // Overwrite style attributes with inline style
      if (element.contentElement.attributes['style'] != null && element.contentElement.attributes['style']!.isNotEmpty) {
        List<String> inlineStylesRaw = element.contentElement.attributes['style']!.split(';');
        List<CssProperty> inlineStyles = inlineStylesRaw
            .where((String inlineStyleRaw) => inlineStyleRaw.isNotEmpty)
            .map((String inlineStyle) => inlineStyle.trim().split(':'))
            .map((List<String> inlineStyleList) => CssProperty(inlineStyleList[0], inlineStyleList[1]))
            .toList();
        for (CssProperty inlineStyle in inlineStyles) {
          try {
            CssProperty oldCssProperty = element.rules.firstWhere((CssProperty property) =>
            inlineStyle.propertyName == property.propertyName);
            element.rules.remove(oldCssProperty);
            element.rules.add(inlineStyle);
          } catch (e) {
            // do nothing
          }
        }
      }
    }
    rawElements = allElements;
  }

  @override
  Future<Map<String, Map<String, List<ContentElement>>>> convertToObjects() async {
    Map<String, Map<String, List<ContentElement>>> results = {};

    for (EpubRawContentElement rawContentElement in rawElements) {
      if(!results.containsKey(rawContentElement.chapter)){
        results[rawContentElement.chapter] = {};
      }
      if (!results[rawContentElement.chapter]!.containsKey(rawContentElement.fileName)) {
        results[rawContentElement.chapter]![rawContentElement.fileName] = [];
      }
      switch(rawContentElement.contentElement.localName) {
        case 'h1':
        case 'h2':
        case 'h3':
        case 'h4':
        case 'h5':
        case 'h6':
          TextStyle style = const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30
          );
          results[rawContentElement.chapter]![rawContentElement.fileName]!.add(SinglePartParagraph(rawContentElement.contentElement.text, style));
          break;
        case 'p':
          ContentElement contentElement;
          List<dom.Element> spanElements = rawContentElement.contentElement.querySelectorAll('span');

          if (spanElements.isNotEmpty) {
            List<PartParagraphElement> parts = [];
            String innerHtml = rawContentElement.contentElement.innerHtml;
            for (dom.Element spanElement in spanElements) {
              innerHtml = innerHtml.replaceAll(spanElement.outerHtml.trim(), ';%;{{${spanElements.indexOf(spanElement)}}};%;');
            }

            List<String> partsRaw = innerHtml.split(';%;');
            for (String part in partsRaw) {
              TextStyle style;
              String text;
              if (part.trim().isEmpty) {
                continue;
              }
              RegExp regex = RegExp(r'\{\{(\d+)}}');
              RegExpMatch? match = regex.firstMatch(part);
              if (match != null) {
                dom.Element spanElement = spanElements[int.tryParse(match.group(1)!)!];
                text = spanElement.text;

                List<CssProperty> rules = rawElements.firstWhere((element) => element.contentElement == spanElement).rules;
                // detect and override the default css rules
                if (spanElement.attributes['style'] != null) {
                  List<CssProperty> localProperties = CssParser().parsePropertiesString(spanElement.attributes['style']!);
                  for (CssProperty property in localProperties) {
                    rules.removeWhere((CssProperty tmpProperty) => property.propertyName == tmpProperty.propertyName);
                    rules.add(property);
                  }
                }
                style = convertCssPropertiesToTextStyle(rules);
              } else {
                text = part;
                style = const TextStyle();
              }

              parts.add(PartParagraphElement(style, text));
            }
            if (parts.isEmpty) {
              continue;
            }
            contentElement = MultiPartParagraphElement(parts);
          } else {
            contentElement = SinglePartParagraph(
                rawContentElement.contentElement.text,
                convertCssPropertiesToTextStyle(rawContentElement.rules)
            );
          }

          results[rawContentElement.chapter]![rawContentElement.fileName]!.add(contentElement);
          break;
        case 'img':
          epubx.EpubByteContentFileRef image = _book.Content!.Images![rawContentElement.contentElement.attributes['src']!.replaceAll('../', '')]!;
          bool fullSize = false;
          if (rawContentElement.contentElement.attributes['src']!.contains('cover')) {
            fullSize = true;
          }

          results[rawContentElement.chapter]![rawContentElement.fileName]!.add(ImageContent(image, fullSize));
          break;
      }
    }
    // Thinking about refactor the result type and removing the filename because possible wrong order during rendering

    return results;
  }

  TextStyle convertCssPropertiesToTextStyle(List<CssProperty> properties) {
    double? fontSize;
    double? fontSizeFactor;
    FontWeight? fontWeight;
    FontStyle? fontStyle;
    for (CssProperty property in properties) {
      if (property.propertyName == 'font-size') {
        //fontSize = double.tryParse(property.propertyValue.replaceAll('px', ''));
        fontSizeFactor = double.tryParse(property.propertyValue.replaceAll('em', ''));
        // 14 is the default font size of flutter
        fontSize = (fontSizeFactor ?? 1) * settings.fontSize;
      }

      if (property.propertyName == 'font-weight') {
        switch (property.propertyValue.trim()) {
          case '100':
            fontWeight = FontWeight.w100;
          case '200':
            fontWeight = FontWeight.w200;
          case '300':
            fontWeight = FontWeight.w300;
          case '400':
            fontWeight = FontWeight.w400;
          case '500':
            fontWeight = FontWeight.w500;
          case '600':
            fontWeight = FontWeight.w600;
          case '700':
            fontWeight = FontWeight.w700;
          case '800':
            fontWeight = FontWeight.w800;
          case '900':
            fontWeight = FontWeight.w900;
          case 'bold':
            fontWeight = FontWeight.bold;
          case 'normal':
            fontWeight = FontWeight.normal;
        }
      }

      if (property.propertyName == 'font-style') {
        switch (property.propertyValue.trim()) {
          case 'italic':
            fontStyle = FontStyle.italic;
            break;
          case 'normal':
            fontStyle = FontStyle.normal;
            break;
        }
      }
    }

    return TextStyle(
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
    );
  }

  void _addCssPropertyToRawContent(EpubRawContentElement contentElement, List<CssProperty> properties) {
    for (int i = 0; i < properties.length; i++) {
      CssProperty property = properties[i];
      try {
        CssProperty existingProperty = contentElement.rules.firstWhere((element) => element.propertyName == property.propertyName);
        contentElement.rules.remove(existingProperty);
      } catch(exception){
        // Do nothing
      }
      contentElement.rules.add(property);
    }
  }

  Future<Map<String, CssParser>> _parseCssFiles() async {
    Map<String, CssParser> cssFiles = {};
    for (String key in _book.Content!.Css!.keys) {
      cssFiles[key] = CssParser.fromString(await _book.Content!.Css![key]!.readContentAsText());
    }
    return cssFiles;
  }

  void _removeAElements(dom.Document document) {
    List<dom.Element> elements = document.querySelectorAll('a');
    for(dom.Element element in elements) {
      if(element.parent!.localName! == 'p'){
        element.reparentChildren(element.parent!);
        element.remove();
      }
    }
  }

  Future<_EpubReaderTmpDataStorage> _getHtmlElements(Map<String, CssParser> cssFiles) async {
    Map<String,List<EpubRawContentElement>> elements = {};
    Map<String, List<dom.Document>> documents = {};

    List<epubx.EpubChapterRef> chapters = await _book.getChapters();
    String chapter = chapters.first.Title!;
    _book.Content!.Html!.forEach((key, value){
      try {
        epubx.EpubChapterRef epubChapter = chapters.firstWhere((element) => element.ContentFileName == key);
        chapter = epubChapter.Title!;
      } catch(exception){
        // don`t do anything
      }

      dom.Document document = parse(utf8.decode(value.getContentFileEntry().content));
      _removeAElements(document);
      List<dom.Element> localElements = document.querySelectorAll('p,h1,h2,h3,h4,h5,h6,img,span');
      String stylesheetName = '';
      if (document.querySelector('link[rel="stylesheet"]') != null) {
        stylesheetName = p.normalize(
            document.querySelector('link[rel="stylesheet"]')!
                .attributes['href']!
                .replaceAll('../', '')
        );
      }

      if (!documents.containsKey(stylesheetName)) {
        documents.addAll({
          stylesheetName: []
        });
      }
      documents[stylesheetName]!.add(document);

      if (!elements.containsKey(stylesheetName)) {
        elements.addAll({
          stylesheetName: []
        });
      }
      for (dom.Element element in localElements) {
        elements[stylesheetName]!.add(EpubRawContentElement(cssFiles[stylesheetName] ?? CssParser(), element, chapter, key));
      }
    });

    return _EpubReaderTmpDataStorage(elements, documents);
  }

  @override
  BookType get bookType {
    bool isComic = _book.Schema?.Package?.Metadata?.MetaItems?.any((element) => element.Property == 'rendition:layout' && element.Content == 'pre-paginated') ?? false;
    return isComic ? BookType.comic : BookType.novel;
  }
}

class _EpubReaderTmpDataStorage {
  final Map<String, List<EpubRawContentElement>> elements;
  final Map<String, List<dom.Document>> documents;

  _EpubReaderTmpDataStorage(this.elements, this.documents);
}