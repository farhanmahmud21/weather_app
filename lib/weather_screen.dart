import 'dart:convert';

import 'package:flutter/gestures.dart';
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
  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  var uri =
      "https://api.openweathermap.org/data/2.5/forecast?q=Dhaka,bd&APPID=38f91636dd15e933a6c1c872df8048df";
  Future<Map<String, dynamic>> getWeather() async {
    var response = await http.get(Uri.parse(uri));
    var decodedData = json.decode(response.body);
    // print(response.body);
    // print(decodedData);
    // print(response.body);

    // temp = decodedData['list'][0]['main']['temp'] - 273.15;

    if (decodedData['cod'] == '200') {
      setState(() {
        temp = decodedData['list'][0]['main']['temp'] - 273.15;
      });

      print(temp);
      return decodedData;
    } else {
      throw "Throwed an exception";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          GestureDetector(
            child: Icon(Icons.refresh),
            onTap: () {
              setState(() {
                getWeather();
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
