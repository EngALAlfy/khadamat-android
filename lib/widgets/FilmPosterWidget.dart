import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:provider/provider.dart';

class FilmPosterWidget extends StatelessWidget {
  final String image;
  final String title;
  final bool hd;
  final bool titleInPoster;
  final Function onTap;


  FilmPosterWidget({this.image, this.title, this.hd, this.onTap, this.titleInPoster});


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            bottom: 0.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                 _widget(),
                if (hd)
                  Positioned(
                      top: 5.0,
                      left: 5.0,
                      child: Icon(Icons.hd, color: Colors.white60, size: 30.0)),
                if (titleInPoster)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            backgroundColor: Colors.black45,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  )
              ],
            )),
        Positioned.fill(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: onTap,
                ))),
      ],
    );
  }

  Widget _widget() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: CachedNetworkImage(
          imageUrl: API.IMAGES_URL + "/" + image,
          fit: BoxFit.cover,

          errorWidget:(context, url, error) =>  Container(
            width: 100,
            height: 100,
            child: Center(child: Icon(Icons.error)),
          ),
          placeholder: (context, url) => Container(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
