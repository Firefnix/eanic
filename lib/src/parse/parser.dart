import 'package:eanic/src/frames.dart';
import 'package:eanic/src/tag.dart';
import 'package:eanic/src/exceptions.dart';

import 'parser_v23.dart';

/// A [Parser] is a tool to provide a [Tag] out of bytes. It is mainly intended
/// for "reading" (not writing) purposes.
abstract class Parser {
  /// Returns the best [Parser] according to the detected version.
  static Parser auto(List<int> bytes) {
    final version = Version(bytes);
    switch (version.type) {
      case 1:
        throw UnsupportedVersionException(version.toString());
      case 2:
        return ParserV2.auto(bytes);
      default:
        throw UnsupportedVersionException(version.toString());
    }
  }

  /// The whole file's bytes, or only the tag's bytes.
  List<int> get bytes;

  /// A [Tag] object containing all the data found in [bytes].
  Tag getTag();
}

/// A ID3v2 [Parser] whose tag extraction process is based on [Frame]s.
abstract class ParserV2 extends Parser {
  /// Returns the best [Parser] according to the detected version.
  static ParserV2 auto(List<int> bytes) {
    final version = Version(bytes);
    assert(version.type == 2);
    switch (version.major) {
      case 3:
      case 4:
        return ParserV23(bytes);
      default:
        throw UnsupportedVersionException(version.toString());
    }
  }

  List<Frame> getFrames();
}
