import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/adInfoCard.dart';
import 'package:weather_app/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  double temp = 0;

  // List of available cities with their country codes
  final List<Map<String, String>> cities = [
    {"name": "Dhaka", "code": "bd"},
    {"name": "London", "code": "uk"},
    {"name": "New York", "code": "us"},
    {"name": "Tokyo", "code": "jp"},
    {"name": "Sydney", "code": "au"},
  ];

  // Default selected city
  String selectedCity = "Dhaka";
  String selectedCountryCode = "bd";

  @override
  void initState() {
    super.initState();
    weather = getWeather(selectedCity, selectedCountryCode);
  }

  String getApiUrl(String city, String countryCode) {
    return "https://api.openweathermap.org/data/2.5/forecast?q=$city,$countryCode&APPID=38f91636dd15e933a6c1c872df8048df";
  }

  Future<Map<String, dynamic>> getWeather(
    String city,
    String countryCode,
  ) async {
    final apiUrl = getApiUrl(city, countryCode);
    var response = await http.get(Uri.parse(apiUrl));
    var decodedData = json.decode(response.body);

    if (decodedData['cod'] == '200') {
      setState(() {
        temp = decodedData['list'][0]['main']['temp'] - 273.15;
      });

      print("Weather data loaded for $city, $countryCode");
      return decodedData;
    } else {
      throw "Failed to load weather data for $city";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.cloud),
            SizedBox(width: 8),
            Text('Weather Forecast'),
          ],
        ),
        actions: [
          // City selection dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedCity,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              dropdownColor: Theme.of(context).primaryColor,
              underline: Container(), // Remove the underline
              onChanged: (String? newCity) {
                if (newCity != null) {
                  setState(() {
                    selectedCity = newCity;
                    // Find the country code for the selected city
                    selectedCountryCode =
                        cities.firstWhere(
                          (city) => city["name"] == newCity,
                          orElse: () => {"name": "Dhaka", "code": "bd"},
                        )["code"]!;

                    // Refresh weather data with new city
                    weather = getWeather(selectedCity, selectedCountryCode);
                  });
                }
              },
              items:
                  cities.map<DropdownMenuItem<String>>((
                    Map<String, String> city,
                  ) {
                    return DropdownMenuItem<String>(
                      value: city["name"],
                      child: Text(
                        city["name"]!,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
            ),
          ),
          // Refresh button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                weather = getWeather(selectedCity, selectedCountryCode);
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.hasData);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          var data = snapshot.data!;

          // Safely handle temperature calculation with explicit type conversion
          double tempKelvin =
              (data['list'][0]['main']['temp'] is int)
                  ? (data['list'][0]['main']['temp'] as int).toDouble()
                  : data['list'][0]['main']['temp'];
          var tem = tempKelvin - 273.15;
          String desc = data['list'][0]['weather'][0]['main'];
          var humidity = data['list'][0]['main']['humidity'];
          var windSpeed = data["list"][0]['wind']['speed'];
          var pressure = data['list'][0]['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shadowColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedCity,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${tem.toStringAsFixed(2)} ° C ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          desc == "Rain"
                              ? Icons.cloudy_snowing
                              : desc == "Clear"
                              ? Icons.sunny
                              : desc == "Clouds"
                              ? Icons.cloud
                              : Icons.help_outline,
                          size: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                HourlyForecastItem(data: data),
                SizedBox(height: 20),
                Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdInfoCard(
                      AdText: 'Humidity',
                      adIcon: Icons.blur_on_rounded,
                      AdTemp: "$humidity% ",
                    ),
                    AdInfoCard(
                      AdText: 'Wind Speed',
                      adIcon: Icons.wind_power_outlined,
                      AdTemp: "$windSpeed km/h",
                    ),
                    AdInfoCard(
                      AdText: 'Pressure',
                      adIcon: Icons.beach_access_sharp,
                      AdTemp: "$pressure",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
