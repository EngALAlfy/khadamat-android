import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/Item.dart';
import 'package:khadamat_app/providers/DatabaseProvider.dart';
import 'package:khadamat_app/screens/EditItemScreen.dart';
import 'package:khadamat_app/screens/ItemsScreen.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;
  final bool owned;

  const ItemDetailsScreen({Key key, this.item, this.owned}) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  void initState() {
    Provider.of<DatabaseProvider>(context , listen: false).checkFavorite(widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _images = [
      imageWidget(widget.item.image),
    ];

    if (widget.item.image1 != null) {
      _images.add(imageWidget(widget.item.image1));
    }

    if (widget.item.image2 != null) {
      _images.add(imageWidget(widget.item.image2));
    }

    if (widget.item.image3 != null) {
      _images.add(imageWidget(widget.item.image3));
    }

    if (widget.item.image4 != null) {
      _images.add(imageWidget(widget.item.image4));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.desc ?? "desc"),
        centerTitle: true,
        backgroundColor: widget.item.sponsored == 1 ? Colors.amber[700] : null,
        actions: [
          IconButton(
            onPressed: () {
              if (kIsWeb) {
                FlutterClipboard.copy(
                        "https://khadamatapk.com/item/${widget.item.id}")
                    .then((value) => EasyLoading.showSuccess(
                        EzLocalization.of(context).get("link_copied")));
              } else {
                Share.share("https://khadamatapk.com/item/${widget.item.id}");
              }
            },
            icon: Icon(
              kIsWeb ? Icons.copy : FontAwesome5Solid.share_alt,
            ),
          ),
          Consumer<DatabaseProvider>(
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  if (value.isFavorite) {
                    Provider.of<DatabaseProvider>(context , listen: false)
                        .unFavorite(context, widget.item);
                  } else {
                    Provider.of<DatabaseProvider>(context , listen: false)
                        .favorite(context, widget.item);
                  }
                },
                icon: Icon(
                  value.isFavorite ? FontAwesome.heart : FontAwesome.heart_o,
                  color: value.isFavorite ? Colors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250.0,
              autoPlay: true,
              initialPage: 0,
            ),
            items: _images,
          ),
          Divider(),
          adBanner(),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              widget.item.desc ?? "desc",
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
            ),
          ),
          if (widget.owned)
            Container(
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.lightBlueAccent)),
                onPressed: () async {
                  goTo(
                      context,
                      ItemsScreen(
                        subsubcategory: widget.item.subsubcategory,
                      ));
                },
                child: Text(
                  "${widget.item.category?.name}->${widget.item.subcategory?.name}->${widget.item.subsubcategory?.name}",
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.visible,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 40),
            ),
          if (widget.owned)
            Container(
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber)),
                onPressed: () async {
                  goTo(
                      context,
                      EditItemScreen(
                        item: widget.item,
                      ));
                },
                icon: Icon(FontAwesome.edit, color: Colors.white),
                label: Text(
                  EzLocalization.of(context).get("edit"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
          widget.owned
              ? Container(
                  width: 0,
                  height: 0,
                )
              : Divider(),
          adBanner(),
          widget.owned
              ? Container(
                  width: 0,
                  height: 0,
                )
              : userProfile(),
          widget.owned
              ? Container(
                  width: 0,
                  height: 0,
                )
              : Divider(),
          widget.owned
              ? Container(
                  width: 0,
                  height: 0,
                )
              : Container(
                  child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue)),
                      onPressed: () async {
                        if (kIsWeb) {
                          return openPlay();
                        }

                        await launch(
                            "tel://+${widget.item.phone == null ? widget.item.created_user?.phone : widget.item.phone}");
                      },
                      icon: Icon(Icons.call, color: Colors.white),
                      label: Text(
                        kIsWeb
                            ? EzLocalization.of(context).get("connect_with")
                            : "+${widget.item.phone == null ? widget.item.created_user?.phone : widget.item.phone}",
                        style: TextStyle(color: Colors.white),
                      )),
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                ),
          widget.owned
              ? Container(
                  width: 0,
                  height: 0,
                )
              : Container(
                  child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green)),
                      onPressed: () async {
                        //if(await canLaunch(
                        //    "https://wa.me/${widget.item.created_user.phone}?text=Hello")){
                        //  await launch(
                        //      "https://wa.me/${widget.item.created_user.phone}?text=${widget.item.name}");
                        //}else{
                        //  EasyLoading.showError(EzLocalization.of(context).get("error_no_whatsapp"));
                        // }

                        //if (await canLaunch(
                        //    "https://api.whatsapp.com/send?phone=${widget.item.created_user.phone}")) {
                        //  await launch(
                        //      "https://api.whatsapp.com/send?phone=${widget.item.created_user.phone}");
                        //} else {
                        //  EasyLoading.showError(
                        //      EzLocalization.of(context).get("error_no_whatsapp"));
                        // }

                        if (kIsWeb) {
                          return openPlay();
                        }

                        final link = WhatsAppUnilink(
                          phoneNumber:
                              '+${widget.item.phone == null ? widget.item.created_user?.phone : widget.item.phone}',
                          text: "مرحبا",
                        );

                        //if (await canLaunch("$link")) {
                        await launch("$link");
                        //} else {
                        //  EasyLoading.showError(
                        //     EzLocalization.of(context).get("error_no_whatsapp"));
                        // }
                      },
                      icon: Icon(FontAwesome5Brands.whatsapp,
                          color: Colors.white),
                      label: Text(
                        kIsWeb
                            ? EzLocalization.of(context).get("connect_with")
                            : "+${widget.item.phone == null ? widget.item.created_user?.phone : widget.item.phone}",
                        style: TextStyle(color: Colors.white),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
        ],
      ),
    );
  }

  imageWidget(image) {
    return FullScreenWidget(
      child: Container(
        //width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: CachedNetworkImage(
          imageUrl: API.IMAGES_URL + "/" + image,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  userProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.item.created_user?.photo != null
            ? CachedNetworkImage(
                imageUrl:
                    API.IMAGES_URL + "/" + widget.item.created_user?.photo,
                width: 100,
                height: 100,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 100,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => IsLoadingWidget(),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/user.png"),
              )
            : Image.asset(
                "assets/images/user.png",
                width: 100,
                height: 100,
              ),
        Text(widget.item.created_user?.name ?? "username"),
        Text(
          widget.item.created_user?.email ?? "user email",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
