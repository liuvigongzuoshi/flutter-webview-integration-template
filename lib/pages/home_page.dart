import 'package:flutter/material.dart';
import 'package:jaguar/jaguar.dart';
import 'package:path_provider/path_provider.dart';

import 'web_view_page.dart';
import '../utils/unzip_asset_file.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = 'http://localhost:8111';
  int _counter = 99;

  @override
  void initState() {
    super.initState();
    unZipFile();
  }

  unZipFile() async {
    final documents = await getApplicationDocumentsDirectory();
    const zipRootPath = "assets/www.zip";
    // 设定要解压的目标文件夹
    final unZipPath = '${documents.path}/www';
    await unZipAssetFile(zipRootPath, unZipPath);
    await startAssetsService(unZipPath);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (context) {
        return WebViewPage(url: url);
      },
      maintainState: false,
    ));
  }

  startAssetsService(String directory) async {
    // 启动静态服务器 Jaguar
    final server = Jaguar(address: "0.0.0.0", port: 8111);
    server.staticFiles("*", directory);
    await server.serve(logRequests: true);
    server.log.onRecord.listen((r) => print(r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '数据包解压中',
            ),
            Text(
              '$_counter %',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}