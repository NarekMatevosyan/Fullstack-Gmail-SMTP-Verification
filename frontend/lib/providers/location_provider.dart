import 'dart:convert';
import 'dart:developer';

import 'package:bbb/models/city_model.dart';
import 'package:bbb/models/country_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/state_model.dart' as model;

class LocationProvider extends ChangeNotifier {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String token = '';
  List<Country> country = [];
  List<model.State> states = [];
  List<City> cities = [];

  fillDetails(String country, String state, String city) {
    selectedCountry = country;
    selectedState = state;
    selectedCity = city;
    notifyListeners();
    generateToken(co: country, st: state);
  }

  onCountrySelect(String? newValue) {
    selectedCountry = newValue;
    selectedState = null;
    selectedCity = null;
    states = [];
    cities = [];
    notifyListeners();
    getState(newValue!);
  }

  onStateSelect(String? newValue) {
    selectedState = newValue;
    selectedCity = null;
    cities = [];
    notifyListeners();
    getCity(newValue!);
  }

  onCitySelect(String? newValue) {
    selectedCity = newValue;
    notifyListeners();
  }

  Future<void> generateToken({String? co, String? st}) async {
    var header = {
      "Accept": "application/json",
      "api-token": "LZFO1n6wM5uTcL7nYI_Pt02nt3G0kQnz_P5jLOT5xgfyDgJ0GxFCbKGs-wUIlZGyMvw",
      "user-email": "nevilrv@gmail.com",
    };
    Uri url = Uri.parse('https://www.universal-tutorial.com/api/getaccesstoken');
    final response = await http.get(url, headers: header);

    log('response :::::::::::::::::: ${{response.body}}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      token = data['auth_token'];
      getCounties();
      getState(co ?? "United States");
      getCity(st ?? "Alaska");
    } else {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }

  Future<void> getCounties() async {
    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    Uri url = Uri.parse('https://www.universal-tutorial.com/api/countries/');
    final response = await http.get(url, headers: header);

    log('response :::::::getCounties::::::::::: ${response.body}');

    if (response.statusCode == 200) {
      country = countryFromJson(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }

  Future<void> getState(String countryName) async {
    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    Uri url = Uri.parse('https://www.universal-tutorial.com/api/states/$countryName');
    final response = await http.get(url, headers: header);

    log('response :::::::response::::::::::: ${response.body}');

    if (response.statusCode == 200) {
      states = model.stateFromJson(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }

  Future<void> getCity(String cityName) async {
    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    Uri url = Uri.parse('https://www.universal-tutorial.com/api/cities/$cityName');
    final response = await http.get(url, headers: header);

    log('response :::::::getCity::::::::::: ${response.body}');

    if (response.statusCode == 200) {
      cities = cityFromJson(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }
}
