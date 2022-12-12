import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EzLocalization.of(context).get("about")),
        centerTitle: true,
      ),
      body: WebView(
        allowsInlineMediaPlayback: true,
        onWebViewCreated: (controller) => _controller = controller,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: API.ABOUT_URL,
        onProgress: (progress) {
          if (progress > 90) {
            EasyLoading.dismiss(animation: true);
          }
        },
        onPageStarted: (url) => EasyLoading.show(
            dismissOnTap: false, maskType: EasyLoadingMaskType.black),
      ),
    );
  }
}
