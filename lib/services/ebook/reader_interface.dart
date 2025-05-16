import '../../enum/read_direction.dart';

abstract class Reader {
  convert();

  convertToObjects();

  ReadDirection get readDirection;
}