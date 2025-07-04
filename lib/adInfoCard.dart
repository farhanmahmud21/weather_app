import 'package:flutter/material.dart';

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