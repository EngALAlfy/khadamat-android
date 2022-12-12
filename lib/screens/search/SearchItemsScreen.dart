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

class SearchItemsScreen extends StatefulWidget {
  @override
  _SearchItemsScreenState createState() => _SearchItemsScreenState();
}

class _SearchItemsScreenState extends State<SearchItemsScreen> {
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
                        provider.search(context);
                      }
                    : null),
          ),
        ],
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, value, child) {
          if (value.searchResponse.isError != null &&
              value.searchResponse.isError) {
            return IsErrorWidget(
              error: value.searchResponse.error,
            );
          }

          if (value.searchResponse.isLoading && !value.isSearching) {
            return SearchHintWidget();
          }

          if (value.searchResponse.isLoading && value.isSearching) {
            return IsLoadingWidget();
          }

          if (value.searchResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            controller: _refreshController,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ItemWidget(
                  index: index,
                  item: value.searchResponse.data.elementAt(index),
                );
              },
              itemCount: value.searchResponse.data.length,
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
          controller: provider.searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            provider.search(context);
          },
          onChanged: (value) {
            if(value.isNotEmpty){
              notifier.value = true;
              provider.search(context);
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
    Provider.of<ItemsProvider>(context, listen: false).searchClear();
    super.initState();
  }
}
