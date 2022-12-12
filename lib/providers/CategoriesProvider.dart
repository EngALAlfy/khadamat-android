import 'package:flutter/cupertino.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/Category.dart';
import 'package:khadamat_app/models/SubSubCategory.dart';
import 'package:smart_select/smart_select.dart';

class CategoriesProvider extends ChangeNotifier with APIMixin {
  APIResponse<Category> categoriesResponse = APIResponse();

  APIResponse<S2Choice<String>> selectCategoriesResponse = APIResponse();
  APIResponse<S2Choice<String>> selectSubSubCategoriesResponse = APIResponse();
  APIResponse<S2Choice<String>> selectSubCategoriesResponse = APIResponse();


  notify() {
    notifyListeners();
  }

  allCategories(context) async {
    categoriesResponse.error = null;
    categoriesResponse.isError = false;
    try {
      var response = await get(API.CATEGORIES_URL);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            categoriesResponse.data = responseJson["data"]
                .map<Category>((e) => e == null ? null : Category.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            categoriesResponse.error = validateError(context, responseJson);
          } else {
            categoriesResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          categoriesResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        categoriesResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      categoriesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  selectCategories(context) async {
    selectCategoriesResponse.error = null;
    selectCategoriesResponse.isError = false;
    try {
      var response = await getWithToken(API.SELECT_CATEGORIES_URL);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {

            selectCategoriesResponse.data = responseJson["data"]
                .map<S2Choice<String>>((e) => e == null ? null : S2Choice<String>(value: '${e["id"]}', title: e["name"]))
                .toList();

            selectSubCategoriesResponse.data = [];
            selectSubSubCategoriesResponse.data = [];

          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            selectCategoriesResponse.error =
                validateError(context, responseJson);
          } else {
            selectCategoriesResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          selectCategoriesResponse.error =
              noSuccessError(context, responseJson);
        }
      } else {
        selectCategoriesResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      selectCategoriesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  selectSubCategories(context , category_id) async {
    selectSubCategoriesResponse.error = null;
    selectSubCategoriesResponse.isError = false;
    try {
      var response = await getWithToken(API.SELECT_SUBCATEGORIES_URL+"/$category_id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {

            selectSubCategoriesResponse.data = responseJson["data"]
                .map<S2Choice<String>>((e) => e == null ? null : S2Choice<String>(value: '${e["id"]}', title: e["name"]))
                .toList();

          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            selectSubCategoriesResponse.error =
                validateError(context, responseJson);
          } else {
            selectSubCategoriesResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          selectSubCategoriesResponse.error =
              noSuccessError(context, responseJson);
        }
      } else {
        selectSubCategoriesResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      selectSubCategoriesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  selectSubSubCategories(context , subcategory_id) async {
    selectSubSubCategoriesResponse.error = null;
    selectSubSubCategoriesResponse.isError = false;
    try {
      var response = await getWithToken(API.SELECT_SUBSUBCATEGORIES_URL+"/$subcategory_id");

      print(response);
      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {

            selectSubSubCategoriesResponse.data = responseJson["data"]
                .map<S2Choice<String>>((e) => e == null ? null : S2Choice<String>(value: '${e["id"]}', title: e["name"]))
                .toList();

          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            selectSubSubCategoriesResponse.error =
                validateError(context, responseJson);
          } else {
            selectSubSubCategoriesResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          selectSubSubCategoriesResponse.error =
              noSuccessError(context, responseJson);
        }
      } else {
        selectSubSubCategoriesResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      selectSubSubCategoriesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }
}
