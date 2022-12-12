import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';

class CustomPosterWidget extends StatelessWidget {

  final String image;

  CustomPosterWidget({@required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: AspectRatio(
        aspectRatio: 2.0 / 3.0,
        child: _widget(),
      ),
    );
  }

  Widget _widget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CachedNetworkImage(
        imageUrl: API.IMAGES_URL + "/" + image,
        fit: BoxFit.cover,
        placeholder:(context, url) =>  Container(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
