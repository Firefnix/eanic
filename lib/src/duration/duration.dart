import 'dart:convert';

import 'versions.dart';

/// Determines the duration of an MP3 file by scanning the headers and summing
/// the duration.
///
/// Inspired from Eric Gilbertson's `fast-mp3-duration`, that can be found at
/// https://github.com/eric-gilbertson/fast-mp3-duration.
class DurationParser {
  DurationParser(this.bytes);

  final List<int> bytes;

  static const _zeroList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  static const _bitRates = {
    'V1Lx': _zeroList,
    'V1L1': [
      0,
      32,
      64,
      96,
      128,
      160,
      192,
      224,
      256,
      288,
      320,
      352,
      384,
      416,
      448
    ],
    'V1L2': [0, 32, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384],
    'V1L3': [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320],
    'V2Lx': _zeroList,
    'V2L1': [0, 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256],
    'V2L2': [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160],
    'V2L3': [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160],
    'VxLx': _zeroList,
    'VxL1': _zeroList,
    'VxL2': _zeroList,
    'VxL3': _zeroList,
  };
  static const _sampleRates = {
    MpegVersion.x: [0, 0, 0],
    MpegVersion.one: [44100, 48000, 32000],
    MpegVersion.two: [22050, 24000, 16000],
    MpegVersion.twoAndHalf: [11025, 12000, 8000]
  };

  static int _samples(MpegVersion version, Layer layer) => const {
        MpegVersion.x: {Layer.x: 0, Layer.one: 0, Layer.two: 0, Layer.three: 0},
        MpegVersion.one: {
          Layer.x: 0,
          Layer.one: 384,
          Layer.two: 1152,
          Layer.three: 1152,
        },
        MpegVersion.two: {
          Layer.x: 0,
          Layer.one: 384,
          Layer.two: 1152,
          Layer.three: 576,
        }
      }[version.simple]![layer]!;

  int _id3V2Offset() {
    if (latin1.decode(bytes.sublist(0, 3)) == 'ID3') {
      final id3v2Flags = bytes[5],
          footerSize = (id3v2Flags & 0x10) != 0 ? 10 : 0;

      // ID3 size encoding is crazy (7 bits in each of 4 bytes)
      final z0 = bytes[6], z1 = bytes[7], z2 = bytes[8], z3 = bytes[9];
      if ((z0 & 0x80) == 0 &&
          (z1 & 0x80) == 0 &&
          (z2 & 0x80) == 0 &&
          (z3 & 0x80) == 0) {
        int tagSize = ((z0 & 0x7f) * 2097152) +
            ((z1 & 0x7f) * 16384) +
            ((z2 & 0x7f) * 128) +
            (z3 & 0x7f);
        return 10 + tagSize + footerSize;
      }
    }
    return 0;
  }

  int _frameSize({
    required int samples,
    required Layer layer,
    required int bitRate,
    required int sampleRate,
    required int paddingBit,
  }) {
    if (layer == Layer.one) {
      return (((samples * bitRate * 125 ~/ sampleRate) + paddingBit * 4)) | 0;
    } else {
      // layer 2 or 3
      return (((samples * bitRate * 125) ~/ sampleRate) + paddingBit) | 0;
    }
  }

  _FrameInfo _parseFrameHeader(header) {
    final int b1 = header[1], b2 = header[2];

    final versionBits = (b1 & 0x18) >> 3,
        version = MpegVersion.values[versionBits];

    final int layerBits = (b1 & 0x06) >> 1;
    final Layer layer = Layer.values[layerBits];

    final bitRateKey =
            'V${version.simple.toShortString()}L${layer.toShortString()}',
        bitRateIndex = (b2 & 0xf0) >> 4,
        bitRate = _bitRates[bitRateKey]![bitRateIndex];

    final sampleRateIdx = (b2 & 0x0c) >> 2,
        sampleRate = _sampleRates[version]![sampleRateIdx];

    final sample = _samples(version, layer), paddingBit = (b2 & 0x02) >> 1;

    return _FrameInfo(
      bitRate: bitRate,
      sampleRate: sampleRate,
      frameSize: _frameSize(
        samples: sample,
        layer: layer,
        bitRate: bitRate,
        sampleRate: sampleRate,
        paddingBit: paddingBit,
      ),
      samples: sample,
    );
  }

  /// Returns the duration of the file, in seconds.
  Duration getDuration() {
    int offset = _id3V2Offset();
    double seconds = 0;

    final buffer = <int>[];
    while (offset < bytes.length) {
      for (var srcIdx = offset;
          srcIdx < bytes.length && srcIdx < offset + 10;
          srcIdx++) {
        buffer.add(bytes[srcIdx]);
      }

      if (buffer.length < 10) {
        return Duration.zero;
      }

      // Looking for 1111 1111 111X XXXX (frame synchronization bits)
      if (buffer[0] == 0xff && (buffer[1] & 0xe0) == 0xe0) {
        final info = _parseFrameHeader(buffer);
        if (info.frameSize != 0 && info.samples != 0) {
          offset += info.frameSize;
          seconds += info.samples / info.sampleRate;
        } else {
          offset++; // Corrupt file?
        }
      } else if (latin1.decode(buffer.sublist(0, 3)) == 'TAG') {
        offset += 128; // Skip over id3v1 tag size
      } else {
        offset++; // Corrupt file?
      }
    }
    return Duration(microseconds: (seconds * 1e6).toInt());
  }
}

class _FrameInfo {
  const _FrameInfo({
    required this.bitRate,
    required this.sampleRate,
    required this.frameSize,
    required this.samples,
  });

  final num bitRate;
  final int sampleRate;
  final int frameSize;
  final int samples;
}
