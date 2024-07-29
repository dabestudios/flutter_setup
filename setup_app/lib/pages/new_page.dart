import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:setup_app/adMob/ad_helper.dart';
import 'package:setup_app/pages/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPage createState() => _NewPage();
}

class _NewPage extends State<NewPage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the New Page!',
              style: TextStyle(fontSize: 24),
            ),
            if (_bannerAd != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
