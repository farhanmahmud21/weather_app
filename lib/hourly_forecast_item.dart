import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
        weather_card(
          time: '9:00',
          weatherIcon: Icons.cloudy_snowing,
          weatherName: 'Rainy',
        ),
      ],
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
