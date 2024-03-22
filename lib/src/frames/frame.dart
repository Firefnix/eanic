import 'dart:convert';

import 'package:eanic/eanic.dart';
import 'package:eanic/src/constants.dart';

import 'block.dart';

/// A ID3 frame, containing an information (sometimes called "a tag").
///
/// [header] is made of: -  [id] (4 bytes), then
///                      -  [contentSize] (4 bytes), then
///                      -  Flags (2 bytes).
class Frame with Encodings {
  factory Frame.firstOf(List<int> bytes, int offset) {
    final id = Frame.firstOfBase(bytes, offset).id;
    if (RegExp(r'[A-Z0-9]{3,4}').stringMatch(id) != id) {
      throw Id3Exception('Invalid frame ID: `${id.codeUnits}`');
    }

    if (id[0] == 'T') {
      return TextFrame.firstOf(bytes, offset);
    } else if (id == 'APIC') {
      return ApicFrame.firstOf(bytes, offset);
    }
    return Frame.firstOfBase(bytes, offset);
  }

  Frame.firstOfBase(this.bytes, [this.offset = 0])
      : header = bytes.sublist(offset, offset + BlockSize.header);

  final int offset;
  final List<int> bytes;
  final List<int> header;
  late final String id = latin1.decode(header.sublist(0, BlockSize.name));
  late final int contentSize =
      _getSize(header.sublist(BlockSize.name, BlockSize.name + BlockSize.size));
  late final List<int> content = bytes.sublist(
      offset + BlockSize.header, offset + BlockSize.header + contentSize);

  int get endOffset => offset + BlockSize.header + contentSize;

  static int _getSize(List<int> sizeBlock) {
    assert(sizeBlock.length == 4);

    const BASE = 8; // should be 7 (see v2.3 doc)

    var len = sizeBlock[0] << BASE * 3;
    len += sizeBlock[1] << BASE * 2;
    len += sizeBlock[2] << BASE;
    len += sizeBlock[3];

    return len;
  }
}

/// A frame containing a single string data.
///
/// Structure: - Encoding (1 byte), and
///            - Value (until end of frame).
class TextFrame extends Frame {
  TextFrame.firstOf(List<int> bytes, [int offset = 0])
      : super.firstOfBase(bytes, offset) {
    assert(id[0] == 'T');
  }

  late Encoding encoding = encodings[content[0]] ?? defaultEncoding;

  /// The main text value of the frame.
  ///
  /// TODO: "If the text string is followed by a termination ($00 (00)) all the
  /// following information should be ignored and not be displayed." (v2.3, 4.2)
  late String value = encoding.decode(content.sublist(BlockSize.encoding));
}

/// A frame containing an attached picture.
///
/// Structure: - Encoding (1 byte), then
///            - MIME type (null-terminated), then
///            - Picture type (null-terminated), then
///            - Description (null-terminated), and finally
///            - Picture data (until end of frame).
class ApicFrame extends Frame {
  ApicFrame.firstOf(List<int> bytes, [int offset = 0])
      : super.firstOfBase(bytes, offset) {
    assert(id == 'APIC');
  }

  late final _encodingBlock = Block.byte(content, start: 0);
  late final Encoding descriptionEncoding =
      encodings[_encodingBlock.value] ?? Encodings.byDefault;

  late final _mimeBlock =
      Block.nullTerminated(content, start: _encodingBlock.end);
  late final String mimeType = defaultEncoding.decode(_mimeBlock.data);

  late final _pictureTypeBlock = Block.byte(content, start: _mimeBlock.end);

  PictureType? get pictureType {
    if (_pictureTypeBlock.value < pictureTypes.count) {
      return pictureTypes[_pictureTypeBlock.value];
    }
    return pictureTypes.fallback;
  }

  late final _descriptionBlock = Block.nullTerminated(
    content,
    start: _pictureTypeBlock.end,
    encoding: descriptionEncoding,
  );
  late final String description =
      descriptionEncoding.decode(_descriptionBlock.data);

  late final _pictureBlock = Block.length(
    content,
    start: _descriptionBlock.end,
    length: contentSize - _descriptionBlock.end,
  );
  late final List<int> pictureData = _pictureBlock.data;
}
