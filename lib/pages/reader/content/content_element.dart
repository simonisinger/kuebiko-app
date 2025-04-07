import 'package:flutter/material.dart';

abstract class ContentElement {
  final GlobalKey key = GlobalKey();

  Widget render();
}