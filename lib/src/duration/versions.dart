enum Layer { x, three, two, one } // WARNING: The order matters.

enum MpegVersion { twoAndHalf, x, two, one } // WARNING: The order matters.

extension LayerMethods on Layer {
  String toShortString() {
    switch (this) {
      case Layer.x:
        return 'x';
      case Layer.three:
        return '3';
      case Layer.two:
        return '2';
      case Layer.one:
        return '1';
    }
  }
}

extension MpegVersionMethods on MpegVersion {
  MpegVersion get simple =>
      this == MpegVersion.twoAndHalf ? MpegVersion.two : this;

  String toShortString() {
    switch (this) {
      case MpegVersion.twoAndHalf:
        return '2.5';
      case MpegVersion.x:
        return 'x';
      case MpegVersion.two:
        return '2';
      case MpegVersion.one:
        return '1';
    }
  }
}
