import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:setup_app/adMob/ad_helper.dart';
import 'package:setup_app/pages/review_and_edit_routine.dart';
import 'package:setup_app/tables/exercise.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  BannerAd? _bannerAd;
  bool _isAdsInitialized = false;
  List<Exercise> _selectedExercises = [];
  List<Exercise> _exercises = [];
  bool _isLoading = true; // Estado de carga inicializado a true
  final ExerciseLoader _exerciseLoader = ExerciseLoader();

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadData(); // Iniciar la carga de los ejercicios
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
          print('Error to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  Future<void> _loadData() async {
    // Cargar los ejercicios usando el singleton ExerciseLoader
    final exercises = await _exerciseLoader.getExercises();
    setState(() {
      _exercises = exercises;
      _isLoading =
          false; // Cuando los datos estén listos, dejar de mostrar la espera
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewAndEditPage(
          selectedExercises: _selectedExercises,
          onSave: (routine) {
            // Implementa la lógica para guardar la rutina en la base de datos
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Mostrar rueda de espera si está cargando
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Select Exercises',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
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
                            children: [
                              // Imagen en la parte superior
                              exercise.images != null
                                  ? Image.asset(
                                      'assets/photos/${exercise.images}',
                                      height:
                                          40, // Ajusta el tamaño según sea necesario
                                      width: double.infinity,
                                    )
                                  : Container(
                                      height:
                                          100, // Tamaño de placeholder si no hay imagen
                                      color: Colors.grey,
                                      child: Center(child: Text('No Image')),
                                    ),
                              // Contenido debajo de la imagen
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        exercise.primaryMuscles.isNotEmpty
                                            ? exercise.primaryMuscles.join(', ')
                                            : 'No muscles info',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
