import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/models/Category.dart';
import 'package:khadamat_app/models/SubCategory.dart';
import 'package:khadamat_app/providers/SubCategoriesProvider.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:khadamat_app/widgets/SubCategoryWidget.dart';
import 'package:khadamat_app/widgets/SubSubCategoryWidget.dart';
import 'package:provider/provider.dart';
class SubSubCategoriesScreen extends StatefulWidget {
  final SubCategory subcategory;

  const SubSubCategoriesScreen({Key key, this.subcategory}) : super(key: key);
  @override
  _SubSubCategoriesScreenState createState() => _SubSubCategoriesScreenState();
}

class _SubSubCategoriesScreenState extends State<SubSubCategoriesScreen> {

  @override
  void initState() {
    context.read<SubCategoriesProvider>().subSubCategories(context , widget.subcategory.category_id , widget.subcategory.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.subcategory.name),
      ),
      body: Consumer<SubCategoriesProvider>(
        builder: (context, value, child) {
          if (value.subSubcategoriesResponse == null) {
            return IsLoadingWidget();
          }

          if (value.subSubcategoriesResponse.isError ||
              value.subSubcategoriesResponse.error != null) {
            print(value.subSubcategoriesResponse);
            return IsErrorWidget(
              error: value.subSubcategoriesResponse.error,
              onRetry: () => context.read<SubCategoriesProvider>()..subSubCategories(context , widget.subcategory.category_id , widget.subcategory.id)..notify(),
            );
          }

          if (value.subSubcategoriesResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (value.subSubcategoriesResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SubSubCategoryWidget(
                  subsubcategory: value.subSubcategoriesResponse.data.elementAt(index),
                );
              },
              itemCount: value.subSubcategoriesResponse.data.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            );
        },
      ),
    );
  }
}
