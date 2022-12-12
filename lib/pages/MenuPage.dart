import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/screens/AboutScreen.dart';
import 'package:khadamat_app/screens/CategoriesScreen.dart';
import 'package:khadamat_app/screens/ItemsScreen.dart';
import 'package:khadamat_app/screens/PrivacyScreen.dart';
import 'package:khadamat_app/screens/ProfileScreen.dart';
import 'package:khadamat_app/screens/SettingsScreen.dart';
import 'package:khadamat_app/screens/TermsScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
        title: Text(EzLocalization.of(context).get("menu")),
      ),
      body: Column(
        children: [
          if (!kIsWeb)
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

                    return ListTile(
                      onTap: () => goTo(context, ProfileScreen()),
                      leading: value.profileResponse.data.photo != null
                          ? CachedNetworkImage(
                              imageUrl: value.profileResponse.data.method ==
                                      "password"
                                  ? API.IMAGES_URL +
                                      "/" +
                                      value.profileResponse.data.photo
                                  : value.profileResponse.data.photo,
                              width: 50,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                              ),
                              height: 50,
                              placeholder: (context, url) => IsLoadingWidget(),
                              errorWidget: (context, url, error) =>
                                  Image.asset("assets/images/user.png"),
                            )
                          : Image.asset(
                              "assets/images/user.png",
                              width: 50,
                              height: 50,
                            ),
                      title: Text(value.profileResponse.data.name),
                      subtitle: Text(value.profileResponse.data.email),
                    );
                  },
                )),
          if (!kIsWeb) Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 25),
              children: [
                ListTile(
                  leading: Icon(FontAwesome.home),
                  title: Text(EzLocalization.of(context).get("home")),
                  onTap: () => goTo(context, CategoriesScreen()),
                ),
                if(!kIsWeb)
                Divider(),
                if(!kIsWeb)
                ListTile(
                  leading: Icon(FontAwesome.list),
                  title: Text(EzLocalization.of(context).get("items")),
                  onTap: () => goTo(context, ItemsScreen()),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(EzLocalization.of(context).get("settings")),
                  onTap: () => goTo(context, SettingsScreen()),
                ),
                Divider(),
                if (!kIsWeb)
                  ListTile(
                    leading: Icon(FontAwesome.user),
                    title: Text(EzLocalization.of(context).get("profile")),
                    onTap: () => goTo(context, ProfileScreen()),
                  ),
                if (!kIsWeb) Divider(),
                ListTile(
                  leading: Icon(FontAwesome.shield),
                  title: Text(EzLocalization.of(context).get("privacy")),
                  onTap: () => goTo(context, PrivacyScreen()),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text(EzLocalization.of(context).get("terms")),
                  onTap: () => goTo(context, TermsScreen()),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(EzLocalization.of(context).get("about")),
                  onTap: () => goTo(context, AboutScreen()),
                ),
                if(!kIsWeb)
                Divider(),
                if(!kIsWeb)
                ListTile(
                  onTap: () {
                    shareApp(context);
                  },
                  leading: Icon(Icons.share),
                  title: Text(EzLocalization.of(context).get("share")),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    if(kIsWeb){
                      return openPlay();
                    }

                    reviewApp();
                  },
                  leading: Icon(Icons.star_rate_outlined),
                  title: Text(EzLocalization.of(context).get("rate")),
                ),
                if (!kIsWeb) Divider(),
                if (!kIsWeb)
                  ListTile(
                    onTap: () {
                      context.read<AuthProvider>().unAuth();
                    },
                    leading: Icon(Icons.logout),
                    title: Text(EzLocalization.of(context).get("logout")),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  reviewApp() async {
    await InAppReview.instance.openStoreListing();
  }

  shareApp(context,
      {subjectKey: "share_subject", messageKey: "share_message"}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String packageName = packageInfo.packageName;

    var subject = EzLocalization.of(context).get(subjectKey);
    String message = EzLocalization.of(context).get(messageKey) +
        "\n" +
        "https://play.google.com/store/apps/details?id=$packageName";
    Share.share(message, subject: subject);
  }
}
