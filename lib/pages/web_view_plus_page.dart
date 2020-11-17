import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_integration_template/widgets/DialogPlus.dart';

// https://github.com/pichillilorenzo/flutter_inappwebview

class WebViewPlusPage extends StatefulWidget {
  WebViewPlusPage({Key key, @required this.url, this.title}) : super(key: key);

  final String title;
  final String url;

  @override
  _WebViewPlusPageState createState() => _WebViewPlusPageState();
}

class _WebViewPlusPageState extends State<WebViewPlusPage> {
  InAppWebViewController webView;
  var _lastClickExitTime;

  @override
  void initState() {
    super.initState();
  }

  _reloadWeb() {
    if (webView != null) {
      webView.reload();
    }
  }

  _onWebViewCreated(BuildContext context, InAppWebViewController controller) {
    webView = controller;

    webView.addJavaScriptHandler(
      handlerName: "Flutter_DeviceMedia",
      callback: (args) {
        MediaQueryData mediaQueryData = MediaQuery.of(context);
        Map<String, dynamic> deviceMedia = {"StatusBarHeight": mediaQueryData.padding.top};
        return deviceMedia;
      },
    );
    webView.addJavaScriptHandler(
      handlerName: "Flutter_Toaster",
      callback: (args) {
        final message = args[0].toString();
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  _pageLoadedEvaluateJavascript(BuildContext context, InAppWebViewController controller) {
    // for Android bug 7、9
    String _fixedCallJs = '''
      if (!window.flutter_inappwebview.callHandler) {
          window.flutter_inappwebview.callHandler = function () {
              var _callHandlerID = setTimeout(function () { });
              window.flutter_inappwebview._callHandler(arguments[0], _callHandlerID, JSON.stringify(Array.prototype.slice.call(arguments, 1)));
              return new Promise(function (resolve, reject) {
                  window.flutter_inappwebview[_callHandlerID] = resolve;
              });
          };
      }''';
    // 状态栏高度
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Object deviceMedia = {'StatusBarHeight': mediaQueryData.padding.top};
    controller.evaluateJavascript(source: "window.Flutter_DeviceMedia='${jsonEncode(deviceMedia)}'");
    controller.evaluateJavascript(source: _fixedCallJs);
  }

  _onConsoleMessage(BuildContext context, ConsoleMessage consoleMessage) {
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(content: Text(consoleMessage.toString())),
    // );
  }

  Future<bool> _onWillPop() {
    if (_lastClickExitTime == null || DateTime.now().difference(_lastClickExitTime) > Duration(milliseconds: 1500)) {
      _lastClickExitTime = DateTime.now();
      return Future.value(false);
    } else {
      return showDialogConfirm<bool>(
        context: context,
        title: "确认退出 App",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double _statusBarHeight = MediaQuery.of(context).padding.top;
    print("_statusBarHeight $_statusBarHeight");

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, elevation: 0),
        body: Builder(builder: (BuildContext context) {
          return InAppWebView(
            initialUrl: this.widget.url,
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(debuggingEnabled: false),
              android: AndroidInAppWebViewOptions(geolocationEnabled: false),
            ),
            onWebViewCreated: (InAppWebViewController controller) => _onWebViewCreated(context, controller),
            onLoadStart: (InAppWebViewController controller, String url) {
              print('Page started loading: $url');
            },
            onLoadStop: (InAppWebViewController controller, String url) {
              print('Page finished loading: $url');
              _pageLoadedEvaluateJavascript(context, controller);
            },
            onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
              _onConsoleMessage(context, consoleMessage);
            },
            androidOnPermissionRequest:
                (InAppWebViewController controller, String origin, List<String> resources) async {
              showDialogAlert(context: context, title: "androidOnPermissionRequest", messages: resources.toString());
              return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
            },
            androidOnGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async {
              return GeolocationPermissionShowPromptResponse(origin: origin, allow: true, retain: true);
            },
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          onPressed: _reloadWeb,
          elevation: 0,
          tooltip: '刷新',
          mini: true,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
