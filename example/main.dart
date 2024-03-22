import 'package:eanic/eanic.dart';

void main() {
  final tagger = Tagger('your/path/here.mp3');
  // Tagger also provides a convenient `fromBytes` constructor.

  Tag tag = tagger.readTagSync()!; // null is returned if the extraction fails.
  print('${tag.title!}' // In the same way, all the fields of Tag are nullable.
      ' by ${tag.artist!}');

  Map<String, dynamic> map = tag.toMap(); // Easy interoperability with JSON.
  print(map['album']!);
}
