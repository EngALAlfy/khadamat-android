import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/CategoriesProvider.dart';
import 'package:khadamat_app/providers/ThemeProvider.dart';
import 'package:khadamat_app/screens/SettingsScreen.dart';
import 'package:khadamat_app/screens/search/SearchItemsScreen.dart';
import 'package:khadamat_app/widgets/CategoryWidget.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/NewItemWidget.dart';
import 'package:khadamat_app/widgets/PointsWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<CategoriesProvider>().allCategories(context);
    print("build 1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("app_name")),
        actions: [
          IconButton(
              icon: Icon(FlutterIcons.theme_light_dark_mco),
              onPressed: () {
                context.read<ThemeProvider>().toggleDark();
              }),
          IconButton(icon: Icon(FlutterIcons.setting_ant), onPressed: () {
            goTo(context, SettingsScreen());
          }),
          IconButton(icon: Icon(FlutterIcons.search_faw), onPressed: () {
            goTo(context, SearchItemsScreen());
          }),
        ],
        leading: Icon(
          FontAwesome.home,
        ),
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, value, child) {
          if (value.categoriesResponse == null) {
            return IsLoadingWidget();
          }

          if (value.categoriesResponse.isError ||
              value.categoriesResponse.error != null) {
            print(value.categoriesResponse);
            return IsErrorWidget(
              error: value.categoriesResponse.error,
              onRetry: () => value
                ..allCategories(context)
                ..notify(),
            );
          }

          if (value.categoriesResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.categoriesResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: () async {
              await value.allCategories(context);
              value..notify();
              _refreshController.refreshCompleted();
            },
            header: MaterialClassicHeader(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return NewItemWidget();
                }

                if (index == 1) {
                  return PointsWidget();
                }
                return CategoryWidget(
                  index: index,
                  category: value.categoriesResponse.data.elementAt(index - 2),
                );
              },
              itemCount: value.categoriesResponse.data.length + 2,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
