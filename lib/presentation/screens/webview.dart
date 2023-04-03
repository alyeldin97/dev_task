import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatelessWidget {
  String url;
  AppWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
        ),
      )
      ..loadRequest(Uri.parse(url));
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
