import 'dart:math';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:khadamat_app/providers/LocaleProvider.dart';
import 'package:khadamat_app/providers/ThemeProvider.dart';
import 'package:khadamat_app/screens/AboutScreen.dart';
import 'package:khadamat_app/screens/PrivacyScreen.dart';
import 'package:khadamat_app/screens/TermsScreen.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ValueNotifier cacheNotifier = ValueNotifier<String>('--');
  ValueNotifier versionNotifier = ValueNotifier<String>('--');

  @override
  void initState() {
    getLang();
    if(!kIsWeb) {
      getCacheSize();
      getVersion();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("settings")),
      ),
      body: ListView(
        children: [
          ListTile(
              leading: Icon(Icons.language),
              title: Text(EzLocalization.of(context).get("language")),
              onTap: () => langAlert(),
              trailing: Consumer<LocaleProvider>(
                builder: (context, value, child) {
                  if (value.isSettingsLocaleLoaded) {
                    return Text(value.settingsLocale != null
                        ? value.settingsLocale.languageCode
                        : "N/A");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )),
          Divider(),
          Consumer<ThemeProvider>(
            builder: (context, ThemeProvider value, child) {
              if (value.isDarkLoaded) {
                return ListTile(
                  trailing: Switch(
                    value: value.isDark == null ? false : value.isDark,
                    onChanged: (dark) => value.setDark(dark),
                  ),
                  leading: Icon(MaterialCommunityIcons.weather_night),
                  title: Text(EzLocalization.of(context).get("dark_mode")),
                );
              } else {
                return IsLoadingWidget();
              }
            },
          ),
          if(!kIsWeb)
          Divider(),
          if(!kIsWeb)
          ListTile(
            onTap: () async {
              emptyCache();
            },
            trailing: ValueListenableBuilder(
              valueListenable: cacheNotifier,
              builder: (context, value, child) => Text(value),
            ),
            leading: Icon(FlutterIcons.cached_mdi),
            title: Text(EzLocalization.of(context).get("clear_cache")),
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesome.shield),
            title: Text(EzLocalization.of(context).get("privacy")),
            onTap: () => goTo(context, PrivacyScreen()),
          ),
          Divider(),
          ListTile(
            leading: Icon(Feather.lock),
            title: Text(EzLocalization.of(context).get("terms")),
            onTap: () => goTo(context, TermsScreen()),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(EzLocalization.of(context).get("about")),
            onTap: () => goTo(context, AboutScreen()),
          ),
          Divider(),
          ListTile(
            onTap: () {
              shareApp(context);
            },
            leading: Icon(Icons.share),
            title: Text(EzLocalization.of(context).get("share")),
          ),
          Divider(),
          ListTile(
            onTap: () async {
              if(kIsWeb){
                return openPlay();
              }

              await InAppReview.instance.openStoreListing();
            },
            leading: Icon(Icons.star_rate_outlined),
            title: Text(EzLocalization.of(context).get("rate")),
          ),
          if(!kIsWeb)
          Divider(),
          if(!kIsWeb)
          ListTile(
            leading: Icon(MaterialIcons.update),
            title: Text(EzLocalization.of(context).get("update")),
            subtitle: ValueListenableBuilder(
              valueListenable: versionNotifier,
              builder: (context, value, child) => Text(value),
            ),
          ),

        ],
      ),
    );
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
  getCacheSize() async {
    var temp = (await getTemporaryDirectory())
        .listSync(recursive: true, followLinks: false);
    int bytes = 0;

    temp.forEach((element) {
      bytes += element.statSync().size;
    });

    if (bytes <= 0) {
      return cacheNotifier.value = '0 B';
    }

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1000)).floor();
    print(i);
    return cacheNotifier.value =
        (bytes / pow(1000, i)).toStringAsFixed(2) + ' ' + suffixes[i];
  }

  emptyCache() async {
    var temp = (await getTemporaryDirectory()).listSync();

    temp.forEach((element) {
      element.deleteSync(recursive: true);
    });

    getCacheSize();
  }

  getLang() {
    context.read<LocaleProvider>().getSettingsLocale(context);
  }

  setLang(lang) {
    context.read<LocaleProvider>().setLocale(context, lang);
  }

  langAlert() {
    Alert(
      context: context,
      title: EzLocalization.of(context).get("language"),
      content: Column(
        children: [
          DialogButton(
              child: Text("عربي"),
              onPressed: () {
                setLang("ar");
              }),
          DialogButton(
              child: Text("English"),
              onPressed: () {
                setLang("en");
              }),
        ],
      ),
      buttons: [],
    ).show();
  }

  getVersion() async {
    final newVersion = NewVersion();

    var status = await newVersion.getVersionStatus();

    if (status.canUpdate) {
      versionNotifier.value = EzLocalization.of(context).get("new_version_available" , {"version" : status.localVersion , "new":status.storeVersion});
    } else {
      versionNotifier.value =  EzLocalization.of(context).get("current_version" , {"version" : status.localVersion});
    }
  }
}
