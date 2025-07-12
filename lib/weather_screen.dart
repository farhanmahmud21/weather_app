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
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.hasData);
          var data = snapshot.data;
          var tem = data!['list'][0]['main']['temp'] - 273.15;
          String desc = data!['list'][0]['weather'][0]['main'];

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
                      borderRadius: BorderRadiusGeometry.circular(14),
                    ),
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${temp.toStringAsFixed(2)} ° C ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Icon(Icons.cloud, size: 50),
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
          );
        },
      ),
    );
  }
}
