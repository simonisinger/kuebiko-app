import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:kuebiko_client/kuebiko_client.dart';

import '../../../services/ebook/html_reader.dart';
import '../http_client.dart';
import 'chapter.dart';
import 'series.dart';

/// tiger translations has no volumes, so a book is a fixed sized bundle of chapters
class TigerTranslationsBook implements HtmlBook {
  static const String _removableSelector = 'script, style, iframe, noscript, ins, form, '
      '.sharedaddy, .jp-relatedposts, .wp-block-buttons, .wp-block-embed';

  final TigerTranslationsHttpClient _httpClient;
  final TigerTranslationsSeries series;
  final List<TigerTranslationsChapter> chapters;
  final String? _coverUrl;

  @override
  final int id;

  @override
  String name;

  TigerTranslationsBook(this.id, this.name, this.series, this.chapters, this._coverUrl, this._httpClient);

  @override
  Future<String> convert(Formats format) {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<String> convertStatus(String convertId) {
    // no support
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> cover() async {
    if (_coverUrl == null) {
      throw Exception('book $id has no cover');
    }
    Response res = await _httpClient.get(Uri.parse(_coverUrl), responseType: ResponseType.bytes);
    return Uint8List.fromList(res.data);
  }

  @override
  Future<void> delete() {
    // no support
    throw UnimplementedError();
  }

  /// the book is always delivered as html document for the [HtmlReader], independent of the format
  @override
  Future<KuebikoDownload> download(Formats format) async {
    Map<int, String> contents = await _loadContents();
    List<({String title, String content})> htmlChapters = [];
    for (TigerTranslationsChapter chapter in chapters) {
      dom.DocumentFragment content = parseFragment(contents[chapter.id] ?? '');
      await _appendContinuationPages(content);
      _clean(content);
      htmlChapters.add((title: chapter.title, content: content.outerHtml));
    }

    Uint8List html = utf8.encode(HtmlReader.createDocument(htmlChapters));
    return KuebikoDownload(stream: Stream.value(html), length: html.length);
  }

  Future<Map<int, String>> _loadContents() async {
    Map<int, String> contents = {};
    for (TigerTranslationsChapterSource source in TigerTranslationsChapterSource.values) {
      List<int> ids = chapters
          .where((chapter) => chapter.source == source)
          .map((chapter) => chapter.id)
          .toList();
      for (int i = 0; i < ids.length; i += TigerTranslationsHttpClient.maxPerPage) {
        List<int> idChunk = ids.sublist(i, (i + TigerTranslationsHttpClient.maxPerPage).clamp(0, ids.length));
        List<Map<String, dynamic>> rawContents = await _httpClient.getList(source.name, {
          'include': idChunk.join(','),
          'per_page': TigerTranslationsHttpClient.maxPerPage,
          '_fields': 'id,content'
        });
        for (Map<String, dynamic> rawContent in rawContents) {
          contents[rawContent['id']] = rawContent['content']['rendered'];
        }
      }
    }
    return contents;
  }

  /// older chapters are split up in multiple wordpress pages which are linked with "PAGE 2", "PAGE 3" ...
  Future<void> _appendContinuationPages(dom.DocumentFragment content) async {
    Set<String> visited = {};
    String? slug = _takeContinuationSlug(content);
    while (slug != null && visited.add(slug)) {
      String? html = await _contentBySlug(slug);
      if (html == null) {
        return;
      }
      dom.DocumentFragment next = parseFragment(html);
      slug = _takeContinuationSlug(next);
      content.nodes.addAll(next.nodes.toList());
    }
  }

  String? _takeContinuationSlug(dom.DocumentFragment content) {
    for (dom.Element link in content.querySelectorAll('a')) {
      Uri? target = Uri.tryParse(link.attributes['href'] ?? '');
      if (target == null
          || !target.host.endsWith('tigertranslations.org')
          || !RegExp(r'^\s*page\s*\d+\s*$', caseSensitive: false).hasMatch(link.text)) {
        continue;
      }
      List<String> segments = target.pathSegments.where((segment) => segment.isNotEmpty).toList();
      dom.Element? paragraph = link.parent;
      if (paragraph != null && paragraph.localName == 'p' && paragraph.text.trim() == link.text.trim()) {
        paragraph.remove();
      } else {
        link.remove();
      }
      return segments.isEmpty ? null : segments.last;
    }
    return null;
  }

  Future<String?> _contentBySlug(String slug) async {
    for (TigerTranslationsChapterSource source in [TigerTranslationsChapterSource.pages, TigerTranslationsChapterSource.posts]) {
      List<Map<String, dynamic>> result = await _httpClient.getList(source.name, {
        'slug': slug,
        '_fields': 'content'
      });
      if (result.isNotEmpty) {
        return result.first['content']['rendered'];
      }
    }
    return null;
  }

  void _clean(dom.DocumentFragment content) {
    for (dom.Element element in content.querySelectorAll(_removableSelector)) {
      element.remove();
    }
    // remove navigation paragraphs like "Previous | ToC | Next Chapter"
    for (dom.Element paragraph in content.querySelectorAll('p')) {
      List<dom.Element> links = paragraph.querySelectorAll('a');
      if (links.isEmpty || paragraph.querySelector('img') != null) {
        continue;
      }
      String rest = paragraph.text;
      for (dom.Element link in links) {
        rest = rest.replaceFirst(link.text, '');
      }
      if (rest.replaceAll(RegExp(r'[\s|\-–—•·/<>«»]+'), '').isEmpty) {
        paragraph.remove();
      }
    }
  }

  @override
  Future<Progress> getProgress() {
    // progress is only saved locally
    throw UnimplementedError();
  }

  @override
  Future<Map> metadata() async => {
    'name': name,
    'author': series.author,
    'description': series.description,
    'series': series.name,
    'number_of_volume': null,
    'publisher': series.publisher,
    'language': series.language,
    'genre': null,
    'tag': null,
    'age_rating': null,
    'release_date': chapters.isEmpty ? null : chapters.first.date.toIso8601String(),
    'type': series.type
  };

  @override
  void renewMetadata() {
    // no support
  }

  @override
  Future<void> setProgress(Progress progress) async {
    // progress is only saved locally
  }
}
