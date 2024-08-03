import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:setup_app/adMob/ad_helper.dart';
import 'package:setup_app/tables/exercise.dart';
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
          children: [
            const Text(
              'Welcome to the New Page!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16.0),
            // Mostrar indicador de carga o los ejercicios
            if (_isLoading)
              const CircularProgressIndicator() // Indicador de carga mientras se cargan los ejercicios
            else if (globalExercises.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Número de columnas en la cuadrícula
                    childAspectRatio:
                        3 / 2, // Relación de aspecto de los elementos
                    mainAxisSpacing:
                        10, // Espaciado entre elementos en la dirección principal
                    crossAxisSpacing:
                        10, // Espaciado entre elementos en la dirección transversal
                  ),
                  itemCount: globalExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = globalExercises[index];
                    return ElevatedButton(
                      onPressed: () {
                        // Acción al presionar el botón del ejercicio
                      },
                      style: ElevatedButton.styleFrom(
                        // Color del texto del botón
                        padding: const EdgeInsets.all(
                            8.0), // Espaciado interno del botón
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Bordes redondeados
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            exercise.name ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            exercise.primaryMuscles.isNotEmpty
                                ? exercise.primaryMuscles[0]
                                : 'No Primary Muscle',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Text('No Exercises Found'),
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
