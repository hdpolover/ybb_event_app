import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class PaymentWebview extends StatefulWidget {
  final String url;
  const PaymentWebview({super.key, required this.url});

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
    url = widget.url;
  }

  static bool urlIsSecure(Uri url) {
    return (url.scheme == "https");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods().buildCommonAppBar(context, "Payment Process"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialSettings: InAppWebViewSettings(
                    transparentBackground: true,
                    safeBrowsingEnabled: true,
                    isFraudulentWebsiteWarningEnabled: true),
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                  if (!kIsWeb &&
                      defaultTargetPlatform == TargetPlatform.android) {
                    await controller.startSafeBrowsing();
                  }
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
                onTitleChanged: (controller, title) {
                  if (title != null) {
                    setState(() {
                      this.title = title;
                    });
                  }
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url;
                  if (navigationAction.isForMainFrame &&
                      url != null &&
                      ![
                        'http',
                        'https',
                        'file',
                        'chrome',
                        'data',
                        'javascript',
                        'about'
                      ].contains(url.scheme)) {
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ),
            progress < 1.0 ? const LoadingPage() : Container(),
          ],
        ),
      ),
    );
  }
}
