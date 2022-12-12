import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/providers/CoinPackProvider.dart';
import 'package:khadamat_app/providers/PointsPurchasesProvider.dart';
import 'package:khadamat_app/widgets/CoinPacksWidget.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyPointsScreen extends StatefulWidget {
  @override
  _BuyPointsScreenState createState() => _BuyPointsScreenState();
}

class _BuyPointsScreenState extends State<BuyPointsScreen> {
  var _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    context.read<PointsPurchasesProvider>()
      ..setContext(context)
      ..loadPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EzLocalization.of(context).get("coins_packs")),
        centerTitle: true,
      ),
      body: Consumer<PointsPurchasesProvider>(
        builder: (context, value, child) {
          if (value.productsResponse == null) {
            return IsLoadingWidget();
          }

          if (value.productsResponse.isError ||
              value.productsResponse.error != null) {
            return IsErrorWidget(
              error: value.productsResponse.error,
              onRetry: () => value
                ..loadPurchases()
                ..notify(),
            );
          }

          if (value.productsResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.productsResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: () async {
              await value.loadPurchases();
              value.notify();
              _refreshController.refreshCompleted();
            },
            header: MaterialClassicHeader(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CoinPacksWidget(
                  coinPack:  value.productsResponse.data.elementAt(index),
                );
              },
              itemCount: value.productsResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        },
      ),
    );
  }

}
