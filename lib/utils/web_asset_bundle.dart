import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:jaguar/serve/server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_integration_template/utils/local_storage.dart';
import 'package:webview_integration_template/utils/unzip_asset_file.dart';

class BundleFile {
  String zipPath;
  String unZipPath;
  String sha1;

  BundleFile({this.zipPath, this.unZipPath, this.sha1});

  BundleFile.fromJson(Map<String, dynamic> json) {
    zipPath = json['zipPath'];
    unZipPath = json['unZipPath'];
    sha1 = json['sha1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zipPath'] = this.zipPath;
    data['unZipPath'] = this.unZipPath;
    data['sha1'] = this.sha1;
    return data;
  }
}

const webLocalStorageKey = "WebBundleFile";
const zipRootPath = "assets/www.zip";

Future<String> unZipWebBundle() async {
  BundleFile bundleFile;
  String webBundleFile = await LocalStorage.getString(webLocalStorageKey);
  final sha1 = await getAssetFileSha1(zipRootPath);
  bool isCached = webBundleFile != null;
  if (isCached) {
    Map<String, dynamic> bundleJson = json.decode(webBundleFile);
    bundleFile = BundleFile.fromJson(bundleJson);
    if (bundleFile.sha1 == sha1) return bundleFile.unZipPath;
  }

  final tempDir = await getApplicationDocumentsDirectory();
  // 设定要解压的目标文件夹
  final unZipPath = '${tempDir.path}/www';
  bundleFile = BundleFile(zipPath: zipRootPath, unZipPath: unZipPath, sha1: sha1);
  await deleteUnZipDirectory(unZipPath);
  await unZipAssetFile(zipRootPath, unZipPath);
  await LocalStorage.putString(webLocalStorageKey, json.encode(bundleFile.toJson()));

  return bundleFile.unZipPath;
}

startStaticService(String directory) async {
  // 启动静态服务器 Jaguar
  final server = Jaguar(address: "0.0.0.0", port: 8111);
  server.staticFiles("*", directory);
  await server.serve(logRequests: true);
  server.log.onRecord.listen((r) => print(r));
}

Future<String> getAssetFileSha1(String zipAssetPath) async {
  final ByteData ass = await rootBundle.load(zipAssetPath);
  Uint8List bytes = ass.buffer.asUint8List();
  Digest digest = sha1.convert(bytes);
  return digest.toString();
}

deleteUnZipDirectory(unZipPath) {
  // 删除解压目录文件
  Directory directory = new Directory(unZipPath);
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
}
