import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pubsnotfound/search/SearchNews.dart';
import 'package:pubsnotfound/service/api_service.dart';
import 'Component/customListTile.dart';
import 'Component/sourceTab.dart';
import 'model/articles.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  // await Hive.initFlutter();
  Hive.registerAdapter(SourceAdapter());
  Hive.registerAdapter(ArticleAdapter());
  //await Hive.openBox<Article>('articles');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService client = ApiService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('News App'),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: const Icon(Icons.search_sharp),
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.source)),
                Tab(
                  icon: Icon(Icons.article),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [ListWidget(client: client), SourceTab(client: client)],
          ),
        ),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  final ApiService client;
  const ListWidget({Key? key, required this.client}) : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  void initState() {
    super.initState();
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getArticles(),
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
        //   log(snapshot.data.toString());
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
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getArticles(),
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
        //   log(snapshot.data.toString());
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
    );
  }
*/

  Future<List<Article>> getArticles() async {
   final box  =  await Hive.openBox<Article>('articles');
     final posts = box.values.toList();
     log(posts.toString());
     if(posts.isNotEmpty) {
       return posts;
     } else{
    final a = await widget.client.getStoreArticle();
    box.addAll(a);
    return a;
    }
  }
}

class SourceTab extends StatefulWidget {
  final ApiService client;
  const SourceTab({Key? key, required this.client}) : super(key: key);

  @override
  _SourceTabState createState() => _SourceTabState();
}

class _SourceTabState extends State<SourceTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client.getArticleSource(),
      builder: (BuildContext context, AsyncSnapshot<List<Source>> snapshot) {
        //   log(snapshot.data.toString());
        if (snapshot.hasData) {
          List<Source>? articles = snapshot.data;
          return ListView.builder(
              itemCount: articles?.length,
              itemBuilder: (context, index) =>
                  customSourceListTile(articles![index], context));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
