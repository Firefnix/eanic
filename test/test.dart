export 'package:test/test.dart';

import 'dart:io';

import 'package:eanic/eanic.dart';
import 'package:eanic/src/constants.dart';

class TestFile {
  const TestFile(
      {String? name,
      this.title = 'Test title',
      this.album = 'Test album',
      this.artist = 'Test artist',
      Artwork? artwork,
      required this.version})
      : path = 'test/files/${name ?? version}.mp3',
        _artwork = artwork;

  final String path;
  final String title;
  final String artist;
  final String album;
  final String version;

  Artwork get artwork => _artwork ?? _defaultArtwork;
  final Artwork? _artwork;

  static final _defaultArtwork = Artwork(
    description: 'Description',
    mimeType: 'image/png',
    pictureType: ArtworkType.frontCover,
    data: File('test/files/artwork.png').readAsBytesSync(),
  );
}

abstract class TestFiles {
  static const v10 = TestFile(version: '1.0');
  static const v11 = TestFile(version: '1.1');
  static const v23 = TestFile(version: '2.3');
  static const v24 = TestFile(version: '2.4');
}
