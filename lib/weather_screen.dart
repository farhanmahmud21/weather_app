import 'package:flutter/material.dart';
import 'package:weather_app/hourly_forecast_item.dart';

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
              child: HourlyForecastItem(),
            ),
            SizedBox(height: 10),
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 10),
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
                  AdText: 'Humidity',
                  adIcon: Icons.water_drop_sharp,
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

class AdInfoCard extends StatelessWidget {
  final IconData adIcon;
  final String AdText;
  final String AdTemp;
  const AdInfoCard({
    super.key,
    required this.adIcon,
    required this.AdText,
    required this.AdTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(adIcon),
        SizedBox(height: 5),
        Text(AdText),
        SizedBox(height: 5),
        Text(AdTemp),
      ],
    );
  }
}
