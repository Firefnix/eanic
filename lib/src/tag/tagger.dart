import 'dart:io';

import 'package:eanic/src/frames.dart';
import 'package:eanic/src/parse.dart';

import 'tag.dart';

class Tagger {
  /// Create a [Tagger] the same way we would create a [File]: from its path.
  Tagger(String path) : _filePath = path;

  /// Create a [Tagger] from raw bytes.
  ///
  /// This can be useful when loading a MP3 file from a remote source.
  Tagger.fromBytes(List<int> bytes) : _providedBytes = bytes;

  String? _filePath;
  List<int>? _providedBytes;

  /// Read synchronously the ID3 tag.
  ///
  /// Returns a [Tag], or `null` if either the tag could not be read or the file
  /// does not contain any tag.
  Tag? readTagSync() => _parse(_getBytesSync());

  /// Read asynchronously the ID3 tag.
  ///
  /// Returns a [Tag], or `null` if either the tag could not be read or the file
  /// does not contain any tag.
  Future<Tag?> readTag() async => _parse(await _getBytes());

  Tag? _parse(List<int> bytes) {
    late Tag tag;
    try {
      tag = Parser.auto(bytes).getTag();
      tag.version = Version(bytes).toString();
    } catch (e) {
      print('Could not finish parsing: $e');
      return null;
    }
    return tag;
  }

  List<int> _getBytesSync() {
    if (_filePath != null) {
      final f = File(_filePath!);
      if (!f.existsSync()) {
        throw FileSystemException('File not found', _filePath);
      }
      _providedBytes = f.readAsBytesSync();
    }
    return _providedBytes!;
  }

  Future<List<int>> _getBytes() async {
    if (_filePath != null) {
      final f = File(_filePath!);
      if (!await f.exists()) {
        throw FileSystemException('File not found', _filePath);
      }
      _providedBytes = await f.readAsBytes();
    }
    return _providedBytes!;
  }
}
