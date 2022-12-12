import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/screens/SubCategoriesScreen.dart';

class CategoryWidget extends StatelessWidget {
  final category;
  final index;

  const CategoryWidget({Key key, this.category, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
            onTap: ()=> goTo(context, SubCategoriesScreen(category: category,)),
            leading: CachedNetworkImage(
              imageUrl: API.IMAGES_URL + "/" + category.image,
              width: 50,
              height: 50,
            ),
            title: Text(category.name),
            trailing: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Text("${category.items_count}"),
                SizedBox(width: 5,),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
    );
  }
}
