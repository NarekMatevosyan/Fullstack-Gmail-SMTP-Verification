import 'dart:convert';
import 'dart:io';

import 'package:bbb/values/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  String userId = "";
  String userName = "";
  String userEmail = "";
  var userData;

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    return authToken;
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/users/get_user');
    String? token = await getAuthToken();
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'AUTH_TOKEN': token ?? ""},
    );
    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      getUserDataFromJson(jsonResponse);
      notifyListeners();
      return jsonResponse;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUserInfo(String? id, Map<String, dynamic> userDetails, File? imageFile) async {
    Uri url = Uri.parse('${AppConstants.serverUrl}/api/users/$id');

    String? userIdToken = await getAuthToken();

    try {
      http.MultipartRequest request = http.MultipartRequest("PUT", url);
      request.fields['detail'] = jsonEncode(userDetails);

      if (imageFile != null) {
        final stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
        final length = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'image', // Field name for the image
          stream,
          length,
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);
      } else {
        request.fields['image'] = '';
      }
      request.headers.addAll({
        'AUTH_TOKEN': userIdToken!,
        'Accept': 'application/json',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        updateUserData(data['result']['detail']);
      } else {
        debugPrint('Failed to update user data. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating user info: $e');
    }
  }

  Future<void> getUserDataFromJson(responseData) async {
    userId = responseData["_id"];
    userName = responseData["name"];
    userEmail = responseData["email"];
    userData = responseData;
    notifyListeners();
  }

  updateUserData(var value) async {
    await fetchUserInfo();
    notifyListeners();
  }

  Future<void> loadUserInfo() async {
    try {
      await fetchUserInfo();
    } catch (e) {
      debugPrint("--------------Error loading user info: $e");
    }
  }
}
