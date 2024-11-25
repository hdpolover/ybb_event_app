import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class PaymentWebViewModel {
  final String url;
  final Map<String, dynamic>? body;

  const PaymentWebViewModel({required this.url, this.body});
}

class PaymentWebview extends StatefulWidget {
  final PaymentWebViewModel model;
  const PaymentWebview({super.key, required this.model});

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  final GlobalKey webViewKey = GlobalKey();
  String url = '';
  String title = '';
  double progress = 0;
  bool? isSecure;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    url = widget.model.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods().buildCommonAppBar(
        context,
        "Payment Process",
        // isBack: false,
        // message: "Are you sure you want to cancel the payment process?"
        //     "\nIf you go back, your payment process will be cancelled.",
        // onPressed: () {
        //   Navigator.of(context).pop();
        //   Navigator.of(context).pop();
        // },
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                  url: WebUri(Uri.parse(widget.model.url).toString()),
                  method: widget.model.body != null ? 'POST' : 'GET',
                  headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                  },
                  body: widget.model.body != null
                      ? Uint8List.fromList(widget.model.body!.entries
                          .map((e) => '${e.key}=${e.value}')
                          .join('&')
                          .codeUnits)
                      : null,
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  allowUniversalAccessFromFileURLs: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  transparentBackground: true,
                  supportZoom: true,
                  useWideViewPort: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  if (url != null) {
                    setState(() {
                      this.url = url.toString();
                      isSecure = urlIsSecure(url);
                    });
                  }
                },
                onLoadStop: (controller, url) async {
                  if (url != null) {
                    setState(() {
                      this.url = url.toString();
                    });
                  }

                  final sslCertificate = await controller.getCertificate();
                  setState(() {
                    isSecure = sslCertificate != null ||
                        (url != null && urlIsSecure(url));
                  });
                },
                onUpdateVisitedHistory: (controller, url, isReload) {
                  if (url != null) {
                    setState(() {
                      this.url = url.toString();
                    });
                  }
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (kDebugMode) {
                    print("Console Message: ${consoleMessage.message}");
                  }
                },
                onReceivedError: (controller, request, error) {
                  if (kDebugMode) {
                    print("Error: ${error.description}");
                  }
                },
                onReceivedHttpError: (controller, request, response) {
                  if (kDebugMode) {
                    print("HTTP error: ${response.reasonPhrase}");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool urlIsSecure(Uri url) {
    return url.scheme == 'https';
  }
}
