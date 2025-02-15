import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../const/config.dart';

class ShopDetailPage extends StatefulWidget {
  final int year;
  final int no;
  final String shopName;
  final String address;

  const ShopDetailPage({
    super.key,
    required this.year,
    required this.no,
    required this.shopName,
    required this.address,
  });

  @override
  State<ShopDetailPage> createState() => _ShopPageDetail();
}

class _ShopPageDetail extends State<ShopDetailPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final String webViewUrl =
        '${Config.eventBaseUrl}/${widget.year}/${widget.no}';
    final String webViewName = 'test';
    _controller = WebViewController()
      ..loadRequest(Uri.parse(webViewUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        webViewName,
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.no}: ${widget.shopName}'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
