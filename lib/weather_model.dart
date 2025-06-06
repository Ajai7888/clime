// models/weather_data.dart

class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final DateTime sunrise;
  final DateTime sunset;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int clouds;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.clouds,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? 'Unknown',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      description:
          (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['description'] ?? 'N/A'
          : 'N/A',
      iconCode:
          (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['icon'] ?? '01d'
          : '01d',
      sunrise: json['sys']?['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['sys']['sunrise'] * 1000,
              isUtc: true,
            ).toLocal()
          : DateTime.now(),
      sunset: json['sys']?['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['sys']['sunset'] * 1000,
              isUtc: true,
            ).toLocal()
          : DateTime.now(),
      humidity: json['main']?['humidity'] ?? 0,
      pressure: json['main']?['pressure'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      clouds: json['clouds']?['all'] ?? 0,
    );
  }
}
