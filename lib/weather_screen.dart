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
  String selectedCity = 'Dhaka';
  final List<String> cities = [
    'Dhaka',
    'London',
    'New York',
    'Tokyo',
    'Sydney',
  ];

  @override
  void initState() {
    super.initState();
    weather = getWeather(selectedCity);
  }

  String getApiUrl(String city) {
    return "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=38f91636dd15e933a6c1c872df8048df";
  }

  Future<Map<String, dynamic>> getWeather(String city) async {
    final apiUrl = getApiUrl(city);
    var response = await http.get(Uri.parse(apiUrl));
    var decodedData = json.decode(response.body);

    if (decodedData['cod'] == '200') {
      setState(() {
        temp = decodedData['list'][0]['main']['temp'] - 273.15;
      });

      print(temp);
      return decodedData;
    } else {
      throw "Failed to fetch weather data for $city";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              hint: Text(
                selectedCity,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: selectedCity,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(height: 0, color: Colors.transparent),
              dropdownColor: Colors.white,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCity = newValue;
                    weather = getWeather(selectedCity);
                  });
                }
              },
              items:
                  cities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          GestureDetector(
            child: Icon(Icons.refresh),
            onTap: () {
              setState(() {
                weather = getWeather(selectedCity);
              });
            },
          ),
          SizedBox(width: 10),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading weather data',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        weather = getWeather(selectedCity);
                      });
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          var data = snapshot.data!;

          // Safely handle temperature calculation
          double tempKelvin = data['list'][0]['main']['temp'];
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
                        Column(
                          children: [
                            Text(
                              selectedCity,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${tem.toStringAsFixed(2)} ° C',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Icon(
                          desc == "Rain"
                              ? Icons.cloudy_snowing
                              : desc == "Sunny"
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
