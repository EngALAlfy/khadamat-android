import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/Item.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/screens/EditItemScreen.dart';
import 'package:khadamat_app/screens/ItemDetailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timeago/timeago.dart' as ago;

class ItemWidget extends StatelessWidget {
  final Item item;
  final index;
  final bool owned;

  const ItemWidget({Key key, this.item, this.owned = false, this.index = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: InkWell(
          onTap: () => goTo(
              context,
              ItemDetailsScreen(
                item: item,
                owned: owned,
              )),
          child: Container(
            child: Column(
              children: [
                Badge(
                  showBadge: item.sponsored == 1,
                  child: CachedNetworkImage(
                    imageUrl: API.IMAGES_URL + "/" + item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                  badgeContent: Wrap(
                    children: [
                      Text(
                        EzLocalization.of(context).get("sponsored"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  shape: BadgeShape.square,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  badgeColor: Colors.amber,
                  elevation: 10,
                  position: BadgePosition.topEnd(top: 10, end: 10),
                  borderRadius: BorderRadius.circular(5),
                ),
                Container(
                  child: Text(item.desc),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                ),
                adBanner(),
                Divider(),
                Container(
                  color: item.sponsored == 1 ? Colors.amber : null,
                  child: info(context),
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  info(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        owned
            ? ownedMenu(context)
            : Text(EzLocalization.of(context)
                .get("by", {"name": item.created_user?.name})),
        if (owned)
          Text(EzLocalization.of(context).get("views", {"views": item.views})),
        if (item.sponsored != 1)
          Text(ago.format(DateTime.parse(item.created_at),
              locale: EzLocalization.of(context).locale.languageCode)),
      ],
    );
  }

  ownedMenu(context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        switch (result) {
          case "stop":
            stopAlert(context);
            break;
          case "start":
            startAlert(context);
            break;
          case "edit":
            goTo(
                context,
                EditItemScreen(
                  item: item,
                ));
            break;
          case "delete":
            deleteAlert(context);
            break;
          case "archive":
            Provider.of<ProfileProvider>(context , listen: false).archiveItem(context , item.id);
            break;
          case "unarchive":
            Provider.of<ProfileProvider>(context , listen: false).unarchiveItem(context , item.id);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        item.sponsored == 1
            ? PopupMenuItem<String>(
                value: "stop",
                child: Text(EzLocalization.of(context).get("stop_sponsored")))
            : PopupMenuItem<String>(
                value: "start",
                child: Text(EzLocalization.of(context).get("start_sponsored"))),
        PopupMenuItem<String>(
          value: item.archived == 1 ? "unarchive" : "archive",
          child: Text(EzLocalization.of(context)
              .get(item.archived == 1 ? "make_unarchive" : "make_archive")),
        ),
        PopupMenuItem<String>(
          value: "edit",
          child: Text(EzLocalization.of(context).get("edit")),
        ),
        PopupMenuItem<String>(
          value: "delete",
          child: Text(EzLocalization.of(context).get("delete")),
        ),
      ],
    );
  }

  deleteAlert(context) {
    Alert(
      context: context,
      title: EzLocalization.of(context).get("warn"),
      type: AlertType.warning,
      buttons: [
        DialogButton(
            color: Colors.red,
            child: Text(EzLocalization.of(context).get("yes")),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<ProfileProvider>(context, listen: false)
                  .delete(context, item.id);
            }),
        DialogButton(
            color: Colors.green,
            child: Text(EzLocalization.of(context).get("no")),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
      desc: EzLocalization.of(context).get("are_you_sure"),
    ).show();
  }

  stopAlert(context) {
    Alert(
      context: context,
      title: EzLocalization.of(context).get("warn"),
      type: AlertType.warning,
      buttons: [
        DialogButton(
            color: Colors.red,
            child: Text(EzLocalization.of(context).get("yes")),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<ProfileProvider>(context, listen: false)
                  .stopSponsored(context, item.id);
            }),
        DialogButton(
            color: Colors.green,
            child: Text(EzLocalization.of(context).get("no")),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
      desc: EzLocalization.of(context).get("are_you_sure"),
    ).show();
  }

  void startAlert(context) {
    Alert(
      context: context,
      title: EzLocalization.of(context).get("warn"),
      type: AlertType.warning,
      buttons: [
        DialogButton(
            color: Colors.red,
            child: Text(EzLocalization.of(context).get("yes")),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<ProfileProvider>(context, listen: false)
                  .startSponsored(context, item.id);
            }),
        DialogButton(
            color: Colors.green,
            child: Text(EzLocalization.of(context).get("no")),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
      desc: EzLocalization.of(context).get("are_you_sure"),
    ).show();
  }
}
