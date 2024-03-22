import 'dart:convert';

import 'package:eanic/src/constants.dart';

/// A list of bytes containing a piece of data.
class Block with Encodings {
  Block(this.bytes, {required this.start, required this.end})
      : data = bytes.sublist(start, end);

  Block.length(List<int> bytes, {required int start, required int length})
      : this(bytes, start: start, end: start + length);

  Block.nullTerminated(this.bytes,
      {required this.start,
      int limit = BlockSize.nullTermStringMaxSize,
      Encoding encoding = Encodings.byDefault})
      : end = start +
            _firstNullTerminatorIndex(bytes.sublist(start),
                limit: limit, encoding: encoding) +
            BlockSize.NULL(encoding),
        data = bytes.sublist(
          start,
          start +
              _firstNullTerminatorIndex(bytes.sublist(start),
                  limit: limit, encoding: encoding),
        );

  static ByteBlock byte(List<int> bytes, {required int start}) =>
      ByteBlock(bytes, start: start);

  final List<int> bytes;
  final int start;
  final int end;
  final List<int> data;

  late final size = data.length;

  /// Return the index of the first '\x00'.
  static int _firstNullTerminatorIndex(List<int> bytes,
      {required int limit, required Encoding encoding}) {
    final s = encoding.decode(bytes.sublist(0, limit));
    final data = s.substring(0, s.indexOf(nullTerminator));
    return encoding.encode(data).length;
  }
}

/// A block of one single byte.
class ByteBlock extends Block {
  ByteBlock(List<int> bytes, {required int start})
      : value = bytes[start],
        super(bytes, start: start, end: start + BlockSize.byte);

  final int value;
}
