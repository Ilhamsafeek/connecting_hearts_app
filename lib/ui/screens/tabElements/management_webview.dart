import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_media/webview_flutter.dart';


class MAnagementWebView extends StatefulWidget {
  @override
  _MAnagementWebViewState createState() => _MAnagementWebViewState();
}

class _MAnagementWebViewState extends State<MAnagementWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
bool isLoading=true;
final _key = UniqueKey();
    var url="https://chadmin.online/dashboard/index/mobile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
                    : Stack(),
        ],
      ),
    );
      
      
      // Builder(builder: (BuildContext context) {
      //   return WebView(
          
      //     initialUrl: 'https://chadmin.online/dashboard/index/mobile',
      //     javascriptMode: JavascriptMode.unrestricted,
      //     onWebViewCreated: (WebViewController webViewController) {
      //       _controller.complete(webViewController);
      //     },
         
      //     onPageStarted: (String url) {
      //       print('Page started loading: $url');
      //     },
      //     onPageFinished: (String url) {
      //       print('Page finished loading: $url');
      //     },
      //     gestureNavigationEnabled: true,
      //   );
      // }),
    
    
    
  }



}
