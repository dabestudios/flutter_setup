import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:setup_app/adMob/ad_helper.dart';
import 'package:setup_app/pages/review_and_edit_routine.dart';
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
  List<Exercise> _selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadData();
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

  Future<void> _loadData() async {
    await loadExercises();
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleExerciseSelection(Exercise exercise) {
    setState(() {
      if (_selectedExercises.contains(exercise)) {
        _selectedExercises.remove(exercise);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  void _createRoutine() {
    // Aquí puedes implementar la navegación a una nueva página para confirmar y guardar la rutina
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReviewAndEditPage(
                  selectedExercises: _selectedExercises,
                  onSave: (routine) {
                    // Implementa la lógica para guardar la rutina en la base de datos
                  },
                )));
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
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Select Exercises',
              style: TextStyle(fontSize: 24),
            ),
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
                  final isSelected = _selectedExercises.contains(exercise);
                  return GestureDetector(
                    onTap: () => _toggleExerciseSelection(exercise),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                            : Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            exercise.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onBackground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Muscle', // Reemplaza con la lógica adecuada para los músculos primarios
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${_selectedExercises.length} Exercises Selected',
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (_selectedExercises.isNotEmpty)
              TextButton(
                child: Text('Save Routine'),
                onPressed: _createRoutine,
              ),
          ],
        ),
      ),
    );
  }
}
