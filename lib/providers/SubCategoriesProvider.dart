import 'package:flutter/cupertino.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/SubCategory.dart';
import 'package:khadamat_app/models/SubSubCategory.dart';
import 'package:smart_select/smart_select.dart';

class SubCategoriesProvider extends ChangeNotifier with APIMixin{

  APIResponse<SubCategory> subcategoriesResponse = APIResponse<SubCategory>();
  APIResponse<SubSubCategory> subSubcategoriesResponse = APIResponse<SubSubCategory>();



  notify(){
    notifyListeners();
  }

  allSubCategories(context , id) async {
    subcategoriesResponse.error = null;
    subcategoriesResponse.isError = false;
    try {
      var response = await get(API.VIEW_CATEGORY_URL + "/$id");

      if (response == null) {
        return;
      }
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            subcategoriesResponse.data = responseJson["data"]
                .map<SubCategory>((e) => e == null ? null : SubCategory.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            subcategoriesResponse.error = validateError(context, responseJson);
          } else {
            subcategoriesResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          subcategoriesResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        subcategoriesResponse.error = statusCodeError(context, response);
      }
    }catch(e){
      subcategoriesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

   subSubCategories(BuildContext context, int category_id, int subcategory_id) async {
     subSubcategoriesResponse.error = null;
     subSubcategoriesResponse.isError = false;
     try {
       var response = await get(API.VIEW_SUBCATEGORY_URL + "/$category_id/$subcategory_id");

       if (response == null) {
         return;
       }
       Map responseJson = response.data;

       if (response.statusCode == 200 || response.statusCode == 201) {
         if (responseJson.containsKey("success")) {
           if (responseJson["success"] == true) {
             subSubcategoriesResponse.data = responseJson["data"]
                 .map<SubSubCategory>((e) => e == null ? null : SubSubCategory.fromJson(e))
                 .toList();
           } else if (responseJson["success"] == false &&
               responseJson["validate"] == true) {
             subSubcategoriesResponse.error = validateError(context, responseJson);
           } else {
             subSubcategoriesResponse.error = falseSuccessError(context, responseJson);
           }
         } else {
           subSubcategoriesResponse.error = noSuccessError(context, responseJson);
         }
       } else {
         subSubcategoriesResponse.error = statusCodeError(context, response);
       }
     }catch(e){
       subSubcategoriesResponse.error = exceptionError(context, e);
     }

     notifyListeners();
   }

}