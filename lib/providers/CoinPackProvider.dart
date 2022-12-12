import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/CoinPack.dart';

class CoinPackProvider extends ChangeNotifier with APIMixin {
  APIResponse<CoinPack> coinPackResponse = APIResponse<CoinPack>();

  getCoinPacks(context) async {
    coinPackResponse.error = null;
    coinPackResponse.isError = false;
    try {
      var response = await getWithToken(API.COIN_PACKS_URL);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            coinPackResponse.data = responseJson["data"]
                .map<CoinPack>((e) => e == null ? null : CoinPack.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            coinPackResponse.error = validateError(context, responseJson);
          } else {
            coinPackResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          coinPackResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        coinPackResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      coinPackResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
