







import 'package:flutter/material.dart';
import 'package:pubsnotfound/model/articles.dart';
import 'package:pubsnotfound/service/api_service.dart';

import 'customListTile.dart';


class SourcePage extends StatefulWidget {
  final Source? source;

  const SourcePage({Key? key, required this.source}) : super(key: key);

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Source Page')),
      body: FutureBuilder(
        future: apiService.getArticleWithName(newsId: widget.source?.id),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            List<Article>? articles = snapshot.data;
            return ListView.builder(
                itemCount: articles?.length,
                itemBuilder: (context, index) =>
                    customListTile(articles![index], context));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
