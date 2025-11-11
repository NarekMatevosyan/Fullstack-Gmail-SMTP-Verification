import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:bbb/components/back_arrow_widget.dart';
import 'package:provider/provider.dart';
import '../../components/common_streak_with_notification.dart';
import '../../providers/data_provider.dart';
import '../../models/exerciselibrary.dart';
// import '../../models/equipmenttitle.dart';
// import '../../models/category.dart';

class ExerciseLibraryPage extends StatefulWidget {
  const ExerciseLibraryPage({super.key});

  @override
  State<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  DataProvider? dataProvider;
  int _currentPage = 0;
  final int _itemsPerPage = 10; // Number of exercises per page
  int _numPages = 0;
  String _searchQuery = "";
  String _selectedSortBy = 'A-Z'; // Default sorting
  List<String> _selectedEquipmentIds = [];
  List<String> _selectedCategoryIds = [];

  List<ExerciseLibrary> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider?.fetchAdminData().then((_) {
      setState(() {
        // Calculate the number of pages based on the fetched exercises
        if (dataProvider!.adminExercises.isNotEmpty) {
          _filteredExercises = dataProvider!.adminExercises;
          _numPages = (_filteredExercises.length / _itemsPerPage).ceil();
        } else {
          _numPages = 1; // Handle the case when no exercises are available
        }
      });
    }).catchError((error) {
      debugPrint('Error fetching admin exercises: $error');
    });
  }

  List<ExerciseLibrary> _getPaginatedExercises() {
    // return _filteredExercises;
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    return _filteredExercises.sublist(
      startIndex,
      endIndex < _filteredExercises.length
          ? endIndex
          : _filteredExercises.length,
    );
  }

  void _applyFilters() {
    setState(() {
      _currentPage = 0;
      // Filter exercises based on selected equipment, category, and search query
      _filteredExercises = dataProvider!.adminExercises.where((exercise) {
        bool matchesEquipment = _selectedEquipmentIds.isEmpty ||
            exercise.usedEquipments
                .any((equip) => _selectedEquipmentIds.contains(equip));

        bool matchesCategory = _selectedCategoryIds.isEmpty ||
            exercise.categories
                .any((cat) => _selectedCategoryIds.contains(cat));

        bool matchesSearch = _searchQuery.isEmpty ||
            exercise.title.toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesEquipment && matchesCategory && matchesSearch;
      }).toList();

      // Sort exercises based on the selected sorting option
      if (_selectedSortBy == 'A-Z') {
        _filteredExercises.sort((a, b) => a.title.compareTo(b.title));
      } else if (_selectedSortBy == 'Z-A') {
        _filteredExercises.sort((a, b) => b.title.compareTo(a.title));
      } else if (_selectedSortBy == 'Newest added') {
        _filteredExercises.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else if (_selectedSortBy == 'Oldest added') {
        _filteredExercises.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }

      _numPages = (_filteredExercises.length / _itemsPerPage).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    ScreenUtil.init(context);

    // Fetch the exercises for the current page
    // List<ExerciseLibrary> paginatedExercises = _getPaginatedExercises();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: media.height / 2.3,
                          width: media.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/back.jpg'),
                              fit: BoxFit.cover,
                              opacity: 1,
                            ),
                          ),
                        ),
                        Container(
                          height: media.height / 2.2,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BackArrowWidget(
                                        onPress: () => {Navigator.pop(context)}
                                      ),
                                      Text(
                                        'Exercise Library',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.horizontalScale(5.5),
                                        ),
                                      ),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(7),
                                  ),
                                  height: media.height * 0.2,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: ScreenUtil.horizontalScale(1),
                                        ),
                                        SearchExerciseField(
                                          onChanged: (query) {
                                            setState(() {
                                              _currentPage = 0;
                                              _searchQuery = query; // Update the search query                                              
                                              _applyFilters(); // Reset pagination when searching
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.horizontalScale(3),
                                        ),
                                        FilterSortButton(
                                          selectedEquipmentIds:
                                              _selectedEquipmentIds,
                                          selectedCategoryIds:
                                              _selectedCategoryIds,
                                          selectedSortBy: _selectedSortBy,
                                          equipments: dataProvider!
                                              .adminEquipment
                                              .map((e) => {
                                                    'id': e.id,
                                                    'title': e.title
                                                  })
                                              .toList(),
                                          categories: dataProvider!
                                              .adminCategory
                                              .map((c) => {
                                                    'id': c.id,
                                                    'title': c.title
                                                  })
                                              .toList(),
                                          onApplyFilters: (List<String>
                                                  selectedEquipments,
                                              List<String> selectedCategories,
                                              String sortBy) {
                                            setState(() {
                                              _selectedEquipmentIds =
                                                  selectedEquipments;
                                              _selectedCategoryIds =
                                                  selectedCategories;
                                              _selectedSortBy = sortBy;
                                            });
                                            _applyFilters(); // Apply the filters and sorting
                                          },
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 3.19,
                          width: media.width,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ClipPath(
                              clipper: DiagonalClipper(),
                              child: Container(
                                height: media.height / 11,
                                width: media.width / 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: media.height / 3.2),
                  child: Container(
                    width: media.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: media.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(55),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil.horizontalScale(5),
                              vertical: ScreenUtil.verticalScale(2),
                            ),
                            child: dataProvider == null || dataProvider!.adminExercises.isEmpty || _filteredExercises.isEmpty
                            ? SizedBox(
                                height: ScreenUtil.verticalScale(10),
                              )
                            : Column(
                              children: [
                                SizedBox(
                                  height: ScreenUtil.verticalScale(2),
                                ),
                                Column(
                                  children:
                                      _getPaginatedExercises().map((exercise) {
                                    return Column(
                                      children: [
                                        exerciseCard(
                                          exercise.title,
                                          exercise
                                              .thumbnail, // Dynamically display exercise titles
                                        ),
                                        SizedBox(
                                          height: ScreenUtil.verticalScale(2),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: ScreenUtil.verticalScale(2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        alignment: Alignment.center,
        color: Colors.white,
        height: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _numPages > 0
              ? NumberPaginator(
                  numberPages: _numPages,
                  config: const NumberPaginatorUIConfig(
                    height: 48,
                    buttonSelectedForegroundColor: AppColors.primaryColor,
                    buttonUnselectedForegroundColor: Colors.grey,
                    buttonUnselectedBackgroundColor: Colors.transparent,
                    buttonSelectedBackgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    buttonTextStyle: TextStyle(fontSize: 15),
                  ),
                  onPageChange: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget exerciseCard(String title, String image) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(right: ScreenUtil.horizontalScale(5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenUtil.verticalScale(8)),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: media.width / 4,
                width: media.width / 4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image == ""
                        ? const AssetImage("assets/img/library_placeholder.png")
                        : NetworkImage(
                            image.startsWith(
                                    'https://storage.cloud.google.com/')
                                ? image.replaceFirst(
                                    'https://storage.cloud.google.com/',
                                    'https://storage.googleapis.com/')
                                : image,
                          ),
                    fit: BoxFit.cover,
                    opacity: 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil.verticalScale(8)),
                    bottomLeft: Radius.circular(ScreenUtil.verticalScale(8)),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: media.width / 2.5,
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: ScreenUtil.horizontalScale(4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.verticalScale(0.7),
              vertical: ScreenUtil.verticalScale(0.7),
            ),
            decoration: const BoxDecoration(
                color: AppColors.primaryColor, shape: BoxShape.circle),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: ScreenUtil.verticalScale(3),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchExerciseField extends StatelessWidget {
  final ValueChanged<String> onChanged; // Add a callback for text change

  const SearchExerciseField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil.horizontalScale(3),
        vertical: ScreenUtil.horizontalScale(1),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(6)),
      ),
      child: TextField(
        onChanged: onChanged, // Notify the parent of text changes
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search Exercises',
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: ScreenUtil.verticalScale(2),
          ),
          suffixIcon: Icon(
            Icons.search,
            size: ScreenUtil.verticalScale(4),
            color: Colors.grey[300],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.horizontalScale(2),
          ),
        ),
      ),
    );
  }
}

class FilterSortButton extends StatefulWidget {
  final List<String> selectedEquipmentIds;
  final List<String> selectedCategoryIds;
  final String selectedSortBy;
  final Function(List<String> selectedEquipmentIds,
      List<String> selectedCategoryIds, String selectedSortBy) onApplyFilters;

  final List<Map<String, String>> equipments; // Add dynamic equipment data
  final List<Map<String, String>> categories; // Add dynamic category data

  const FilterSortButton({
    super.key,
    required this.selectedEquipmentIds,
    required this.selectedCategoryIds,
    required this.selectedSortBy,
    required this.onApplyFilters,
    required this.equipments, // Receive the equipment data
    required this.categories, // Receive the category data
  });

  @override
  _FilterSortButtonState createState() => _FilterSortButtonState();
}

class _FilterSortButtonState extends State<FilterSortButton> {
  String _selectedSortBy = 'A-Z'; // Default value for sort by
  List<String> _selectedEquipmentIds = []; // Store selected equipment IDs
  List<String> _selectedCategoryIds = []; // Store selected category IDs
  @override
  void initState() {
    super.initState();
    _selectedEquipmentIds = widget.selectedEquipmentIds;
    _selectedCategoryIds = widget.selectedCategoryIds;
    _selectedSortBy = widget.selectedSortBy;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
      width: media.width,
      child: ElevatedButton(
        onPressed: () {
          _showFilterSortDialog(context, media.width);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9a354e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil.verticalScale(6)),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil.horizontalScale(3.5),
            horizontal: ScreenUtil.horizontalScale(4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.tune,
              color: Colors.white70,
              size: 25,
            ),
            const SizedBox(width: 20),
            Container(
              height: 35,
              width: 0.5,
              decoration: const BoxDecoration(color: Colors.white70),
            ),
            const SizedBox(width: 65),
            const Text(
              'Filter & Sort',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSortDialog(BuildContext context, double dialogWidth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            List<bool> isExpanded = [true, false, false];
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(0),// Popup background color
              child: SingleChildScrollView(
                // Wrap the content in a SingleChildScrollView
                child: Container(
                  width: ScreenUtil.horizontalScale(96), // Set the width of the popup to match the button
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter & Sort Options',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9a354e), // White text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Color(0xFF9a354e)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // "Sort by" ExpansionTile with Radio buttons
                      ExpansionTile(
                        title: const Text(
                          'Sort by',
                          style: TextStyle(fontSize: 14), // Small white text
                        ),
                        textColor: const Color(0xFF9a354e),
                        collapsedTextColor: Colors.black,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 252, 252, 252),
                              width: 1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color(0xFF9a354e), width: 1),
                        ),
                        iconColor: Colors.black,
                        collapsedIconColor: const Color(0xFF9a354e),
                        initiallyExpanded:
                            isExpanded[0], // Set initial expanded state
                        onExpansionChanged: (isExpandedState) {
                          setState(() {
                            // Set the current index to true and others to false
                            isExpanded = [isExpandedState, false, false];
                          });
                        },
                        children: <String>[
                          'A-Z',
                          'Z-A',
                          'Newest added',
                          'Oldest added'
                        ].map((String option) {
                          return RadioListTile<String>(
                            title: Text(option,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black)),
                            value: option,
                            groupValue: _selectedSortBy,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSortBy = value!;
                              });
                            },
                            activeColor: const Color(
                                0xFF9a354e), // Change the checked color here
                            hoverColor: Colors.white,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // "Filter by Equipment" ExpansionTile with Checkboxes
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Green background for the tile
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: const Text(
                            'Filter by Equipment',
                            style: TextStyle(fontSize: 14),
                          ),
                          textColor: const Color(0xFF9a354e),
                          collapsedTextColor: Colors.black,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 252, 252, 252),
                                width: 1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0xFF9a354e), width: 1),
                          ),
                          iconColor: Colors.black,
                          collapsedIconColor: const Color(0xFF9a354e),
                          initiallyExpanded:
                              isExpanded[1], // Set initial expanded state
                          onExpansionChanged: (isExpandedState) {
                            setState(() {
                              // Set the current index to true and others to false
                              isExpanded = [false, isExpandedState, false];
                            });
                          },
                          children: widget.equipments
                              .map((Map<String, String> equipment) {
                            return CheckboxListTile(
                              title: Text(equipment['title']!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black)),
                              value: _selectedEquipmentIds
                                  .contains(equipment['id']),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedEquipmentIds.add(equipment['id']!);
                                  } else {
                                    _selectedEquipmentIds
                                        .remove(equipment['id']);
                                  }
                                });
                              },
                              activeColor: const Color(
                                  0xFF9a354e), // Change the checked color here
                              checkColor: Colors.white,
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // "Filter by Categories" ExpansionTile with Checkboxes
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Green background for the tile
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: const Text(
                            'Filter by Categories',
                            style: TextStyle(fontSize: 14),
                          ),
                          textColor: const Color(0xFF9a354e),
                          collapsedTextColor: Colors.black,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 252, 252, 252),
                                width: 1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0xFF9a354e), width: 1),
                          ),
                          iconColor: Colors.black,
                          collapsedIconColor: const Color(0xFF9a354e),
                          initiallyExpanded:
                              isExpanded[2], // Set initial expanded state
                          onExpansionChanged: (isExpandedState) {
                            setState(() {
                              // Set the current index to true and others to false
                              isExpanded = [false, false, isExpandedState];
                            });
                          },
                          children: widget.categories
                              .map((Map<String, String> category) {
                            return CheckboxListTile(
                              title: Text(category['title']!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black)),
                              value:
                                  _selectedCategoryIds.contains(category['id']),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedCategoryIds.add(category['id']!);
                                  } else {
                                    _selectedCategoryIds.remove(category['id']);
                                  }
                                });
                              },
                              activeColor: const Color(
                                  0xFF9a354e), // Change the checked color here
                              checkColor: Colors.white,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Apply now button
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF9a354e), // Apply now button color
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onApplyFilters(
                              _selectedEquipmentIds,
                              _selectedCategoryIds,
                              _selectedSortBy,
                            );
                          },
                          child: const Text(
                            'Apply now',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
