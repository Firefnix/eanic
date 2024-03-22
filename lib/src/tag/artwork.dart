import 'dart:typed_data';

import 'package:eanic/src/constants.dart';
import 'package:eanic/src/frames/frame.dart';

class Artwork {
  Artwork(
      {required this.description,
      required this.mimeType,
      required this.pictureType,
      required this.data});

  Artwork.fromFrame(ApicFrame frame)
      : this(
          description: frame.description,
          mimeType: frame.mimeType,
          pictureType: frame.pictureType ?? pictureTypes.fallback,
          data: Uint8List.fromList(frame.pictureData),
        );

  /// The description of the picture.
  final String description;

  /// The mime type of the image format of [data].
  ///
  /// e.g. `image/jpg` or `image/png`.
  final String mimeType;

  /// The type of the picture, for example ''
  ///
  /// If the picture type
  final PictureType pictureType;

  /// The actual byte data of the file.
  final Uint8List data;
}

