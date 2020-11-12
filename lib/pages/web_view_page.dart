import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({Key key, @required this.url, this.title}) : super(key: key);

  final String title;
  final String url;
  final Completer<WebViewController> _webViewController = Completer<WebViewController>();

  _reloadWeb() {
    _webViewController.future.then((webViewController) => webViewController.reload());
  }

  _onWebViewCreated(WebViewController controller, BuildContext context) {
    _webViewController.complete(controller);
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

  initEvaluateJavascript(BuildContext context) {
    _webViewController.future.then((controller) {
      // controller.evaluateJavascript("");
    });
  }

  @override
  Widget build(BuildContext context) {
    double _statusBarHeight = MediaQuery.of(context).padding.top;
    print("_statusBarHeight $_statusBarHeight");

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) => _onWebViewCreated(controller, context),
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            initEvaluateJavascript(context);
          },
          gestureNavigationEnabled: true,
          debuggingEnabled: true,
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadWeb,
        tooltip: '刷新',
        mini: true,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
