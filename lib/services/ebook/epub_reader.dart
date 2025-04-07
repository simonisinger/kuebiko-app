
import 'dart:typed_data';

import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/rendering.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
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
import 'package:image/image.dart' as image;

class EpubReader {
  late final epubx.EpubBook _book;
  late final List<EpubRawContentElement> rawElements;

  static Future<EpubReader> init(Uint8List rawEpubData) async {
    EpubReader reader = EpubReader();
    reader._book = await epubx.EpubReader.readBook(rawEpubData);
    reader._convert();
    return reader;
  }

  ReadDirection get readDirection => _book.Schema?.Package?.Spine?.ltr ?? true ? ReadDirection.ltr : ReadDirection.rtl;

  _convert(){
    Map<String, CssParser> cssFiles = _parseCssFiles();
    _EpubReaderTmpDataStorage elements = _getHtmlElements(cssFiles);

    // parse each css file
    cssFiles.forEach((cssFilename, cssFile) {
      for (int i = 0; i < cssFile.rules.length; i++) {
        CssRule cssRule = cssFile.rules[i];
        for (int d = 0; d < elements.documents[cssFilename]!.length; d++) {
          dom.Document document = elements.documents[cssFilename]![d];
          List<dom.Element> selectedElements;
          try {
            selectedElements = document.querySelectorAll(cssRule.selector);
          } catch (exception) {
            selectedElements = document.querySelectorAll('.' + cssRule.selector);
          }
          for (dom.Element selectedElement in selectedElements) {
            EpubRawContentElement rawContentElement = elements.elements[cssFilename]!
                .firstWhere((element) => selectedElement == element.contentElement);
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

  Map<String, Map<String, List<ContentElement>>> convertToObjects() {
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
              innerHtml = innerHtml.replaceAll(spanElement.outerHtml.trim(), '%;' + spanElements.indexOf(spanElement).toString() + ';%');
            }
            RegExp regex = RegExp(r'%;(\d+);%');

            List<String> partsRaw = regex.allMatches(innerHtml).map((RegExpMatch match) => match.group(1)!).toList();
            for (String part in partsRaw) {
              TextStyle style;
              String text;
              dom.Element spanElement = spanElements[int.tryParse(part)!];
              text = spanElement.text;
              if (text.trim().isEmpty) {
                continue;
              }

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
          List<int> imageContent = _book.Content!.Images![rawContentElement.contentElement.attributes['src']!.replaceAll('../', '')]!.Content!;
          bool fullSize = false;
          if (rawContentElement.contentElement.attributes['src']!.contains('cover')) {
            fullSize = true;
          }

          results[rawContentElement.chapter]![rawContentElement.fileName]!.add(ImageContent(Uint8List.fromList(imageContent), fullSize));
          break;
      }
    }

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
        fontSize = (fontSizeFactor ?? 1) * 14;
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

  _addCssPropertyToRawContent(EpubRawContentElement contentElement, List<CssProperty> properties) {
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

  Map<String, CssParser> _parseCssFiles(){
    return _book.Content!.Css!.map(
            (key, value) => MapEntry(
            key,
            CssParser.fromString(value.Content!)
        )
    );
  }

  _removeAElements(dom.Document document) {
    List<dom.Element> elements = document.querySelectorAll('a');
    for(dom.Element element in elements) {
      if(element.parent!.localName! == 'p'){
        element.reparentChildren(element.parent!);
        element.remove();
      }
    }
  }

  _EpubReaderTmpDataStorage _getHtmlElements(Map<String, CssParser> cssFiles){
    Map<String,List<EpubRawContentElement>> elements = {};
    Map<String, List<dom.Document>> documents = {};
    String chapter = _book.Chapters!.first.Title!;
    _book.Content!.Html!.forEach((key, value){
      try {
        epubx.EpubChapter epubChapter = _book.Chapters!.firstWhere((element) => element.ContentFileName == key);
        chapter = epubChapter.Title!;
      } catch(exception){
        // don`t do anything
      }

      dom.Document document = parse(value.Content!);
      _removeAElements(document);
      List<dom.Element> localElements = document.querySelectorAll('p,h1,h2,h3,h4,h5,h6,img,span');
      String stylesheetName = '';
      if (document.querySelector('link[rel="stylesheet"]') != null) {
        stylesheetName = document.querySelector('link[rel="stylesheet"]')!.attributes['href']!;
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
          break;
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
          break;
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
          break;
      }
    }

    return heights;
  }
}

class _EpubReaderTmpDataStorage {
  final Map<String, List<EpubRawContentElement>> elements;
  final Map<String, List<dom.Document>> documents;

  _EpubReaderTmpDataStorage(this.elements, this.documents);
}