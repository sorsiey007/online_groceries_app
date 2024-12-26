import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _baseUrl = 'https://online-shop-hxhm.onrender.com/api';

  // Method to fetch data from the API
  static Future<dynamic> fetchData(String endpoint,
      {Map<String, String>? filters}) async {
    try {
      // Build query string from filters
      final queryString =
          filters != null ? Uri(queryParameters: filters).query : '';
      final url =
          '$_baseUrl/$endpoint${queryString.isNotEmpty ? '?$queryString' : ''}';

      print('Fetching data from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.body}');
      }
    } catch (err) {
      print('Error fetching data: $err');
      rethrow;
    }
  }

  // Method to handle user registration
  static Future<dynamic> register(Map<String, String> data) async {
    try {
      final url = Uri.parse('$_baseUrl/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Successfully registered
        return json.decode(response.body);
      } else {
        // Registration failed
        throw Exception('Error: ${response.body}');
      }
    } catch (err) {
      print('Error during registration: $err');
      rethrow;
    }
  }
}
