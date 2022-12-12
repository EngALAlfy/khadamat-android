import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';

class PointsPurchasesProvider  extends ChangeNotifier with APIMixin{
  StreamSubscription<List<PurchaseDetails>> _subscription;
  final iapConnection = InAppPurchase.instance;
  var storeState = "loading";

  APIResponse<ProductDetails> productsResponse = APIResponse<ProductDetails>();

  BuildContext context;

  var ids = <String>{
    'coins_1',
    'coins_8',
    'coins_30',
    'coins_15',
  };

  PointsPurchasesProvider() {
    final purchaseUpdated =
        iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );

    //loadPurchases();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> buy(ProductDetails product) async {
    iapConnection.buyConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(_handlePurchase);
    notifyListeners();
  }

  void _handlePurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      print("complete : ${purchaseDetails.productID}");
      if (ids.contains(purchaseDetails.productID)) {
        addPointsToUser(purchaseDetails.productID.replaceFirst("coins_", ""));
      }else{
        errorAlert(context, "id ${purchaseDetails.productID} not included");
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      iapConnection.completePurchase(purchaseDetails);
    }
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    //Handle error here
    print("error : ${error.toString()}");
    errorAlert(context, error.toString());
  }

  Future<void> loadPurchases() async {
    productsResponse.error = null;
    productsResponse.isError = false;

    final available = await iapConnection.isAvailable();
    if (!available) {
      productsResponse.error = "notAvailable";
      notifyListeners();
      return;
    }

    final response = await iapConnection.queryProductDetails(ids);
    response.notFoundIDs.forEach((element) {
      print('Purchase $element not found');
    });

    productsResponse.data = response.productDetails;
    productsResponse.data.sort((ProductDetails a, ProductDetails b) =>
        a.rawPrice.compareTo(b.rawPrice));
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }

  addPointsToUser(points) async {
    SingleAPIResponse<bool> nameResponse = SingleAPIResponse();
    nameResponse.isError = false;

    try {

      if(points == "30"){
        points = "32";
      }

      if(points == "15"){
        points = "16";
      }


      FormData data = FormData.fromMap({
        "points": points,
      });

      var response = await postWithToken(API.ADD_POINTS_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            nameResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            nameResponse.error = validateError(context, responseJson);
          } else {
            nameResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          nameResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        nameResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      nameResponse.error = exceptionError(context, e);
    }

    if (nameResponse.isError) {
      errorAlert(context, nameResponse.error);
    } else {
      successAlert(context,
          message:
          EzLocalization.of(context).get("points_updated_successfully"));
    }

  }

  setContext(BuildContext context) {
    this.context = context;
  }

}