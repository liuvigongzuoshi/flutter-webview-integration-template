import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';

Future<void> unZipAssetFile(String zipAssetPath, String unZipPath) async {
  // 加载 assets 资源
  final ByteData ass = await rootBundle.load(zipAssetPath);
  // 获取二进制内容
  Uint8List bytes = ass.buffer.asUint8List();
  // 解压
  final archive = ZipDecoder().decodeBytes(bytes);
  // 解压文件到磁盘
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final document = File('$unZipPath/$filename');
      final data = file.content as List<int>;
      bool isExists = document.existsSync();
      if (isExists) continue;

      // 同步创建文件
      document.createSync(recursive: true);
      // 将解压出来的文件内容写入到文件
      document.writeAsBytesSync(data);
    } else {
      Directory('$unZipPath/$filename')..create(recursive: true);
    }
  }
}
