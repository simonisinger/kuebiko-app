import 'package:flutter/material.dart';

import 'content_element.dart';

class HorizontalLine extends ContentElement {
  @override
  Widget render() => Container(padding: EdgeInsets.symmetric(horizontal: 10), child: Divider());
}