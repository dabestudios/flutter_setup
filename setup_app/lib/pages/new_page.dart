import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:setup_app/adMob/ad_helper.dart';
import 'package:setup_app/exercise.dart';
import 'package:setup_app/main.dart';
import 'navbar.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  BannerAd? _bannerAd;
  bool _isAdsInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadExercises();
  }

  Future<void> _initGoogleMobileAds() async {
    await MobileAds.instance.initialize();
    setState(() {
      _isAdsInitialized = true;
    });
    _loadBannerAd();
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
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

  Future<void> _loadExercises() async {
    await loadExercises();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Dispose the BannerAd object
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the New Page!',
              style: TextStyle(fontSize: 24),
            ),
            const Spacer(),
            // Display the first exercise
            if (_isLoading)
              const CircularProgressIndicator()
            else if (globalExercises.isNotEmpty)
              Column(
                children: [
                  Text(
                    globalExercises[0].name ?? 'No Name',
                    style: TextStyle(fontSize: 18),
                  ),
                  ...globalExercises[0]
                          .instructions
                          ?.map((instruction) => Text(instruction))
                          .toList() ??
                      [Text('No Instructions')],
                ],
              )
            else
              const Text('No Exercises Found'),
            Spacer(),
            if (_bannerAd != null && _isAdsInitialized)
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
