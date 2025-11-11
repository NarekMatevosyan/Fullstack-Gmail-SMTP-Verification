// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

List<Country> countryFromJson(String str) => List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  String countryName;
  String countryShortName;
  int countryPhoneCode;

  Country({
    required this.countryName,
    required this.countryShortName,
    required this.countryPhoneCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    countryName: json["country_name"],
    countryShortName: json["country_short_name"],
    countryPhoneCode: json["country_phone_code"],
  );

  Map<String, dynamic> toJson() => {
    "country_name": countryName,
    "country_short_name": countryShortName,
    "country_phone_code": countryPhoneCode,
  };
}
