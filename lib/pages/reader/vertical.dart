import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'package:http/http.dart' as http;
import 'package:kuebiko_web_client/services/ebook/epub_reader.dart';

import 'content/content_element.dart';

class VerticalReaderPage extends StatefulWidget {

  final String ebookPath;

  const VerticalReaderPage({Key? key, required this.ebookPath}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerticalReaderPageState();
}

class _VerticalReaderPageState extends State<VerticalReaderPage> {

  EpubReader? _ebook;
  Map<String, Map<String, List<ContentElement>>> _contentElements = {};
  late String _chapter;
  late String _part;
  final Map<String, Map<String, double>> _chapterHeight = {};
  final ScrollController _scrollController = ScrollController();
  final Map<String, Map<String, _PartPosition>> _renderedChapters = {};

  @override
  void initState() {
    super.initState();
    _initEbook();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener(){
    if (_scrollController.position.pixels > _renderedChapters[_chapter]![_part]!.end || _scrollController.position.pixels < _renderedChapters[_chapter]![_part]!.start) {
      // Find the new chapter
      double height = 0;

      bool changed = false;
      for (String chapter in _renderedChapters.keys) {
        for (String part in _renderedChapters[chapter]!.keys) {
          height += _chapterHeight[chapter]![part]!;
          if (_scrollController.position.pixels < height) {
            _chapter = chapter;
            _part = part;
            changed = true;
            break;
          }
        }
        if (changed) {
          break;
        }
      }
      setState(_buildRenderedCache);
    }
  }

  _initEbook() async {
    File file = File(widget.ebookPath);
    http.Response res = await http.get(Uri.parse('https://kuebiko.app/Trapped in a Dating Sim_ The W - Yomu Mishima & Monda_382.epub'));
    _ebook = await EpubReader.init(res.bodyBytes);
    _contentElements = _ebook!.convertToObjects();
    _chapter = _contentElements.keys.first;
    _part = _contentElements[_chapter]!.keys.first;

    _chapterHeight.addAll(
        _contentElements.map((key, value) {
          Map<String, double> heightMap = value.map((key, contentElements) {
            List<double> heights = EpubReader.generateHeight(
                contentElements,
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.9
            );

            double height = 0;

            for (double element in heights) {
              height += element;
            }
            return MapEntry(key, height);
          });
          return MapEntry(key, heightMap);
        })
    );

    setState(_buildRenderedCache);
  }

  void _buildRenderedCache() {
    Map<String, Map<String, _PartPosition>> renderElements = {};
    int chapterIndex = _contentElements.keys.toList().indexOf(_chapter);
    int partIndex = _contentElements[_chapter]!.keys.toList().indexOf(_part);
    double height = 0;
    int startChapterIndex = chapterIndex;
    int startPartIndex = partIndex;
    int p = 2;
    while (p > 0) {
      if(startChapterIndex == 0 && startPartIndex == 0){
        break;
      } else if (startPartIndex == 0) {
        startChapterIndex--;
        startPartIndex = _contentElements[_contentElements.keys.toList()[startChapterIndex]]!.keys.length - 1;
      } else {
        startPartIndex--;
      }
      p--;
    }
    int currentChapterIndex = startChapterIndex;
    int currentPartIndex = startPartIndex;
    for (int i = 0; i < 5; i++) {
      String chapter = _contentElements.keys.toList()[currentChapterIndex];
      String part = _contentElements[chapter]!.keys.toList()[currentPartIndex];
      double chapterHeight = _chapterHeight[chapter]![part]!;

      if (currentPartIndex == _contentElements[chapter]!.keys.length - 1) {
        currentChapterIndex++;
        currentPartIndex = 0;
        if (currentChapterIndex == _contentElements.keys.length) {
          break;
        }
      } else {
        currentPartIndex++;
      }

      if (!renderElements.containsKey(chapter)) {
        renderElements[chapter] = {};
      }
      renderElements[chapter]![part] = _PartPosition(height, height + chapterHeight);
      height += chapterHeight;
    }

    if (_scrollController.hasClients) {
      double newPosition = _scrollController.position.pixels;
      for (String chapter in _renderedChapters.keys) {
        for (String part in _renderedChapters[chapter]!.keys) {
          if (!renderElements.containsKey(chapter)) {
            if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward) {
              newPosition += _chapterHeight[chapter]![part]!;
            } else if (_scrollController.position.userScrollDirection ==
                ScrollDirection.reverse) {
              newPosition -= _chapterHeight[chapter]![part]!;
            }
          }
        }
      }
      _scrollController.jumpTo(newPosition);
    }

    _renderedChapters.clear();
    _renderedChapters.addAll(renderElements);
  }

  Widget _showLoading() {
    return Stack(
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.topCenter,
              child: SpinKitDualRing(
                color: Theme.of(context).shadowColor,
                size: 100,
              ),
            ),
          ),
          Positioned.fill(
              child: Container(
                  margin: const EdgeInsets.only(top: 200),
                  alignment: AlignmentDirectional.center,
                  child: const Text(
                    'Ebook wird geladen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )
          )
        ]
    );
  }

  Widget _showReader() {
    List<Widget> renderElements = [];
    for (String chapter in _renderedChapters.keys) {
      for (String part in _renderedChapters[chapter]!.keys) {
        renderElements.addAll(_contentElements[chapter]![part]!.map((e) => e.render()).toList());
      }
    }
    return Stack(
      children: [
        ListView(
            controller: _scrollController,
            children: renderElements
        ),
        Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor
              ),
              child: Text(
                _chapter,
                textAlign: TextAlign.center,
              ),
            )
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _ebook == null ? _showLoading() : _showReader(),
      ),
    );
  }
}

class _PartPosition {
  final double start;
  final double end;

  _PartPosition(this.start, this.end);
}
