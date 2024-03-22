import 'dart:convert';

import 'package:eanic/src/constants.dart';
import 'package:eanic/src/frames.dart';
import 'package:eanic/src/tag/tag.dart';

import 'parser.dart';

/// A parser for both ID3v1.0 and ID3v1.1.
class ParserV10 implements Parser {
  ParserV10(this.bytes) {
    assert(version.type == 1);
    assert(version.major == 0 || version.major == 1);
  }

  @override
  final List<int> bytes;

  late final version = Version(bytes);

  static final codec = latin1;

  @override
  Tag getTag() {
    final tag = Tag(version: version.toString());
    final tagBytes = bytes.sublist(bytes.length - 128);

    final header = Block.length(tagBytes, start: 0, length: 3);
    assert(codec.decode(header.data).toLowerCase() == 'tag');

    final title = Block.length(
      tagBytes,
      start: header.end,
      length: FieldSizeV10.title,
    ).nullTruncate();
    tag.title = title.value;

    final artist = Block.length(
      tagBytes,
      start: title.end,
      length: FieldSizeV10.artist,
    ).nullTruncate();
    tag.artist = artist.value;

    final album = Block.length(
      tagBytes,
      start: artist.end,
      length: FieldSizeV10.album,
    ).nullTruncate();
    tag.album = album.value;

    final year = Block.length(
      tagBytes,
      start: album.end,
      length: FieldSizeV10.year,
    ).nullTruncate();
    tag.year = year.value;

    final comment = Block.length(
      tagBytes,
      start: year.end,
      length: FieldSizeV10.comment,
    ).nullTruncate();
    tag.comment = comment.value;

    if (version.major == 1) {
      assert(Block.byte(tagBytes, start: comment.end - 2).value == NULL);
      tag.trackNumber = Block.byte(tagBytes, start: comment.end - 1).value;
    }

    final genre = Block.byte(
      tagBytes,
      start: comment.end,
    );
    tag.genre = '(${genre.value})${Genres.v10[genre.value]}';

    return tag;
  }
}
