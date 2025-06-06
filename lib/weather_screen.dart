import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_model.dart';
import 'api_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  WeatherData? _weatherData;
  bool _isLoading = false;
  bool _hasError = false; // Flag for error

  final List<String> _weatherTips = [
    'Don’t forget your umbrella—rainclouds love surprise visits!',
    'Sunshine alert! Keep your water bottle close and stay refreshed.',
    'Hold onto your hats—windy days call for extra care!',
    'Layer up smartly; cozy warmth beats the chill any day.',
    'Thunderstorms brewing? Stay safe and avoid unnecessary trips.',
    'Cloudy skies today? Perfect for a cozy indoor read or coffee.',
    'When the air is crisp, a light jacket is your best friend.',
    'Mist and fog ahead—drive slow and keep those headlights on.',
    'Feeling the heat? Seek shade and give yourself a cool break.',
    'Rainy days bring puddles—time for your favorite boots!',
  ];

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _hasError = false; // Reset error before new fetch
    });
    try {
      final data = await _apiService.fetchWeather(city);
      setState(() {
        _weatherData = data;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _weatherData = null;
      });
    }
  }

  String _getWeatherBackground(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear')) return 'assets/images/clear.jpg';
    if (desc.contains('cloud')) return 'assets/images/cloudy.jpg';
    if (desc.contains('rain')) return 'assets/images/rainy.jpg';
    if (desc.contains('snow')) return 'assets/images/snow.jpg';
    if (desc.contains('thunder')) return 'assets/images/thunderstorm.jpg';
    if (desc.contains('mist') || desc.contains('fog') || desc.contains('haze'))
      return 'assets/images/foggy.jpg';
    return 'assets/images/default.jpg';
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather("Chennai");
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tip = (_weatherTips..shuffle()).first;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_weatherData != null)
            Image.asset(
              _getWeatherBackground(_weatherData!.description),
              fit: BoxFit.cover,
            )
          else
            Image.asset('assets/images/default.jpg', fit: BoxFit.cover),

          Container(color: Colors.black.withOpacity(0.2)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter city',
                              hintStyle: const TextStyle(color: Colors.white70),
                              fillColor: Colors.black.withOpacity(0.3),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (val) {
                              if (val.isNotEmpty) _fetchWeather(val.trim());
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              _fetchWeather(_controller.text.trim());
                            }
                          },
                          child: const Icon(Icons.search),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    _isLoading
                        ? const CircularProgressIndicator()
                        : _hasError
                        ? Text(
                            'City not found. Please try again.',
                            style: GoogleFonts.poppins(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : _weatherData == null
                        ? Text(
                            'Enter a city to get weather data',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )
                        : Column(
                            children: [
                              // Weather Info Card
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Today",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Image.network(
                                      _weatherData!.iconUrl,
                                      width: 60,
                                      height: 60,
                                    ),
                                    Text(
                                      '${_weatherData!.temperature.toStringAsFixed(0)}°',
                                      style: GoogleFonts.poppins(
                                        fontSize: 72,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _weatherData!.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      '${_weatherData!.city}, ${_weatherData!.country}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${now.day} ${_getMonthName(now.month)} ${now.year}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                'Feels like ${_weatherData!.feelsLike.toStringAsFixed(0)}°',
                                            style: const TextStyle(
                                              color: Colors.lightBlueAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: '  |  ',
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'Sunset ${_weatherData!.sunset.hour}:${_weatherData!.sunset.minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(
                                              color: Colors.deepOrangeAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Random Weather Tip
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tip,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
