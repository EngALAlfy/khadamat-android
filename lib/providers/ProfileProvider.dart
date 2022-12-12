import 'package:dio/dio.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/Item.dart';
import 'package:khadamat_app/models/User.dart';

class ProfileProvider extends ChangeNotifier with APIMixin {
  SingleAPIResponse<User> profileResponse = SingleAPIResponse();
  SingleAPIResponse<User> userResponse = SingleAPIResponse();

  APIResponse<Item> profileItemResponse = APIResponse();
  APIResponse<Item> profileArchivedItemResponse = APIResponse();
  APIResponse<Item> userItemResponse = APIResponse();

  String photo;

  getProfile(context) async {
    profileResponse.error = null;
    profileResponse.isError = false;
    try {
      var response = await getWithToken(API.PROFILE_URL);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            profileResponse.data = User.fromJson(responseJson["data"]);
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            profileResponse.error = validateError(context, responseJson);
          } else {
            profileResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          profileResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        profileResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      profileResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  getItems(BuildContext context) async {
    profileItemResponse.error = null;
    profileItemResponse.isError = false;
    try {
      var response = await getWithToken(API.PROFILE_ITEMS_URL);

      if (response == null) {
        return;
      }
      print(response.data);
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            profileItemResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            profileItemResponse.error = validateError(context, responseJson);
          } else {
            profileItemResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          profileItemResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        profileItemResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      profileItemResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  delete(context, id) async {
    SingleAPIResponse<bool> deleteResponse = SingleAPIResponse();
    deleteResponse.isError = false;

    try {
      var response = await getWithToken(API.DELETE_ITEM_URL + "/$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            deleteResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            deleteResponse.error = validateError(context, responseJson);
          } else {
            deleteResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          deleteResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        deleteResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      deleteResponse.error = exceptionError(context, e);
    }

    if (deleteResponse.isError) {
      errorAlert(context, deleteResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context).get("item_deleted_successfully"));
    }

    notifyListeners();
  }

  stopSponsored(context, id) async {
    SingleAPIResponse<bool> stopSponsoredResponse = SingleAPIResponse();
    stopSponsoredResponse.isError = false;

    try {
      var response = await getWithToken(API.STOP_SPONSORED_ITEM_URL + "/$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            stopSponsoredResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            stopSponsoredResponse.error = validateError(context, responseJson);
          } else {
            stopSponsoredResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          stopSponsoredResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        stopSponsoredResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      stopSponsoredResponse.error = exceptionError(context, e);
    }

    if (stopSponsoredResponse.isError) {
      errorAlert(context, stopSponsoredResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context).get("item_stopped_sponsored_successfully"));
    }

    getItems(context);
  }

  updatePhoto(context) async {
    SingleAPIResponse<bool> photoResponse = SingleAPIResponse();
    photoResponse.isError = false;

    try {
      FormData data = FormData.fromMap({
        "photo": photo == null || photo.isEmpty
            ? null
            : await MultipartFile.fromFile(photo,
                filename: photo.split("/").last),
      });

      var response = await postWithToken(API.UPDATE_PHOTO_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            photoResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            photoResponse.error = validateError(context, responseJson);
          } else {
            photoResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          photoResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        photoResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      photoResponse.error = exceptionError(context, e);
    }

    if (photoResponse.isError) {
      errorAlert(context, photoResponse.error);
    } else {
      successAlert(context,
          message:
              EzLocalization.of(context).get("photo_updated_successfully"));
    }

    getProfile(context);
  }

  Future<void> updateName(BuildContext context, String name) async {
    SingleAPIResponse<bool> nameResponse = SingleAPIResponse();
    nameResponse.isError = false;

    try {
      FormData data = FormData.fromMap({
        "name": name,
      });

      var response = await postWithToken(API.UPDATE_NAME_URL, data);

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
          EzLocalization.of(context).get("name_updated_successfully"));
    }

    getProfile(context);
  }

  Future<void> startSponsored(context, id) async {
    SingleAPIResponse<bool> startSponsoredResponse = SingleAPIResponse();
    startSponsoredResponse.isError = false;

    try {
      var response = await getWithToken(API.START_SPONSORED_ITEM_URL + "/$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            startSponsoredResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            startSponsoredResponse.error = validateError(context, responseJson);
          } else {
            startSponsoredResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          startSponsoredResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        startSponsoredResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      startSponsoredResponse.error = exceptionError(context, e);
    }

    if (startSponsoredResponse.isError) {
      errorAlert(context, startSponsoredResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context).get("item_started_sponsored_successfully"));
    }

    getItems(context);
  }

  void getUserProfile(BuildContext context, int id) async {
    userResponse.error = null;
    userResponse.isError = false;
    try {
      var response = await get(API.USER_PROFILE_URL + "$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            userResponse.data = User.fromJson(responseJson["data"]);
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            userResponse.error = validateError(context, responseJson);
          } else {
            userResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          userResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        userResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      userResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  getUserItems(BuildContext context , id) async {
    userItemResponse.error = null;
    userItemResponse.isError = false;
    try {
      var response = await get(API.USER_ITEMS_URL + "$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            userItemResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            userItemResponse.error = validateError(context, responseJson);
          } else {
            userItemResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          userItemResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        userItemResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      userItemResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  getArchived(BuildContext context) async {
    profileArchivedItemResponse.error = null;
    profileArchivedItemResponse.isError = false;
    try {
      var response = await getWithToken(API.PROFILE_ARCHIVED_ITEMS_URL);

      if (response == null) {
        return;
      }
      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            profileArchivedItemResponse.data = responseJson["data"]
                .map<Item>((e) => e == null ? null : Item.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            profileArchivedItemResponse.error = validateError(context, responseJson);
          } else {
            profileArchivedItemResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          profileArchivedItemResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        profileArchivedItemResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      profileArchivedItemResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  Future<void> unarchiveItem(context, int id) async {
    SingleAPIResponse<bool> archiveResponse = SingleAPIResponse();
    archiveResponse.isError = false;

    try {
      var response = await getWithToken(API.UNARCHIVE_ITEM_URL + "$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            archiveResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            archiveResponse.error = validateError(context, responseJson);
          } else {
            archiveResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          archiveResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        archiveResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      archiveResponse.error = exceptionError(context, e);
    }

    if (archiveResponse.isError) {
      errorAlert(context, archiveResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context).get("item_unarchived_successfully"));
    }

    getArchived(context);
    getItems(context);

  }

  Future<void> archiveItem(context, int id) async {
    SingleAPIResponse<bool> archiveResponse = SingleAPIResponse();
    archiveResponse.isError = false;

    try {
      var response = await getWithToken(API.ARCHIVE_ITEM_URL + "$id");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            archiveResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            archiveResponse.error = validateError(context, responseJson);
          } else {
            archiveResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          archiveResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        archiveResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      archiveResponse.error = exceptionError(context, e);
    }

    if (archiveResponse.isError) {
      errorAlert(context, archiveResponse.error);
    } else {
      EasyLoading.showSuccess(EzLocalization.of(context).get("item_archived_successfully"));
      getArchived(context);
      getItems(context);
    }

  }
}
