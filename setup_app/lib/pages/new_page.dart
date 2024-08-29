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
  bool _isLoading = true;
  final ExerciseLoader _exerciseLoader = ExerciseLoader();
  Set<String> _selectedMuscleGroups = {'All'};
  List<Exercise> _filteredExercises = [];
  Set<String> _muscleGroups = {'All'};

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadData();
  }

  void _filterExercises() {
    setState(() {
      if (_selectedMuscleGroups.contains('All')) {
        _filteredExercises = _exercises;
      } else {
        _filteredExercises = _exercises.where((exercise) {
          return exercise.primaryMuscles.any((muscle) {
            return _selectedMuscleGroups.contains(muscle);
          });
        }).toList();
      }
    });
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
    final exercises = await _exerciseLoader.getExercises();
    setState(() {
      _exercises = exercises;
      _filteredExercises = exercises;
      _muscleGroups.addAll(_extractMuscleGroups(exercises));
      _isLoading = false;
    });
  }

  Set<String> _extractMuscleGroups(List<Exercise> exercises) {
    final muscleGroups = <String>{};
    for (var exercise in exercises) {
      muscleGroups.addAll(exercise.primaryMuscles);
    }
    return muscleGroups;
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

  bool _isSelected(Exercise exercise) {
    return _selectedExercises.any((selected) => selected.id == exercise.id);
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (String muscleGroup) {
              setState(() {
                if (muscleGroup == 'All') {
                  _selectedMuscleGroups = {'All'};
                } else {
                  if (_selectedMuscleGroups.contains('All')) {
                    _selectedMuscleGroups.remove('All');
                  }
                  if (_selectedMuscleGroups.contains(muscleGroup)) {
                    _selectedMuscleGroups.remove(muscleGroup);
                    if (_selectedMuscleGroups.isEmpty) {
                      _selectedMuscleGroups.add('All');
                    }
                  } else {
                    _selectedMuscleGroups.add(muscleGroup);
                  }
                }
                _filterExercises();
              });
            },
            itemBuilder: (BuildContext context) {
              return _muscleGroups.map((String muscleGroup) {
                return PopupMenuItem<String>(
                  value: muscleGroup,
                  child: Text(muscleGroup),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by muscle group',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      final isSelected = _isSelected(exercise);
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
                              exercise.images != null
                                  ? Image.asset(
                                      'assets/photos/${exercise.images}',
                                      height: 40,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      height: 100,
                                      color: Colors.grey,
                                      child:
                                          const Center(child: Text('No Image')),
                                    ),
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
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (_selectedExercises.isNotEmpty)
              TextButton(
                child: const Text('Save Routine'),
                onPressed: _createRoutine,
              ),
          ],
        ),
      ),
    );
  }
}
