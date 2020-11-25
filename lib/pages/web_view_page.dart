import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key, @required this.url, this.title}) : super(key: key);

  final String title;
  final String url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _webViewController = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  _reloadWeb() {
    _webViewController.future.then((webViewController) => webViewController.reload());
  }

  _onWebViewCreated(WebViewController controller, BuildContext context) {
    _webViewController.complete(controller);
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Flutter_Toaster',
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
          initialUrl: widget.url,
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
          debuggingEnabled: false,
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

  @override
  void dispose() {
    super.dispose();
  }
}
