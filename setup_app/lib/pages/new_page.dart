import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:setup_app/adMob/ad_helper.dart';
import 'package:setup_app/pages/review_and_edit_routine.dart';
import 'package:setup_app/tables/exercise.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  BannerAd? _bannerAd;
  bool _isAdsInitialized = false;
  final List<Exercise> _selectedExercises = [];
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  bool _isLoading = true;
  final ExerciseLoader _exerciseLoader = ExerciseLoader();
  final Set<String> _selectedMuscleGroups = {}; // No hay opción 'All'
  final Set<String> _muscleGroups = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadData();
    _searchController.addListener(() {
      _filterExercises();
    });
  }

  void _filterExercises() {
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        final matchesName = exercise.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesMuscleGroups = _selectedMuscleGroups.isEmpty ||
            exercise.primaryMuscles
                .any((muscle) => _selectedMuscleGroups.contains(muscle));
        return matchesName && matchesMuscleGroups;
      }).toList();
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

  void _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(Locales.string(context, 'select_muscle_groups')),
              content: SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 8.0, // Espacio horizontal entre chips
                  runSpacing: 4.0, // Espacio vertical entre chips
                  children: _muscleGroups.map((String muscleGroup) {
                    final isSelected =
                        _selectedMuscleGroups.contains(muscleGroup);
                    return FilterChip(
                      label: Text(
                        muscleGroup,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedMuscleGroups.add(muscleGroup);
                          } else {
                            _selectedMuscleGroups.remove(muscleGroup);
                          }
                        });
                        _filterExercises();
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.grey[200],
                      showCheckmark: false, // Oculta el checkmark
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets
                          .zero, // Ajusta el padding para que no haya espacio extra
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Locales.string(context, 'reset')),
                  onPressed: () {
                    setState(() {
                      _selectedMuscleGroups.clear();
                      _filterExercises();
                    });
                  },
                ),
                TextButton(
                  child: Text(Locales.string(context, 'apply')),
                  onPressed: () {
                    _filterExercises();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locales.string(context, 'create_routine')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 8.0),
                PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: Locales.string(context, 'search_exercises'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        // Para actualizar el estado y mostrar/ocultar la "X"
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
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
                                : Theme.of(context).colorScheme.surface,
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      exercise.images != null
                                          ? Image.asset(
                                              'assets/photos/${exercise.images}',
                                              height: 74,
                                            )
                                          : Container(
                                              height: 74,
                                              color: Colors.grey,
                                              child: const Center(
                                                  child: Text('No Image')),
                                            ),
                                      Text(
                                        exercise.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2, // Limita a una línea
                                        overflow: TextOverflow
                                            .ellipsis, // Usa puntos suspensivos si es necesario
                                      ),
                                      Text(
                                        exercise.primaryMuscles.isNotEmpty
                                            ? exercise.primaryMuscles.join(', ')
                                            : Locales.string(
                                                context, 'no_muscles_info'),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Colors.grey,
                                        ),

                                        textAlign: TextAlign.center,
                                        maxLines: 1, // Limita a dos líneas
                                        overflow: TextOverflow
                                            .ellipsis, // Usa puntos suspensivos si es necesario
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
                    child: SizedBox(
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
                '${Locales.string(context, 'exercises_selected')}: ${_selectedExercises.length}',
              ),
            ),
            if (_selectedExercises.isNotEmpty)
              TextButton(
                onPressed: _createRoutine,
                child: Text(Locales.string(context, 'save_routine')),
              ),
          ],
        ),
      ),
    );
  }
}
