

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pubsnotfound/model/articles.dart';

class ApiService {
  final client = http.Client();
  final endPoint =
      "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=d5a82e8ff0064231bd6500ba039c7289";

  Future<List<Article>> getArticle({String? query}) async {
    final response = await client.get(Uri.parse(endPoint));
    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['articles'];
 //   log(body.toString());
    List<Article> articles =
    body.map((dynamic item) => Article.fromJson(item)).toList();
    if (query != null) {
      articles = articles
          .where((element) =>
          element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      articles = articles
          .where((element) =>
          element.description!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      // print("api_service class ra getArticle method fetch error");
    }
    return articles;
  }

  final sourceEndPoint =
      "https://newsapi.org/v2/top-headlines/sources?apiKey=d5a82e8ff0064231bd6500ba039c7289";

  Future<List<Source>> getArticleSource({String? query}) async {
    final response = await client.get(Uri.parse(sourceEndPoint));
    //  log(response.body.toString());
    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['sources'];

    List<Source> source =
    body.map((dynamic item) => Source.fromJson(item)).toList();
    // log(articles.length.toString());
    return source;
  }

  Future<List<Article>> getArticleWithName({String? newsId}) async {
    final response = await client.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?sources=$newsId&apiKey=d5a82e8ff0064231bd6500ba039c7289"
    ));
    //  log(response.body.toString());
    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['articles'];
    //  log(body.toString());
    List<Article> article =
    body.map((dynamic item) => Article.fromJson(item)).toList();
    // log(articles.length.toString());
    return article;
  }

  Future<List<Article>> getStoreArticle() async {
    final response = await client.get(Uri.parse(endPoint));
    Map<String, dynamic> json = jsonDecode(response.body);
    List<dynamic> body = json['articles'];
  //  log(body.toString());
    List<Article> articles =
    body.map((dynamic item) => Article.fromJson(item)).toList();
    if (articles != null) {
      //   log(articles.toString());
      return articles;
    } else {
      print("api_service class ra getArticle method fetch error");
    }
    return articles;
  }

}


