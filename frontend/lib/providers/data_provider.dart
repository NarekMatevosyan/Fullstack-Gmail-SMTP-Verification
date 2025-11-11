import 'dart:convert';

import 'package:bbb/models/bonuses.dart';
import 'package:bbb/models/category.dart';
import 'package:bbb/models/challenges.dart';
import 'package:bbb/models/collections.dart';
import 'package:bbb/models/equipment.dart';
import 'package:bbb/models/equipmenttitle.dart';
import 'package:bbb/models/exerciselibrary.dart';
import 'package:bbb/models/staffs.dart';
import 'package:bbb/models/tutorials.dart';
import 'package:bbb/pages/NewMonthView/Database/month_database.dart';
import 'package:bbb/pages/NewMonthView/Database/month_prefrence.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/month_response_model.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/new_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/values/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {
  List<ExerciseLibrary> adminExercises = [];
  List<CategoryTitle> adminCategory = [];
  List<EquipmentTitle> adminEquipment = [];
  List<Equipment> adminEquipmentsData = [];
  List<Bonuses> adminBonusesData = [];
  MonthProvider? monthProvider;

  List<Staffs> staffsData = [];
  List<dynamic> selectWeekBasedOnSplit = [];
  List<Staffs> athletesData = [];
  List<Collections> collectionsData = [];
  String equipmentCheckpoint = '';
  String bonusCheckpoint = '';
  String workoutCheckpoint = '';
  bool equipmentCheckpointState = false;
  bool bonusCheckpointState = false;
  bool workoutCheckpointState = false;

  Collections collectionData = Collections(id: "", title: "", description: "", photo: "", equipments: []);

  Challenges featureChallengeData = Challenges(id: '', title: '', description: '', photo: '');
  Tutorials tutorialData = Tutorials(id: "", title: "", description: "", photo: "", files: []);

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    return authToken;
  }

  Future<bool> joinChallenge(String? userid, String? challengeid) async {
    final challengeDetail = {
      '_id': challengeid,
      'joinedUserId': userid,
    };
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/challenges');
    String? userIdToken = await getAuthToken();
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
        body: jsonEncode(challengeDetail));
    if (response.statusCode == 200) {
      debugPrint('User data updated successfully');
      return true;
    } else {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }

  List<Staffs> get staffs => staffsData;
  List<Staffs> get athletes => athletesData;

  Future<void> fetchStaffs() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/staffs/admin/get');
    String? userIdToken = await getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['staffs'] is List) {
          // Map the 'staffs' list to Staff objects
          staffsData = (data['staffs'] as List).where((item) => item['type'] == 1).map((item) => Staffs.fromJson(item)).toList();
          athletesData = (data['staffs'] as List).where((item) => item['type'] == 2).map((item) => Staffs.fromJson(item)).toList();
          notifyListeners(); // Notify listeners to update the UI
        }
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Failed to load staff data');
    }
  }

  Challenges get featureChallenge => featureChallengeData;

  Future<void> fetchFeaturedChalleng() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/challenges/get-featured');
    String? userIdToken = await getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data != null) {
          featureChallengeData = Challenges.fromJson(data);
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Failed to load staff data');
    }
  }

  List<Collections> get collections => collectionsData;

  Future<void> fetchFeaturedColllections() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/collections/get-featured');
    String? userIdToken = await getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['collections'] is List) {
          // Map the 'staffs' list to Staff objects
          collectionsData = (data['collections'] as List).map((item) => Collections.fromJson(item)).toList();
          notifyListeners(); // Notify listeners to update the UI
        }
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Failed to load staff data');
    }
  }

  Collections get oneCollection => collectionData;

  Future<void> fetchOneCollection(String collectionId) async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/collections/get/$collectionId');
    String? userIdToken = await getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        collectionData = Collections.fromJson(data);
        notifyListeners(); // Notify listeners to update the UI
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Failed to load staff data');
    }
  }

  Future<void> fetchAdminData() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/exercises/get');
    String? userIdToken = await getAuthToken();

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'AUTH_TOKEN': userIdToken ?? "",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('exercises') && responseData.containsKey('categories') && responseData.containsKey('equipments')) {
        List<dynamic> exercisesData = responseData['exercises'];
        List<ExerciseLibrary> exerciseList = exercisesData.map((exerciseJson) {
          return ExerciseLibrary.fromJson(exerciseJson);
        }).toList();
        debugPrint("this is data provider ${exerciseList.length}");
        List<dynamic> categoriesData = responseData['categories'];
        List<CategoryTitle> categoryList = categoriesData.map((categoryJson) {
          return CategoryTitle.fromJson(categoryJson);
        }).toList();

        List<dynamic> equipmentsData = responseData['equipments'];
        List<EquipmentTitle> equipmentList = equipmentsData.map((equipmentJson) {
          return EquipmentTitle.fromJson(equipmentJson);
        }).toList();

        adminExercises = exerciseList;
        adminCategory = categoryList;
        adminEquipment = equipmentList;

        notifyListeners();
      } else {
        throw Exception('Missing data in response (exercises, categories, or equipments)');
      }
    } else {
      throw Exception('Failed to load admin data');
    }
  }

  Future<void> fetchAdminEquipmentsData() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/equipments/admin/get');
    String? userIdToken = await getAuthToken();

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'AUTH_TOKEN': userIdToken ?? "",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('equipments')) {
        List<dynamic> equipmentsData = responseData['equipments'];
        List<Equipment> equipmentList = equipmentsData.map((equipmentJson) {
          return Equipment.fromJson(equipmentJson);
        }).toList();

        adminEquipmentsData = equipmentList;

        notifyListeners();
      } else {
        throw Exception('Missing data in response (equipments)');
      }
    } else {
      throw Exception('Failed to load admin data');
    }
  }

  Future<void> fetchAdminBonusesData() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/bonuses/admin/get');
    String? userIdToken = await getAuthToken();

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'AUTH_TOKEN': userIdToken ?? "",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('bonuses')) {
        List<dynamic> bonusesData = responseData['bonuses'];
        List<Bonuses> bonusesList = bonusesData.map((bonusJson) {
          return Bonuses.fromJson(bonusJson);
        }).toList();

        adminBonusesData = bonusesList;

        notifyListeners();
      } else {
        throw Exception('Missing data in response (bonuses)');
      }
    } else {
      throw Exception('Failed to load admin data');
    }
  }

  Future fetchMonthWorkouts(int month) async {
    final Map<String, String> queryParams = {
      'month': month.toString(),
      'equipment': '0',
      'split': '5',
    };

    Uri url = Uri.parse('${AppConstants.serverUrl}/api/workouts/current');
    url = Uri.http(url.authority, url.path, queryParams);

    String? userIdToken = await getAuthToken();
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'AUTH_TOKEN': userIdToken ?? "",
      },
    );

    // Print JSON as a string for debugging
    if (response.statusCode == 200) {
      await getMonthInfoFromJson(jsonDecode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to load exercise info');
    }
  }

  ///OLD
  Future<void> getMonthInfoFromJson(Map<String, dynamic> responseData) async {
    debugPrint("this is fetch month workout data");
    try {
      MonthDataModel monthDataModelSplit3 = MonthDataModel.fromJson(responseData);
      MonthDataModel monthDataModelSplit4 = MonthDataModel.fromJson(responseData);
      MonthDataModel monthDataModelSplit5 = MonthDataModel.fromJson(responseData);

      await monthProvider?.fetchMonthLocalData();

      final data = {
        "monthId": monthDataModelSplit3.id,
        "monthStartDate": monthDataModelSplit3.startDate.toString(),
        "monthEndDate": monthDataModelSplit3.endDate.toString(),
      };

      MonthResponseModel? matchingElement = monthProvider?.monthLocalDataModel.firstWhere(
        (element) => element.monthId == monthDataModelSplit3.id,
        orElse: () => MonthResponseModel(),
      );

      if (matchingElement?.id == null) {
        await DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.monthHistory);
      }

      List split3 = [
        "Day 1 Workout",
        "Rest Day 1",
        "Day 2 Workout",
        "Rest Day 2",
        "Day 3 Workout",
        "Rest Day 3",
        "Rest Day 4",
      ];

      List split4 = [
        "Day 1 Workout",
        "Day 2 Workout",
        "Rest Day 1",
        "Day 3 Workout",
        "Day 4 Workout",
        "Rest Day 2",
        "Rest Day 3",
      ];

      List split5 = [
        "Day 1 Workout",
        "Day 2 Workout",
        "Day 3 Workout",
        "Day 4 Workout",
        "Day 5 Workout",
        "Rest Day 1",
        "Rest Day 2",
      ];

      await preferences.putString(SharedPreference.monthId, "${monthDataModelSplit3.id}");

      monthDataModelSplit3.weeks?.forEach(
        (element) {
          element.dayList = split3;
          element.idList = [
            "${element.id} split3 Day 1 Workout",
            "${element.id} split3 Rest Day 1",
            "${element.id} split3 Day 2 Workout",
            "${element.id} split3 Rest Day 2",
            "${element.id} split3 Day 3 Workout",
            "${element.id} split3 Rest Day 3",
            "${element.id} split3 Rest Day 4",
          ];
          element.days?.removeWhere((element) => !element.formats!.contains("3"));
          for (var i = 0; i < element.days!.length; i++) {
            element.days?[i].dayType = split3[i];
          }
        },
      );

      await preferences.putString("${SplitType.split3}-${monthDataModelSplit3.id}", jsonEncode(monthDataModelSplit3));

      monthDataModelSplit4.weeks?.forEach(
        (element) {
          element.dayList = split4;
          element.idList = [
            "${element.id} split4 Day 1 Workout",
            "${element.id} split4 Day 2 Workout",
            "${element.id} split4 Rest Day 1",
            "${element.id} split4 Day 3 Workout",
            "${element.id} split4 Day 4 Workout",
            "${element.id} split4 Rest Day 2",
            "${element.id} split4 Rest Day 3",
          ];
          element.days?.removeWhere((element) => !element.formats!.contains("4"));
          for (var i = 0; i < element.days!.length; i++) {
            element.days?[i].dayType = split4[i];
          }
        },
      );

      await preferences.putString("${SplitType.split4}-${monthDataModelSplit4.id}", jsonEncode(monthDataModelSplit4));

      monthDataModelSplit5.weeks?.forEach(
        (element) {
          element.dayList = split5;
          element.idList = [
            "${element.id} split5 Day 1 Workout",
            "${element.id} split5 Day 2 Workout",
            "${element.id} split5 Day 3 Workout",
            "${element.id} split5 Day 4 Workout",
            "${element.id} split5 Day 5 Workout",
            "${element.id} split5 Rest Day 1",
            "${element.id} split5 Rest Day 2",
          ];
          element.days?.removeWhere((element) => !element.formats!.contains("5"));
          for (var i = 0; i < element.days!.length; i++) {
            element.days?[i].dayType = split5[i];
          }
        },
      );

      await preferences.putString("${SplitType.split5}-${monthDataModelSplit5.id}", jsonEncode(monthDataModelSplit5));

      final dataList = [];

      monthDataModelSplit3.weeks?.forEach(
        (element) async {
          final data = await monthProvider?.fetchRestDay(element.restdayId ?? "");
          dataList.add(data!);
          await preferences.putString("REST-${monthDataModelSplit3.id}", jsonEncode(dataList));
        },
      );

      notifyListeners();
    } catch (e) {
      debugPrint("issue in month view loading=> $e");
    }
  }

  Future<void> fetchCheckoutPoint() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/settings/');
    String? userIdToken = await getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var responseData = data[0];

        if (equipmentCheckpoint == '' || bonusCheckpoint == '' || workoutCheckpoint == '') {
          equipmentCheckpoint = responseData["equipmentCheckpoint"];
          bonusCheckpoint = responseData["bonusCheckpoint"];
          workoutCheckpoint = responseData["workoutCheckpoint"];
        } else {
          // Parse the timestamps to DateTime
          DateTime currentEquipmentCheckpoint = DateTime.parse(equipmentCheckpoint);
          DateTime currentBonusCheckoutPoint = DateTime.parse(bonusCheckpoint);
          DateTime currentWorkoutCheckPoint = DateTime.parse(workoutCheckpoint);
          DateTime newEquipmentCheckpoint = DateTime.parse(responseData["equipmentCheckpoint"]);
          DateTime newBonusCheckpoint = DateTime.parse(responseData["bonusCheckpoint"]);
          DateTime newWorkoutCheckpoint = DateTime.parse(responseData["workoutCheckpoint"]);

          // Compare the DateTime values
          if (currentEquipmentCheckpoint.isBefore(newEquipmentCheckpoint)) {
            equipmentCheckpointState = true; // Update the state
            equipmentCheckpoint = responseData["equipmentCheckpoint"]; // Update the checkpoint
          }
          if (currentBonusCheckoutPoint.isBefore(newBonusCheckpoint)) {
            bonusCheckpointState = true; // Update the state
            bonusCheckpoint = responseData["bonusCheckpoint"]; // Update the checkpoint
          }
          if (currentWorkoutCheckPoint.isBefore(newWorkoutCheckpoint)) {
            workoutCheckpointState = true; // Update the state
            workoutCheckpoint = responseData["workoutCheckpoint"]; // Update the checkpoint
          }
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Failed to load staff data');
    }
  }

  Future<void> fetchTutorialData() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/tutorials/');
    String? userIdToken = await getAuthToken();
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH_TOKEN': userIdToken ?? "",
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data != null) {
          tutorialData = Tutorials.fromJson(data);
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load staff data');
      }
    } catch (e) {
      throw Exception('Failed to load staff data');
    }
  }
}
