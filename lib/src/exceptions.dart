import 'dart:io';

/// An error raised while parsing an ID3 tag.
///
/// All the errors that can occur when parsing a ID3 tag are [Id3Exception]s or
/// [FileSystemException]s (e.g. if the tagger cannot read the content of the
/// file we gave it).
class Id3Exception implements Exception {
  Id3Exception([this.message]);

  final String? message;

  @override
  String toString() => '$Id3Exception: $message';
}

class UnknownVersionException extends Id3Exception {
  @override
  String toString() =>
      '$UnknownVersionException: cannot get the ID3 version used';
}

class UnsupportedVersionException extends Id3Exception {
  UnsupportedVersionException(this.versionName);

  final String versionName;

  @override
  String toString() => '$UnsupportedVersionException: the version $versionName'
      'is not supported yet.';
}
