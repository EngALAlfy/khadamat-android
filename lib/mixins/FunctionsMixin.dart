import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

mixin FunctionsMixin {



}

goTo(context, screen) {
  Navigator.of(context).push(
      PageTransition(child: screen, type: PageTransitionType.leftToRight));
}


adBanner({bannerSize : AdmobBannerSize.BANNER}) {
  if(kIsWeb) return Container(height: 0,width: 0,);
  return AdmobBanner(
    adUnitId: "ca-app-pub-2005768462081299/5307321595",
    adSize: bannerSize,
  );
}

adFull() {
  if(kIsWeb) return;
  return AdmobInterstitial(
    adUnitId: "ca-app-pub-2005768462081299/3234518566",
  );
}


openPlay() async {
  await launch("https://play.google.com/store/apps/details?id=com.alalfy.khadamat_app");
}