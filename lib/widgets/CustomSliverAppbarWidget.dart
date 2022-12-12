import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:share_plus/share_plus.dart';

class CustomSliverAppBarWidget extends StatelessWidget {
  final String title;
  final String image;

  CustomSliverAppBarWidget({@required this.title, @required this.image});

  @override
  Widget build(BuildContext context) {

    return SliverAppBar(
      //backgroundColor: settings.appBackgroundColor,
      expandedHeight: MediaQuery.of(context).size.height * 0.50,
      pinned: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share(title);
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
          title: Container(
            width:  MediaQuery.of(context).size.width * 0.50,
            child: Text(title,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis),
          ),
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: API.IMAGES_URL + "/" + image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                    height:  MediaQuery.of(context).size.height * 0.50,
                    width:  MediaQuery.of(context).size.width,
                    child: CircularProgressIndicator()),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.1, 0.6, 1.0],
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.54),
                      Colors.transparent,
                      Theme.of(context).primaryColor
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
