import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/adInfoCard.dart';
import 'package:weather_app/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getWeather();
  }

  var uri =
      "https://api.openweathermap.org/data/2.5/weather?q=Dhaka,uk&APPID=38f91636dd15e933a6c1c872df8048df";
  Future<void> getWeather() async {
    var response = await http.get(Uri.parse(uri));
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [GestureDetector(child: Icon(Icons.refresh))],
      ),
      body: Padding(
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
                  borderRadius: BorderRadiusGeometry.circular(14),
                ),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '300.67° F ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Icon(Icons.cloud, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Cloudy',
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HourlyForecastItem(),
            ),
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
                  adIcon: Icons.water_drop_sharp,
                  AdTemp: '30',
                ),
                AdInfoCard(
                  AdText: 'Humidity',
                  adIcon: Icons.water_drop_sharp,
                  AdTemp: '30',
                ),
                AdInfoCard(
                  AdText: 'Pressure',
                  adIcon: Icons.beach_access_sharp,
                  AdTemp: '30',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
