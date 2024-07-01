import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'c17ccb8975a5d1153532786e437f1b1f';
  final String baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    try {
      final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Invalid City Name, Try Again');
      }
    } catch (e) {
      throw Exception('Invalid City Name, Try Again');
    }
  }
}
