import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyForecastItem extends StatelessWidget {
  // final List<dynamic>? forecastList;
  final Map<String, dynamic> data;

  const HourlyForecastItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            data != null
                ? data['list'].length > 5
                    ? 5
                    : data['list'].length
                : 0,
        itemBuilder: (context, index) {
          // final hourData = forecastList![index + 1];
          // final timeString = hourData['dt_txt'].toString();
          // final time = timeString.substring(11, 16);
          // final weatherCondition = hourData['weather'][0]['main'];
          final hourlyForecast = data['list'][index + 1];
          final hourlySky = data['list'][index + 1]['weather'][0]['main'];

          // Handle potential integer value in temperature data
          var tempValue = hourlyForecast['main']['temp'];
          double tempKelvin =
              (tempValue is int) ? tempValue.toDouble() : tempValue;
          final hourlyTemp = (tempKelvin - 273.15).toStringAsFixed(2);
          final time = DateTime.parse(hourlyForecast['dt_txt']);

          // IconData weatherIcon;
          // if (weatherCondition == 'Rain') {
          //   weatherIcon = Icons.cloudy_snowing;
          // } else if (weatherCondition == 'Clear') {
          //   weatherIcon = Icons.sunny;
          // } else if (weatherCondition == 'Clouds') {
          //   weatherIcon = Icons.cloud;
          // } else {
          //   weatherIcon = Icons.help_outline;
          // }

          return weather_card(
            time: DateFormat.j().format(time),
            weatherIcon:
                hourlySky == 'Clouds' || hourlySky == 'Rain'
                    ? Icons.cloud
                    : Icons.sunny,
            weatherName: "$hourlyTemp °C",
          );
        },
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
