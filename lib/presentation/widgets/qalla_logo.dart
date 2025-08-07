import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../assets/image_assets.dart';

class QallaLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const QallaLogo({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      qallaLogo,
      width: width ?? 98,
      height: height ?? 45,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.error,
          size: 16,
        );
      },
    );
  }
}
