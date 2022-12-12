import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/Film.dart';
import 'package:khadamat_app/models/FilmCategory.dart';
import 'package:khadamat_app/screens/videos/WatchScreen.dart';
import 'package:khadamat_app/widgets/CustomPosterWidget.dart';
import 'package:khadamat_app/widgets/CustomSliverAppbarWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class FilmDetailsScreen extends StatefulWidget {
  final Film film;
  final FilmCategory category;

  const FilmDetailsScreen({Key key, this.film, this.category})
      : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<FilmDetailsScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBarWidget(
              title: widget.film.name, image: widget.film.image),
          SliverList(
              delegate: SliverChildListDelegate([
                adBanner(),
            _moviePoster(),
                adBanner(),
            _movieOverview(),
                adBanner(),
          ]))
        ],
      ),
    );
  }

  Widget _moviePoster() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: <Widget>[
          CustomPosterWidget(
            image: widget.film.image,
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.category.name),
                  Text(
                    widget.film.name,
                    style: TextStyle(fontSize: 18),
                  ),
                  RaisedButton.icon(
                      color: Colors.deepOrangeAccent,
                      icon: Icon(Icons.play_arrow),
                      label: Text(
                        EzLocalization.of(context).get("watch")
                      ),
                      onPressed: () {
                        adFull();
                        if(widget.film.url == null || widget.film.url.isEmpty){
                          goTo(context, WatchScreen(link: API.VIDEOS_URL + "/" + widget.film.file,));
                        }else{
                          goTo(context, WatchScreen(link: widget.film.url,));
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton.icon(
                      color: Colors.greenAccent,
                      icon: Icon(Icons.download_outlined),
                      label: Text(
                        EzLocalization.of(context).get("download")
                      ),
                      onPressed: () {
                        adFull();
                        if(widget.film.url == null || widget.film.url.isEmpty){
                          launch(API.VIDEOS_URL + "/" + widget.film.file);
                        }else{
                          launch(widget.film.url);
                        }
                      }),
                ]),
          )
        ],
      ),
    );
  }

  Widget _movieOverview() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Text(widget.film.desc ?? '',
          style: TextStyle(fontSize: 18.0), textAlign: TextAlign.justify),
    );
  }
}
