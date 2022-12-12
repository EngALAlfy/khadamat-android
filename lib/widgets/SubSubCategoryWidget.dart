import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/screens/ItemsScreen.dart';
import 'package:khadamat_app/screens/SubCategoriesScreen.dart';

class SubSubCategoryWidget extends StatelessWidget {
  final subsubcategory;

  const SubSubCategoryWidget({Key key, this.subsubcategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: ()=> goTo(context, ItemsScreen(subsubcategory: subsubcategory,)),
        leading: CachedNetworkImage(
          imageUrl: API.IMAGES_URL + "/" + subsubcategory.image,
          width: 50,
          height: 50,
        ),
        title: Text(subsubcategory.name),
        trailing: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            Text("${subsubcategory.items_count}"),
            SizedBox(width: 5,),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
