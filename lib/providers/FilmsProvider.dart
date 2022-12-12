import 'package:flutter/material.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/Film.dart';
import 'package:khadamat_app/models/FilmCategory.dart';

class FilmsProvider extends ChangeNotifier with APIMixin{

  APIResponse<Film> filmsResponse = APIResponse<Film>();
  APIResponse<FilmCategory> categoriesResponse = APIResponse<FilmCategory>();


  allCategories(context) async {
    categoriesResponse.error = null;
    categoriesResponse.isError = false;
    try {
      var response = await get(API.FILM_CATEGORIES_URL);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            categoriesResponse.data = responseJson["data"]
                .map<FilmCategory>((e) => e == null ? null : FilmCategory.fromJson(e))
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


  films(context , category) async {
    filmsResponse.error = null;
    filmsResponse.isError = false;
    try {
      var response = await get(API.FILMS_URL + "$category");

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            filmsResponse.data = responseJson["data"]
                .map<Film>((e) => e == null ? null : Film.fromJson(e))
                .toList();
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            filmsResponse.error = validateError(context, responseJson);
          } else {
            filmsResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          filmsResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        filmsResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      filmsResponse.error = exceptionError(context, e);
    }

    notifyListeners();
  }


}