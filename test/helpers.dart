import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:qr_code_vision/helpers/bit_matrix.dart';
import 'package:qr_code_vision/helpers/convert_to_binary.dart';

Image bitMatrixToImage(BitMatrix matrix) {
  final output = Uint8ClampedList(matrix.width * matrix.height * 4);
  for (var y = 0; y < matrix.height; y++) {
    for (var x = 0; x < matrix.width; x++) {
      final v = matrix.get(x, y);
      final i = (y * matrix.width + x) * 4;
      output[i + 0] = v ? 0x00 : 0xff;
      output[i + 1] = v ? 0x00 : 0xff;
      output[i + 2] = v ? 0x00 : 0xff;
      output[i + 3] = 0xff;
    }
  }
  return Image.fromBytes(
    width: matrix.width,
    height: matrix.height,
    bytes: output.buffer,
  );
}

BitMatrix loadMatrix(String path) {
  final image = decodeImage(File(path).readAsBytesSync())!;
  return convertToBinary(image.getBytes(), image.width, image.height);
}

BitMatrix loadBinarized(String path) {
  final image = decodeImage(File(path).readAsBytesSync())!;
  final data = image.getBytes();
  final out = BitMatrix.createEmpty(image.width, image.height);
  for (var x = 0; x < image.width; x++) {
    for (var y = 0; y < image.height; y++) {
      out.set(x, y, data[(y * image.width + x) * 4] == 0x00);
    }
  }
  return out;
}
