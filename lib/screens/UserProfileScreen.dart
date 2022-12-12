import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/screens/UserProfileItemsScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulWidget {
  final int id;

  const UserProfileScreen({Key key, this.id}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<ProfileProvider>().getUserProfile(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<ProfileProvider>(
          builder: (context, value, child) {
            if (value.userResponse.error != null ||
                value.userResponse.isError) {
              return Text("--");
            }

            if (value.userResponse.isLoading) {
              return IsLoadingWidget();
            }

            if (value.userResponse.isEmpty) {
              return Text("N/A");
            }

            return Text(value.userResponse.data.name);
          },
        ),
      ),
      body: SmartRefresher(
        child: ListView(
          padding: EdgeInsets.only(bottom: 25),
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Consumer<ProfileProvider>(
                  builder: (context, value, child) {
                    if (value.userResponse.error != null ||
                        value.userResponse.isError) {
                      return IsErrorWidget(
                        error: value.userResponse.error,
                      );
                    }

                    if (value.userResponse.isLoading) {
                      return IsLoadingWidget();
                    }

                    if (value.userResponse.isEmpty) {
                      return IsEmptyWidget();
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        value.userResponse.data.photo != null
                            ? FullScreenWidget(
                                child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 100,
                                  backgroundImage: imageProvider,
                                ),
                                imageUrl: value.userResponse.data.method ==
                                        "password"
                                    ? API.IMAGES_URL +
                                        "/" +
                                        value.userResponse.data.photo
                                    : value.userResponse.data.photo,
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
                        Text(value.userResponse.data.name),
                      ],
                    );
                  },
                )),
            Divider(),
            Consumer<ProfileProvider>(
              builder: (context, value, child) {
                if (value.userResponse.error != null ||
                    value.userResponse.isError) {
                  return Text("--");
                }

                if (value.userResponse.isLoading) {
                  return IsLoadingWidget();
                }

                if (value.userResponse.isEmpty) {
                  return ListTile(
                    onTap: () {
                        openPlay();
                    },
                    leading: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    title: Text(EzLocalization.of(context).get("connect_with")),
                  );
                }

                return ListTile(
                  onTap: () {
                    if(kIsWeb){
                      openPlay();
                    }else{
                       launch(
                          "tel://+${value.userResponse.data.phone}");
                    }
                  },
                  leading: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  title: kIsWeb ? Text(EzLocalization.of(context).get("connect_with")) : Text("+${value.userResponse.data.phone}"),
                );
              },
            ),
            Divider(),
            Consumer<ProfileProvider>(
              builder: (context, value, child) {
                return Container(
                  child: ListTile(
                    onTap: () => goTo(
                        context,
                        UserProfileItemsScreen(
                          id: value.userResponse.data.id,
                        )),
                    leading: Icon(
                      FontAwesome5Brands.adversal,
                    ),
                    title: Text(EzLocalization.of(context).get("items")),
                    trailing: (!value.userResponse.isLoading)
                        ? Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              (!value.userResponse.isEmpty)
                                  ? Text(
                                      "${value.userResponse.data.items_count}")
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
