import 'package:html/dom.dart';
import 'package:kuebiko_web_client/services/css/property.dart';
import 'package:kuebiko_web_client/services/css_parser.dart';

class EpubRawContentElement {
  final CssParser css;
  final Element contentElement;
  final String chapter;
  final String fileName;
  List<CssProperty> rules = [];

  EpubRawContentElement(this.css, this.contentElement, this.chapter, this.fileName);
}