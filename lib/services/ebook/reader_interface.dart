import '../../enum/read_direction.dart';
import '../../pages/reader/content/content_element.dart';

abstract class Reader {
  Future<void> convert();

  Future<Map<String, Map<String, List<ContentElement>>>> convertToObjects();

  ReadDirection get readDirection;
}