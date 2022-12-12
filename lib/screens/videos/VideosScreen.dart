import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/screens/videos/FilmCategoriesScreen.dart';
import 'package:khadamat_app/screens/videos/SeriesCategoriesScreen.dart';

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("app_name")),
      ),
      body: GridView(children: [
        Tooltip(
          message: EzLocalization.of(context).get("films"),
          child: InkWell(
            onTap: () => goTo(context, FilmCategoriesScreen()),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepOrangeAccent,
              ),
              child: GridTile(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Image.asset("assets/images/films.png"),
                ),
                footer: Container(
                  child: Center(
                    child: Text(
                      EzLocalization.of(context).get("films"),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: EzLocalization.of(context).get("series"),
          child: InkWell(
            onTap: () => goTo(context, SeriesCategoriesScreen()),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlueAccent,
              ),
              child: GridTile(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Image.asset("assets/images/series.png"),
                ),
                footer: Container(
                  child: Center(
                    child: Text(
                      EzLocalization.of(context).get("series"),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
      ),
    );
  }
}
