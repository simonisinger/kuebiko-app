import 'package:html/parser.dart';

enum TigerTranslationsChapterSource {
  posts,
  pages
}

class TigerTranslationsChapter {
  final TigerTranslationsChapterSource source;
  final int id;
  final String slug;
  final String title;
  final DateTime date;

  TigerTranslationsChapter(this.source, this.id, this.slug, this.title, this.date);

  factory TigerTranslationsChapter.fromJson(TigerTranslationsChapterSource source, Map<String, dynamic> json) {
    return TigerTranslationsChapter(
      source,
      json['id'],
      json['slug'],
      decodeTitle(json['title']['rendered']),
      DateTime.parse(json['date'])
    );
  }

  /// the chapter number at the end of the title, e.g. "Jack of all Trades – 12"
  /// the slug is only the fallback, because it contains typos sometimes
  int? get number {
    RegExpMatch? match = RegExp(r'(\d+)\s*$').firstMatch(title);
    return match == null ? numberFromSlug(slug) : int.parse(match.group(1)!);
  }

  static int? numberFromSlug(String slug) {
    RegExpMatch? match = RegExp(r'-(\d+)$').firstMatch(slug);
    return match == null ? null : int.parse(match.group(1)!);
  }

  static String? slugPrefix(String slug) {
    RegExpMatch? match = RegExp(r'^(.+)-\d+$').firstMatch(slug);
    return match?.group(1);
  }

  static String decodeTitle(String rawTitle) => parseFragment(rawTitle).text ?? rawTitle;

  static int compare(TigerTranslationsChapter a, TigerTranslationsChapter b) {
    int? numberA = a.number;
    int? numberB = b.number;
    if (numberA != null && numberB != null && numberA != numberB) {
      return numberA.compareTo(numberB);
    }
    return a.date.compareTo(b.date);
  }
}
