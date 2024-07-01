import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/shared%20prefs/shared_prefs.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? cityName;

  @override
  void initState() {
    getCity();
    super.initState();
  }

  Future<void> getCity() async {
    cityName = await SharedPrefsHelper().getString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Search City'),
            ),
            const SizedBox(height: 20),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () async {
                if (cityController.text.isEmpty) {
                  // Show the SnackBar when the text field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter a valid city name'),
                    ),
                  );
                  return;
                }

                // Fetch the weather and navigate to the weather detail screen
                await Provider.of<WeatherProvider>(context, listen: false)
                    .fetchWeather(cityController.text);

                // Save the searched city
                await SharedPrefsHelper().saveString(cityController.text);
                getCity();

                // Navigate to the WeatherDetailScreen
                Navigator.pushNamed(context, '/weather');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'View Forecast',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (cityName != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Previously Searched City',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cityName ?? ''),
                      ElevatedButton(
                        onPressed: () async {
                          if (cityName != null) {
                            await Provider.of<WeatherProvider>(context,
                                    listen: false)
                                .fetchWeather(cityName!);
                            Navigator.pushNamed(context, '/weather');
                          }
                        },
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
