
import 'package:flutter/material.dart';
import 'package:pubsnotfound/model/articles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatelessWidget {
  final Article article;
  ArticlePage({required this.article});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(article.title??"")),
        body: WebView(
          initialUrl: article.url,
          javascriptMode: JavascriptMode.unrestricted,
        )
    );
  }


}