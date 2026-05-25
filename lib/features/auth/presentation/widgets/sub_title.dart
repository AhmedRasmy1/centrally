import 'package:centrally/core/theme/style_manager.dart';
import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  const SubTitle({super.key, required this.title, required this.textAlign});
  final String title;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.bodyMedium, textAlign: textAlign);
  }
}
