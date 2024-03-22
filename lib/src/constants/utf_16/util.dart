// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library utf.util;

import 'constants.dart';
import 'list_range.dart';
import 'code_unit_decoder.dart';

/// Decodes the utf16 codeunits to codepoints.
List<int> utf16CodeUnitsToCodepoints(List<int> utf16CodeUnits,
    [int offset = 0,
    int? length,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
  var source = (ListRange(utf16CodeUnits, offset, length)).iterator;
  var decoder =
      Utf16CodeUnitDecoder.fromListRangeIterator(source, replacementCodepoint);
  var codepoints = List<int>.filled(source.remaining, 0);
  var i = 0;
  while (decoder.moveNext()) {
    codepoints[i++] = decoder.current!;
  }
  if (i == codepoints.length) {
    return codepoints;
  } else {
    var codepointTrunc = List<int>.filled(i, 0);
    codepointTrunc.setRange(0, i, codepoints);
    return codepointTrunc;
  }
}

/// Encode code points as UTF16 code units.
List<int> codepointsToUtf16CodeUnits(List<int> codepoints,
    [int offset = 0,
    int? length,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
  var listRange = ListRange(codepoints, offset, length);
  var encodedLength = 0;
  for (var value in listRange) {
    if ((value! >= 0 && value < unicodeUtf16ReservedLo) ||
        (value > unicodeUtf16ReservedHi && value <= unicodePlaneOneMax)) {
      encodedLength++;
    } else if (value > unicodePlaneOneMax &&
        value <= unicodeValidRangeMax) {
      encodedLength += 2;
    } else {
      encodedLength++;
    }
  }

  var codeUnitsBuffer = List<int>.filled(encodedLength, 0);
  var j = 0;
  for (var value in listRange) {
    if ((value! >= 0 && value < unicodeUtf16ReservedLo) ||
        (value > unicodeUtf16ReservedHi && value <= unicodePlaneOneMax)) {
      codeUnitsBuffer[j++] = value;
    } else if (value > unicodePlaneOneMax &&
        value <= unicodeValidRangeMax) {
      var base = value - unicodeUtf16Offset;
      codeUnitsBuffer[j++] = unicodeUtf16SurrogateUnit0Base +
          ((base & unicodeUtf16HiMask) >> 10);
      codeUnitsBuffer[j++] =
          unicodeUtf16SurrogateUnit1Base + (base & unicodeUtf16LoMask);
    } else {
      codeUnitsBuffer[j++] = replacementCodepoint;
    }
  }
  return codeUnitsBuffer;
}
