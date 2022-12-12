import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khadamat_app/providers/ItemsProvider.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/ItemWidget.dart';
import 'package:khadamat_app/widgets/SearchHintWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchICategoryScreen extends StatefulWidget {
  final subsubcategory_id;

  const SearchICategoryScreen({Key key, this.subsubcategory_id}) : super(key: key);
  @override
  _SearchICategoryScreenState createState() => _SearchICategoryScreenState();
}

class _SearchICategoryScreenState extends State<SearchICategoryScreen> {
  ValueNotifier notifier = ValueNotifier(false);

  var _refreshController = RefreshController(initialRefresh: false);


  @override
  Widget build(BuildContext context) {
    ItemsProvider provider = Provider.of<ItemsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: searchText(provider),
        titleSpacing: 0.0,
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, value, child) => IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: value
                    ? () {
                        provider.searchCategory(context);
                      }
                    : null),
          ),
        ],
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, value, child) {
          if (value.searchCategoryResponse.isError != null &&
              value.searchCategoryResponse.isError) {
            return IsErrorWidget(
              error: value.searchCategoryResponse.error,
            );
          }

          if (value.searchCategoryResponse.isLoading && !value.isCategorySearching) {
            return SearchHintWidget();
          }

          if (value.searchCategoryResponse.isLoading && value.isCategorySearching) {
            return IsLoadingWidget();
          }

          if (value.searchCategoryResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            controller: _refreshController,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ItemWidget(
                  index: index,
                  item: value.searchCategoryResponse.data.elementAt(index),
                );
              },
              itemCount: value.searchCategoryResponse.data.length,
            ),
          );
        },
      ),
    );
  }

  searchText(ItemsProvider provider) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: TextField(
          autofocus: true,
          controller: provider.searchCategoryController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            provider.searchCategory(context);
          },
          onChanged: (value) {
            if(value.isNotEmpty){
              notifier.value = true;
              provider.searchCategory(context);
            }else{
              notifier.value = false;
            }
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            hintText: "ادخل كلمة البحث",
            hintStyle: TextStyle(fontSize: 14, color: Colors.white),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<ItemsProvider>(context, listen: false).searchCategoryClear();
    Provider.of<ItemsProvider>(context, listen: false).search_subsubcategory_id = widget.subsubcategory_id;
    super.initState();
  }
}
