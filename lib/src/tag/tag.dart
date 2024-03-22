import 'artwork.dart';

/// A [Tag] represents an ID3 tag (both v1 and v2).
///
/// All the fields are null if they don't appear in the file, or if an error
/// occurred during their extraction ; except [other] that is empty by default.
class Tag {
  /// Version if ID3 used
  String? version;

  /// Title of the track
  String? title;

  /// Artist of the track
  String? artist;

  /// Genre of the track
  String? genre;

  /// Number of the track in the album
  String? trackNumber;

  /// Total number of tracks in the album
  String? trackTotal;

  /// Number of the disc in the artist discography
  String? discNumber;

  /// Total number of discs in the artist discography
  String? discTotal;

  /// Lyrics of the track
  String? lyrics;

  /// Custom comment
  String? comment;

  /// Album of the track
  String? album;

  /// Artist of the album
  String? albumArtist;

  /// Year of publication
  String? year;

  /// Artwork path
  Artwork? artwork;

  /// Any other tags
  Map<String, String> other;

  /// Default constructor
  Tag({
    this.version,
    this.title,
    this.artist,
    this.genre,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.lyrics,
    this.comment,
    this.album,
    this.albumArtist,
    this.year,
    this.artwork,
    Map<String, String>? other,
  }) : other = other ?? <String, String>{};

  /// Create a [Tag] from a [Map] of the tags.
  Tag.fromMap(Map<String, dynamic> map)
      : version = map['version'],
        title = map['title'],
        artist = map['artist'],
        genre = map['genre'],
        trackNumber = map['trackNumber'],
        trackTotal = map['trackTotal'],
        discNumber = map['discNumber'],
        discTotal = map['discTotal'],
        lyrics = map['lyrics'],
        comment = map['comment'],
        album = map['album'],
        albumArtist = map['albumArtist'],
        year = map['year'],
        artwork = map['artwork'],
        other = <String, String>{};

  /// Get a [Map] of the tags from a [Tag] object.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'version': version,
        'title': title,
        'artist': artist,
        'genre': genre,
        'trackNumber': trackNumber,
        'trackTotal': trackTotal,
        'discNumber': discNumber,
        'discTotal': discTotal,
        'lyrics': lyrics,
        'comment': comment,
        'album': album,
        'albumArtist': albumArtist,
        'year': year,
        'artwork': artwork,
        'other': other,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toMap().toString();
}
