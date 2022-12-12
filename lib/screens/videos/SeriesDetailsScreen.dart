import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/Series.dart';
import 'package:khadamat_app/models/SeriesCategory.dart';
import 'package:khadamat_app/models/SeriesEpisode.dart';
import 'package:khadamat_app/providers/SeriesProvider.dart';
import 'package:khadamat_app/screens/videos/WatchScreen.dart';
import 'package:khadamat_app/widgets/CustomPosterWidget.dart';
import 'package:khadamat_app/widgets/CustomSliverAppbarWidget.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SeriesDetailsScreen extends StatefulWidget {
  final Series series;
  final SeriesCategory category;

  const SeriesDetailsScreen({Key key, this.series, this.category})
      : super(key: key);

  @override
  _SeriesDetailsScreenState createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  @override
  void initState() {
    context.read<SeriesProvider>().episodes(context, widget.series.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        CustomSliverAppBarWidget(
            title: widget.series.name, image: widget.series.image),
        SliverList(
            delegate: SliverChildListDelegate([
              adBanner(),
          _seriesPoster(),
              adBanner(),
          _overview(),
              adBanner(),
          Divider(),
          _episodesView(),
              adBanner(),
        ])),
      ],
    ));
  }

  Widget _seriesPoster() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: <Widget>[
          CustomPosterWidget(
            image: widget.series.image,
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.category.name),
                  Text(
                    widget.series.name,
                    style: TextStyle(fontSize: 18),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Widget _overview() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(widget.series.desc ?? "N/A",
          style: TextStyle(fontSize: 18.0), textAlign: TextAlign.justify),
    );
  }

  Widget _episodesView() {
    return Container(
      child: Consumer<SeriesProvider>(
        builder: (context, value, child) {
          if (value.episodesResponse == null) {
            return IsLoadingWidget();
          }

          if (value.episodesResponse.isError ||
              value.episodesResponse.error != null) {
            return IsErrorWidget(
              error: value.episodesResponse.error,
              onRetry: () => value..episodes(context, widget.series.id),
            );
          }

          if (value.episodesResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.episodesResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return Container(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 20.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.episodesResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      height: 52,
                      width: 92,
                      imageUrl: API.IMAGES_URL +
                          "/" +
                          value.episodesResponse.data.elementAt(index).image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          height: 52,
                          width: 92,
                          child: Center(
                            child: CircularProgressIndicator(),
                          )),
                    ),
                  ),
                  title: Text(
                      value.episodesResponse.data.elementAt(index).name ?? '',
                      overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    value.episodesResponse.data.elementAt(index).desc ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.play_circle_outline),
                  onTap: () {
                    _episodeDialog(
                        context, value.episodesResponse.data.elementAt(index));
                  },
                  onLongPress: () {
                    _detailDialog(context,
                        name: value.episodesResponse.data.elementAt(index).name,
                        overview:
                            value.episodesResponse.data.elementAt(index).desc);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _episodeDialog(BuildContext context, SeriesEpisode episode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              episode.name ?? '',
              overflow: TextOverflow.ellipsis,
            ),
            content: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.series.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    RaisedButton.icon(
                        color: Colors.deepOrangeAccent,
                        icon: Icon(Icons.play_arrow),
                        label: Text(EzLocalization.of(context).get("watch")),
                        onPressed: () {
                          adFull();
                          if (episode.url == null ||
                              episode.url.isEmpty) {
                            goTo(
                                context,
                                WatchScreen(
                                  link: API.VIDEOS_URL + "/" + episode.file,
                                ));
                          } else {
                            goTo(
                                context,
                                WatchScreen(
                                  link: episode.url,
                                ));
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton.icon(
                        color: Colors.greenAccent,
                        icon: Icon(Icons.download_outlined),
                        label: Text(EzLocalization.of(context).get("download")),
                        onPressed: () {
                          adFull();
                          if(episode.url == null || episode.url.isEmpty){
                            launch(API.VIDEOS_URL + "/" + episode.file);
                          }else{
                            launch(episode.url);
                          }

                        }),
                  ]),
            ),
          );
        });
  }

  void _detailDialog(BuildContext context, {String name, String overview}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(name ?? '', overflow: TextOverflow.clip),
              content: Text(
                overview ?? "N/A",
                overflow: TextOverflow.clip,
              ));
        });
  }
}
