import 'dart:convert';

import 'utf_16.dart';

class Utf16 extends Encoding {
  Utf16();

  factory Utf16.be() => _Utf16BE();

  factory Utf16.le() => _Utf16LE();

  @override
  final String name = 'UTF-16';

  @override
  final Converter<List<int>, String> decoder =
      SimpleConverter((a) => decodeUtf16(a));

  @override
  final Converter<String, List<int>> encoder =
      SimpleConverter((a) => encodeUtf16(a));
}

class _Utf16BE extends Utf16 {
  @override
  final String name = 'UTF-16BE';

  @override
  final Converter<List<int>, String> decoder =
      SimpleConverter((a) => decodeUtf16(a));

  @override
  final Converter<String, List<int>> encoder =
      SimpleConverter((a) => encodeUtf16be(a));
}

class _Utf16LE extends Utf16 {
  @override
  final String name = 'UTF-16LE';

  @override
  final Converter<List<int>, String> decoder =
      SimpleConverter((a) => decodeUtf16le(a));

  @override
  final Converter<String, List<int>> encoder =
      SimpleConverter((a) => encodeUtf16le(a));
}

class SimpleConverter<S, T> extends Converter<S, T> {
  SimpleConverter(this.f);

  final T Function(S a) f;

  @override
  T convert(S input) => f(input);
}
