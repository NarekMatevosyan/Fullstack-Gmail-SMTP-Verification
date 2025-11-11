// To parse this JSON data, do
//
//     final state = stateFromJson(jsonString);

import 'dart:convert';

List<State> stateFromJson(String str) => List<State>.from(json.decode(str).map((x) => State.fromJson(x)));

String stateToJson(List<State> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class State {
  String stateName;

  State({
    required this.stateName,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "state_name": stateName,
  };
}
