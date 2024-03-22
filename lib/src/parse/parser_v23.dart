import 'package:eanic/src/constants.dart';
import 'package:eanic/src/tag.dart';
import 'package:eanic/src/frames.dart';

import 'parser.dart';

/// A [Parser] for ID3v2.3 tags.
class ParserV23 implements ParserV2 {
  ParserV23(this.bytes);

  @override
  final List<int> bytes;

  @override
  Tag getTag() {
    final tag = Tag();
    tag.version = Version(bytes).toString();
    for (final i in getFrames()) {
      if (i is TextFrame) {
        switch (i.id) {
          case 'TIT2':
            tag.title = i.value;
            break;
          case 'TPE1':
            tag.artist = i.value;
            break;
          case 'TALB':
            tag.album = i.value;
            break;
          default:
            tag.other[FrameNames.v23[i.id] ?? i.id] = i.value;
        }
      } else if (i is ApicFrame) {
        tag.artwork = Artwork.fromFrame(i);
      }
    }
    return tag;
  }

  @override
  List<Frame> getFrames() {
    List<Frame> frames = [];
    try {
      while (true) {
        if (frames.isEmpty) {
          frames.add(Frame.firstOf(bytes, BlockSize.header));
        } else {
          frames.add(Frame.firstOf(bytes, frames.last.endOffset));
        }
      }
    } catch (_) {
      return frames;
    }
  }
}
