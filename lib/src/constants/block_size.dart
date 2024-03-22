import 'dart:convert';

import 'package:eanic/src/constants.dart';

class BlockSize {
  static const byte = 1;
  static const header = 10;
  static const name = 4;
  static const size = 4;
  static const encoding = 1;

  /// The size of a null-terminator.
  // ignore: non_constant_identifier_names
  static int NULL(Encoding encoding) {
    if (encoding is Utf16) {
      return 2;
    }
    return 1; // latin1 or utf8
  }

  /// The default maximal size for a null-terminated string.
  static const nullTermStringMaxSize = 1000; // 1 Kb
}
