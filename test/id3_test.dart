import 'package:eanic/eanic.dart';
import 'test.dart';

void main() async {
  late Tagger tagger;
  late Tag tag;

  for (final file in TestFiles.all) {
    group('ID3v${file.version}', () {
      setUp(() {
        tagger = Tagger(file.path);
        tag = tagger.readTagSync()!;
      });
      test('title', () {
        expect(tag.title, file.title);
      });
      test('artist', () {
        expect(tag.artist, file.artist);
      });
      test('album', () {
        expect(tag.album, file.album);
      });
      test('genre', () {
        expect(tag.genre, file.genre);
      });
      if (file.version != '1.0') {
        test('trackNumber', () {
          expect(tag.trackNumber, file.trackNumber);
        });
      }

      if (file.version.startsWith('2')) {
        test('picture', () {
          expect(tag.pictures.length, 1);
          final picture = tag.pictures.first;
          expect(picture.mimeType, file.picture.mimeType);
          expect(picture.description, file.picture.description);
          expect(picture.data, file.picture.data);
          expect(picture.pictureType, file.picture.pictureType);
        });
      }
    });
  }
}
