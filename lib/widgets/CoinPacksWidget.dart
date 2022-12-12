
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:khadamat_app/providers/PointsPurchasesProvider.dart';
import 'package:provider/provider.dart';

class CoinPacksWidget extends StatefulWidget {
  final ProductDetails coinPack;

  const CoinPacksWidget({Key key, this.coinPack}) : super(key: key);

  @override
  _CoinPacksWidgetState createState() => _CoinPacksWidgetState();
}

class _CoinPacksWidgetState extends State<CoinPacksWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: (){
          context.read<PointsPurchasesProvider>().buy(widget.coinPack);
          //context.read<PointsPurchasesProvider>().addPointsToUser(100);
        },
        leading: Image.asset(
          "assets/images/money.png",
          width: 50,
          height: 50,
        ),
        title: Text(widget.coinPack.title),
        subtitle: Text("${widget.coinPack.description}"),
        trailing: Text("${widget.coinPack.price}"),
      ),
    );
  }
}
