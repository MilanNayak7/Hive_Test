


import 'package:flutter/material.dart';
import 'package:pubsnotfound/model/articles.dart';
import 'package:pubsnotfound/pages/articles_details_page.dart';
import 'package:pubsnotfound/service/api_service.dart';

class SearchUser extends SearchDelegate {
  ApiService _userList = ApiService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Article>>(
        future: _userList.getArticle(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Article>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Container(
                        height:50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(data![index].urlToImage??"")
                            )
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data[index].author}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${data[index].title}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticlePage(article: data[index])
                        )
                    );
                  },
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search News'),
    );
  }
}
