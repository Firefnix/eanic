import 'package:eanic/eanic.dart';

import 'picture.dart';

/// A [Tag] represents an ID3 tag (both v1 and v2).
///
/// All the fields are null if they don't appear in the file, except [other] and
/// [pictures] that are empty by default.
class Tag {
  /// Version if ID3 used
  String? version;

  /// Title of the track
  String? title;

  /// Artist of the track
  String? artist;

  /// The genre of the track.
  ///
  /// It is usually capitalized, but this library doesn't reformat it: you get
  /// it as it is in the tag.
  String? genre;

  /// Number of the track in the album
  int? trackNumber;

  /// Total number of tracks in the album
  int? trackTotal;

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

  /// The file attached pictures, sometimes called "artworks".
  ///
  /// A file can contain multiple attached pictures. To differentiate them, you
  /// can use their [PictureType].
  ///
  /// See [Picture] for more details.
  List<Picture> pictures;

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
    List<Picture>? pictures,
    Map<String, String>? other,
  })  : other = other ?? <String, String>{},
        pictures = pictures ?? <Picture>[];

  Tag merge(Tag other) => Tag(
        version: version ?? other.version,
        title: title ?? other.title,
        artist: artist ?? other.artist,
        genre: genre ?? other.genre,
        trackNumber: trackNumber ?? other.trackNumber,
        trackTotal: trackTotal ?? other.trackTotal,
        discNumber: discNumber ?? other.discNumber,
        discTotal: discTotal ?? other.discTotal,
        lyrics: lyrics ?? other.lyrics,
        comment: comment ?? other.comment,
        album: album ?? other.album,
        albumArtist: albumArtist ?? other.albumArtist,
        year: year ?? other.year,
      );

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
        pictures = map['pictures'],
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
        'pictures': pictures,
        'other': other,
      }..removeWhere((key, value) => value == null);

  @override
  String toString() => toMap().toString();
}
