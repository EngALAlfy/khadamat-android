import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/pages/MenuPage.dart';
import 'package:khadamat_app/screens/AddNewItem.dart';
import 'package:khadamat_app/screens/CategoriesScreen.dart';
import 'package:khadamat_app/screens/ProfileScreen.dart';
import 'package:khadamat_app/screens/YoutubeScreen.dart';
import 'package:khadamat_app/screens/videos/VideosScreen.dart';
import 'package:new_version/new_version.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _bottomNavIndex = 0;

  get iconList => [
        FontAwesome.home,
    kIsWeb ?
        FontAwesome.download
      :
        FontAwesome.user,
      AntDesign.youtube,
        SimpleLineIcons.menu,
      ];

  checkVersion(context) async {
    final newVersion = NewVersion();

    var status = await newVersion.getVersionStatus();

    if (status != null && status.canUpdate) {
      Alert(
          type: AlertType.info,
          context: context,
          title: EzLocalization.of(context).get("update"),
          desc: EzLocalization.of(context).get("update_your_app",
              {"from": status.localVersion, "to": status.storeVersion}),
          buttons: []).show();
    }
  }

  @override
  void initState() {
    if(!kIsWeb)
      checkVersion(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(kIsWeb){
            return await openPlay();
          }

          goTo(context, AddNewItem());
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor
            : Colors.white,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }

  getBody() {
    switch (_bottomNavIndex) {
      case 0:
        return CategoriesScreen();
      case 1:
        //return ItemsScreen();
        if(kIsWeb) {
          //openPlay();
          return VideosScreen();
        }
        return ProfileScreen();
      case 2:
        return VideosScreen();
      case 3:
        return MenuPage();
    }
  }
}
