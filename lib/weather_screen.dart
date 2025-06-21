import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
          mainAxisAlignment: MainAxisAlignment.start,
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
            SizedBox(height: 10),
            Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  weather_card(
                    time: '9:00',
                    weatherIcon: Icons.cloud,
                    weatherName: 'Cloudy',
                  ),
                  weather_card(
                    time: '9:00',
                    weatherIcon: Icons.cloudy_snowing,
                    weatherName: 'Rainy',
                  ),
                  weather_card(
                    time: '9:00',
                    weatherIcon: Icons.cloudy_snowing,
                    weatherName: 'Rainy',
                  ),
                  weather_card(
                    time: '9:00',
                    weatherIcon: Icons.cloudy_snowing,
                    weatherName: 'Rainy',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class weather_card extends StatelessWidget {
  final String time;
  final IconData weatherIcon;
  final String weatherName;
  const weather_card({
    super.key,
    required this.time,
    required this.weatherIcon,
    required this.weatherName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 0.6,
        shadowColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Icon(weatherIcon, size: 20),
            SizedBox(height: 10),
            Text(
              weatherName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
