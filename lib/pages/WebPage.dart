import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebPage extends StatefulWidget{
  final String requestUrl;
  final String title;
  WebPage(this.requestUrl,this.title,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebPageState(this.requestUrl, this.title);
  }

}
class WebPageState extends State<WebPage>{
  String requestUrl;
  String title;
  WebPageState(this.requestUrl,this.title);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("request url is ${requestUrl}");
    return Scaffold(
      appBar: AppBar(
        title: new Text(title),
      ),
      body: WebView(
        initialUrl: requestUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}