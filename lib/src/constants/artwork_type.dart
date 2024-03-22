/// Represents the type of the attached picture.
enum ArtworkType {
  /// Everything that doesn't fit the other categories.
  ///
  /// Used by default when the type of the picture
  other,

  /// A 32x32 pixels icon, `png` only (v2.3.0, 4.15).
  fileIcon,

  /// Another [fileIcon].
  otherFileIcon,

  /// The front cover of the album.
  frontCover,

  /// The back cover of the album.
  backCover,

  /// The leaflet page.
  leafletPage,
  // e.g. label side of CD
  media,

  /// Lead artist/lead performer/soloist.
  soloist,

  /// Artist or performer.
  artist,

  /// Conductor.
  conductor,

  /// Band or orchestra.
  band,

  /// Composer.
  composer,

  /// Lyricist.
  lyricist,

  /// Recording Location.
  location,

  /// During recording.
  recording,

  /// During performance.
  performance,

  /// Movie/video screen capture.
  screenCapture,

  /// A bright coloured fish, I guess. It's in the doc.
  brightColouredFish,

  /// An illustration.
  illustration,

  /// Band/artist logotype.
  artistLogotype,

  /// Publisher/Studio logotype.
  studioLogotype,
}

const pictureTypes = PictureTypes();

class PictureTypes {
  const PictureTypes();

  /// The [ArtworkType] used when it cannot be determined.
  final fallback = ArtworkType.other;

  final count = 0x15;

  /// Picture types for ID3v2.3
  operator [](int code) => {
        0x00: ArtworkType.other,
        0x01: ArtworkType.fileIcon, // 32x32 pixels, `png` only (v2.3.0, 4.15)
        0x02: ArtworkType.otherFileIcon,
        0x03: ArtworkType.frontCover,
        0x04: ArtworkType.backCover,
        0x05: ArtworkType.leafletPage,
        0x06: ArtworkType.media, // e.g. label side of CD
        0x07: ArtworkType.soloist, // Lead artist/lead performer/soloist
        0x08: ArtworkType.artist, // Artist or performer
        0x09: ArtworkType.conductor,
        0x0A: ArtworkType.band, // Band or orchestra
        0x0B: ArtworkType.composer,
        0x0C: ArtworkType.lyricist,
        0x0D: ArtworkType.location, // Recording Location
        0x0E: ArtworkType.recording, // During recording
        0x0F: ArtworkType.performance, // During performance
        0x10: ArtworkType.screenCapture,
        0x11: ArtworkType.brightColouredFish, // What the heck?
        0x12: ArtworkType.illustration,
        0x13: ArtworkType.artistLogotype, // Band/artist logotype
        0x14: ArtworkType.studioLogotype, // Publisher/Studio logotype
      }[code];
}
