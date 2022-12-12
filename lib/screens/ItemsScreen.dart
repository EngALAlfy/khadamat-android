import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/SubCategory.dart';
import 'package:khadamat_app/providers/ItemsProvider.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/screens/search/SearchICategoryScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/ItemWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ItemsScreen extends StatefulWidget {
  final SubCategory subcategory;
  final int userId;
  final category;
  final subsubcategory;

  ItemsScreen(
      {this.subcategory, this.category, this.userId, this.subsubcategory});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (widget.subsubcategory != null) {
      context.read<ItemsProvider>().subSubCategoryItems(
          context, widget.subsubcategory.id, widget.subsubcategory.subcategory_id,
          widget.subsubcategory.category_id);
    } else if (widget.subcategory != null) {
      context.read<ItemsProvider>().subCategoryItems(
          context, widget.subcategory.id, widget.subcategory.category_id);
    } else if (widget.category != null) {
      context.read<ItemsProvider>().categoryItems(context, widget.category.id);
    } else if (widget.userId != null) {
      context.read<ProfileProvider>().getItems(context);
    } else {
      context.read<ItemsProvider>().allItems(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subsubcategory != null) {
      return subsubcategory();
    }

    if (widget.subcategory != null) {
      return subcategory();
    }

    if (widget.category != null) {
      return category();
    }


    if (widget.userId != null) {
      return user();
    }

    return all();
  }

  subcategory() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.subcategory.name),
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, value, child) {
          if (value.subcategoryItemsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.subcategoryItemsResponse.isError ||
              value.subcategoryItemsResponse.error != null) {
            print(value.subcategoryItemsResponse);
            return IsErrorWidget(
              error: value.subcategoryItemsResponse.error,
              onRetry: () =>
              value
                ..subCategoryItems(context, widget.subcategory.id,
                    widget.subcategory.category_id)
                ..notify(),
            );
          }

          if (value.subcategoryItemsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.subcategoryItemsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.subCategoryItems(context, widget.subcategory.id,
                  widget.subcategory.category_id);
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
                  item: value.subcategoryItemsResponse.data.elementAt(index),
                );
              },
              itemCount: value.subcategoryItemsResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }


  subsubcategory() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.subsubcategory.name),
        actions: [
          IconButton(icon: Icon(FlutterIcons.search_faw), onPressed: () {
            goTo(context, SearchICategoryScreen(subsubcategory_id: widget.subsubcategory.id,));
          }),
        ],
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, value, child) {
          if (value.subSubcategoryItemsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.subSubcategoryItemsResponse.isError ||
              value.subSubcategoryItemsResponse.error != null) {
            print(value.subSubcategoryItemsResponse);
            return IsErrorWidget(
              error: value.subSubcategoryItemsResponse.error,
              onRetry: () =>
              value
                ..subSubCategoryItems(context, widget.subsubcategory.id,
                    widget.subsubcategory.subcategory_id , widget.subsubcategory.category_id)
                ..notify(),
            );
          }

          if (value.subSubcategoryItemsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.subSubcategoryItemsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.subSubCategoryItems(context, widget.subsubcategory.id,
                  widget.subsubcategory.subcategory_id , widget.subsubcategory.category_id);
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
                  item: value.subSubcategoryItemsResponse.data.elementAt(index),
                );
              },
              itemCount: value.subSubcategoryItemsResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }

  user() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("your_items")),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          if (value.profileItemResponse == null) {
            return IsLoadingWidget();
          }

          if (value.profileItemResponse.isError ||
              value.profileItemResponse.error != null) {
            print(value.profileItemResponse);
            return IsErrorWidget(
              error: value.profileItemResponse.error,
              onRetry: () =>
              value
                ..getItems(context)
                ..notify(),
            );
          }

          if (value.profileItemResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.profileItemResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.getItems(context);
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
                  item: value.profileItemResponse.data.elementAt(index),
                );
              },
              itemCount: value.profileItemResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }

  category() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.subcategory.name),
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, value, child) {
          if (value.subcategoryItemsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.subcategoryItemsResponse.isError ||
              value.subcategoryItemsResponse.error != null) {
            print(value.subcategoryItemsResponse);
            return IsErrorWidget(
              error: value.subcategoryItemsResponse.error,
              onRetry: () =>
              value
                ..subCategoryItems(context, widget.subcategory.id,
                    widget.subcategory.category_id)
                ..notify(),
            );
          }

          if (value.subcategoryItemsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.subcategoryItemsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.subCategoryItems(context, widget.subcategory.id,
                  widget.subcategory.category_id);
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
                  item: value.subcategoryItemsResponse.data.elementAt(index),
                );
              },
              itemCount: value.subcategoryItemsResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }

  all() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(EzLocalization.of(context).get("items")),
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, value, child) {
          if (value.allItemsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.allItemsResponse.isError ||
              value.allItemsResponse.error != null) {
            print(value.allItemsResponse);
            return IsErrorWidget(
              error: value.allItemsResponse.error,
              onRetry: () =>
              value
                ..allItems(context)
                ..notify(),
            );
          }

          if (value.allItemsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.allItemsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            onRefresh: () async {
              await value.allItems(context);
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
                  item: value.allItemsResponse.data.elementAt(index),
                );
              },
              itemCount: value.allItemsResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
