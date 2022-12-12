import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/models/Category.dart';
import 'package:khadamat_app/providers/SubCategoriesProvider.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/SubCategoryWidget.dart';
import 'package:provider/provider.dart';
class SubCategoriesScreen extends StatefulWidget {
  final Category category;

  const SubCategoriesScreen({Key key, this.category}) : super(key: key);
  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {

  @override
  void initState() {
    context.read<SubCategoriesProvider>().allSubCategories(context , widget.category.id);
    print("build 1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.category.name),
      ),
      body: Consumer<SubCategoriesProvider>(
        builder: (context, value, child) {
          if (value.subcategoriesResponse == null) {
            return IsLoadingWidget();
          }

          if (value.subcategoriesResponse.isError ||
              value.subcategoriesResponse.error != null) {
            print(value.subcategoriesResponse);
            return IsErrorWidget(
              error: value.subcategoriesResponse.error,
              onRetry: () => context.read<SubCategoriesProvider>()..allSubCategories(context , widget.category.id)..notify(),
            );
          }

          if (value.subcategoriesResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.subcategoriesResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SubCategoryWidget(
                  subcategory: value.subcategoriesResponse.data.elementAt(index),
                );
              },
              itemCount: value.subcategoriesResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            );
        },
      ),
    );
  }
}
