import 'dart:typed_data';

import 'package:eanic/src/constants.dart';
import 'package:eanic/src/frames.dart';

/// A class representing an ID3v2 attached picture.
///
/// Although the term "artwork" is often used to refer to attached pictures, it
/// was decided that this class would be named `Picture` because the specs don't
/// mention the word "artwork" at all (neither v2.3 nor v2.4).
///
/// In ID3v2 (both v2.3 and v2.4), an attached picture is represented by a frame
/// of ID `APIC`. Its maximal theoretical size is about 4.29 Gb.
class Picture {
  /// Create an [Picture] from raw data.
  Picture(
      {required this.description,
      required this.mimeType,
      required this.pictureType,
      required this.data});

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

// This was not made a constructor because [Picture] is part of the public API.
Picture pictureFromFrame(ApicFrame frame) => Picture(
      description: frame.description,
      mimeType: frame.mimeType,
      pictureType: frame.pictureType ?? pictureTypes.fallback,
      data: Uint8List.fromList(frame.pictureData),
    );
