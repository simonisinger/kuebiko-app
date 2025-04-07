import 'package:kuebiko_web_client/services/css/property.dart';

class CssRule {
  final String selector;
  final List<CssProperty> properties = [];

  CssRule(this.selector);

  void addProperty(String propertyName, String propertyValue){
    properties.add(CssProperty(propertyName, propertyValue));
  }
}