import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/shared%20prefs/shared_prefs.dart';
import 'package:intl/intl.dart'; // For date and time formatting

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? cityName;

  @override
  void initState() {
    getCity();
    super.initState();
  }

  Future<void> getCity() async {
    cityName = await SharedPrefsHelper().getString();
    if (cityName != null) {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(cityName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weatherData = weatherProvider.weatherData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          cityName != null
              ? IconButton(
                  onPressed: () {
                    Provider.of<WeatherProvider>(context, listen: false)
                        .fetchWeather(cityName!);
                  },
                  icon: const Icon(Icons.refresh),
                )
              : const SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: weatherProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : weatherProvider.errorMessage != null
                ? Center(
                    child: Text(
                      weatherProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  )
                : weatherData != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weatherData['city']['name'],
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        '${weatherData['list'][0]['main']['temp']}°C',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Humidity: ${weatherData['list'][0]['main']['humidity']}%',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    'Wind: ${weatherData['list'][0]['wind']['speed']} m/s',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    weatherData['list'][0]['weather'][0]
                                        ['description'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              getWeatherIcon(
                                  weatherData['list'][0]['weather'][0]['icon']),
                            ],
                          ),
                          const SizedBox(height: 100),
                          const Text(
                            '5-Day Forecast',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: weatherData['list'].length,
                              itemBuilder: (context, index) {
                                final hourly = weatherData['list'][index];
                                return hourlyForecastItem(hourly);
                              },
                            ),
                          ),
                          const SizedBox(height: 200),
                        ],
                      )
                    : const Center(child: Text('No weather data available')),
      ),
    );
  }

  Widget getWeatherIcon(String iconCode) {
    String iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';
    return Image.network(
      iconUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

// for later forecast
  Widget hourlyForecastItem(Map<String, dynamic> hourly) {
    DateTime dateTime = DateTime.parse(hourly['dt_txt']);

    String formattedDate = DateFormat('EEE, MMM d').format(dateTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white70,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getWeatherIcon(hourly['weather'][0]['icon']),
          const SizedBox(height: 5),
          Text(
            '${hourly['main']['temp']}°C',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(
            hourly['weather'][0]['description'],
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            formattedTime,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
