import 'dart:convert';

import 'utf_16/encodings.dart';

mixin Encodings {
  final defaultEncoding = byDefault;

  // Only to be used as a constant.
  static const byDefault = latin1;

  /// Gives the encoding corresponding to a text frame (ID3v2 only).
  final Map<int, Encoding> encodings = {
    0x00: latin1,
    0x01: Utf16(), // should be UCS-2 encoded Unicode with BOM (v2.2 and v2.3)
    0x02: Utf16.be(), // should be UTF-16BE encoded Unicode without BOM (v2.4)
    0X03: utf8, // v2.4 only
  };
}
