import 'package:ConservativeNews/helper/data.dart';
import 'package:ConservativeNews/helper/news.dart';
import 'package:ConservativeNews/model/article_model.dart';
import 'package:ConservativeNews/model/category_model.dart';
import 'package:ConservativeNews/views/article_view.dart';
import 'package:ConservativeNews/views/category_news.dart';
import 'package:ConservativeNews/views/custom_admob.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  CustomAdmob myCustomAdmob = new CustomAdmob();

  bool _loading;

  @override
  void initState() {
    _loading = true;
    categories = getCategories();
    getNews();
    super.initState();
    showBannerAd();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  showBannerAd() {
    myCustomAdmob.bannerAd()
      // typicaltargetingInfoly this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 60.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 10.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Liberal"),
              Text(
                "News",
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: _loading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          child: ListView.builder(
                              itemCount: categories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CategoryTile(
                                  imageUrl: categories[index].imageUrl,
                                  categoryName: categories[index].categoryName,
                                  newsSource: categories[index].newsGood,
                                );
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                              itemCount: articles.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return BlogTile(
                                  imageUrl: articles[index].urlToImage,
                                  desc: articles[index].description,
                                  title: articles[index].title,
                                  url: articles[index].url,
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName, newsSource;
  CategoryTile({this.imageUrl, this.categoryName, this.newsSource});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      category: newsSource,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile(
      {@required this.imageUrl,
      @required this.desc,
      @required this.title,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 12,
            ),
            Text(title,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 4,
            ),
            Text(
              desc,
              maxLines: 3,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
