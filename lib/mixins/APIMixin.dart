import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat_app/config/Errors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIMixin extends Object {
  getWithToken(url) async {
    var token = await getToken();

    if (token == null) {
      return Future.error(Errors.NO_TOKEN);
    }

    Future<Response> response = Dio().get(
      url,
      options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
          headers: {
            Headers.acceptHeader: Headers.jsonContentType,
          }),
      queryParameters: {"api_token": token},
    );

    return response;
  }

  postWithToken(url, data) async {
    var token = await getToken();

    if (token == null) {
      return Future.error(Errors.NO_TOKEN);
    }

    Future<Response> response = Dio().post(
      url,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
        },
        validateStatus: (status) => true,
      ),
      queryParameters: {"api_token": token},
      data: data,
    );

    return response;
  }

  post(url, data) async {
    var response = Dio().post(
      url,
      options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
          headers: {
            Headers.acceptHeader: Headers.jsonContentType,
          }),
      data: data,
    );

    return response;
  }

  get(url) async {
    var response = Dio().get(
      url,
      options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
          headers: {
            Headers.acceptHeader: Headers.jsonContentType,
          }),
    );

    return response;
  }

  handleError(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responseJson = response.data;

      if (responseJson.containsKey("success")) {
        if (responseJson["success"] == true) {
          return null;
        } else {
          return responseJson['data'];
        }
      } else {
        return responseJson;
      }
    } else {
      print("error with code : $response");
      return Future.error(response.statusCode);
    }
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  validateAlert(context, Map validateErrors) {
    double height = (validateErrors.length * 100).toDouble() > 300.toDouble()
        ? 300.toDouble()
        : (validateErrors.length * 100).toDouble();

    Alert(
      type: AlertType.error,
      context: context,
      title: EzLocalization.of(context).get('error'),
      content: Container(
        child: ListView(
          shrinkWrap: true,
          children: validateErrors.keys
              .map((e) => e == null
                  ? null
                  : ListTile(
                      title: Text(e),
                      subtitle: Column(
                        children: (validateErrors[e] as List<dynamic>)
                            .map<Widget>((k) => Text("$k"))
                            .toList(),
                      ),
                    ))
              .toList(),
        ),
        height: height,
        width: 400,
      ),
    ).show();
  }

  falseSuccessAlert(context, error) {
    Alert(
      type: AlertType.error,
      context: context,
      desc: EzLocalization.of(context)
          .get('error_success_false', {"message": error}),
      title: EzLocalization.of(context).get('error'),
    ).show();
  }

  noSuccessAlert(context, responseJson) {
    Alert(
      type: AlertType.error,
      context: context,
      desc: EzLocalization.of(context)
          .get('error_no_success', {"error": responseJson}),
      title: EzLocalization.of(context).get('error'),
    ).show();
  }

  statusCodeAlert(context, response) {
    print(response);
    Alert(
      type: AlertType.error,
      context: context,
      desc: EzLocalization.of(context).get('error_code',
          {'code': response.statusCode, 'message': response.data["data"]}),
      title: EzLocalization.of(context).get('error'),
    ).show();
  }

  validateError(context, Map validateErrors) {
    String errors = validateErrors["data"]
        .keys
        .map((e) {
          if (e == null) {
            return null;
          }

          print(validateErrors[e]);

          var messages = validateErrors["data"][e].join("\n");

          print(messages);

          return "$e : $messages";
        })
        .toList()
        .join("\n");

    return errors;
  }

  falseSuccessError(context, responseJson) {
    var message = responseJson.containsKey("data")
        ? responseJson["data"]
        : (responseJson.containsKey("message")
            ? responseJson["message"]
            : "UNKNOWN_ERROR");
    return EzLocalization.of(context)
        .get('error_server_500', {'message': message});
  }

  noSuccessError(context, responseJson) {
    var message = responseJson.containsKey("data")
        ? responseJson["data"]
        : (responseJson.containsKey("message")
            ? responseJson["message"]
            : "UNKNOWN_ERROR");
    return EzLocalization.of(context)
        .get('error_no_success', {'message': message});
  }

  statusCodeError(context, Response response) {
    Map data = response.data;
    switch (response.statusCode) {
      case 404:
        // not found
        return EzLocalization.of(context).get('error_server_404');
      case 500:
        // server error
        var message = data.containsKey("data")
            ? data["data"]
            : (data.containsKey("message") ? data["message"] : "UNKNOWN_ERROR");
        return EzLocalization.of(context)
            .get('error_server_500', {'message': message});
      case 401:
        // unauth error
        var message = data.containsKey("data")
            ? data["data"]
            : (data.containsKey("message") ? data["message"] : "UNKNOWN_ERROR");
        return EzLocalization.of(context)
            .get('error_server_unauth', {'message': message});
      default:
        print(response);
        var message = data.containsKey("data")
            ? data["data"]
            : (data.containsKey("message") ? data["message"] : "UNKNOWN_ERROR");
        return EzLocalization.of(context)
            .get('error_server_unknown', {'message': message});
    }
  }

  exceptionError(context, e) {
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          return EzLocalization.of(context).get("connect_timeout");
        case DioErrorType.sendTimeout:
          return EzLocalization.of(context).get("send_timeout");
        case DioErrorType.receiveTimeout:
          return EzLocalization.of(context).get("receive_timeout");
        case DioErrorType.response:
          return EzLocalization.of(context).get("status_error");
        case DioErrorType.cancel:
          return EzLocalization.of(context).get("request_canceled");
        case DioErrorType.other:
        default:
          return EzLocalization.of(context).get("unable_to_connect");
      }
    } else {
      print(e);
      return EzLocalization.of(context).get("unknown_error" , {"error" : e.toString()});
    }
  }

  errorAlert(context, error) {
    Alert(
      type: AlertType.error,
      context: context,
      desc: error,
      title: EzLocalization.of(context).get('error'),
    ).show();
  }

  successAlert(context, {message, Function fun}) {
    Alert(
        type: AlertType.success,
        context: context,
        desc: message == null
            ? EzLocalization.of(context).get("done_successfully")
            : message,
        title: EzLocalization.of(context).get('success'),
        buttons: [
          DialogButton(
              child: Text(EzLocalization.of(context).get("ok")),
              onPressed: () {
                Navigator.pop(context);
                if (fun != null) {
                  fun();
                }
              })
        ]).show();
  }
}
