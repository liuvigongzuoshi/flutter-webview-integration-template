import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key, @required this.url, this.title}) : super(key: key);

  final String title;
  final String url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  void _reloadWeb() {
    _controller.future.then((webViewController) => webViewController.reload());
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  void evaluateJavascript(WebViewController controller) {
    controller
        .evaluateJavascript('window.API_OFFLINE="http://localhost:8111";true;');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller.complete(controller);
            evaluateJavascript(controller);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadWeb,
        tooltip: '刷新',
        child: Icon(Icons.refresh),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _loadHtmlFromAssets(WebViewController controller) async {
    String fileText = await rootBundle.loadString('assets/xxxxx/index.html');
    print(fileText);
    String theURI = Uri.dataFromString(
      fileText,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    setState(() {
      print(theURI);
      controller.loadUrl(theURI);
    });
  }
}
