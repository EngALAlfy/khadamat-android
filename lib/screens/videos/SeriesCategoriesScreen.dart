import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/SeriesProvider.dart';
import 'package:khadamat_app/screens/videos/SeriesScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SeriesCategoriesScreen extends StatefulWidget {
  @override
  _SeriesCategoriesScreenState createState() => _SeriesCategoriesScreenState();
}

class _SeriesCategoriesScreenState extends State<SeriesCategoriesScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<SeriesProvider>().allCategories(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("series")),
      ),
      body: Consumer<SeriesProvider>(
        builder: (context, value, child) {
          if (value.categoriesResponse == null) {
            return IsLoadingWidget();
          }

          if (value.categoriesResponse.isError ||
              value.categoriesResponse.error != null) {
            return IsErrorWidget(
              error: value.categoriesResponse.error,
              onRetry: () => value..allCategories(context),
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
              _refreshController.refreshCompleted();
            },
            header: MaterialClassicHeader(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => goTo(
                      context, SeriesScreen(category:value.categoriesResponse.data.elementAt(index))),
                  leading: CachedNetworkImage(
                    imageUrl: API.IMAGES_URL + "/" + value.categoriesResponse.data.elementAt(index).image,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(value.categoriesResponse.data.elementAt(index).name),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
              itemCount: value.categoriesResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
