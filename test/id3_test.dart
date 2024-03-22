import 'package:eanic/eanic.dart';
import 'test.dart';

void main() async {
  late Tagger tagger;
  late Tag tag;
  final file = TestFiles.v23;

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
  test('artwork', () {
    expect(tag.artwork, isA<Artwork>());
    expect(tag.artwork!.mimeType, file.artwork.mimeType);
    expect(tag.artwork!.description, file.artwork.description);
    expect(tag.artwork!.data, file.artwork.data);
    expect(tag.artwork!.pictureType, file.artwork.pictureType);
  });
}
