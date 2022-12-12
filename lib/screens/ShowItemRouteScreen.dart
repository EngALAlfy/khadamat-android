import 'package:flutter/material.dart';
import 'package:khadamat_app/providers/ItemsProvider.dart';
import 'package:khadamat_app/screens/ItemDetailsScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';

class ShowItemRouteScreen extends StatelessWidget {
  final id;

  const ShowItemRouteScreen({Key key, this.id}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Provider.of<ItemsProvider>(context , listen: false).getItem(context, id);

    print("test");

    return Consumer<ItemsProvider>(
      builder: (context, value, child) {


        if (value.itemResponse == null) {
          return IsLoadingWidget();
        }

        if (value.itemResponse.isError ||
            value.itemResponse.error != null) {
          return IsErrorWidget(
              error: value.itemResponse.error,
              onRetry: () =>
              value
                ..getItem(context, id)
          );
        }

        if (value.itemResponse.isLoading) {
          return IsLoadingWidget();
        }

        if (value.itemResponse.isEmpty) {
          return IsEmptyWidget();
        }

        return ItemDetailsScreen(
          item: value.itemResponse.data,
          owned: false,
        );
      },
    );
  }
}
