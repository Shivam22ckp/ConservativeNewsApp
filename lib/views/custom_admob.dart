import 'package:firebase_admob/firebase_admob.dart';

class CustomAdmob {
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Newsapp', 'beautifulApps'],
    contentUrl: 'https://flutter.io',
    childDirected: true,
    testDevices: <String>[],
  );

  BannerAd bannerAd() {
    return BannerAd(
      adUnitId: 'a-app-pub-9831290057758886/5082159886',
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }
}
