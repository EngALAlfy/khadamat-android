import 'package:dio/dio.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat_app/config/API.dart';
import 'package:khadamat_app/mixins/APIMixin.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/mixins/FunctionsMixin.dart';
import 'package:khadamat_app/models/User.dart' as model;
import 'package:khadamat_app/screens/auth/GoogleSignUpScreen.dart';
import 'package:khadamat_app/screens/reset/ChangePasswordScreen.dart';
import 'package:khadamat_app/screens/reset/EnterResetCodeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier with APIMixin {
  String username;
  var password;
  var name;
  var email;
  var phone;
  var verificationId;
  var verificationCode;

  var resetPhone;
  var resetedPassword;
  var changedPassword;

  var _countryCode;
  var countryName;

  bool isLoaded = false;
  bool isAuth = false;
  bool isVerified = false;

  get countryCode => _countryCode;

  set countryCode(value) {
    _countryCode = value;
    notifyListeners();
  }

  checkAuth(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isAuth = prefs.getString('token') != null;
    isLoaded = true;
    notifyListeners();
  }

  unAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    isAuth = false;
    notifyListeners();
  }

  unAuthGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    isAuth = false;
    notifyListeners();
  }

  bool isValidPhoneNumber(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty) {
      return false;
    }

    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  loginWithUsername(context) async {
    EasyLoading.show();

    if (isValidPhoneNumber(username)) {
      if (username.startsWith("+")) {
        username = username.replaceFirst("+", "");
      }
    }

    var response =
        await post(API.LOGIN_URL, {"username": username, "password": password});

    EasyLoading.dismiss();

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responseJson = response.data;

      if (responseJson.containsKey("success")) {
        if (responseJson["success"] == true) {
          model.User user = model.User.fromJson(responseJson['data']);
          if (user.api_token != null) {
            await setToken(user.api_token);
            await checkAuth(context);
          }
        } else if (responseJson["success"] == false &&
            responseJson["validate"] == true) {
          validateAlert(context, responseJson["data"]);
        } else {
          falseSuccessAlert(context, responseJson["data"]);
        }
      } else {
        noSuccessAlert(context, responseJson);
      }
    } else {
      statusCodeAlert(context, response);
    }
  }

  loginWithGoogle(context) async {
    SingleAPIResponse<model.User> loginGoogleResponse = SingleAPIResponse();
    loginGoogleResponse.isError = false;

    try {
      UserCredential userCredential = await signInWithGoogle();

      print(userCredential.user.photoURL);

      var data = {'token': await userCredential.user.getIdToken()};

      Response response = await post(API.LOGIN_GOOGLE_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            loginGoogleResponse.data =
                model.User.fromJson(responseJson["data"]);
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            loginGoogleResponse.error = validateError(context, responseJson);
          } else {
            loginGoogleResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          loginGoogleResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        loginGoogleResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      loginGoogleResponse.error = exceptionError(context, e);
    }

    if (loginGoogleResponse.isError) {
      errorAlert(context, loginGoogleResponse.error);
    } else {
      model.User user = loginGoogleResponse.data;
      if (user.api_token != null) {
        await setToken(user.api_token);
        await checkAuth(context);
      }
    }
  }

  signUpWithGoogle(context) async {
    try {
      UserCredential userCredential = await signInWithGoogle();
      goTo(
          context,
          GoogleSignUpScreen(
            email: userCredential.user.email,
            name: userCredential.user.displayName,
          ));
    } catch (e) {
      errorAlert(context, exceptionError(context, e));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signUpWithUsername(context) async {
    EasyLoading.show();
    var response = await post(API.REGISTER_URL, {
      "username": username,
      "name": name,
      "phone": phone,
      "country_code": countryCode,
      "email": email,
      "password": password,
    });

    EasyLoading.dismiss();

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responseJson = response.data;

      if (responseJson.containsKey("success")) {
        if (responseJson["success"] == true) {
          EasyLoading.dismiss(animation: true);
          model.User user = model.User.fromJson(responseJson['data']);
          if (user.api_token != null) {
            await setToken(user.api_token);
            await checkAuth(context);
            Navigator.pop(context);
          }
        } else if (responseJson["success"] == false &&
            responseJson["validate"] == true) {
          validateAlert(context, responseJson["data"]);
        } else {
          falseSuccessAlert(context, responseJson["data"]);
        }
      } else {
        noSuccessAlert(context, responseJson);
      }
    } else {
      statusCodeAlert(context, response);
    }
  }

  signInWithGoogleAccount(context) async {
    SingleAPIResponse<model.User> loginGoogleResponse = SingleAPIResponse();
    loginGoogleResponse.isError = false;

    try {
      UserCredential userCredential = await signInWithGoogle();

      var data = {
        'name': userCredential.user.displayName,
        'email': userCredential.user.email,
        'username': username,
        'phone': phone,
        "country_code": countryCode,
        'photo': userCredential.user.photoURL,
      };

      Response response = await post(API.REGISTER_GOOGLE_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            loginGoogleResponse.data =
                model.User.fromJson(responseJson["data"]);
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            loginGoogleResponse.error = validateError(context, responseJson);
          } else {
            loginGoogleResponse.error =
                falseSuccessError(context, responseJson);
          }
        } else {
          loginGoogleResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        loginGoogleResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      loginGoogleResponse.error = exceptionError(context, e);
    }

    if (loginGoogleResponse.isError) {
      errorAlert(context, loginGoogleResponse.error);
    } else {
      model.User user = loginGoogleResponse.data;
      if (user.api_token != null) {
        await setToken(user.api_token);
        await checkAuth(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> sendResetPasswordCode(context) async {
    if (!isValidPhoneNumber(resetPhone)) {
      errorAlert(context, EzLocalization.of(context).get("enter_phone"));
      return;
    }

    goTo(context, EnterResetCodeScreen());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+$countryCode$resetPhone',
      verificationCompleted: (PhoneAuthCredential credential) {
        EasyLoading.showSuccess(EzLocalization.of(context).get("auto_code"));
        goTo(
            context,
            ChangePasswordScreen(
              reset: true,
            ));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          errorAlert(context, EzLocalization.of(context).get("invalid_phone"));
          return;
        }

        errorAlert(
            context,
            EzLocalization.of(context)
                .get("unknown_error", {"error": e.message}));
      },
      codeSent: (String verificationId, int resendToken) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("time out : $verificationId");
      },
      timeout: const Duration(seconds: 120),
    );
  }

  resetPassword(context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);

      var user = await FirebaseAuth.instance.signInWithCredential(credential);

      await user.user.delete();

      goTo(
          context,
          ChangePasswordScreen(
            reset: true,
          ));
    } catch (e) {
      if (e.code == "invalid-verification-code") {
        errorAlert(context, EzLocalization.of(context).get("invalid_code"));
      } else {
        errorAlert(
            context,
            EzLocalization.of(context)
                .get("unknown_error", {"error": e.toString()}));
      }
    }
  }

  changeResetPassword(context) async {
    if (resetedPassword == null || resetedPassword.isEmpty) {
      errorAlert(context, EzLocalization.of(context).get("empty_password"));
      return;
    }

    SingleAPIResponse<bool> resetResponse = SingleAPIResponse();
    resetResponse.isError = false;

    try {
      var data = {
        'phone': "$countryCode$resetPhone",
        'password': resetedPassword,
      };

      Response response = await post(API.RESET_PASSWORD_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            resetResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            resetResponse.error = validateError(context, responseJson);
          } else {
            resetResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          resetResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        resetResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      resetResponse.error = exceptionError(context, e);
    }

    if (resetResponse.isError) {
      errorAlert(context, resetResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context)
              .get("password_reseted_successfully"), fun: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  changeNewPassword(context, id) async {
    if (changedPassword == null || changedPassword.isEmpty) {
      errorAlert(context, EzLocalization.of(context).get("empty_password"));
      return;
    }

    SingleAPIResponse<bool> changeResponse = SingleAPIResponse();
    changeResponse.isError = false;

    try {
      var data = {
        'id': id,
        'password': changedPassword,
      };

      Response response = await post(API.CHANGE_PASSWORD_URL, data);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            changeResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            changeResponse.error = validateError(context, responseJson);
          } else {
            changeResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          changeResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        changeResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      changeResponse.error = exceptionError(context, e);
    }

    if (changeResponse.isError) {
      errorAlert(context, changeResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context)
              .get("password_changed_successfully"), fun: () {
        Navigator.pop(context);
      });
    }
  }

  //

  Future<void> sendPhoneVerifiedCode(context) async {
    if (!isValidPhoneNumber(phone)) {
      errorAlert(context, EzLocalization.of(context).get("invalid_phone"));
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        EasyLoading.showSuccess(EzLocalization.of(context).get("auto_code"));
        var user = await FirebaseAuth.instance.signInWithCredential(credential);

        loginWithPhone(context, await user.user.getIdToken());

        await user.user.delete();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          errorAlert(context, EzLocalization.of(context).get("invalid_phone"));
          return;
        }

        errorAlert(
            context,
            EzLocalization.of(context)
                .get("unknown_error", {"error": e.message}));
      },
      codeSent: (String verificationId, int resendToken) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("time out : $verificationId");
      },
      timeout: const Duration(seconds: 120),
    );
  }

  verifyPhoneCode(context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);

      var user = await FirebaseAuth.instance.signInWithCredential(credential);

      loginWithPhone(context, await user.user.getIdToken());

      await user.user.delete();
    } catch (e) {
      if (e.code == "invalid-verification-code") {
        errorAlert(context, EzLocalization.of(context).get("invalid_code"));
      } else {
        errorAlert(
            context,
            EzLocalization.of(context)
                .get("unknown_error", {"error": e.toString()}));
      }
    }
  }

  verifyPhone(context) async {
    SingleAPIResponse<bool> verifyResponse = SingleAPIResponse();
    verifyResponse.isError = false;

    try {
      Response response = await getWithToken(API.PHONE_VERIFIED_URL);

      print(response);

      if (response == null) {
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            verifyResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            verifyResponse.error = validateError(context, responseJson);
          } else {
            verifyResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          verifyResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        verifyResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      verifyResponse.error = exceptionError(context, e);
    }

    if (verifyResponse.isError) {
      errorAlert(context, verifyResponse.error);
    } else {
      successAlert(context,
          message: EzLocalization.of(context)
              .get("phone_verified_successfully"), fun: () {
        //Navigator.pop(context);
        isVerified = true;
        notifyListeners();
      });
    }
  }

  checkUserOnServer(context) async {
    SingleAPIResponse<bool> verifyResponse = SingleAPIResponse();
    verifyResponse.isError = false;

    try {
      Response response = await getWithToken(API.CHECK_USER_URL);

      print(response);

      if (response == null) {
        isVerified = false;
        isLoaded = true;
        notifyListeners();
        return;
      }

      Map responseJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson.containsKey("success")) {
          if (responseJson["success"] == true) {
            verifyResponse.data = true;
          } else if (responseJson["success"] == false &&
              responseJson["validate"] == true) {
            verifyResponse.error = validateError(context, responseJson);
          } else {
            verifyResponse.error = falseSuccessError(context, responseJson);
          }
        } else {
          verifyResponse.error = noSuccessError(context, responseJson);
        }
      } else {
        verifyResponse.error = statusCodeError(context, response);
      }
    } catch (e) {
      verifyResponse.error = exceptionError(context, e);
    }

    if (verifyResponse.isError) {
      isVerified = false;
    } else {
      isVerified = true;
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<void> loginWithPhone(context, token) async {
    EasyLoading.show();

    var response = await post(API.PHONE_LOGIN_URL, {"token": token});

    EasyLoading.dismiss();

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responseJson = response.data;

      if (responseJson.containsKey("success")) {
        if (responseJson["success"] == true) {
          model.User user = model.User.fromJson(responseJson['data']);
          if (user.api_token != null) {
            await setToken(user.api_token);
            await checkAuth(context);
            Navigator.pop(context);
          }
        } else if (responseJson["success"] == false &&
            responseJson["validate"] == true) {
          validateAlert(context, responseJson["data"]);
        } else {
          falseSuccessAlert(context, responseJson["data"]);
        }
      } else {
        noSuccessAlert(context, responseJson);
      }
    } else {
      statusCodeAlert(context, response);
    }
  }
}
