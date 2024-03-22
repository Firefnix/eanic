# Eanic

Eanic is a cross-platform, pure Dart package to read and write ID3 tags. Its
name comes from Ean, the music player it has been made for.

> Please note that this package does not support tag writing yet.

## Getting started

First, you have to add `eanic` to your Dart or Flutter project. A simple `dart
pub add eanic` should do the trick. Then, import it:
```dart
import 'package:eanic:eanic.dart`;
```

The main way to use this package is to use the `Id3Tagger` class.
```dart
final tagger = Tagger('your/path/here.mp3');
// Tagger also provides a convenient `fromBytes` constructor.

Tag tag = tagger.readTagSync()!; // null is returned if the extraction fails.
print('${tag.title!}' // In the same way, all the fields of Tag are nullable.
  ' by ${tag.artist!}');

Map<String, dynamic> map = tag.toMap(); // Easy interoperability with JSON.
print(map['album']!);
```

## Sources
The standards and docs used :
  -  [ID3 on Wikipedia](https://en.wikipedia.org/wiki/ID3)
  -  [ID3v2](https://id3.org/id3v2-00)
      -  [ID3v2.3.0](https://id3.org/id3v2.3.0)
