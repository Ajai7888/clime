import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart'; // Your WeatherData model (without hourly field or ignore hourly)

class ApiService {
  final String _apiKey = '567ccd2e4f1ca68963303481ce41996b';

  Future<WeatherData> fetchWeather(String cityName) async {
    final currentUrl = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$_apiKey',
    );

    final currentResponse = await http.get(currentUrl);

    if (currentResponse.statusCode == 200) {
      final currentJson = json.decode(currentResponse.body);

      // Create WeatherData without hourly (remove hourly from WeatherData model)
      return WeatherData.fromJson(currentJson);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
