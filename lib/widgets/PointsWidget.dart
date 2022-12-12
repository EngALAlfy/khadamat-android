import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/screens/BuyPointsScreen.dart';
import 'package:provider/provider.dart';

class PointsWidget extends StatefulWidget {
  @override
  _PointsWidgetState createState() => _PointsWidgetState();
}

class _PointsWidgetState extends State<PointsWidget> {
  @override
  Widget build(BuildContext context) {
    if(!kIsWeb) {
      context.read<ProfileProvider>().getProfile(context);
    }
    return Consumer<ProfileProvider>(
      builder: (context, value, child) {
        return Container(
          child: ListTile(
            onTap: () async {
              if(kIsWeb){
                return await openPlay();
              }

              goTo(context, BuyPointsScreen());
            },leading: kIsWeb ? Image.asset("assets/images/ic_logo.png" , width: 50, height: 50, ) : Icon(
              FlutterIcons.coin_mco,
              color: Colors.amber,
              size: 50,
            ),
            title: Text(EzLocalization.of(context).get(kIsWeb ? "get_app" : "points_balance")),
            trailing: kIsWeb ? null :  (!value.profileResponse.isLoading)
                ? Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                (!value.profileResponse.isEmpty)
                    ? Text("${value.profileResponse.data.points}")
                    : Text("0"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ) : CircularProgressIndicator(),
          ),
          margin: EdgeInsets.only(bottom: 20),
        );
      },
    );
  }
}
