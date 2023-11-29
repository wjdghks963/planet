import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdWidget extends StatefulWidget {
  const CustomAdWidget({super.key});

  @override
  State<CustomAdWidget> createState() => _CustomAdWidgetState();
}

class _CustomAdWidgetState extends State<CustomAdWidget> {
  BannerAd? banner;

  @override
  void initState() {
    super.initState();
    final BannerAdListener listener = BannerAdListener(
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      onAdOpened: (Ad ad) => print('Ad opened.'),
      onAdClosed: (Ad ad) => print('Ad closed.'),
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    banner = BannerAd(
      adUnitId: Platform.isAndroid == true
          ? 'ca-app-pub-7080497784773590/3622916780'
          : 'ca-app-pub-7080497784773590/9074554018',
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    )..load();
  }

  @override
  Widget build(BuildContext context) {

    if (banner == null) {
      return const SizedBox();
    } else {
      // 광고가 있을 때, AdWidget을 반환
      return SizedBox(
        height: 50, // 광고의 높이 설정
        child: AdWidget(ad: banner!),
      );
    }
  }
}
