import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {

  final String url;
  const DetailPage({Key? key, required this.url}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool loader = true;
  String url = "https://jsoc.co.in/";
  WebViewController? _controller;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 10)).then((value){
      setState(() {
        loader = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loader? Center(child: CircularProgressIndicator(color: Colors.black,)) : SafeArea(
        child: Stack(
            children:[
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: widget.url,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
              ),
            ]
        ),
      ),
    );
  }
}
