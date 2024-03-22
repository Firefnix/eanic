import 'dart:typed_data';

import 'package:eanic/src/constants.dart';
import 'package:eanic/src/frames/frame.dart';

/// A class representing a ID3v2 attached picture.
///
/// In ID3v2 (both v2.3 and v2.4), an attached picture is represented by a frame
/// of ID `APIC`. Its maximal theoretical size is about 4.29 Gb.
class Artwork {
  /// Create an [Artwork] from raw data.
  Artwork(
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
  final ArtworkType pictureType;

  /// The actual byte data of the file.
  final Uint8List data;
}

// This was not made a constructor because [Artwork] is part of the public API.
Artwork artworkFromFrame(ApicFrame frame) => Artwork(
      description: frame.description,
      mimeType: frame.mimeType,
      pictureType: frame.pictureType ?? pictureTypes.fallback,
      data: Uint8List.fromList(frame.pictureData),
    );
