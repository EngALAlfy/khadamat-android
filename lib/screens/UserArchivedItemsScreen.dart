import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/ItemWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserArchivedItemsScreen extends StatefulWidget {
  @override
  _UserProfileItemsScreenState createState() => _UserProfileItemsScreenState();
}

class _UserProfileItemsScreenState extends State<UserArchivedItemsScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<ProfileProvider>().getArchived(context);
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
        title: Text(EzLocalization.of(context).get("archive")),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          if (value.profileArchivedItemResponse == null) {
            return IsLoadingWidget();
          }

          if (value.profileArchivedItemResponse.isError ||
              value.profileArchivedItemResponse.error != null) {
            return IsErrorWidget(
              error: value.profileArchivedItemResponse.error,
              onRetry: () =>
              value
                ..getArchived(context)
                ..notify(),
            );
          }

          if (value.profileArchivedItemResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.profileArchivedItemResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.getArchived(context);
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
                  owned: true,
                  item: value.profileArchivedItemResponse.data.elementAt(index),
                );
              },
              itemCount: value.profileArchivedItemResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
