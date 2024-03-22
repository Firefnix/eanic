import 'dart:convert';

import 'package:eanic/src/constants.dart';

/// A list of bytes containing a piece of data.
class Block {
  Block(this.bytes, {required this.start, required this.end, List<int>? data})
      : data = data ?? bytes.sublist(start, end);

  Block.length(List<int> bytes, {required int start, required int length})
      : this(bytes, start: start, end: start + length);

  static ByteBlock byte(List<int> bytes, {required int start}) =>
      ByteBlock(bytes, start: start);

  static NullTerminatedBlock nullTerminated(List<int> bytes,
          {required int start, int? limit, Encoding? encoding}) =>
      NullTerminatedBlock(bytes,
          start: start, limit: limit, encoding: encoding);

  final List<int> bytes;
  final int start;
  final int end;
  final List<int> data;

  late final size = data.length;

  /// Returns a block whose [data] is truncated, removing
  NullTerminatedBlock nullTruncate([Encoding? encoding]) =>
      NullTerminatedBlock.raw(
        bytes,
        start: start,
        end: end,
        data: data.sublist(
          0,
          NullTerminatedBlock.firstNullTerminatorIndex(
            data,
            limit: size,
            encoding: encoding,
          ),
        ),
      );
}

class NullTerminatedBlock extends Block {
  NullTerminatedBlock.raw(List<int> bytes,
      {required int start,
      required int end,
      List<int>? data,
      int? limit,
      Encoding? encoding})
      : limit = limit ?? BlockSize.nullTermStringMaxSize,
        encoding = encoding ?? Encodings.byDefault,
        super(bytes, start: start, end: end, data: data);

  NullTerminatedBlock(List<int> bytes,
      {required int start, int? limit, Encoding? encoding})
      : limit = limit ?? BlockSize.nullTermStringMaxSize,
        encoding = encoding ?? Encodings.byDefault,
        super(
          bytes,
          start: start,
          end: start +
              firstNullTerminatorIndex(bytes.sublist(start),
                  limit: (limit ?? BlockSize.nullTermStringMaxSize),
                  encoding: encoding) +
              BlockSize.NULL(encoding ?? Encodings.byDefault),
          data: bytes.sublist(
            start,
            start +
                firstNullTerminatorIndex(bytes.sublist(start),
                    limit: (limit ?? BlockSize.nullTermStringMaxSize),
                    encoding: encoding),
          ),
        );

  final int limit;
  final Encoding encoding;

  late final String value = encoding.decode(data);

  /// Return the index of the first '\x00'.
  static int firstNullTerminatorIndex(List<int> bytes,
      {required int limit, Encoding? encoding}) {
    final s = (encoding ?? Encodings.byDefault).decode(bytes.sublist(0, limit));
    final data = s.substring(0, s.indexOf(nullTerminator));
    return (encoding ?? Encodings.byDefault).encode(data).length;
  }
}

/// A block of one single byte.
class ByteBlock extends Block {
  ByteBlock(List<int> bytes, {required int start})
      : value = bytes[start],
        super(bytes, start: start, end: start + BlockSize.byte);

  final int value;
}
