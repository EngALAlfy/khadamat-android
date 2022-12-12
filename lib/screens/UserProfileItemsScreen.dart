import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/ItemWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserProfileItemsScreen extends StatefulWidget {

  final int id;

  const UserProfileItemsScreen({Key key, this.id}) : super(key: key);
  @override
  _UserProfileItemsScreenState createState() => _UserProfileItemsScreenState();
}

class _UserProfileItemsScreenState extends State<UserProfileItemsScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<ProfileProvider>().getUserItems(context , widget.id);
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
        title: Text(EzLocalization.of(context).get("items")),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          if (value.userItemResponse == null) {
            return IsLoadingWidget();
          }

          if (value.userItemResponse.isError ||
              value.userItemResponse.error != null) {
            return IsErrorWidget(
              error: value.userItemResponse.error,
              onRetry: () =>
              value
                ..getUserItems(context , widget.id)
                ..notify(),
            );
          }

          if (value.userItemResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.userItemResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.getUserItems(context , widget.id);
              value.notify();
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
                  item: value.userItemResponse.data.elementAt(index),
                );
              },
              itemCount: value.userItemResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
