import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/FilmsProvider.dart';
import 'package:khadamat_app/screens/videos/FilmsScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilmCategoriesScreen extends StatefulWidget {
  @override
  _FilmCategoriesScreenState createState() => _FilmCategoriesScreenState();
}

class _FilmCategoriesScreenState extends State<FilmCategoriesScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<FilmsProvider>().allCategories(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("films")),
      ),
      body: Consumer<FilmsProvider>(
        builder: (context, value, child) {
          if (value.categoriesResponse == null) {
            return IsLoadingWidget();
          }

          if (value.categoriesResponse.isError ||
              value.categoriesResponse.error != null) {
            print(value.categoriesResponse);
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
                      context, FilmsScreen(category:value.categoriesResponse.data.elementAt(index))),
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
