import 'package:ez_localization/ez_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deep_linking/flutter_deep_linking.dart' as deep;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:khadamat_app/providers/CategoriesProvider.dart';
import 'package:khadamat_app/providers/CoinPackProvider.dart';
import 'package:khadamat_app/providers/FilmsProvider.dart';
import 'package:khadamat_app/providers/ItemsProvider.dart';
import 'package:khadamat_app/providers/LocaleProvider.dart';
import 'package:khadamat_app/providers/PointsPurchasesProvider.dart';
import 'package:khadamat_app/providers/ProfileProvider.dart';
import 'package:khadamat_app/providers/SeriesProvider.dart';
import 'package:khadamat_app/providers/SubCategoriesProvider.dart';
import 'package:khadamat_app/providers/ThemeProvider.dart';
import 'package:khadamat_app/providers/UtilsProvider.dart';
import 'package:khadamat_app/screens/AboutScreen.dart';
import 'package:khadamat_app/screens/HomeScreen.dart';
import 'package:khadamat_app/screens/ItemDetailsScreen.dart';
import 'package:khadamat_app/screens/UserProfileItemsScreen.dart';
import 'package:khadamat_app/screens/UserProfileScreen.dart';
import 'package:khadamat_app/screens/auth/LoginScreen.dart';
import 'package:khadamat_app/widgets/IsEmptyWidget.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as ago;
import 'package:khadamat_app/providers/DatabaseProvider.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'package:khadamat_app/screens/ShowItemRouteScreen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if ((defaultTargetPlatform == TargetPlatform.iOS) ||
      (defaultTargetPlatform == TargetPlatform.android)) {
    // Some android/ios specific code
    if (!kIsWeb) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
      await Firebase.initializeApp();
    }
  }

  configureApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UtilsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CoinPackProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SubCategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ItemsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PointsPurchasesProvider(),
        ),ChangeNotifierProvider(
          create: (context) => DatabaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilmsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SeriesProvider(),
        ),
      ],
      child: EzLocalizationBuilder(
          delegate: EzLocalizationDelegate(
            supportedLocales: [
              Locale('en'),
              Locale('ar'),
            ],
          ),
          builder: (context, localizationDelegate) {
            return Consumer2<ThemeProvider, LocaleProvider>(
              builder: (context, value, value2, child) {
                if (value.isDarkLoaded) {
                  if (value2.isLocaleLoaded) {
                    return MaterialApp(
                      onGenerateTitle: (BuildContext context) {
                        return EzLocalization.of(context).get("app_web_title");
                      },
                      debugShowCheckedModeBanner: false,
                      darkTheme: ThemeData(
                        fontFamily: 'cairo',
                        brightness: Brightness.dark,
                        accentColor: Colors.brown[300],
                        textTheme: TextTheme(
                          headline1: TextStyle(color: Colors.white),
                          headline6: TextStyle(color: Colors.white),
                          bodyText2: TextStyle(color: Colors.white),
                        ),
                      ),
                      themeMode: value.isDark == null
                          ? ThemeMode.system
                          : (value.isDark ? ThemeMode.dark : ThemeMode.light),
                      theme: ThemeData(
                        fontFamily: 'cairo',
                        brightness: Brightness.light,
                        primaryColor: Colors.brown[300],
                      ),
                      builder: EasyLoading.init(),
                      home: getHome(context),
                      locale: value2.locale,
                      onGenerateRoute: router.onGenerateRoute,
                      localizationsDelegates:
                          localizationDelegate.localizationDelegates,
                      supportedLocales: localizationDelegate.supportedLocales,
                      localeResolutionCallback:
                          localizationDelegate.localeResolutionCallback,
                    );
                  } else {
                    value2.getLocale(context);
                    return IsLoadingWidget();
                  }
                } else {
                  value.getIsDark();
                  return IsLoadingWidget();
                }
              },
            );
          }),
    );
  }

  getHome(context) {
    ago.setLocaleMessages('ar', ago.ArMessages());

    if (kIsWeb) {
      return HomeScreen();
    }

    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        if (value.isLoaded) {
          if (value.isAuth) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        } else {
          value.checkAuth(context);
        }
        return IsLoadingWidget();
      },
    );
  }

  final router = deep.Router(
    routes: [

      deep.Route(
        matcher: deep.Matcher.path('item'),
        routes: [
          deep.Route(
            matcher: deep.Matcher.path('{id}'),
            materialBuilder: (_, deep.RouteResult result) {

              var id = int.parse(result['id']);
              return ShowItemRouteScreen(id:id,);

              },
          ),
        ],
      ),

      deep.Route(
        matcher: deep.Matcher.path('profile'),
        routes: [
          deep.Route(
            matcher: deep.Matcher.path('{id}'),
            routes: [
              deep.Route(
                matcher: deep.Matcher.path('items'),
                materialBuilder: (_, deep.RouteResult result) {
                  return UserProfileItemsScreen(
                    id: int.parse(result['id']),
                  );
                },
              ),
            ],
            materialBuilder: (_, deep.RouteResult result) {
              return UserProfileScreen(
                id: int.parse(result['id']),
              );
            },
          ),
        ],
      ),
    ],
  );
}
