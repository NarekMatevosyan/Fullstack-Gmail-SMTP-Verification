import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/program_info_model.dart';
import '../pages/login_page.dart';
import '../values/app_constants.dart';

class ProgramInfoProvider extends ChangeNotifier {
  ProgramInfoModel? programInfoModel;

  bool loading = false;

  void getProgramInfo(BuildContext context) async {
    if (programInfoModel != null) {
      return;
    }

    try {
      loading = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      final response = await http.get(
        Uri.parse('${AppConstants.serverUrl}/api/program-info'), // replace with actual endpoint
        headers: {"auth_token": "$token"},
      );

      if (response.statusCode == 200) {
        debugPrint('success getProgramInfo');
        programInfoModel = programInfoModelFromJson(response.body);
      } else {
        showBottomAlert(context, 'Failed to load description');
        debugPrint('this is programInfo ${response.statusCode}');
      }
      loading = false;
      notifyListeners();
    } catch (e) {
      showBottomAlert(context, 'An error occurred');
      debugPrint('this is programInfo  $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
