import 'package:dio/dio.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/Item.dart';

class ItemsProvider extends ChangeNotifier with APIMixin {
  APIResponse<Item> subcategoryItemsResponse = APIResponse<Item>();
  APIResponse<Item> subSubcategoryItemsResponse = APIResponse<Item>();
  APIResponse<Item> categoryItemsResponse = APIResponse<Item>();
  APIResponse<Item> allItemsResponse = APIResponse<Item>();

  APIResponse<Item> searchResponse = APIResponse<Item>();
  APIResponse<Item> searchCategoryResponse = APIResponse<Item>();
  bool isCategorySearching = false;
  bool isSearching = false;
  String searchItem;
  String searchCategoryItem;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchCategoryController = TextEditingController();

  SingleAPIResponse<bool> addItemResponse = SingleAPIResponse<bool>();
  SingleAPIResponse<Item> itemResponse = SingleAPIResponse<Item>();

  var nameController = TextEditingController(text: "");
  var descController = TextEditingController();

  String name;
  String desc;
  String _image;
  String _image1;
  String _image2;
  String _image3;
  String _image4;
  String category_id;
  String subcategory_id;
  String subsubcategory_id;
  var search_subsubcategory_id;
  int sponsored;

  String get image => _image;

  set image(String value) {
    _image = value;
    if (value != null) {
      notifyListeners();
    }
  }

