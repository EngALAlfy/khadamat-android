import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/Series.dart';
import 'package:khadamat_app/models/SeriesCategory.dart';
import 'package:khadamat_app/models/SeriesEpisode.dart';

class SeriesProvider extends ChangeNotifier with APIMixin{


  APIResponse<Series> seriesResponse = APIResponse<Series>();
  APIResponse<SeriesEpisode> episodesResponse = APIResponse<SeriesEpisode>();
  APIResponse<SeriesCategory> categoriesResponse = APIResponse<SeriesCategory>();


  allCategories(context) async {
    categoriesResponse.error = null;
    categoriesResponse.isError = false;
    try {
      var response = await get(API.SERIES_CATEGORIES_URL);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            categoriesResponse.data = responseJson["data"]
                .map<SeriesCategory>((e) => e == null ? null : SeriesCategory.fromJson(e))
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

  series(context , category) async {
    seriesResponse.error = null;
    seriesResponse.isError = false;
    try {
      var response = await get(API.SERIES_URL + "$category");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            seriesResponse.data = responseJson["data"]
                .map<Series>((e) => e == null ? null : Series.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            seriesResponse.error = validateError(context, responseJson);
          } else {
            seriesResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          seriesResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        seriesResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      seriesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }

  episodes(context , series) async {
    episodesResponse.error = null;
    episodesResponse.isError = false;
    try {
      var response = await get(API.SERIES_EPISODES_URL + "$series");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            episodesResponse.data = responseJson["data"]
                .map<SeriesEpisode>((e) => e == null ? null : SeriesEpisode.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            episodesResponse.error = validateError(context, responseJson);
          } else {
            episodesResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          episodesResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        episodesResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      episodesResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }
}