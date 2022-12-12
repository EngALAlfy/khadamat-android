import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:images_picker/images_picker.dart';
import 'package:khadamat_app/screens/UserFavoriteItemsScreen.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/screens/AddNewItem.dart';
import 'package:khadamat_app/screens/ItemsScreen.dart';
import 'package:khadamat_app/screens/UserArchivedItemsScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'BuyPointsScreen.dart';
import 'SettingsScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<ProfileProvider>().getProfile(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("profile")),
      ),
      body: SmartRefresher(
        child: ListView(
          padding: EdgeInsets.only(bottom: 25),
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Consumer<ProfileProvider>(
                  builder: (context, value, child) {
                    if (value.profileResponse.error != null ||
                        value.profileResponse.isError) {
                      return IsErrorWidget(
                        error: value.profileResponse.error,
                      );
                    }

                    if (value.profileResponse.isLoading) {
                      return IsLoadingWidget();
                    }

                    if (value.profileResponse.isEmpty) {
                      return IsEmptyWidget();
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Badge(
                          child: value.profileResponse.data.photo != null
                              ? FullScreenWidget(
                                  child: CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 100,
                                    backgroundImage: imageProvider,
                                  ),
                                  imageUrl: value.profileResponse.data.method ==
                                          "password"
                                      ? API.IMAGES_URL +
                                          "/" +
                                          value.profileResponse.data.photo
                                      : value.profileResponse.data.photo,
                                  width: 100,
                                  height: 100,
                                  placeholder: (context, url) =>
                                      IsLoadingWidget(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/images/user.png"),
                                ))
                              : Image.asset(
                                  "assets/images/user.png",
                                  width: 100,
                                  height: 100,
                                ),
                          badgeContent: Container(
                            child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await Permission.storage.request();

                                  Alert(
                                    title: EzLocalization.of(context)
                                        .get("pick_image"),
                                    context: context,
                                    content: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.image),
                                          title: Text(EzLocalization.of(context)
                                              .get("gallery")),
                                          onTap: () async {
                                            final ImagePicker _picker =
                                                ImagePicker();
                                            // Pick an image
                                            XFile image =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            value.photo = image.path;
                                            value.updatePhoto(context);
                                          },
                                        ),
                                        ListTile(
                                          leading:
                                              Icon(Icons.camera_alt_outlined),
                                          title: Text(EzLocalization.of(context)
                                              .get("camera")),
                                          onTap: () async {
                                            final ImagePicker _picker =
                                                ImagePicker();
                                            // Capture a photo
                                            XFile photo =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);

                                            value.photo = photo.path;
                                            value.updatePhoto(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ).show();

                                  /*
                                List<Media> res = await ImagesPicker.pick(
                                  count: 1,
                                  language: Language.English,
                                  quality: 0.7,
                                  cropOpt:
                                      CropOption(cropType: CropType.circle),
                                  pickType: PickType.image,
                                );

                                value.photo = res.first.path;
                                value.updatePhoto(context);

                                 */
                                }),
                            width: 35,
                            height: 35,
                          ),
                          toAnimate: true,
                          position: BadgePosition.bottomEnd(bottom: 1, end: 1),
                          padding: EdgeInsets.all(0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(value.profileResponse.data.name),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                var _nameController = TextEditingController(
                                    text: value.profileResponse.data.name);
                                Alert(
                                  context: context,
                                  title: EzLocalization.of(context)
                                      .get("edit_name"),
                                  content: TextField(
                                    decoration: InputDecoration(
                                        labelText: EzLocalization.of(context)
                                            .get("name")),
                                    controller: _nameController,
                                  ),
                                  buttons: [
                                    DialogButton(
                                        child: Text(EzLocalization.of(context)
                                            .get("ok")),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          value.updateName(
                                              context, _nameController.text);
                                        })
                                  ],
                                ).show();
                              },
                              iconSize: 20,
                            ),
                          ],
                        ),
                        Text(
                          value.profileResponse.data.email ?? "--",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  },
                )),
            Divider(),
            ListTile(
              leading: Icon(FontAwesome.heart),
              title: Text(EzLocalization.of(context).get("favorite")),
              onTap: () => goTo(context, UserFavoriteItemsScreen()),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            Consumer<ProfileProvider>(
              builder: (context, value, child) {
                return Container(
                  child: ListTile(
                    onTap: () => goTo(context, BuyPointsScreen()),
                    leading: Icon(
                      FlutterIcons.coin_mco,
                      color: Colors.amber,
                    ),
                    title:
                        Text(EzLocalization.of(context).get("points_balance")),
                    trailing: (!value.profileResponse.isLoading)
                        ? Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              (!value.profileResponse.isEmpty)
                                  ? Text("${value.profileResponse.data.points}")
                                  : Text("0"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          )
                        : CircularProgressIndicator(),
                  ),
                );
              },
            ),
            Divider(),
            Consumer<ProfileProvider>(
              builder: (context, value, child) {
                if (value.profileResponse.error != null ||
                    value.profileResponse.isError) {
                  return IsErrorWidget(
                    error: value.profileResponse.error,
                  );
                }

                if (value.profileResponse.isLoading) {
                  return IsLoadingWidget();
                }

                if (value.profileResponse.isEmpty) {
                  return IsEmptyWidget();
                }
                return ListTile(
                  onTap: () {
                    FlutterClipboard.copy('https://khadamatapk.com/profile/${value.profileResponse.data.id}').then((value) {
                      EasyLoading.showSuccess(EzLocalization.of(context).get("link_copied"));
                    });
                  },
                  leading: Icon(
                    Icons.copy,
                  ),
                  title: Text(EzLocalization.of(context).get("copy_profile_link")),
                );
              },
            ),

            Divider(),
            ListTile(
              onTap: () => goTo(context, AddNewItem()),
              leading: Icon(
                Icons.add,
                color: Colors.green,
              ),
              title: Text(EzLocalization.of(context).get("new_item")),
            ),
            Divider(),
            Consumer<ProfileProvider>(
              builder: (context, value, child) {
                return Container(
                  child: ListTile(
                    onTap: () => goTo(
                        context,
                        ItemsScreen(
                          userId: value.profileResponse.data.id,
                        )),
                    leading: Icon(
                      FontAwesome5Brands.adversal,
                    ),
                    title: Text(EzLocalization.of(context).get("your_items")),
                    trailing: (!value.profileResponse.isLoading)
                        ? Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              (!value.profileResponse.isEmpty)
                                  ? Text(
                                      "${value.profileResponse.data.items_count}")
                                  : Text("0"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          )
                        : CircularProgressIndicator(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text(EzLocalization.of(context).get("archive")),
              onTap: () => goTo(context, UserArchivedItemsScreen()),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(EzLocalization.of(context).get("settings")),
              onTap: () => goTo(context, SettingsScreen()),
            ),
            Divider(),
            ListTile(
              onTap: () {
                context.read<AuthProvider>().unAuth();
              },
              leading: Icon(Icons.logout),
              title: Text(EzLocalization.of(context).get("logout")),
            ),
          ],
        ),
        header: ClassicHeader(),
        onRefresh: () {
          context.read<ProfileProvider>().getProfile(context);
          _refreshController.refreshCompleted();
        },
        controller: _refreshController,
      ),
    );
  }
}
