import 'package:flutter/material.dart';

class ServiceLogo extends StatelessWidget {
  ServiceLogo(this.logo, this.size);
  final AssetImage logo;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.white),
        color: Colors.white,
        image: DecorationImage(
          image: logo,
        ),
      ),
    );
  }
}
