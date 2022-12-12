import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/screens/AddNewItem.dart';

class NewItemWidget extends StatefulWidget {
  @override
  _NewItemWidgetState createState() => _NewItemWidgetState();
}

class _NewItemWidgetState extends State<NewItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () async {
          if(kIsWeb){
            return await openPlay();
          }

          goTo(context, AddNewItem());
        },leading: Icon(Icons.add , color: Colors.green,size: 50,),
        title: Text(EzLocalization.of(context).get("new_item")),
      ),
    );
  }
}
