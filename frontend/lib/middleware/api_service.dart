// api_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> fetchData(String endpoint) async {
    log('$baseUrl/$endpoint');
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}