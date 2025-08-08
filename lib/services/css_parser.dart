import 'dart:io';

import '../../services/css/property.dart';
import '../../services/css/rule.dart';

class CssParser {
  final List<CssRule> rules = [];

  static CssParser fromString(String content){
    return CssParser()
      .._parse(content);
  }

  static CssParser fromFile(String fileName){
    File file = File(fileName);
    String content = file.readAsStringSync();
    return CssParser()
      .._parse(content);
  }

  bool _validate(String propertyName, String propertyValue) {
    propertyValue = propertyValue.trim();
    switch(propertyName) {
      case 'font-weight':
        List<String> values = ['100','200','300','400','500','600','700','800','900', 'bold', 'normal'];
        if (values.contains(propertyValue)) {
          return true;
        }
        return false;
      case 'font-size':
        bool check = propertyValue.endsWith('em');
        propertyValue = propertyValue.replaceAll('em', '');
        if (check && double.tryParse(propertyValue) != null) {
          return true;
        }
        return false;
      case 'text-align':
        List<String> values = ['left', 'right', 'center'];
        if (values.contains(propertyValue)) {
          return true;
        }
        return false;
      case 'font-style':
        List<String> values = ['normal', 'italic', 'initial'];
        if (values.contains(propertyValue)) {
          return true;
        }
        return false;
      case 'max-width':
        bool check = propertyValue.endsWith('px');
        propertyValue = propertyValue.replaceAll('px', '');
        if (check && int.tryParse(propertyValue) != null) {
          return true;
        }
        return false;
      case 'page-break-before':
      case 'page-break-after':
        if (propertyValue == 'auto' || propertyValue == 'always') {
          return true;
        }
        return false;
      default:
        return false;
    }
  }

  List<CssProperty> parsePropertiesString(String propertiesString) {
    RegExp propertiesRegexp = RegExp(
        r'(?<propertyName>[a-zA-Z\-]+):(?<propertyValue>[a-zA-Z0-9\- .]+);',
        multiLine: true
    );
    List<RegExpMatch> propertiesMatches = propertiesRegexp.allMatches(propertiesString).toList();
    List<CssProperty> properties = [];

    for (RegExpMatch propertyMatch in propertiesMatches) {
      bool valid = _validate(
          propertyMatch.namedGroup('propertyName')!,
          propertyMatch.namedGroup('propertyValue')!
      );
      if (valid) {
        properties.add(
          CssProperty(
              propertyMatch.namedGroup('propertyName')!,
              propertyMatch.namedGroup('propertyValue')!)
        );
      }
    }

    return properties;
  }

  void _parse(String content) {
    RegExp regExp = RegExp(
        r"(?<selector>[a-zA-Z0-9 \-._\n\r>#]+){(?<properties>[a-zA-Z0-9\-: ;.\n\r]+)}$",
        multiLine: true
    );
    List<RegExpMatch> matches = regExp.allMatches(content).toList();
    for (RegExpMatch match in matches) {
      String? selector = match.namedGroup('selector');
      CssRule rule = CssRule(selector!.trim());
      rule.properties.addAll(parsePropertiesString(match.namedGroup('properties')!));
      if(rule.properties.isNotEmpty){
        rules.add(rule);
      }
    }
  }
}