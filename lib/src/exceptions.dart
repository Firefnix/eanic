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
