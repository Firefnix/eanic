import 'dart:io';

import 'package:eanic/eanic.dart';
import 'package:eanic/src/frames.dart';
import 'package:eanic/src/parse.dart';

import 'tag.dart';

/// The main class of the package, used to read an ID3 tag.
///
/// A tagger can read tags directly from bytes or from a file (given its path).
/// It can work either synchronously with [readTagSync], or asynchronously
/// with [readTag].
class Tagger {
  /// Create a [Tagger] the same way we would create a [File]: from its path.
  ///
  /// The content of the file is read only when a reading method (either
  /// [readTag] or [readTagSync]) is called.
  Tagger(String path) : _filePath = path;

  /// Create a [Tagger] from raw bytes.
  ///
  /// This can be useful when loading a MP3 file from a remote source. Changing
  /// the given [bytes] will not affect in any way the parsing process, since
  /// they are copied at instantiation.
  Tagger.fromBytes(List<int> bytes) : _providedBytes = List.from(bytes);

  String? _filePath;
  List<int>? _providedBytes;

  /// Reads synchronously the ID3 tag.
  ///
  /// Returns a [Tag], or `null` if the file does not contain any tag. If an
  /// error was encountered while reading the tag, an [Id3Exception] is raised.
  Tag? readTagSync() => _parse(_getBytesSync());

  /// Reads asynchronously the ID3 tag.
  ///
  /// Returns a [Tag], or `null` if the file does not contain any tag. If an
  /// error was encountered while reading the tag, an [Id3Exception] is raised.
  Future<Tag?> readTag() async => _parse(await _getBytes());

  Tag? _parse(List<int> bytes) {
    late Tag tag;
    try {
      tag = Parser.auto(bytes).getTag();
      tag.version = Version(bytes).toString();
    } catch (e) {
      throw Id3Exception('Could not finish parsing: $e');
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