  addNewItem(context) async {
    EasyLoading.show();
    addItemResponse.isError = false;
    addItemResponse.error = null;

    name = nameController.text;
    desc = descController.text;

    try {
      FormData data = FormData.fromMap({
        "name": name,
        "desc": desc,
        "category_id": category_id,
        "subcategory_id": subcategory_id,
        "subsubcategory_id": subsubcategory_id,
        "image": await MultipartFile.fromFile(image,
            filename: image
                .split("/")
                .last),
        "image1": image1 == null || image1.isEmpty
            ? null
            : await MultipartFile.fromFile(image1,
            filename: image1
                .split("/")
                .last),
        "image2": image2 == null || image2.isEmpty
            ? null
            : await MultipartFile.fromFile(image2,
            filename: image2
                .split("/")
                .last),
        "image3": image3 == null || image3.isEmpty
            ? null
            : await MultipartFile.fromFile(image3,
            filename: image3
                .split("/")
                .last),
        "image4": image4 == null || image4.isEmpty
            ? null
            : await MultipartFile.fromFile(image4,
            filename: image4
                .split("/")
                .last),
        "sponsored": sponsored,
      });

      print(data.files);

      var response = await postWithToken(API.ADD_ITEM_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            addItemResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            addItemResponse.error = validateError(context, responseJson);
          } else {
            addItemResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          addItemResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        addItemResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      addItemResponse.error = exceptionError(context, e);
    }

    EasyLoading.dismiss(animation: true);

    if (addItemResponse.isError) {
      errorAlert(context, addItemResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context).get("item_added_successfully"),
          fun: () => Navigator.pop(context));
      clearAdd();
    }

    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  subCategoryItems(context, subcategory_id, category_id) async {
    subcategoryItemsResponse.error = null;
    subcategoryItemsResponse.isError = false;
    try {
      var response = await get(
          API.VIEW_SUBCATEGORY_URL + "/$category_id/$subcategory_id");

      if (response == null) {
        return;
      }
      print(response.data);
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            subcategoryItemsResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            subcategoryItemsResponse.error =
                validateError(context, responseJson);
          } else {
            subcategoryItemsResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          subcategoryItemsResponse.error =
              noSuccessError(context, responseJson);
        }
      } else {
        subcategoryItemsResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      subcategoryItemsResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  categoryItems(context, category_id) async {
    categoryItemsResponse.error = null;
    categoryItemsResponse.isError = false;
    try {
      var response =
      await getWithToken(API.VIEW_CATEGORY_URL + "/$category_id");

      if (response == null) {
        return;
      }
      print(response.data);
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            categoryItemsResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            categoryItemsResponse.error = validateError(context, responseJson);
          } else {
            categoryItemsResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          categoryItemsResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        categoryItemsResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      categoryItemsResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  allItems(context) async {
    allItemsResponse.error = null;
    allItemsResponse.isError = false;
    try {
      var response = await getWithToken(API.ITEMS_URL);

      if (response == null) {
        return;
      }
      print(response.data);
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            allItemsResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            allItemsResponse.error = validateError(context, responseJson);
          } else {
            allItemsResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          allItemsResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        allItemsResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      allItemsResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  getItem(context, id) async {
    itemResponse.error = null;
    itemResponse.isError = false;
    try {
      var response = await get(API.GET_ITEM_URL + "$id");

      //print(response);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            itemResponse.data = Item.fromJson(responseJson["data"]);
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            itemResponse.error = validateError(context, responseJson);
          } else {
            itemResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          itemResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        itemResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      itemResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  subSubCategoryItems(BuildContext context, subsubcategory_id, subcategory_id,
      category_id) async {
    subSubcategoryItemsResponse.error = null;
    subSubcategoryItemsResponse.isError = false;
    try {
      var response = await get(API.VIEW_SUBSUBCATEGORY_URL +
          "/$category_id/$subcategory_id/$subsubcategory_id");

      if (response == null) {
        return;
      }
      print(response.data);
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            subSubcategoryItemsResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            subSubcategoryItemsResponse.error =
                validateError(context, responseJson);
          } else {
            subSubcategoryItemsResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          subSubcategoryItemsResponse.error =
              noSuccessError(context, responseJson);
        }
      } else {
        subSubcategoryItemsResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      subSubcategoryItemsResponse.error = exceptionError(context, e);
    }

    print(subSubcategoryItemsResponse.error);

    notifyListeners();
  }

  String get image1 => _image1;

  set image1(String value) {
    _image1 = value;

    if (value != null) {
      notifyListeners();
    }
  }

  String get image2 => _image2;

  set image2(String value) {
    _image2 = value;

    if (value != null) {
      notifyListeners();
    }
  }

  String get image3 => _image3;

  set image3(String value) {
    _image3 = value;

    if (value != null) {
      notifyListeners();
    }
  }

  String get image4 => _image4;

  set image4(String value) {
    _image4 = value;

    if (value != null) {
      notifyListeners();
    }
  }

  void clearAdd() {
    nameController.clear();
    descController.clear();
    name = "";
    desc = "";
    image = null;
    image1 = null;
    image2 = null;
    image3 = null;
    image4 = null;
  }

  void searchClear() {
    searchController.clear();
    searchItem = "";
    searchResponse = APIResponse<Item>();
  }

  void searchCategoryClear() {
    searchCategoryController.clear();
    searchCategoryItem = "";
    searchCategoryResponse = APIResponse<Item>();
  }

  Future<void> search(BuildContext context) async {
    searchResponse.error = null;
    searchResponse.isError = false;

    searchItem = searchController.text;

    try {
      var response = await get(API.SEARCH_ITEMS_URL + "/$searchItem");

      if (response == null) {
        return;
      }
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            searchResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            searchResponse.error = validateError(context, responseJson);
          } else {
            searchResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          searchResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        searchResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      searchResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  Future<void> searchCategory(BuildContext context) async {
    searchCategoryResponse.error = null;
    searchCategoryResponse.isError = false;

    searchCategoryItem = searchCategoryController.text;

    try {
      var response = await get(API.SEARCH_CATEGORY_ITEMS_URL +
          "/$search_subsubcategory_id/$searchCategoryItem");

      if (response == null) {
        return;
      }
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            searchCategoryResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            searchCategoryResponse.error = validateError(context, responseJson);
          } else {
            searchCategoryResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          searchCategoryResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        searchCategoryResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      searchCategoryResponse.error = exceptionError(context, e);
    }


    notifyListeners();
  }

  void initUpdate(Item item) {
    descController.text = item.desc;
    desc = item.desc;
    //_image = item.image;
    //_image1 = item.image1;
    //_image2 = item.image2;
    //_image3 = item.image3;
    //_image4 = item.image4;
    category_id = item.category.id.toString();
    subcategory_id = item.subcategory.id.toString();
    subsubcategory_id = item.subsubcategory.id.toString();
  }

  updateItem(context, id) async {
    EasyLoading.show();
    SingleAPIResponse<bool> updateItemResponse = new SingleAPIResponse();
    updateItemResponse.isError = false;
    updateItemResponse.error = null;

    desc = descController.text;

    try {
      FormData data = FormData.fromMap({
        "desc": desc,
        "category_id": category_id,
        "subcategory_id": subcategory_id,
        "subsubcategory_id": subsubcategory_id,
        "image": image == null || image.isEmpty
            ? null :
        await MultipartFile.fromFile(image,
            filename: image
                .split("/")
                .last),
        "image1": image1 == null || image1.isEmpty
            ? null
            : await MultipartFile.fromFile(image1,
            filename: image1
                .split("/")
                .last),
        "image2": image2 == null || image2.isEmpty
            ? null
            : await MultipartFile.fromFile(image2,
            filename: image2
                .split("/")
                .last),
        "image3": image3 == null || image3.isEmpty
            ? null
            : await MultipartFile.fromFile(image3,
            filename: image3
                .split("/")
                .last),
        "image4": image4 == null || image4.isEmpty
            ? null
            : await MultipartFile.fromFile(image4,
            filename: image4
                .split("/")
                .last),
      });

      var response = await postWithToken(API.UPDATE_ITEM_URL + "$id", data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            updateItemResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            updateItemResponse.error = validateError(context, responseJson);
          } else {
            updateItemResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          updateItemResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        updateItemResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      updateItemResponse.error = exceptionError(context, e);
    }

    EasyLoading.dismiss(animation: true);

    if (updateItemResponse.isError) {
      errorAlert(context, updateItemResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context).get("item_updated_successfully"),
          fun: () {
            Navigator.pop(context);
            clearAdd();
            Navigator.pop(context);
          });
    }

    notifyListeners();
  }
}
