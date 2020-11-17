import 'package:flutter/material.dart';
import 'package:webview_integration_template/pages/web_view_page.dart';
// import 'package:webview_integration_template/pages/web_view_plus_page.dart';
import 'package:webview_integration_template/utils/web_asset_bundle.dart';

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
    final unZipPath = await unZipWebBundle();
    await startStaticService(unZipPath);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (context) => WebViewPage(url: url),
      maintainState: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
