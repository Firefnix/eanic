import 'dart:convert';

import 'package:eanic/src/exceptions.dart';

/// Parses, and describes an ID3 version and its characteristics.
///
/// Let's take for example, v2.4.0:
///   -  `2` is the [type] (ID3v1 or ID3v2)
///   -  `4` is the [major] version
///   -  `0` is the [minor] version
class Version {
  factory Version(List<int> bytes) {
    final base = Version.base(bytes);
    if (base._isV1) {
      return Version1(bytes);
    } else if (base._isV2) {
      return Version2(bytes);
    }
    throw UnknownVersionException();
  }

  Version.base(this.bytes) {
    if (!canParse()) throw UnknownVersionException();
  }

  final List<int> bytes;

  /// Either `1` (for ID3v1.x) or `2` (for ID3v2.x);
  int get type => _isV2 ? 2 : 1;

  int? get major => null;

  int? get minor => null;

  final Encoding encoding = latin1;

  bool canParse() => _isV2 || _isV1;

  bool get _isV2 => latin1.decode(bytes.sublist(0, 3)) == 'ID3';

  bool get _isV1 {
    final v1Tag = bytes.sublist(bytes.length - 128).sublist(0, 3);
    return latin1.decode(v1Tag).toLowerCase() == 'tag';
  }

  @override
  String toString() => '$type.$major.$minor';
}

class Version2 extends Version {
  Version2(List<int> bytes) : super.base(bytes) {
    assert(type == 2);
  }

  @override
  Encoding get encoding => throw UnimplementedError();

  @override
  late final int major = bytes[3];

  @override
  late final int minor = bytes[4];
}

class Version1 extends Version {
  Version1(List<int> bytes) : super.base(bytes) {
    assert(type == 1);
  }

  late final tail = bytes.sublist(bytes.length - 128);

  // ID3v1.2 is not supported yet.
  @override
  int get major => tail[125] == 0 ? 1 : 0;

  @override
  final int minor = 0;
}
