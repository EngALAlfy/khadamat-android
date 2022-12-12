import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/ItemWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:khadamat_app/providers/DatabaseProvider.dart';
import 'package:provider/provider.dart';

class UserFavoriteItemsScreen extends StatefulWidget {
  @override
  _UserFavoriteItemsScreenState createState() => _UserFavoriteItemsScreenState();
}

class _UserFavoriteItemsScreenState extends State<UserFavoriteItemsScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<DatabaseProvider>().getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user();
  }

  user() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("favorite")),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          if (value.itemsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.itemsResponse.isError ||
              value.itemsResponse.error != null) {
            return IsErrorWidget(
              error: value.itemsResponse.error,
              onRetry: () =>
              value
                ..getFavorites(),
            );
          }

          if (value.itemsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.itemsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.getFavorites();
              _refreshController.refreshCompleted();
            },
            controller: _refreshController,
            enablePullDown: true,
            header: ClassicHeader(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ItemWidget(
                  index: index,
                  owned: false,
                  item: value.itemsResponse.data.elementAt(index),
                );
              },
              itemCount: value.itemsResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
