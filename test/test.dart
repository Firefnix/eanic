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
      this.genre = '(4)Disco',
      this.trackNumber = 3,
      Picture? picture,
      required this.version})
      : path = 'test/files/${name ?? version}.mp3',
        _picture = picture;

  final String path;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int trackNumber;
  final String version;

  Picture get picture => _picture ?? _defaultPicture;
  final Picture? _picture;

  static final _defaultPicture = Picture(
    description: 'Description',
    mimeType: 'image/png',
    pictureType: PictureType.frontCover,
    data: File('test/files/picture.png').readAsBytesSync(),
  );
}

abstract class TestFiles {
  static const v10 = TestFile(version: '1.0'),
      v11 = TestFile(version: '1.1'),
      v23 = TestFile(version: '2.3'),
      v24 = TestFile(version: '2.4'),
      all = [v10, v23];
}
